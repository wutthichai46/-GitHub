<!--- 0. Title -->
# Wide and Deep Large Dataset FP32 training

<!-- 10. Description -->

This document has instructions for training [Wide and Deep](https://arxiv.org/pdf/1606.07792.pdf)
using a large dataset using Intel-optimized TensorFlow.


<!--- 20. Download link -->
## Download link

[wide-deep-large-ds-fp32-training.tar.gz](https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_2_0/wide-deep-large-ds-fp32-training.tar.gz)

<!--- 30. Datasets -->
## Dataset

The large [Kaggle Display Advertising Challenge Dataset](https://www.kaggle.com/c/criteo-display-ad-challenge/data)
will be used for training Wide and Deep. The
[data](https://www.kaggle.com/c/criteo-display-ad-challenge/data) is from
[Criteo](https://www.criteo.com) and has a field indicating if an ad was
clicked (1) or not (0), along with integer and categorical features.

Download large Kaggle Display Advertising Challenge Dataset from
[Criteo Labs](http://labs.criteo.com/2014/02/kaggle-display-advertising-challenge-dataset/).
* Download the large version of train dataset from: https://storage.googleapis.com/dataset-uploader/criteo-kaggle/large_version/train.csv
* Download the large version of evaluation dataset from: https://storage.googleapis.com/dataset-uploader/criteo-kaggle/large_version/eval.csv

The directory where you've downloaded the `train.csv` and `eval.csv`
files should be used as the `DATASET_DIR` when running [quickstart scripts](#quick-start-scripts).


<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`fp32_training_check_accuracy.sh`](fp32_training_check_accuracy.sh) | Trains the model for a specified number of steps (default is 500) and then compare the accuracy against the specified target accuracy. If the accuracy is not met, then script exits with error code 1. The `CHECKPOINT_DIR` environment variable can optionally be defined to start training based on previous set of checkpoints. |
| [`fp32_training.sh`](fp32_training.sh) | Trains the model for 10 epochs. The `CHECKPOINT_DIR` environment variable can optionally be defined to start training based on previous set of checkpoints. |
| [`fp32_training_demo.sh`](fp32_training_demo.sh) | A short demo run that trains the model for 100 steps. |

These quickstart scripts can be run in different environments:
* [Bare Metal](#bare-metal)
* [Docker](#docker)

<!--- 50. Bare Metal -->
## Bare Metal

To run on bare metal, the following prerequisites must be installed in your environment:
* Python 3
* [intel-tensorflow==2.3.0](https://pypi.org/project/intel-tensorflow/)

Download and untar the model package and then run a
[quickstart script](#quick-start-scripts) with enviornment variables
that point to the [dataset](#dataset), a checkpoint directory, and an
output directory where log files and the saved model will be written.

```
DATASET_DIR=<path to the dataset directory>
OUTPUT_DIR=<directory where the logs and the saved model will be written>
CHECKPOINT_DIR=<directory where checkpoint files will be read and written>

wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v2_2_0/wide-deep-large-ds-fp32-training.tar.gz
tar -xvf wide-deep-large-ds-fp32-training.tar.gz
cd wide-deep-large-ds-fp32-training

quickstart/<script name>.sh
```

The script will write a log file and the saved model to the `OUTPUT_DIR`
and checkpoints will be written to the `CHECKPOINT_DIR`.


<!-- 60. Docker -->
## Docker

The model container used in the example below includes the scripts and
libraries needed to run Wide and Deep Large Dataset FP32 training. To run one of the
model quickstart scripts using this container, you'll need to provide
volume mounts for the [dataset](#dataset), checkpoints, and an output
directory where logs and the saved model will be written.
```
DATASET_DIR=<path to the dataset directory>
OUTPUT_DIR=<directory where the logs and the saved model will be written>
CHECKPOINT_DIR=<directory where checkpoint files will be read and written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env CHECKPOINT_DIR=${CHECKPOINT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --volume ${CHECKPOINT_DIR}:${CHECKPOINT_DIR} \
  --privileged --init -t \
  intel/recommendation:tf-2.3.0-imz-2.2.0-wide-deep-large-ds-fp32-training \
  /bin/bash quickstart/<script name>.sh
```

The script will write a log file and the saved model to the `OUTPUT_DIR`
and checkpoints will be written to the `CHECKPOINT_DIR`.

<!-- 61. Advanced Options -->

See the [Advanced Options for Model Packages and Containers](/quickstart/common/tensorflow/ModelPackagesAdvancedOptions.md)
document for more advanced use cases.

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

