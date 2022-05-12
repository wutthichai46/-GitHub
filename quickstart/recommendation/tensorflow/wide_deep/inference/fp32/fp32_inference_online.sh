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

# Check for TF_MODEL_SOURCE_DIR
if [ -d "/tensorflow/models" ]; then # if true assume running in docker
   TF_MODEL_SOURCE_DIR=/tensorflow/models
elif [ -z ${TF_MODEL_SOURCE_DIR} ]; then
    echo "Please set TF_MODEL_SOURCE_DIR or run in docker mode." >&2
    exit 1
fi

echo 'TF_MODEL_SOURCE_DIR='$TF_MODEL_SOURCE_DIR

# Unzip pretrained model files
pretrained_model_dir="pretrained_model/wide_deep_fp32_pretrained_model"
if [ ! -d "${pretrained_model_dir}" ]; then
    tar -C pretrained_model/ -xvf pretrained_model/wide_deep_fp32_pretrained_model.tar.gz
fi
CHECKPOINT_DIR="$(pwd)/${pretrained_model_dir}"

# Create an array of input directories that are expected and then verify that they exist
declare -A input_dirs
input_dirs[CHECKPOINT_DIR]=${CHECKPOINT_DIR}
input_dirs[DATASET_DIR]=${DATASET_DIR}

for i in "${!input_dirs[@]}"; do
  var_name=$i
  dir_path=${input_dirs[$i]}
 
  if [[ -z $dir_path ]]; then
    echo "The required environment variable $var_name is empty" >&2
    exit 1
  fi

  if [[ ! -d $dir_path ]]; then
    echo "The $var_name path '$dir_path' does not exist" >&2
    exit 1
  fi
done

source "$(dirname $0)/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
      --framework tensorflow \
      --model-source-dir ${TF_MODEL_SOURCE_DIR} \
      --precision fp32 \
      --mode inference \
      --model-name wide_deep \
      --batch-size 1 \
      --data-location ${DATASET_DIR} \
      --checkpoint ${CHECKPOINT_DIR} \
      --output-dir ${OUTPUT_DIR} \
      $@

