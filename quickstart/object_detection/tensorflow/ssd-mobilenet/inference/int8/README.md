<!--- 0. Title -->
# SSD-MobileNet Int8 inference

<!-- 10. Description -->
## Description

This document has instructions for running SSD-MobileNet Int8 inference using
Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

The [COCO validation dataset](http://cocodataset.org) is used in these
SSD-Mobilenet quickstart scripts. The inference and accuracy quickstart scripts require the dataset to be converted into the TF records format.
See the [COCO dataset](/datasets/coco/README.md) for instructions on
downloading and preprocessing the COCO validation dataset.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`int8_accuracy.sh`](int8_accuracy.sh) | Runs inference and checks accuracy on the results. |
| [`multi_instance_batch_inference.sh`](multi_instance_batch_inference.sh) | A multi-instance run that uses all the cores for each socket for each instance with a batch size of 448 and synthetic data. |
| [`multi_instance_online_inference.sh`](multi_instance_online_inference.sh) | A multi-instance run that uses 4 cores per instance with a batch size of 1 and synthetic data. |

These quickstart scripts can be run using:
* [Docker](#docker)

<!--- 60. Docker -->
## Docker

The model container includes the scripts and libraries needed to run 
SSD-MobileNet Int8 inference. To run one of the quickstart scripts 
using this container, you'll need to provide volume mounts for the dataset
and an output directory. Omit the `DATASET_DIR` when running the multi-instance
quickstart scripts, since synthetic data will be used.

```
DATASET_DIR=<path to the coco tf record file>
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/object-detection:tf-r2.5-icx-b631821f-ssd-mobilenet-int8-inference \
  /bin/bash quickstart/<script name>.sh
```

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

