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

# Check for MODEL_SRC_DIR 
if [ -z ${MODEL_SRC_DIR} ]; then
    echo "Please set MODEL_SRC_DIR to the location where the MaskRCNN repository has been cloned." >&2
    exit 1
fi

echo 'MODEL_SRC_DIR='$MODEL_SRC_DIR

source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
    --model-source-dir $MODEL_SRC_DIR \
    --model-name maskrcnn \
    --framework tensorflow \
    --precision fp32 \
    --mode inference \
    --batch-size 1 \
    --socket-id 0 \
    --data-location $DATASET_DIR \
    --output-dir ${OUTPUT_DIR} \
    $@
