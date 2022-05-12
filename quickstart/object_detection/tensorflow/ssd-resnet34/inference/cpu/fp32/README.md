<!--- 0. Title -->
# SSD-ResNet34 FP32 inference

<!-- 10. Description -->
## Description

This document has instructions for running [SSD-ResNet34](https://arxiv.org/pdf/1512.02325.pdf)
FP32 inference using Intel-optimized TensorFlow.

<!--- 20. Download link -->
## Download link

Use the link below to download the model package for SSD-ResNet34
FP32 <inference>. The model package includes scripts and
documentation need to run the model.

[ssd-resnet34-fp32-inference.tar.gz](https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_5_0/ssd-resnet34-fp32-inference.tar.gz)

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
| [fp32_accuracy_1200.sh](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/fp32/fp32_accuracy_1200.sh) | Runs an accuracy test using data in the TF records format with an input size of 1200x1200. |
| [fp32_accuracy.sh](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/fp32/fp32_accuracy.sh) | Runs an accuracy test using data in the TF records format with an input size of 300x300. |
| [fp32_inference_1200.sh](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/fp32/fp32_inference_1200.sh) | Runs inference with a batch size of 1 using synthetic data with an input size of 1200x1200. Prints out the time spent per batch and total samples/second. |
| [fp32_inference.sh](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/fp32/fp32_inference.sh) | Runs inference with a batch size of 1 using synthetic data with an input size of 300x300. Prints out the time spent per batch and total samples/second. |
| [multi_instance_batch_inference_1200.sh](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/fp32/multi_instance_batch_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with one instance per socket. Uses synthetic data with an input size of 1200x1200. Waits for all instances to complete, then prints a summarized throughput value. |
| [multi_instance_online_inference_1200.sh](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/cpu/fp32/multi_instance_online_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with 4 cores per instance. Uses synthetic data with an input size of 1200x1200. Waits for all instances to complete, then prints a summarized throughput value. |

<!--- 50. Bare Metal -->
## Bare Metal

To run on bare metal, the following prerequisites must be installed in your environment:
* Python 3
* build-essential
* git
* libgl1-mesa-glx
* libglib2.0-0
* numactl
* python3-dev
* wget
* [intel-tensorflow>=2.5.0](https://pypi.org/project/intel-tensorflow/)
* Cython
* contextlib2
* horovod==0.19.1
* jupyter
* lxml
* matplotlib
* numpy>=1.17.4
* opencv-python
* pillow>=8.1.2
* pycocotools
* tensorflow-addons==0.11.0

The [TensorFlow models](https://github.com/tensorflow/models) and
[benchmarks](https://github.com/tensorflow/benchmarks) repos are used by
SSD-ResNet34 FP32 inference. Clone those at the git SHAs specified
below and set the `TF_MODELS_DIR` environment variable to point to the
directory where the models repo was cloned.

```
git clone --single-branch https://github.com/tensorflow/models.git tf_models
git clone --single-branch https://github.com/tensorflow/benchmarks.git ssd-resnet-benchmarks
cd tf_models
export TF_MODELS_DIR=$(pwd)
git checkout f505cecde2d8ebf6fe15f40fb8bc350b2b1ed5dc
cd ../ssd-resnet-benchmarks
git checkout 509b9d288937216ca7069f31cfb22aaa7db6a4a7
cd ..
```

After installing the prerequisites and cloning the models and benchmarks
repos, download and untar the model package.
Set environment variables for the path to your `DATASET_DIR` (for accuracy
testing only -- inference benchmarking uses synthetic data) and an
`OUTPUT_DIR` where log files will be written, then run a
[quickstart script](#quick-start-scripts).

```
DATASET_DIR=<path to the dataset (for accuracy testing only)>
OUTPUT_DIR=<directory where log files will be written>

wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_5_0/ssd-resnet34-fp32-inference.tar.gz
tar -xzf ssd-resnet34-fp32-inference.tar.gz
cd ssd-resnet34-fp32-inference

./quickstart/<script name>.sh
```

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
  intel/object-detection:tf-latest-ssd-resnet34-fp32-inference \
  /bin/bash quickstart/<script name>.sh
```

If you are new to docker and are running into issues with the container,
see [this document](https://github.com/IntelAI/models/tree/master/docs/general/docker.md)
for troubleshooting tips.

<!--- 61. Advanced Options -->

See the [Advanced Options for Model Packages and Containers](quickstart/common/tensorflow/ModelPackagesAdvancedOptions.md)
document for more advanced use cases.

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

