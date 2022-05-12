import argparse
import os
import stat
import subprocess
import sys
from shutil import copyfile
from time import sleep

# Import PlatformUtils from the model zoo code
sys.path.insert(0, "benchmarks/common")
import platform_util


class LaunchMultiInstanceBenchmark(object):
    def __init__(self, args):
        self.args = args
        run_script = self.args.run_script.strip()
        script_basename = os.path.splitext(os.path.basename(run_script))[0]
        log_file_prefix = self.args.log_file_prefix.strip()

        if not log_file_prefix:
            log_file_prefix = script_basename

        if not os.path.exists(run_script):
            sys.exit("The specified script '{}' does not exist.".format(run_script))

        if "OUTPUT_DIR" in os.environ:
            output_dir = os.getenv("OUTPUT_DIR")
        else:
            sys.exit("The required environment variable OUTPUT_DIR is not set")

        # Verify that we are running with the python 3, otherwise the core
        # parsing won't work properly with python 2.
        if sys.version_info[0] < 3:
            sys.exit("ERROR: This script requires Python 3 (found Python {})"
                     .format(sys.version_info[0]))

        # Get platform info
        self.platform = platform_util.PlatformUtil(self.args)
        cores_per_instance = args.cores_per_instance if args.cores_per_instance \
            else self.platform.num_cores_per_socket
        cpu_info_list, test_cores_list = self.cpu_info(cores_per_instance)

        # Create the shell script with run commands for each instance
        multi_instance_command = "#!/usr/bin/env bash \n\n"

        if "training" in run_script:
            # For training, add on mpi args to the quickstart command
            get_crti = 'find /usr/ -name crti* | head -n 1'
            crti_path_shell = subprocess.Popen(get_crti, shell=True,
                                               stdout=subprocess.PIPE)
            crti_path = crti_path_shell.stdout.readline()
            crti_path = str(crti_path).lstrip("b'").rstrip("\\n'")
            crti_path_env = '/'.join(crti_path.split('/')[:-1])
            run_env = 'export LIBRARY_PATH={0}:$LIBRARY_PATH;'.format(crti_path_env)

            all_instance_log = os.path.join(output_dir, "{}_instance_all.log".
                                            format(log_file_prefix))

            batch_size = 256

            training_command = ("PREFIX=\"{0}\" "
                                "bash {1} "
                                "--num-intra-threads {2} --num-inter-threads 2 "
                                "--mpi_num_processes={3} --mpi_num_processes_per_socket=1 "
                                "--batch-size {4} "
                                "-- steps=300 train_epochs=1 epochs_between_evals=1 "
                                "2>&1 | tee {5}\n").format(
                run_env, run_script, int(cpu_info_list[1])-4, cpu_info_list[0], batch_size, all_instance_log)

            multi_instance_command += training_command

        else:
            # For inference, run multiple instances using numactl
            for test_cores in test_cores_list:
                instance_num = test_cores_list.index(test_cores)

                if len(test_cores) < int(cores_per_instance):
                    print("NOTE: Skipping remainder of {} cores for instance {}"
                          .format(len(test_cores), instance_num))
                    continue

                numactl_cpu_list = ','.join(test_cores)
                instance_log = os.path.join(output_dir, "{}_cores{}_instance{}.log".
                                            format(log_file_prefix, cores_per_instance, instance_num))

                prefix = ("OMP_NUM_THREADS={0} "
                          "KMP_AFFINITY=granularity=fine,verbose,compact,1,0 "
                          "numactl --localalloc --physcpubind={1}").format(len(test_cores), numactl_cpu_list)

                multi_instance_command += ("PREFIX=\"{0}\" "
                                          "bash {1} "
                                          "--num-intra-threads {2} --num-inter-threads 1 "
                                          "--data-num-intra-threads {2} --data-num-inter-threads 1 "
                                          "> {3} 2>&1 & \\\n").format(
                    prefix, run_script, len(test_cores), instance_log)

            multi_instance_command += "wait"

        sys.stdout.flush()

        # Write command file
        command_file_path = "instance{}_cores{}_{}".format(
            len(test_cores_list), cores_per_instance, os.path.basename(run_script))
        command_file_path = os.path.join(output_dir, command_file_path)

        if not args.dry_run:
            with open(command_file_path, 'w+') as tf:
                tf.write(multi_instance_command)
            sleep(5)
            os.chmod(command_file_path, os.stat(command_file_path).st_mode | stat.S_IEXEC)
        else:
            print(multi_instance_command)

        run_multi_instance_file = "bash " + command_file_path
        print("Running {}".format(run_multi_instance_file))

        sys.stdout.flush()

        if not args.dry_run:
            subprocess.call(run_multi_instance_file, shell=True, executable="/bin/bash")

        if "training" in run_script:
            sleep(5)
            throughput_command = 'cat {0} | grep "global_step/sec:" | sed -e s"/.*: //" | tail -n 1'.format(
                all_instance_log)
            get_global_step = subprocess.Popen(throughput_command, shell=True,
                                               stdout=subprocess.PIPE)
            global_step_byte = get_global_step.stdout.readline()
            global_step = float(
                str(global_step_byte).lstrip("b'").rstrip("\\n'"))
            throughput = global_step * int(batch_size) * int(cpu_info_list[0])
            print("{} * {} * {} = {}".format(global_step, batch_size, cpu_info_list[0], throughput))
            print("Throughput: {}".format(throughput))

    def list_of_groups(self, init_list, children_list_len):
        children_list_len = int(children_list_len)
        list_of_groups = zip(*(iter(init_list),) * children_list_len)
        end_list = [list(i) for i in list_of_groups]
        count = len(init_list) % children_list_len
        end_list.append(init_list[-count:]) if count != 0 else end_list
        return end_list

    def cpu_info(self, cores_per_instance):
        num_physical_cores = self.platform.num_cpu_sockets * self.platform.num_cores_per_socket
        cores_per_node = int(num_physical_cores / self.platform.num_numa_nodes)
        cpu_array_shell = \
            "numactl -H |grep 'node [0-9]* cpus:' |" \
            "sed 's/.*node [0-9]* cpus: *//' | head -{0} |cut -f1-{1} -d' '".format(
            self.platform.num_numa_nodes, int(cores_per_node))

        cpu_array = subprocess.Popen(cpu_array_shell, shell=True,
                                     stdout=subprocess.PIPE)
        cpu_array_output = cpu_array.stdout.readlines()
        cpu_cores_string = ''
        for one_core in cpu_array_output:
            new_one_core = str(one_core).lstrip("b'").replace("\\n'", " ")
            cpu_cores_string += new_one_core
        cpu_cores_list = cpu_cores_string.split(" ")
        new_cpu_cores_list = [x for x in cpu_cores_list if x != '']
        test_cores_list = self.list_of_groups(new_cpu_cores_list, cores_per_instance)
        cpu_info_list = [self.platform.num_cpu_sockets,
                         self.platform.num_cores_per_socket,
                         self.platform.num_numa_nodes,
                         num_physical_cores,
                         cores_per_node,
                         cores_per_instance,
                         self.platform.num_numa_nodes]
        return cpu_info_list, test_cores_list

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="run LZ models jenkins")
    parser.add_argument("--cores_per_instance", "-cpi",
                        help="The number of cores per instance. The default is to use "
                             "the number of cores per socket.",
                        default=None)
    parser.add_argument("--run_script",
                        help="The quickstart script or run command. The numactl "
                             "prefix will be added to the front of this command and "
                             "--num-inter-threads/--num-intra-threads will be added "
                             "to the end.",
                        required=True)
    parser.add_argument("--log_file_prefix",
                        help="Specify the prefix for the log file names for each "
                             "instance. If no value is given this this defaults to "
                             "use the base name of the run script.",
                        required=False, default="")
    parser.add_argument("--dry_run",
                        help="Prints the run command, but does not execute the script",
                        dest="dry_run", action="store_true")

    args = parser.parse_args()
    LaunchMultiInstanceBenchmark(args)
