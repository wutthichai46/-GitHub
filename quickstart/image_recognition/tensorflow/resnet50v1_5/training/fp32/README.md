<!--- 0. Title -->
# ResNet50 v1.5 FP32 training

<!-- 10. Description -->

This document has instructions for running ResNet50 v1.5 FP32 training
using Intel-optimized TensorFlow.

Note that the ImageNet dataset is used in these ResNet50 v1.5 examples.
Download and preprocess the ImageNet dataset using the [instructions here](/datasets/imagenet/README.md).
After running the conversion script you should have a directory with the
ImageNet dataset in the TF records format.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`multi_instance_training_demo.sh`](multi_instance_training_demo.sh) | Uses mpirun to execute 2 processes with 1 process per socket with a batch size of 256 for 50 steps. |
| [`multi_instance_training.sh`](multi_instance_training.sh) | Uses mpirun to execute 2 processes with 1 process per socket with a batch size of 256. Checkpoint files and logs for each instance are saved to the output directory. Note that this will take a considerable amount of time. |

These quick start scripts can be run using:
* [Docker](#docker)

<!-- 60. Docker -->
## Docker

The ResNet50 v1.5 FP32 training model container includes the scripts
and libraries needed to run ResNet50 v1.5 FP32 training. To run one of the model
training quickstart scripts using this container, you'll need to provide volume mounts for
the ImageNet dataset and an output directory where checkpoint files will be written.

```
DATASET_DIR=<path to the preprocessed imagenet dataset>
OUTPUT_DIR=<directory where checkpoint and log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/image-recognition:tf-r2.5-icx-b631821f-resnet50v1-5-fp32-training \
  /bin/bash quickstart/<script name>.sh
```


<!-- 61. Advanced Options -->

See the [Advanced Options for Model Packages and Containers](/quickstart/common/tensorflow/ModelPackagesAdvancedOptions.md)
document for more advanced use cases.

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

