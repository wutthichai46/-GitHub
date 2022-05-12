<!--- 60. Docker -->
## Docker

The model container `<docker image>` includes the scripts and libraries needed to run
<model name> <precision> <mode>. To run one of the quickstart scripts 
using this container, you'll need to provide volume mounts for the dataset 
and an output directory.

For accuracy, `DATASET_DIR` is required to be set. For inference,
just to evaluate performance on synthetic data, the `DATASET_DIR` is not needed.
Otherwise `DATASET_DIR` needs to be set. Add or remove `DATASET_DIR` environment
variable and volume mount accordingly in following command:


```
DATASET_DIR=<path to the dataset>
OUTPUT_DIR=<directory where log files will be written>

docker run \
  --env DATASET_DIR=${DATASET_DIR} \
  --env OUTPUT_DIR=${OUTPUT_DIR} \
  --env http_proxy=${http_proxy} \
  --env https_proxy=${https_proxy} \
  --volume ${DATASET_DIR}:${DATASET_DIR} \
  --volume ${OUTPUT_DIR}:${OUTPUT_DIR} \
  --privileged --init -t \
  <docker image> \
  /bin/bash quickstart/<script name>.sh
```
