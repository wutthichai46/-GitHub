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
echo 'CHECKPOINT_DIR='$CHECKPOINT_DIR
echo 'DATASET_DIR='$DATASET_DIR

if [[ -z $OUTPUT_DIR ]]; then
  echo "The required environment variable OUTPUT_DIR has not been set" >&2
  exit 1
fi

# Create the output directory, if it doesn't already exist
mkdir -p $OUTPUT_DIR

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

mpi_num_proc_arg=""

if [[ -n $MPI_NUM_PROCESSES ]]; then
  mpi_num_proc_arg="--mpi_num_processes=${MPI_NUM_PROCESSES}"
fi

source "${MODEL_DIR}/quickstart/common/utils.sh"
_command python ${MODEL_DIR}/benchmarks/launch_benchmark.py \
  --model-name=bert_large \
  --precision=fp32 \
  --mode=training \
  --framework=tensorflow \
  --batch-size=32 \
  ${mpi_num_proc_arg} \
  --output-dir=$OUTPUT_DIR \
  $@ \
  -- train-option=Classifier \
  task-name=MRPC \
  do-train=true \
  do-eval=true \
  data-dir=$DATASET_DIR/MRPC \
  vocab-file=$CHECKPOINT_DIR/vocab.txt \
  config-file=$CHECKPOINT_DIR/bert_config.json \
  init-checkpoint=$CHECKPOINT_DIR/bert_model.ckpt \
  max-seq-length=128 \
  learning-rate=2e-5 \
  num-train-epochs=30 \
  optimized_softmax=True \
  experimental_gelu=False \
  do-lower-case=True
  
