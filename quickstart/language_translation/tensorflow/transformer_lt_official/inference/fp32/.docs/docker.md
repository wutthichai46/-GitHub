<!-- 60. Docker -->
## Docker

The model container used in the example below includes the scripts,
libraries, and pretrained model needed to run <model name> <precision>
<mode>. To run one of the model quickstart scripts using this
container, you'll need to provide volume mounts for the dataset and an
output directory.

```
DATASET_DIR=<path to the test dataset directory>
OUTPUT_DIR=<directory where the log and translation file will be written>

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

If you have your own pretrained model, you can specify the path to the frozen 
graph .pb file using the `FROZEN_GRAPH` environment variable and mount the
frozen graph's directory as a volume in the container.

