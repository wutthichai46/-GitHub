<!--- 0. Title -->
# PyTorch DLRM training

<!-- 10. Description -->
## Description

This document has instructions for running DLRM training using
Intel-optimized PyTorch for bare metal.

### General Setup
Follow [link](/docs/general/pytorch/BareMetalSetup.md) to install Conda and build Pytorch, IPEX, and Jemalloc.

### Model Specific Setup

* Install dependencies
  ```bash
  cd <clone of the model zoo>/quickstart/recommendation/pytorch/dlrm
  pip install requirements.txt
  ```
* Set Jemalloc Preload for better performance

  The jemalloc should be built from the [General setup](#general-setup) section.
  ```bash
  export LD_PRELOAD="path/lib/libjemalloc.so":$LD_PRELOAD
  export MALLOC_CONF="oversize_threshold:1,background_thread:true,metadata_thp:auto,dirty_decay_ms:9000000000,muzzy_decay_ms:9000000000"
  ```

* Set IOMP preload for better performance

  IOMP should be installed in your conda env from the [General setup](#general-setup) section.
  ```bash
  export LD_PRELOAD=path/lib/libiomp5.so:$LD_PRELOAD
  export KMP_AFFINITY="granularity=fine,compact,1,0"
  export KMP_BLOCKTIME=1
  ```

* Set ENV to use AMX if you are using SPR
  ```bash
  export DNNL_MAX_CPU_ISA=AVX512_CORE_AMX
  ```

## Datasets

### Criteo Terabyte Dataset

The [Criteo Terabyte Dataset](https://labs.criteo.com/2013/12/download-terabyte-click-logs/) is
used to run DLRM. To download the dataset, you will need to visit the Criteo website and accept
their terms of use:
[https://labs.criteo.com/2013/12/download-terabyte-click-logs/](https://labs.criteo.com/2013/12/download-terabyte-click-logs/).
Copy the download URL into the command below as the `<download url>` and
replace the `<dir/to/save/dlrm_data>` to any path where you want to download
and save the dataset.
```bash
export DATASET_DIR=<dir/to/save/dlrm_data>

mkdir ${DATASET_DIR} && cd ${DATASET_DIR}
curl -O <download url>/day_{$(seq -s , 0 23)}.gz
gunzip day_*.gz
```
The raw data will be automatically preprocessed and saved as `day_*.npz` to
the `DATASET_DIR` when DLRM is run for the first time. On subsequent runs, the
scripts will automatically use the preprocessed data.

### Environment Setup
```bash

# set OUTPUT_DIR, PRECISION, WEIGHT, DATASET
export PRECISION=<specify the precision to run>
export DATASET_DIR=<path to the dataset>
export OUTPUT_DIR=<directory where log files will be written>

```
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| `bare_metal_train.sh` | Run training for the specified precision (fp32 or bf16). |

## Run the model

Follow the instructions above to setup your bare metal environment, do the
model-specific setup and download and prepropcess the datsaet. Once all the
setup is done, the Model Zoo can be used to run a [quickstart script](#quick-start-scripts).
Ensure that you have enviornment variables set to point to the dataset directory,
precision, and an output directory. The `NUM_BATCH` environment variable
can be set to specify the number of batches to run.

```bash
# Clone the model zoo repo and set the MODEL_DIR
git clone https://github.com/IntelAI/models.git
cd models
export MODEL_DIR=$(pwd)

# Env vars
export PRECISION=<specify the precision to run>
export DATASET_DIR=<path to the dataset>
export OUTPUT_DIR=<directory where log files will be written>

# Navigate to the DLRM training quickstart directory
cd ${MODEL_DIR}/quickstart/recommendation/pytorch/dlrm/training/cpu

# Run the quickstart script to test performance
NUM_BATCH=10000 bash bare_metal_train.sh

# Or, run quickstart script for testing convergence trend
NUM_BATCH=50000 bash bare_metal_train.sh
```

<!--- 80. License -->
## License

[LICENSE](/LICENSE)
