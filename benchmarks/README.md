# Model Zoo Scripts

Training and inference scripts with Intel-optimized MKL

## Prerequisites

The model scripts can be run on Linux and require the following
dependencies to be installed:
* [Docker](https://docs.docker.com/install/)
* [Python](https://www.python.org/downloads/) 3.5 or later
* [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* `wget` for downloading pre-trained models

## TensorFlow Use Cases

The following workload containers have been built based on the `intel/intel-optimized-tensorflow:tf-r2.5-icx-b631821f`
container. These containers contain all the dependencies, scripts, and pretrained models
needed to run the workload.

| Use Case                | Framework    | Model              | Mode      | Workload container instructions |
| ----------------------- | ------------ | ------------------ | --------- | ------------------------------- |
| Image Recognition       | TensorFlow   | [MobileNet V1*](https://arxiv.org/pdf/1704.04861.pdf) | Inference | [Int8](/quickstart/image_recognition/tensorflow/mobilenet_v1/inference/int8/README.md) [FP32](/quickstart/image_recognition/tensorflow/mobilenet_v1/inference/fp32/README.md) |
| Image Recognition       | TensorFlow   | [ResNet 50v1.5](https://github.com/tensorflow/models/tree/master/official/resnet) | Inference | [Int8](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/int8/README.md) [FP32](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/fp32/README.md) |
| Image Recognition       | TensorFlow   | [ResNet 50v1.5](https://github.com/tensorflow/models/tree/master/official/resnet) | Training | [FP32](/quickstart/image_recognition/tensorflow/resnet50v1_5/training/fp32/README.md) |
| Language Modeling       | TensorFlow   | [BERT](https://arxiv.org/pdf/1810.04805.pdf) | Inference | [Int8](/quickstart/language_modeling/tensorflow/bert_large/inference/int8/README.md) [FP32](/quickstart/language_modeling/tensorflow/bert_large/inference/fp32/README.md) |
| Object Detection        | TensorFlow   | [SSD-MobileNet*](https://arxiv.org/pdf/1704.04861.pdf) | Inference | [Int8](/quickstart/object_detection/tensorflow/ssd-mobilenet/inference/int8/README.md) [FP32](/quickstart/object_detection/tensorflow/ssd-mobilenet/inference/fp32/README.md) |
| Object Detection        | TensorFlow   | [SSD-ResNet34*](https://arxiv.org/pdf/1512.02325.pdf) | Inference | [Int8](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/int8/README.md) [FP32](/quickstart/object_detection/tensorflow/ssd-resnet34/inference/fp32/README.md) |

For information on running more advanced use cases using the workload containers
see the [advanced options documentation](/quickstart/common/tensorflow/ModelPackagesAdvancedOptions.md).

## TensorFlow Serving Use Cases

| Use Case               | Framework     | Model               | Mode      | Run from the Model Zoo repository    |
| -----------------------| --------------| ------------------- | --------- |------------------------------|
| Image Recognition      | TensorFlow Serving | [Inception V3](https://arxiv.org/pdf/1512.00567.pdf)        | Inference | [FP32](image_recognition/tensorflow_serving/inceptionv3/README.md#fp32-inference-instructions) |
| Image Recognition      | TensorFlow Serving | [ResNet 50v1.5](https://github.com/tensorflow/models/tree/master/official/resnet) | Inference | [FP32](image_recognition/tensorflow_serving/resnet50v1_5/README.md#fp32-inference-instructions) |
| Language Translation   | TensorFlow Serving | [Transformer_LT_Official](https://arxiv.org/pdf/1706.03762.pdf) | Inference | [FP32](language_translation/tensorflow_serving/transformer_lt_official/README.md#fp32-inference-instructions) |
| Object Detection       | TensorFlow Serving | [SSD-MobileNet](https://arxiv.org/pdf/1704.04861.pdf)       | Inference | [FP32](object_detection/tensorflow_serving/ssd-mobilenet/README.md#fp32-inference-instructions) |

## PyTorch Use Cases

| Use Case                | Framework    | Model              | Mode      | oneContainer Portal | Run from the Model Zoo repository |
| ----------------------- | ------------ | ------------------ | --------- | ------------------- | --------------------------------- |
| Image Recognition       | PyTorch      | [ResNet 50](https://arxiv.org/pdf/1512.03385.pdf)   | Inference | Model Containers: [FP32](https://software.intel.com/content/www/us/en/develop/articles/containers/resnet50-fp32-inference-pytorch-container.html) [BFloat16**](https://software.intel.com/content/www/us/en/develop/articles/containers/resnet50-bfloat16-inference-pytorch-container.html) <br> Model Packages: [FP32](https://software.intel.com/content/www/us/en/develop/articles/containers/resnet50-fp32-inference-pytorch-model.html) [BFloat16**](https://software.intel.com/content/www/us/en/develop/articles/containers/resnet50-bfloat16-inference-pytorch-model.html)  | [FP32](/quickstart/image_recognition/pytorch/resnet50/inference/fp32/README.md) [BFloat16**](/quickstart/image_recognition/pytorch/resnet50/inference/bf16/README.md) |
| Recommendation          | PyTorch      | [DLRM](https://arxiv.org/pdf/1906.00091.pdf)        | Training  |  | [BFloat16**](../models/recommendation/pytorch/dlrm/training/bf16/README.md#dlrm-mlperf-bf16-training-v07-intel-submission) |

*Means the model belongs to [MLPerf](https://mlperf.org/) models and will be supported long-term.

**Means the BFloat16 data type support is experimental.
