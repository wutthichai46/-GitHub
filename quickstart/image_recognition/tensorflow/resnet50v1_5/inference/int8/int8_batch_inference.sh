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

# DATASET_DIR is optional
if [ -z "${DATASET_DIR}" ]; then
  DATASET_OPTION=""
else
  if [ ! -d "${DATASET_DIR}" ]; then
    echo "The DATASET_DIR '${DATASET_DIR}' does not exist"
    exit 1
  fi
  DATASET_OPTION="--data-location ${DATASET_DIR}"
fi

MODEL_FILE="${MODEL_DIR}/pretrained_model/resnet50v1_5_int8_pretrained_model.pb"

source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
    --in-graph ${MODEL_FILE} \
    --model-name resnet50v1_5 \
    --framework tensorflow \
    --precision int8 \
    --mode inference \
    --batch-size=128 \
    --output-dir ${OUTPUT_DIR} \
    ${DATASET_OPTION} \
    --benchmark-only \
    $@ \
    -- warmup_steps=50 steps=500

