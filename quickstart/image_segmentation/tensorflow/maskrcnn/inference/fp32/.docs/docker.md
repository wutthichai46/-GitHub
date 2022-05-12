<!--- 60. Docker -->
## Docker

The model container includes the scripts,
[pretrained model](https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5),
and libraries needed to run  <model name> <precision> <mode>. To run one
of the quickstart scripts  using this container, you'll need to provide
volume mounts for the dataset and an output directory.

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
