#
# -*- coding: utf-8 -*-
#
# Copyright (c) 2018 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#

import argparse
import os
import sys

from common.base_model_init import BaseModelInitializer
from common.base_model_init import set_env_var


class ModelInitializer(BaseModelInitializer):
    accuracy_script = "coco_mAP.sh"
    accuracy_script_path = ""

    def run_inference_sanity_checks(self, args, custom_args):
        if args.batch_size != -1 and args.batch_size != 1:
            sys.exit("R-FCN inference supports 'batch-size=1' " +
                     "only, please modify via the '--batch_size' flag.")

    def __init__(self, args, custom_args, platform_util):
        super(ModelInitializer, self).__init__(args, custom_args, platform_util)

        self.accuracy_script_path = os.path.join(
            self.args.intelai_models, self.args.mode, self.args.precision,
            self.accuracy_script)
        self.benchmark_script = os.path.join(
            self.args.intelai_models, self.args.mode,
            self.args.precision, "run_rfcn_inference.py")

        # Set KMP env vars, if they haven't already been set
        config_file_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "config.json")
        self.set_kmp_vars(config_file_path)

        # Set num_inter_threads and num_intra_threads
        self.set_num_inter_intra_threads()

        self.run_inference_sanity_checks(self.args, self.custom_args)
        self.parse_custom_args()
        self.research_dir = os.path.join(self.args.model_source_dir,
                                         "research")

    def parse_custom_args(self):
        if self.custom_args:
            parser = argparse.ArgumentParser()
            mutex_group = parser.add_mutually_exclusive_group()
            mutex_group.add_argument("-x", "--number_of_steps",
                                     help="Run for n number of steps",
                                     type=int, default=None)
            mutex_group.add_argument(
                "-v", "--visualize",
                help="Whether to visualize the output image",
                action="store_true")
            parser.add_argument("-q", "--split",
                                help="Location of accuracy data",
                                type=str, default=None)
            self.args = parser.parse_args(self.custom_args, namespace=self.args)
        else:
            raise ValueError("Custom parameters are missing...")

    def run_perf_command(self):
        # Get the command previx, but numactl is added later in run_perf_command()
        command = []
        num_cores = str(self.platform_util.num_cores_per_socket)
        if self.args.num_cores != -1:
            num_cores = str(self.args.num_cores)

        set_env_var("OMP_NUM_THREADS", num_cores)

        if self.args.socket_id != -1:
            command.append("numactl")
            if self.args.socket_id:
                socket_id = self.args.socket_id
            else:
                socket_id = "0"

            if self.args.num_cores != -1:
                command.append("-C")
                command.append("+0")
                i = 1
                while i < self.args.num_cores:
                    command.append(",{}".format(i))
                    i += i

            command.append("-N")
            command.append("{}".format(socket_id))
            command.append("-m")
            command.append("{}".format(socket_id))

        command += (self.python_exe, self.benchmark_script)
        command += ("-m", self.args.model_source_dir)
        command += ("-g", self.args.input_graph)
        command += ("--num-intra-threads", str(self.args.num_intra_threads))
        command += ("--num-inter-threads", str(self.args.num_inter_threads))
        if self.args.number_of_steps:
            command += ("-x", "{}".format(self.args.number_of_steps))
        if self.args.visualize:
            command += ("-v")
        if self.args.data_location:
            command += ("-d", self.args.data_location)
        self.run_command(" ".join(command))

    def run_accuracy_command(self):
        if not os.path.exists(self.accuracy_script_path):
            raise ValueError("Unable to locate the R-FCN accuracy script: "
                             "{}".format(self.accuracy_script_path))
        command = "FROZEN_GRAPH=" + self.args.input_graph

        if self.args.data_location and os.path.exists(
                self.args.data_location):
            command += " TF_RECORD_FILE=" + self.args.data_location
        else:
            raise ValueError(
                "Unable to locate the coco data record file at {}".format(
                    self.args.tf_record_file))

        if self.args.split:
            command += " SPLIT=" + self.args.split
        else:
            raise ValueError("Must specify SPLIT parameter")

        command += " TF_MODELS_ROOT={}".format(
            self.args.model_source_dir)

        command += " " + self.accuracy_script_path
        self.run_command(command)

    def run(self):
        original_dir = os.getcwd()
        os.chdir(self.research_dir)
        if self.args.accuracy_only:
            self.run_accuracy_command()
        else:
            self.run_perf_command()
        os.chdir(original_dir)
