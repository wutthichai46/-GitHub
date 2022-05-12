<!--- 0. Title -->
# SSD-ResNet34 FP32 inference

<!-- 10. Description -->
## Description

This document has instructions for running [SSD-ResNet34](https://arxiv.org/pdf/1512.02325.pdf)
FP32 inference using Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

The SSD-ResNet34 accuracy scripts ([fp32_accuracy.sh](fp32_accuracy.sh)
and [fp32_accuracy_1200.sh](fp32_accuracy_1200.sh)) use the
[COCO validation dataset](http://cocodataset.org) in the TF records
format. See the [COCO dataset document](/datasets/coco/README.md) for
instructions on downloading and preprocessing the COCO validation dataset.

The performance benchmarking scripts ([fp32_inference.sh](fp32_inference.sh)
and [fp32_inference_1200.sh](fp32_inference_1200.sh)) use synthetic data,
so no dataset is required.



<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [fp32_accuracy_1200.sh](fp32_accuracy_1200.sh) | Runs an accuracy test using data in the TF records format with an input size of 1200x1200. |
| [multi_instance_batch_inference_1200.sh](multi_instance_batch_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with one instance per socket. Uses synthetic data with an input size of 1200x1200. Waits for all instances to complete, then prints a summarized throughput value. |
| [multi_instance_online_inference_1200.sh](multi_instance_online_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with 4 cores per instance. Uses synthetic data with an input size of 1200x1200. Waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run using:
* [Docker](#docker)

<!--- 60. Docker -->
## Docker

The model container includes the scripts and libraries needed to run 
SSD-ResNet34 FP32 inference. To run one of the quickstart scripts 
using this container, you'll need to provide a volume mount for the
output directory. Running an accuracy test will also require a volume
mount for the dataset directory (with the COCO validation dataset in
the TF records format). Inference performance scripts use synthetic
data.

```
DATASET_DIR=<path to the dataset (for accuracy testing only)>
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/object-detection:tf-r2.5-icx-b631821f-ssd-resnet34-fp32-inference \
  /bin/bash quickstart/<script name>.sh
```

<!--- 61. Advanced Options -->

See the [Advanced Options for Model Packages and Containers](quickstart/common/tensorflow/ModelPackagesAdvancedOptions.md)
document for more advanced use cases.

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

