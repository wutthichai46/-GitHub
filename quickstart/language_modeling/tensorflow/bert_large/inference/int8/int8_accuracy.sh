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
echo 'DATASET_DIR='$DATASET_DIR

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

# Unzip pretrained model files
pretrained_model_dir="pretrained_model/bert_large_checkpoints"
if [ ! -d "${pretrained_model_dir}" ]; then
    unzip pretrained_model/bert_large_checkpoints.zip -d pretrained_model
fi

CHECKPOINT_DIR="${MODEL_DIR}/${pretrained_model_dir}"
PRETRAINED_MODEL="${MODEL_DIR}/pretrained_model/asymmetric_per_channel_bert_int8.pb"
BATCH_SIZE="32"

source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
  --model-name bert_large \
  --mode inference \
  --precision int8 \
  --framework tensorflow \
  --socket-id 0 \
  --batch-size ${BATCH_SIZE} \
  --in-graph ${PRETRAINED_MODEL} \
  --data-location ${DATASET_DIR} \
  --checkpoint ${CHECKPOINT_DIR} \
  --accuracy-only \
  --output-dir ${OUTPUT_DIR} \
  $@ \
  -- \
  init_checkpoint=model.ckpt-3649 \
  infer_option=SQuAD \
  experimental-gelu=True
