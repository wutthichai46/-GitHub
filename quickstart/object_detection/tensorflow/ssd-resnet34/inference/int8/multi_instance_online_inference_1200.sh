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

if [ -z "${TF_MODELS_DIR}" ]; then
  echo "The required environment variable TF_MODELS_DIR has not been set."
  echo "Set TF_MODELS_DIR to the directory where the tensorflow/models repo has been cloned."
  exit 1
fi

if [ ! -d "${TF_MODELS_DIR}" ]; then
  echo "The TF_MODELS_DIR directory '${TF_MODELS_DIR}' does not exist"
  exit 1
fi

export PYTHONPATH=${PYTHONPATH}:${TF_MODELS_DIR}/research
export PYTHONPATH=${PYTHONPATH}:${TF_BENCHMARKS_DIR}/scripts/tf_cnn_benchmarks

FROZEN_GRAPH=${FROZEN_GRAPH-"$MODEL_DIR/pretrained_models/ssd_resnet34_int8_1200x1200_pretrained_model.pb"}
CORES_PER_INSTANCE="4"
BATCH_SIZE="1"
PRECISION="int8"
MODE="inference"

source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
    --in-graph ${FROZEN_GRAPH} \
    --model-source-dir ${TF_MODELS_DIR} \
    --model-name ssd-resnet34 \
    --framework tensorflow \
    --precision ${PRECISION} \
    --mode ${MODE} \
    --numa-cores-per-instance ${CORES_PER_INSTANCE} \
    --batch-size ${BATCH_SIZE} \
    --output-dir ${OUTPUT_DIR} \
    --benchmark-only \
    $@ \
    -- input-size=1200

if [[ $? == 0 ]]; then
  echo "Summary total samples/sec:"
  grep 'Total samples/sec' ${OUTPUT_DIR}/ssd-resnet34_${PRECISION}_${MODE}_bs${BATCH_SIZE}_cores${CORES_PER_INSTANCE}_all_instances.log  | awk -F' ' '{sum+=$3;} END{print sum} '
else
  exit 1
fi
