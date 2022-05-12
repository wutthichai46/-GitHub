<!--- 50. AI Kit -->
## Run the model

Setup your environment using the instructions below, depending on if you are
using [AI Kit](/docs/general/tensorflow/AIKit.md):

<table>
  <tr>
    <th>Setup using AI Kit</th>
    <th>Setup without AI Kit</th>
  </tr>
  <tr>
    <td>
      <p>AI Kit does not currently support TF 1.15.2 models</p>
    </td>
    <td>
      <p>To run without AI Kit you will need:</p>
      <ul>
        <li>Python 3.6 or 3.7
        <li>git
        <li>numactl
        <li>wget
        <li><a href="https://github.com/tensorflow/models/blob/v1.12.0/research/object_detection/g3doc/installation.md#protobuf-compilation">Protobuf Compilation</a>
        <li><a href="https://pypi.org/project/intel-tensorflow/1.15.2/">intel-tensorflow==1.15.2</a>
        <li>Cython
        <li>contextlib2
        <li>jupyter
        <li>lxml
        <li>matplotlib
        <li>pillow>=8.1.2
        <li>pycocotools
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>

Running <model name> <precision> <mode> also requires cloning the TensorFlow
models repo using the tag specified below. Set the `TF_MODELS_DIR` environment
variable to point to the TensorFlow models directory. Run the
[protobuf-compiler](https://github.com/tensorflow/models/blob/v1.12.0/research/object_detection/g3doc/installation.md#protobuf-compilation)
on the `research` directory.
```
# Clone the TF models repo
git clone https://github.com/tensorflow/models.git tf_models
pushd tf_models
git checkout tags/v1.12.0
export TF_MODELS_DIR=$(pwd)

# Run the protobuf-compiler from the TF models research directory
pushd research
wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip
unzip protobuf.zip
./bin/protoc object_detection/protos/*.proto --python_out=.
rm protobuf.zip
popd
popd
```

Download the pretrained model and set the `PRETRAINED_MODEL` environment
variable to point to the frozen graph. The quickstart scripts will use this var.
```
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/faster_rcnn_int8_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/faster_rcnn_int8_pretrained_model.pb
```

In addition to the `TF_MODELS_DIR` and `PRETRAINED_MODEL` variables from
above, set environment variables for the path to your `DATASET_DIR` (where
the coco TF records file is located) and an `OUTPUT_DIR` where log files
will be written, then run a [quickstart script](#quick-start-scripts).
```
# cd to your model zoo directory
cd models

export DATASET_DIR=<path to the coco dataset>
export OUTPUT_DIR=<directory where log files will be written>
export TF_MODELS_DIR=<path to the TensorFlow models dir>
export PRETRAINED_MODEL=<path to the pretrained model frozen graph file>

./quickstart/object_detection/tensorflow/faster_rcnn/inference/cpu/int8/<script name>.sh
```