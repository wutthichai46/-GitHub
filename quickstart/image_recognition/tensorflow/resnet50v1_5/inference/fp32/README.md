<!--- 0. Title -->
# ResNet50 v1.5 FP32 inference

<!-- 10. Description -->

This document has instructions for running ResNet50 v1.5 FP32 inference using
Intel-optimized TensorFlow.

Note that the ImageNet dataset is used in these ResNet50 v1.5 examples.
Download and preprocess the ImageNet dataset using the [instructions here](/datasets/imagenet/README.md).
After running the conversion script you should have a directory with the
ImageNet dataset in the TF records format.


<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`fp32_accuracy.sh`](fp32_accuracy.sh) | Measures the model accuracy (batch_size=100). |
| [`multi_instance_batch_inference.sh`](multi_instance_batch_inference.sh) | Uses numactl to run batch inference (batch_size=128) with one instance per socket for 1500 steps and 50 warmup steps. If no `DATASET_DIR` is set, synthetic data is used. Waits for all instances to complete, then prints a summarized throughput value. |
| [`multi_instance_online_inference.sh`](multi_instance_online_inference.sh) | Uses numactl to run online inference (batch_size=1) using four cores per instance for 1500 steps and 50 warmup steps. If no `DATASET_DIR` is set, synthetic data is used. Waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run using:
* [Docker](#docker)


<!-- 60. Docker -->
## Docker

The model container `intel/image-recognition:tf-r2.5-icx-b631821f-resnet50v1-5-fp32-inference` includes the scripts
and libraries needed to run ResNet50 v1.5 FP32 inference. To run one of the model
inference quickstart scripts using this container, you'll need to provide volume mounts for
the ImageNet dataset (if a real dataset is being used) and an output directory where
checkpoint files will be written.

```
DATASET_DIR=<path to the preprocessed imagenet dataset>
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/image-recognition:tf-r2.5-icx-b631821f-resnet50v1-5-fp32-inference \
  /bin/bash quickstart/<script name>.sh
```


<!-- 61. Advanced Options -->
### Advanced Options

See the [Advanced Options for Model Packages and Containers](/quickstart/common/tensorflow/ModelPackagesAdvancedOptions.md)
document for more advanced use cases.

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

