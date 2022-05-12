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

if [ ! -f "${DATASET_DIR}" ]; then
  echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
  exit 1
fi

NUM_OMP_THREADS="${NUM_OMP_THREADS:-1}"
PRETRAINED_MODEL=${PRETRAINED_MODEL-$MODEL_DIR/wide_deep_fp32_pretrained_model.pb}

# Run wide and deep large dataset inference
source "$MODEL_DIR/quickstart/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
   --model-name wide_deep_large_ds \
   --precision fp32 \
   --mode inference \
   --framework tensorflow \
   --batch-size 1 \
   --data-location $DATASET_DIR \
   --output-dir $OUTPUT_DIR \
   --in-graph ${PRETRAINED_MODEL} \
   --benchmark-only \
   $@ \
   -- num_omp_threads=$NUM_OMP_THREADS
