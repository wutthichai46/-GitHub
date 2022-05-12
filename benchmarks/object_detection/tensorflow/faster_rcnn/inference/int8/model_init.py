#
# -*- coding: utf-8 -*-
#
# Copyright (c) 2019 Intel Corporation
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
# SPDX-License-Identifier: EPL-2.0
#

import argparse
import os

from common.base_model_init import BaseModelInitializer
from common.base_model_init import set_env_var


class ModelInitializer(BaseModelInitializer):
    RFCN_PERF_SCRIPT = "run_frozen_graph_rcnn.py"
    RFCN_ACCURACY_SCRIPT = "coco_int8.sh"
    perf_script_path = ""
    accuracy_script_path = ""

    def __init__(self, args, custom_args=[], platform_util=None):
        super(ModelInitializer, self).__init__(args, custom_args, platform_util)

        self.perf_script_path = os.path.join(
            self.args.intelai_models, self.args.mode, self.args.precision,
            self.RFCN_PERF_SCRIPT)
        self.accuracy_script_path = os.path.join(
            self.args.intelai_models, self.args.mode, self.args.precision,
            self.RFCN_ACCURACY_SCRIPT)

        # Set KMP env vars, if they haven't already been set
        config_file_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), "config.json")
        self.set_kmp_vars(config_file_path)

        self.validate_args()

        # set num_inter_threads and num_intra_threds (override inter threads to 2)
        self.set_num_inter_intra_threads(num_inter_threads=2)

    def validate_args(self):
        if not (self.args.batch_size == -1 or self.args.batch_size == 1):
            raise ValueError(
                "Batch Size specified: {}. faster RCNN inference only supports "
                "batch size = 1".format(self.args.batch_size))

        if not os.path.exists(self.perf_script_path)\
                and self.args.bechmark_only:
            raise ValueError("Unable to locate the faster RCNN perf script: {}".
                             format(self.perf_script_path))

        if not os.path.exists(self.accuracy_script_path)\
                and self.args.accuracy_only:
            raise ValueError("Unable to locate the faster RCNN  accuracy script: "
                             "{}".format(self.accuracy_script_path))

        if not self.args.model_source_dir or not os.path.isdir(
                self.args.model_source_dir):
            raise ValueError("Unable to locate TensorFlow models at {}".
                             format(self.args.model_source_dir))

    def parse_args(self):
        if self.custom_args:
            parser = argparse.ArgumentParser()
            parser.add_argument("-n", "--number-of-steps",
                                help="Run for n number of steps",
                                type=int, default=None)
            self.args = parser.parse_args(self.custom_args,
                                          namespace=self.args)

    def run_perf_command(self):
        set_env_var("OMP_NUM_THREADS", self.args.num_intra_threads)
        self.parse_args()
        command = self.get_command_prefix(self.args.socket_id)
        command += " {} ".format(self.python_exe) + self.perf_script_path
        command += " -g " + self.args.input_graph
        if self.custom_args:
            command += " -n " + str(self.args.number_of_steps)
        if self.args.socket_id != -1:
            command += " -x "
        command += \
            " -d " + self.args.data_location + \
            " --num-inter-threads " + str(self.args.num_inter_threads) + \
            " --num-intra-threads " + str(self.args.num_intra_threads)
        self.run_command(command)

    def run_accuracy_command(self):
        num_cores = str(self.platform_util.num_cores_per_socket)
        if self.args.num_cores != -1:
            num_cores = str(self.args.num_cores)

        set_env_var("OMP_NUM_THREADS", num_cores)

        command = "{} {} {} {}".format(self.accuracy_script_path,
                                       self.args.input_graph,
                                       self.args.data_location,
                                       self.args.model_source_dir)
        self.run_command(command)

    def run(self):
        # Run script from the tensorflow models research directory
        original_dir = os.getcwd()
        os.chdir(os.path.join(self.args.model_source_dir, "research"))
        if self.args.accuracy_only:
            self.run_accuracy_command()
        else:
            self.run_perf_command()
        os.chdir(original_dir)
