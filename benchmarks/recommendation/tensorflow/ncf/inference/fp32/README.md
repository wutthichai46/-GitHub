<!--- 0. Title -->
# NCF FP32 inference

<!-- 10. Description -->
## Description

This document has instructions for running Neural Collaborative Filtering (NCF)
FP32 inference using Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

Download [movielens 1M dataset](https://grouplens.org/datasets/movielens/1m/)
```
wget http://files.grouplens.org/datasets/movielens/ml-1m.zip
unzip ml-1m.zip
```
Set the `DATASET_DIR` to point to this directory when running NCF.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`fp32_online_inference.sh`](fp32_online_inference.sh) | Runs online inference (batch_size=1). |
| [`fp32_batch_inference.sh`](fp32_batch_inference.sh) | Runs batch inference (batch_size=256). |
| [`fp32_accuracy.sh`](fp32_accuracy.sh) | Measures the model accuracy (batch_size=256). |

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
        <li>Python 3
        <li><a href="https://pypi.org/project/intel-tensorflow/1.15.2/">intel-tensorflow==1.15.2</a>
        <li>numactl
        <li>git
        <li>google-api-python-client==1.6.7
        <li>google-cloud-bigquery==0.31.0
        <li>kaggle==1.3.9
        <li>numpy==1.16.3
        <li>oauth2client==4.1.2
        <li>pandas
        <li>psutil>=5.6.7
        <li>py-cpuinfo==3.3.0
        <li>tar
        <li>typing
        <li>wget
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>


Running NCF also requires a clone of the
[TensorFlow models repository](https://github.com/tensorflow/models) with
at the `v1.11` tag. Set the `TF_MODELS_DIR` env var to the path of your clone.
```
git clone https://github.com/tensorflow/models.git tf_models
cd tf_models
git checkout v1.11
export TF_MODELS_DIR=$(pwd)
cd ..
```

Download and extract the pretrained model and set the path to the
`PRETRAINED_MODEL` env var.
```
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_5/ncf_fp32_pretrained_model.tar.gz
tar -xzvf ncf_fp32_pretrained_model.tar.gz
export PRETRAINED_MODEL=$(pwd)/ncf_trained_movielens_1m
```

After your environment is setup, set environment variables to the `DATASET_DIR`
and an `OUTPUT_DIR` where log files will be written. Ensure that you already have
the `TF_MODELS_DIR` and `PRETRAINED_MODEL` paths set from the previous commands.
Once the environment variables are all set, you can run a
[quickstart script](#quick-start-scripts).
```
# cd to your model zoo directory
cd models

export DATASET_DIR=<path to the dataset>
export OUTPUT_DIR=<directory where log files will be written>
export TF_MODELS_DIR=<path to the TensorFlow models directory tf_models>
export PRETRAINED_MODEL=<path to the pretrained model>

./quickstart/recommendation/tensorflow/ncf/inference/cpu/fp32/<script name>.sh
```

<!--- 90. Resource Links-->
## Additional Resources

* To run more advanced use cases, see the instructions [here](Advanced.md)
  for calling the `launch_benchmark.py` script directly.
* To run the model using docker, please see the [oneContainer](http://software.intel.com/containers)
  workload container:<br />
  [https://software.intel.com/content/www/us/en/develop/articles/containers/ncf-fp32-inference-tensorflow-container.html](https://software.intel.com/content/www/us/en/develop/articles/containers/ncf-fp32-inference-tensorflow-container.html).

