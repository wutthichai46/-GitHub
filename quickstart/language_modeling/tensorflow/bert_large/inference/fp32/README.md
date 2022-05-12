<!--- 0. Title -->
# BERT Large FP32 inference

<!-- 10. Description -->

This document has instructions for running
[BERT](https://github.com/google-research/bert#what-is-bert) FP32 inference
using Intel-optimized TensorFlow.

<!--- 30. Datasets -->
## Datasets

### BERT Large Data
Download and unzip the BERT Large uncased (whole word masking) model from the
[google bert repo](https://github.com/google-research/bert#pre-trained-models).
Then, download the Stanford Question Answering Dataset (SQuAD) dataset file `dev-v1.1.json` into the `wwm_uncased_L-24_H-1024_A-16` directory that was just unzipped.

```
wget https://storage.googleapis.com/bert_models/2019_05_30/wwm_uncased_L-24_H-1024_A-16.zip
unzip wwm_uncased_L-24_H-1024_A-16.zip

wget https://rajpurkar.github.io/SQuAD-explorer/dataset/dev-v1.1.json -P wwm_uncased_L-24_H-1024_A-16
```
Set the `DATASET_DIR` to point to that directory when running BERT Large inference using the SQuAD data.

<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`fp32_accuracy.sh`](fp32_accuracy.sh) | This script is runs bert large fp32 inference in accuracy mode. |
| [`multi_instance_batch_inference.sh`](multi_instance_batch_inference.sh) | A multi-instance run that uses all the cores for each socket for each instance with a batch size of 128. |
| [`multi_instance_online_inference.sh`](multi_instance_online_inference.sh) | A multi-instance run that uses 4 cores for each instance with a batch size of 1. |

These quickstart scripts can be run using:
* [Docker](#docker)

<!-- 60. Docker -->
## Docker

The BERT Large FP32 inference model container includes the scripts and libraries
needed to run BERT Large FP32 inference. To run one of the quickstart scripts
using this container, you'll need to provide volume mounts for the,
dataset, and an output directory where log files will be written.

The snippet below shows how to run a quickstart script:
```
DATASET_DIR=<path to the dataset being used>
OUTPUT_DIR=<directory where log files will be saved>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  intel/language-modeling:tf-r2.5-icx-b631821f-bert-large-fp32-inference \
  /bin/bash ./quickstart/<SCRIPT NAME>.sh
```

<!--- 80. License -->
## License

[LICENSE](/LICENSE)

