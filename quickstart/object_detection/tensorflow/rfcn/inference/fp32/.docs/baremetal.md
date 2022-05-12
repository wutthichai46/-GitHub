<!--- 50. Bare Metal -->
## Bare Metal

To run on bare metal, [prerequisites](https://github.com/tensorflow/models/blob/6c21084503b27a9ab118e1db25f79957d5ef540b/research/object_detection/g3doc/installation.md#installation)
to run the <model name> scripts must be installed in your environment.

Download and untar the <model name> <precision> inference model package:

```
wget <package url>
tar -xvf <package name>
```

In addition to the general model zoo requirements, <model name> uses the object detection code from the
[TensorFlow Model Garden](https://github.com/tensorflow/models). Clone this repo with the SHA specified
below and apply the patch from the <model name> <precision> <mode> model package to run with TF2.

```
git clone https://github.com/tensorflow/models.git tensorflow-models
cd tensorflow-models
git checkout 6c21084503b27a9ab118e1db25f79957d5ef540b
git apply ../<package dir>/models/object_detection/tensorflow/rfcn/inference/tf-2.0.patch
```

You must also install the dependencies and run the protobuf compilation described in the
[object detection installation instructions](https://github.com/tensorflow/models/blob/6c21084503b27a9ab118e1db25f79957d5ef540b/research/object_detection/g3doc/installation.md#installation)
from the [TensorFlow Model Garden](https://github.com/tensorflow/models) repository.

Once your environment is setup, navigate back to the directory that contains the <model name> <precision> <mode>
model package, set environment variables pointing to your dataset and output directories, and then run
a quickstart script.

To run inference with performance metrics:
```
DATASET_DIR=<path to the coco val2017 directory>
OUTPUT_DIR=<directory where log files will be written>
TF_MODELS_DIR=<directory where TensorFlow Model Garden is cloned>

quickstart/fp32_inference.sh
```

To get accuracy metrics:
```
DATASET_DIR=<path to the COCO validation TF record directory>
OUTPUT_DIR=<directory where log files will be written>
TF_MODELS_DIR=<directory where TensorFlow Model Garden is cloned>

quickstart/fp32_accuracy.sh
```
