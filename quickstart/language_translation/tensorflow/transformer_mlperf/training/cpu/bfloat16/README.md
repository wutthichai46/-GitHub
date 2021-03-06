<!--- 0. Title -->
# Transformer Language BFloat16 training

<!-- 10. Description -->
## Description

This document has instructions for running Transformer Language BFloat16 training using
Intel-optimized TensorFlow.

Detailed information on mlperf Benchmark can be found in [mlperf/training](https://github.com/mlperf/training/tree/master/translation/tensorflow/transformer)

<!--- 20. Download link -->
## Download link

[transformer-mlperf-bfloat16-training.tar.gz](https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_7_0/transformer-mlperf-bfloat16-training.tar.gz)

<!--- 30. Datasets -->
## Datasets

Follow [instructions](https://github.com/IntelAI/models/tree/master/datasets/transformer_data/README.md) to download and preprocess the WMT English-German dataset.
Set `DATASET_DIR` to point out to the location of the dataset directory.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

Transformer Language in mlperf benchmark can run with full training or
fewer training steps. During training we can control if it will do the evaluation
or not.

| Script name | Description |
|-------------|-------------|
| [`bfloat16_training_demo.sh`](/quickstart/language_translation/tensorflow/transformer_mlperf/training/cpu/bfloat16/bfloat16_training_demo.sh) | Runs 100 training steps. The script runs in single instance mode by default, for multi instance mode set `MPI_NUM_PROCESSES`. |
| [`bfloat16_training.sh`](/quickstart/language_translation/tensorflow/transformer_mlperf/training/cpu/bfloat16/bfloat16_training.sh) | Runs 200 training steps, saves checkpoints and does evaluation. The script runs in single instance mode by default, for multi instance mode set `MPI_NUM_PROCESSES`. |

<!--- 50. Bare Metal -->
## Bare Metal

To run on bare metal, the following prerequisites must be installed in your environment:
* Python 3
* [intel-tensorflow>=2.5.0](https://pypi.org/project/intel-tensorflow/)
* numactl

After installing the prerequisites, download and untar the model package.
Set environment variables for the path to your `DATASET_DIR` and an
`OUTPUT_DIR` where log files will be written, then run a 
[quickstart script](#quick-start-scripts). 

```
DATASET_DIR=<path to the dataset>
OUTPUT_DIR=<directory where log files will be written>

wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_7_0/transformer-mlperf-bfloat16-training.tar.gz
tar -xzf transformer-mlperf-bfloat16-training.tar.gz
cd transformer-mlperf-bfloat16-training

./quickstart/<script name>
```

For training in multi-instance mode (2 sockets in a single node for example) in evaluation mode,
where we are "saving checkpoints" and "doing the evaluation", the following prerequisites must be installed in your environment:
* gcc-8
* g++-8
* libopenmpi-dev
* openmpi
* openssh
* horovod

Set environment variables for the path to your `DATASET_DIR`, 
`OUTPUT_DIR` where log files will be written, and set the 
`MPI_NUM_PROCESSES` to the number of sockets to use. Then run a
[quickstart script](#quick-start-scripts).

```
DATASET_DIR=<path to the dataset>
OUTPUT_DIR=<directory where log files will be written>
MPI_NUM_PROCESSES=<number of sockets to use>

cd transformer-mlperf-bfloat16-training
./quickstart/<script name>
```


<!--- 60. Docker -->
## Docker

The model container includes the scripts and libraries needed to run 
Transformer Language BFloat16 training. To run one of the quickstart scripts 
using this container, you'll need to provide volume mounts for the dataset 
and an output directory.

```
DATASET_DIR=<path to the dataset>
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/language-translation:tf-latest-transformer-mlperf-bfloat16-training \
  /bin/bash quickstart/<script name>
```

To run distributed training (one MPI process per socket) for better throughput,
set the `MPI_NUM_PROCESSES` to the number of sockets to use.

```
DATASET_DIR=<path to the dataset>
OUTPUT_DIR=<directory where log files will be written>
MPI_NUM_PROCESSES=<number of sockets to use>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
   --env MPI_NUM_PROCESSES=${MPI_NUM_PROCESSES} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/language-translation:tf-latest-transformer-mlperf-bfloat16-training \
  /bin/bash quickstart/<script name>
```

If you are new to docker and are running into issues with the container,
see [this document](https://github.com/IntelAI/models/tree/master/docs/general/docker.md)
for troubleshooting tips.

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

