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

PRETRAINED_MODEL=${PRETRAINED_MODEL-${MODEL_DIR}/densenet169_fp32_pretrained_model.pb}

source "${MODEL_DIR}/quickstart/common/utils.sh"
_command python benchmarks/launch_benchmark.py \
         --model-name=densenet169 \
         --precision=fp32 \
         --mode=inference \
         --framework tensorflow \
         --in-graph ${PRETRAINED_MODEL} \
         --data-location=${DATASET_DIR} \
         --output-dir ${OUTPUT_DIR} \
         --accuracy-only \
         --batch-size=100 \
         --socket-id 0 \
         $@ \
         -- input_height=224 input_width=224 \
         input_layer="input" output_layer="densenet169/predictions/Reshape_1"

