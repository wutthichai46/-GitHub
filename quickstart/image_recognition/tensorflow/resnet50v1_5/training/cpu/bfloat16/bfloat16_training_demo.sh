#!/usr/bin/env bash
#
# Copyright (c) 2020 Intel Corporation
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

MODEL_DIR=${MODEL_DIR-$PWD}

if [ -z "${OUTPUT_DIR}" ]; then
  echo "The required environment variable OUTPUT_DIR has not been set"
  exit 1
fi

# Create the output directory in case it doesn't already exist
mkdir -p ${OUTPUT_DIR}

if [ -z "${DATASET_DIR}" ]; then
  echo "The required environment variable DATASET_DIR has not been set"
  exit 1
fi

if [ ! -d "${DATASET_DIR}" ]; then
  echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
  exit 1
fi

mpi_num_proc_arg=""

if [[ -n $MPI_NUM_PROCESSES ]]; then
  mpi_num_proc_arg="--mpi_num_processes=${MPI_NUM_PROCESSES}"
fi

source "${MODEL_DIR}/quickstart/common/utils.sh"
_command python benchmarks/launch_benchmark.py \
         --model-name=resnet50v1_5 \
         --precision=bfloat16 \
         --mode=training \
         --framework tensorflow \
         --batch-size 16 \
         --checkpoint ${OUTPUT_DIR} \
         --data-location=${DATASET_DIR} \
         --noinstall \
	 ${mpi_num_proc_arg} \
         $@ \
         -- steps=50 train_epochs=1 epochs_between_evals=1

