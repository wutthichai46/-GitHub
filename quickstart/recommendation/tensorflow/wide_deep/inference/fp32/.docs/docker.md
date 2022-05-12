<!-- 60. Docker -->
### Docker

When running in docker, the <model name> <precision> <mode> container includes the model package and TensorFlow model source repo,
which is needed to run inference. To run the quickstart scripts, you'll need to provide volume mounts for the dataset and
an output directory where log files will be written.

```
DATASET_DIR=<path to the Wide & Deep dataset directory>
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
