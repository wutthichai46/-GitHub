<!--- 0. Title -->
# SSD-ResNet34 Int8 inference

<!-- 10. Description -->
## Description

This document has instructions for running
[SSD-ResNet34](https://arxiv.org/pdf/1512.02325.pdf) Int8 inference
using Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

SSD-ResNet34 uses the [COCO dataset](https://cocodataset.org) for accuracy
testing.

Download and preprocess the COCO validation images using the
[instructions here](/datasets/coco). After the script to convert the raw
images to the TF records file completes, rename the tf_records file:
```
$ mv ${OUTPUT_DIR}/coco_val.record ${OUTPUT_DIR}/validation-00000-of-00001
```

Set the `DATASET_DIR` to the folder that has the `validation-00000-of-00001`
file when running the accuracy test. Note that the inference performance
test uses synthetic dataset.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [int8_accuracy_1200.sh](int8_accuracy_1200.sh) | Tests accuracy using the COCO dataset in the TF Records format with an input size of 1200x1200. |
| [multi_instance_batch_inference_1200.sh](multi_instance_batch_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with an input size of 1200x1200 and one instance per socket. Waits for all instances to complete, then prints a summarized throughput value. |
| [multi_instance_online_inference_1200.sh](multi_instance_online_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with an input size of 1200x1200 and four cores per instance. Waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run using:
* [Docker](#docker)

<!--- 60. Docker -->
## Docker

The model container includes the pretrained model, scripts and libraries
needed to run  SSD-ResNet34 Int8 inference. To run one of the
quickstart scripts using this container, you'll need to provide a volume
mount for an output directory where logs will be written. If you are
testing accuracy, then the directory where the coco dataset
`validation-00000-of-00001` file located will also need to be mounted.

To run inference using synthetic data:
```
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/object-detection:tf-r2.5-icx-b631821f-ssd-resnet34-int8-inference \
  /bin/bash quickstart/<script name>.sh
```

To test accuracy using the COCO dataset:
```
DATASET_DIR=<path to the COCO directory>
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/object-detection:tf-r2.5-icx-b631821f-ssd-resnet34-int8-inference \
  /bin/bash quickstart/int8_accuracy_1200.sh
```

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

