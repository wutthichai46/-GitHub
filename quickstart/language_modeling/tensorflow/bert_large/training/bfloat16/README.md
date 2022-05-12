# BERT Large FP32/BFloat16 Training with LAMB Optimizer (MLPerf Training v0.7 compliant)

## Description

This document has instructions for running BERT Large BFloat16 training with LAMB optimizer using Intel-optimized TensorFlow. This BERT code base was developed to be as much complaint to MLPerf Training v0.7 as possible.

## Datasets

### Pretrained models

Download and extract checkpoints (the bert pretrained model) released by Google and used by MLPerf Training v0.7 from the following link:
(https://console.cloud.google.com/storage/browser/pkanwar-bert/bs64k_32k_ckpt).
The extracted directory should be set to the `CHECKPOINT_DIR` environment
variable when running the quickstart scripts.

MLPerf Training v0.7 was training from the above checkpoint file. For training from scratch, the above checkpoint files would not be used. In either cases, the wikipedia dataset would be needed. Please follow the other text file (HowToGenerateBERTPretrainingDataset.txt) for instructions to generate the dataset.

## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`bfloat16_pretraining_training.sh`](bfloat16_pretraining_training.sh) | This script can do pretraining using wikipedia dataset.|

The quickstart scripts can be run in the following environments:
* [Docker](#docker)
* [Bare metal](#bare-metal)


## Docker

The BERT Large BFloat16 training model container includes the scripts and libraries
needed to run distributed BERT Large BFloat16 pretuning. To run the quickstart scripts
using this container, you'll need to provide volume mounts for the pretrained model,
dataset, and an output directory where log and checkpoint files will be written.

The snippet below shows a quickstart script running distributed training on the entire machine (by default the script assumes running on all the sockets of the machine and two times the amount of MPI processes).
```
CHECKPOINT_DIR=<path to the pretrained bert model directory>
DATASET_DIR=<path to the dataset being used>
OUTPUT_DIR=<directory where checkpoints and log files will be saved>

docker run \
  --env CHECKPOINT_DIR=${CHECKPOINT_DIR} \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${CHECKPOINT_DIR}:${CHECKPOINT_DIR} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -it \
  intel/language-modeling:tf-2.2.0-imz-2.2.0-bert-large-bfloat16-lamb-training \
  /bin/bash quickstart/bfloat16_pretraining_training.sh
```
For example, running the above command on an 8-socket 28 core 3rd gen Intel Xeon scalable processors would generate 16 MPI processes (2 MPI processes per socket). 
To change the behaviour, say, to run distributed training with one MPI process per socket, please 
set the `MPI_NUM_PROCESSES` var to the number of sockets to use and optionally the `NUM_SOCKETS` var. If `NUM_SOCKETS` var is omitted, the script assumes using all sockets. However if `MPI_NUM_PROCESSES` is omitted and `NUM_SOCKETS` is not, the system will again utilize two MPI processes per socket to maximize throughput. Note that the
global batch size is mpi_num_processes * train_batch_size and sometimes the learning
rate needs to be adjusted for convergence. By default, the script uses square root
learning rate scaling.
Below shows the example command to adjust the MPI_NUM_PROCESSES.

```
CHECKPOINT_DIR=<path to the pretrained bert model directory>
DATASET_DIR=<path to the dataset being used>
OUTPUT_DIR=<directory where checkpoints and log files will be saved>
MPI_NUM_PROCESSES=<number of MPI workers to use for pretraining>
NUM_SOCKETS=<number of sockets to use>

docker run \
  --env CHECKPOINT_DIR=${CHECKPOINT_DIR} \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env MPI_NUM_PROCESSES=${MPI_NUM_PROCESSES} \
  --env NUM_SOCKETS=${NUM_SOCKETS} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${CHECKPOINT_DIR}:${CHECKPOINT_DIR} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -it \
  intel/language-modeling:tf-2.2.0-imz-2.2.0-bert-large-bfloat16-lamb-training \
  /bin/bash quickstart/bfloat16_pretraining_training.sh
```

## Bare Metal

To run distributed training of BERT pretraining on bare metal, the following prerequisites must be installed in your enviornment:
* Python 3
* A custom build of Intel optimized TensorFlow for best performance (https://github.com/Intel-tensorflow/tensorflow/tree/bf16/base)
* numactl
* git

The following additional dependencies will need to be
installed in your environment to enable distributed training with horovod:
* openmpi-bin
* openmpi-common
* openssh-client
* openssh-server
* libopenmpi-dev
* horovod==0.19.1

Step 1: Set up TensorFlow distributed training environment 

MPI version: Make sure MPI has been installed. Both Intel MPI and OpenMPI would work, in this document, we use OpenMPI. The OpenMPI version we tested was 2.1.1. Newer version of OpenMPI should also work.  

TensorFlow version: for best BERT training performance, we used the https://github.com/Intel-tensorflow/tensorflow/tree/bf16/base and commit id: 4c883d50823609e8450a8627ff4da819f9c35687 

The above TF is also available in this docker container: docker pull intel/intel-optimized-tensorflow:tensorflow-2.2-bf16-nightly 

If the intention is to build a TF wheel, the following build command is recommended:  

bazel build --copt=-O3 --copt=-march=native --copt=-DENABLE_INTEL_MKL_BFLOAT16  --config=mkl --define build_with_mkl_dnn_v1_only=true -c opt //tensorflow/tools/pip_package:build_pip_package   

Horovod version: we used 0.19.1 version.  

Steps to setup the above 3 SW: 

Making sure mpirun –version shows the OpenMPI 2.1.1 has been installed. 

virtualenv -p python3  TF-BF16-BERT-venv 

. TF-BF16-BERT-venv/bin/activate 

pip install tensorflow-2.1.0-cp36-cp36m-linux_x86_64.whl (the wheel is from step b above, if you are using docker, all the above can be skipped) 

pip install --no-cache-dir  horovod==0.19.1  

This step may have errors depending on system’s env, contact Intel if error happens in this step, we can help trouble shoot the env issue. 


The snippet below shows a quickstart script running distributed training on the entire machine (by default the script assumes running on all the sockets of the machine and two times the amount of MPI processes).

```
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/<TBD>.tar.gz
tar -xvf bert-large-bfloat16-training.tar.gz
cd bert-large-bfloat16-training

CHECKPOINT_DIR=<path to the pretrained bert model directory>
DATASET_DIR=<path to the dataset being used>
OUTPUT_DIR=<directory where checkpoints and log files will be saved>

./quickstart/bfloat16_pretraining_training.sh
```
For example, running the above command on an 8-socket 28 core 3rd gen Intel Xeon scalable processors would generate 16 MPI processes (2 MPI processes per socket). 
To change the behaviour, say, to run distributed training with one MPI process per socket, please 
set the `MPI_NUM_PROCESSES` var to the number of sockets to use and optionally the `NUM_SOCKETS` var. If `NUM_SOCKETS` var is omitted, the script assumes using all sockets. However if `MPI_NUM_PROCESSES` is omitted and `NUM_SOCKETS` is not, the system will again utilize two MPI processes per socket to maximize throughput. Note that the
global batch size is mpi_num_processes * train_batch_size and sometimes the learning
rate needs to be adjusted for convergence. By default, the script uses square root
learning rate scaling.
Below shows the example command to adjust the MPI_NUM_PROCESSES.

```
CHECKPOINT_DIR=<path to the pretrained bert model directory>
DATASET_DIR=<path to the dataset being used>
OUTPUT_DIR=<directory where checkpoints and log files will be saved>
MPI_NUM_PROCESSES=<number of MPI workers to use for pretraining>
NUM_SOCKETS=<number of sockets to use>

./quickstart/bfloat16_pretraining_training.sh
```

## License

[LICENSE](/LICENSE)

