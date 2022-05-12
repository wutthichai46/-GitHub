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
MPI_NUM_PROCESSES=${MPI_NUM_PROCESSES:=1}

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

if [ -z "${TF_MODELS_DIR}" ]; then
  echo "The required environment variable TF_MODELS_DIR has not been set."
  echo "Set this variable to point to a clone of the tensorflow/models repository."
  exit 1
fi

if [ ! -d "${TF_MODELS_DIR}" ]; then
  echo "The TF_MODELS_DIR '${TF_MODELS_DIR}' does not exist"
  echo "Set this variable to point to a clone of the tensorflow/models repository."
  exit 1
fi

# Apply the TF 2.0 patch to the TF_MODELS_DIR
cd ${TF_MODELS_DIR}
git apply ${MODEL_DIR}/models/object_detection/tensorflow/ssd-resnet34/training/fp32/tf-2.0.diff
cd ${MODEL_DIR}

# Run training with one mpi process
source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
  --data-location ${DATASET_DIR} \
   --model-source-dir ${TF_MODELS_DIR} \
   --model-name ssd-resnet34 \
   --framework tensorflow \
   --precision fp32 \
   --mode training \
   --num-train-steps 100 \
   --batch-size 100 \
   --weight_decay=1e-4 \
   --mpi_num_processes=${MPI_NUM_PROCESSES} \
   --mpi_num_processes_per_socket=1 \
   --output-dir ${OUTPUT_DIR}
