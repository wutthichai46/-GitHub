<!--- 0. Title -->
# ResNet50 v1.5 Int8 inference

<!-- 10. Description -->
## Description

This document has instructions for running ResNet50 v1.5 Int8 inference using
Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

Download and preprocess the ImageNet dataset using the [instructions here](/datasets/imagenet/README.md).
After running the conversion script you should have a directory with the
ImageNet dataset in the TF records format.

Set the `DATASET_DIR` to point to the TF records directory when running ResNet50 v1.5.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`int8_online_inference.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/cpu/int8/int8_online_inference.sh) | Runs online inference (batch_size=1). |
| [`int8_batch_inference.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/cpu/int8/int8_batch_inference.sh) | Runs batch inference (batch_size=128). |
| [`int8_accuracy.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/cpu/int8/int8_accuracy.sh) | Measures the model accuracy (batch_size=100). |
| [`multi_instance_batch_inference.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/cpu/int8/multi_instance_batch_inference.sh) | Uses numactl to run batch inference (batch_size=128) with one instance per socket for 1500 steps and 50 warmup steps. If no `DATASET_DIR` is set, synthetic data is used. The script waits for all instances to complete, then prints a summarized throughput value. |
| [`multi_instance_online_inference.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/inference/cpu/int8/multi_instance_online_inference.sh) | Uses numactl to run online inference (batch_size=1) using four cores per instance for 1500 steps and 50 warmup steps. If no `DATASET_DIR` is set, synthetic data is used. The script waits for all instances to complete, then prints a summarized throughput value. |

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
      <p>To run using AI Kit you will need:</p>
      <ul>
        <li>numactl
        <li>wget
        <li>openmpi-bin (only required for multi-instance)
        <li>openmpi-common (only required for multi-instance)
        <li>openssh-client (only required for multi-instance)
        <li>openssh-server (only required for multi-instance)
        <li>libopenmpi-dev (only required for multi-instance)
        <li>horovod==0.21.0 (only required for multi-instance)
        <li>Activate the tensorflow conda environment
        <pre>conda activate tensorflow</pre>
      </ul>
    </td>
    <td>
      <p>To run without AI Kit you will need:</p>
      <ul>
        <li>Python 3
        <li>[intel-tensorflow>=2.5.0](https://pypi.org/project/intel-tensorflow/)
        <li>git
        <li>numactl
        <li>wget
        <li>openmpi-bin (only required for multi-instance)
        <li>openmpi-common (only required for multi-instance)
        <li>openssh-client (only required for multi-instance)
        <li>openssh-server (only required for multi-instance)
        <li>libopenmpi-dev (only required for multi-instance)
        <li>horovod==0.21.0 (only required for multi-instance)
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>

After finishing the setup above, download the pretrained model and set the
`PRETRAINED_MODEL` environment var to the path to the frozen graph:
```
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/resnet50v1_5_int8_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/resnet50v1_5_int8_pretrained_model.pb
```

Set environment variables for the path to your `DATASET_DIR` for ImageNet and an `OUTPUT_DIR` 
where log files will be written. Navigate to your model zoo directory and then 
run a [quickstart script](#quick-start-scripts).
```
# cd to your model zoo directory
cd models

export PRETRAINED_MODEL=<path to the frozen graph downloaded above>
export DATASET_DIR=<path to the ImageNet TF records>
export OUTPUT_DIR=<directory where log files and checkpoints will be written>

./quickstart/image_recognition/tensorflow/resnet50v1_5/inference/cpu/int8/<script name>.sh
```

<!--- 90. Resource Links-->
## Additional Resources

* To run more advanced use cases, see the instructions [here](Advanced.md)
  for calling the `launch_benchmark.py` script directly.
* To run the model using docker, please see the [oneContainer](http://software.intel.com/containers)
  workload container:<br />
  [https://software.intel.com/content/www/us/en/develop/articles/containers/resnet50v1-5-int8-inference-tensorflow-container.html](https://software.intel.com/content/www/us/en/develop/articles/containers/resnet50v1-5-int8-inference-tensorflow-container.html).

