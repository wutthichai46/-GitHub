<!--- 0. Title -->
# ResNet50 v1.5 Int8 inference

<!-- 10. Description -->
## Description

This document has instructions for running ResNet50 v1.5 Int8 inference using
Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

Download and preprocess the ImageNet dataset using the [instructions here](/datasets/imagenet/README.md).
After running the conversion script you should have a directory with the
ImageNet dataset in the TF records format.

Set the `DATASET_DIR` to point to the TF records directory when running ResNet50 v1.5.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`int8_accuracy.sh`](int8_accuracy.sh) | Measures the model accuracy (batch_size=100). |
| [`multi_instance_batch_inference.sh`](multi_instance_batch_inference.sh) | Uses numactl to run batch inference (batch_size=128) with one instance per socket for 1500 steps and 50 warmup steps. If no `DATASET_DIR` is set, synthetic data is used. The script waits for all instances to complete, then prints a summarized throughput value. |
| [`multi_instance_online_inference.sh`](multi_instance_online_inference.sh) | Uses numactl to run online inference (batch_size=1) using four cores per instance for 1500 steps and 50 warmup steps. If no `DATASET_DIR` is set, synthetic data is used. The script waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run using:
* [Docker](#docker)

<!--- 60. Docker -->
## Docker

The model container `intel/image-recognition:tf-r2.5-icx-b631821f-resnet50v1-5-int8-inference` includes the scripts and libraries needed to run
ResNet50 v1.5 Int8 inference. To run one of the quickstart scripts 
using this container, you'll need to provide volume mounts for the dataset 
and an output directory.

For accuracy, `DATASET_DIR` is required to be set. For inference,
just to evaluate performance on synthetic data, the `DATASET_DIR` is not needed.
Otherwise `DATASET_DIR` needs to be set. Add or remove `DATASET_DIR` environment
variable and volume mount accordingly in following command:


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
  intel/image-recognition:tf-r2.5-icx-b631821f-resnet50v1-5-int8-inference \
  /bin/bash quickstart/<script name>.sh
```

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

