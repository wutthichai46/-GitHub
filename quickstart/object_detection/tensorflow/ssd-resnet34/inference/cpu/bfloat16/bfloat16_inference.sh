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

echo 'MODEL_DIR='$MODEL_DIR
echo 'OUTPUT_DIR='$OUTPUT_DIR

if [ -z "${OUTPUT_DIR}" ]; then
  echo "The required environment variable OUTPUT_DIR has not been set"
  exit 1
fi

# Create the output directory in case it doesn't already exist
mkdir -p ${OUTPUT_DIR}

if [ -z "${TF_MODELS_DIR}" ]; then
  echo "The required environment variable TF_MODELS_DIR has not been set."
  echo "Set TF_MODELS_DIR to the directory where the tensorflow/models repo has been cloned."
  exit 1
fi

if [ ! -d "${TF_MODELS_DIR}" ]; then
  echo "The TF_MODELS_DIR directory '${TF_MODELS_DIR}' does not exist"
  exit 1
fi

PRETRAINED_MODEL=${PRETRAINED_MODEL-"$MODEL_DIR/pretrained_models/ssd_resnet34_fp32_bs1_pretrained_model.pb"}

export PYTHONPATH=${PYTHONPATH}:${TF_MODELS_DIR}/research
export PYTHONPATH=${PYTHONPATH}:${TF_BENCHMARKS_DIR}/scripts/tf_cnn_benchmarks

source "${MODEL_DIR}/quickstart/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
    --in-graph ${PRETRAINED_MODEL} \
    --model-source-dir ${TF_MODELS_DIR} \
    --model-name ssd-resnet34 \
    --framework tensorflow \
    --precision bfloat16 \
    --mode inference \
    --socket-id 0 \
    --batch-size 1 \
    --benchmark-only \
    --output-dir ${OUTPUT_DIR} \
    $@
