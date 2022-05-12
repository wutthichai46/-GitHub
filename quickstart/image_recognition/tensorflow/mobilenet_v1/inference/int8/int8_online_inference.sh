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

MODEL_FILE="$(pwd)/mobilenetv1_int8_pretrained_model.pb"
python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
     --model-name mobilenet_v1 \
     --precision int8 \
     --mode inference \
     --framework tensorflow \
     --benchmark-only \
     --batch-size 1  \
     --socket-id 0 \
     --output-dir ${OUTPUT_DIR} \
     --in-graph ${MODEL_FILE} \
     $@ \
     -- input_height=224 input_width=224 warmup_steps=10 steps=50 \
     input_layer="input" output_layer="MobilenetV1/Predictions/Reshape_1"

