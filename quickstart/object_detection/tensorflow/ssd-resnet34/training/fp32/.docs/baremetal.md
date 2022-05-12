<!--- 50. Bare Metal -->
## Bare Metal

To run on bare metal, the following prerequisites must be installed in your environment:
* Python 3
* contextlib2
* cpio
* Cython
* horovod
* [intel-tensorflow==2.3.0](https://pypi.org/project/intel-tensorflow/)
* jupyter
* lxml
* matplotlib
* numpy==1.17.4
* opencv
* openmpi
* openssh
* pillow>=7.1.0
* protoc
* pycocotools
* tensorflow-addons==0.8.1

For more information, see the
[installation instructions](https://github.com/tensorflow/models/blob/8110bb64ca63c48d0caee9d565e5b4274db2220a/research/object_detection/g3doc/installation.md#installation)
for object detection models at the
[TensorFlow Model Garden](https://github.com/tensorflow/models) repository.

After installing the prerequisites, download and untar the model package.
Clone the [TensorFlow Model Garden](https://github.com/tensorflow/models)
repo at the commit specified below, and set the `TF_MODELS_DIR` environment
variable to point to that directory. Set the `DATASET_DIR` to point to the
directory with COCO training TF records files and the `OUTPUT_DIR` to the
location where logs will be written. You can optionally set the
`MPI_NUM_PROCESSES` environment variable (defaults to 1).
After all the setup is complete, run the [quickstart script](#quick-start-scripts).

```
export DATASET_DIR=<path to the dataset>
export OUTPUT_DIR=<directory where log files will be written>
export MPI_NUM_PROCESSES=<number of MPI processes (optional, defaults to 1)>

# Clone the tensorflow/models repo at the specified commit
git clone https://github.com/tensorflow/models.git tf_models
cd tf_models
export TF_MODELS_DIR=$(pwd)
git checkout 8110bb64ca63c48d0caee9d565e5b4274db2220a
cd ..

# Download and extract the model package, then run a quickstart script
wget <package url>
tar -xzf <package name>
cd <package dir>

quickstart/fp32_training.sh
```
