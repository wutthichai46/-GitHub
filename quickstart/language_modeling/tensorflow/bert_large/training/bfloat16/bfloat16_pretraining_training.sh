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
OUTPUT_DIR=${OUTPUT_DIR}
CHECKPOINT_DIR=${CHECKPOINT_DIR}
DATASET_DIR=${DATASET_DIR}

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
socket_num=""

if [[ -n $MPI_NUM_PROCESSES ]]; then
  mpi_num_proc_arg="${MPI_NUM_PROCESSES}"
  if [[ -n $NUM_SOCKETS ]]; then
    echo "Both number of MPI processes and number of sockets are specified"
    socket_num=$NUM_SOCKETS
  else
    socket_num=`lscpu |grep Socket |awk '{print $2}'`
  fi
else
  # When the users do not specify anything relating to MPI_NUM_PROCESSES
  # The script assumes common use case is two MPI per socket
  # Decide on whether the number of sockets has been provided
  if [[ -n $NUM_SOCKETS ]]; then
    mpi_num_proc_arg=`expr $NUM_SOCKETS \* 2`
    socket_num=$NUM_SOCKETS
  # NUM_SOCKETS to be used is not specified, use all sockets
  else 	  
    # Figure out the number of total sockets
    socket_num=`lscpu |grep Socket |awk '{print $2}'`
    mpi_num_proc_arg=`expr $socket_num \* 2`
  fi
fi

echo $mpi_num_proc_arg
echo $socket_num

# Determine OMP_NUM_THREADS and MPI command based on
# mpi_num_proc_arg and socket_num

ppr=""

# get number of cores per socket
num_cores_per_socket=`lscpu |grep "per socket" |awk '{print $NF}'`

if [ $mpi_num_proc_arg -le $socket_num ] 
then
  ppr=1
  omp_threads=$num_cores_per_socket
else
  ppr=`expr $mpi_num_proc_arg / $socket_num`
  num_pe=`expr $num_cores_per_socket / $ppr`
  if [ $num_pe  -gt 2 ] 
  then
    omp_threads=`expr $num_pe - 2`
  else 
    omp_threads=$num_pe
  fi 
fi

echo $omp_threads  
export OMP_NUM_THREADS=$omp_threads
export KMP_BLOCKTIME=1
export KMP_SETTINGS=TRUE
export KMP_AFFINITY=granularity=fine,compact,1,0

if  [ $ppr -gt 1 ] 
then 
  mpirun --allow-run-as-root -n $mpi_num_proc_arg --map-by ppr:$ppr:socket:pe=$num_pe python ${MODEL_DIR}/models/language_modeling/tensorflow/bert_large/training/bfloat16/run_pretraining.py --input_file=${DATASET_DIR}/part-* --output_dir=${OUTPUT_DIR}/MLPerfWheelGoogle-bf16-IntelTF-4 --do_train=True --do_eval=True  --bert_config_file=${CHECKPOINT_DIR}/bs64k_32k_ckpt_bert_config.json --init_checkpoint=${CHECKPOINT_DIR}/bs64k_32k_ckpt_model.ckpt-28252 --train_batch_size=16 --max_seq_length=512 --max_predictions_per_seq=76 --num_train_steps=13617 --optimizer_type=lamb --learning_rate=0.0000875 --use_tpu=False --inter_op_parallelism_threads=1 --intra_op_parallelism_threads=12 --iteration_per_loop=1953 --precision=bfloat16 --experimental_gelu=True --num_warmup_steps=0 --optimized_softmax=True --max_eval_steps=40 --eval_batch_size=256 --save_checkpoints_steps=2000
else 
  mpirun --allow-run-as-root -n $mpi_num_proc_arg --map-by socket python ${MODEL_DIR}/models/language_modeling/tensorflow/bert_large/training/bfloat16/run_pretraining.py --input_file=${DATASET_DIR}/part-* --output_dir=${OUTPUT_DIR}/MLPerfWheelGoogle-bf16-IntelTF-4 --do_train=True --do_eval=True  --bert_config_file=${CHECKPOINT_DIR}/bs64k_32k_ckpt_bert_config.json --init_checkpoint=${CHECKPOINT_DIR}/bs64k_32k_ckpt_model.ckpt-28252 --train_batch_size=16 --max_seq_length=512 --max_predictions_per_seq=76 --num_train_steps=13617 --optimizer_type=lamb --learning_rate=0.0000875 --use_tpu=False --inter_op_parallelism_threads=1 --intra_op_parallelism_threads=12 --iteration_per_loop=1953 --precision=bfloat16 --experimental_gelu=True --num_warmup_steps=0 --optimized_softmax=True --max_eval_steps=40 --eval_batch_size=256 --save_checkpoints_steps=2000
fi  
