#!/usr/bin/env bash
#
# Copyright (c) 2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

MODEL_DIR=${MODEL_DIR-$PWD}

if [ ! -e "${MODEL_DIR}/models/object_detection/pytorch/ssd-resnet34/inference/cpu/infer.py" ]; then
  echo "Could not find the script of infer.py. Please set environment variable '\${MODEL_DIR}'."
  echo "From which the infer.py exist at the: \${MODEL_DIR}/models/object_detection/pytorch/ssd-resnet34/inference/cpu/infer.py"
  exit 1
fi

if [ ! -e "${CHECKPOINT_DIR}/e2e_mask_rcnn_R_50_FPN_1x.pth" ]; then
  echo "The pretrained model \${CHECKPOINT_DIR}/e2e_mask_rcnn_R_50_FPN_1x.pth does not exist"
  exit 1
fi

if [ ! -d "${DATASET_DIR}/coco" ]; then
  echo "The DATASET_DIR \${DATASET_DIR}/coco does not exist"
  exit 1
fi

if [ ! -d "${OUTPUT_DIR}" ]; then
  echo "The OUTPUT_DIR '${OUTPUT_DIR}' does not exist"
  exit 1
fi

ARGS=""

if [ "$1" == "bf16" ]; then
    ARGS="$ARGS --bf16"
    echo "### running bf16 datatype"
elif [ "$1" == "fp32" ]; then
    echo "### running fp32 datatype"
else
    echo "The specified precision '$1' is unsupported."
    echo "Supported precisions are: fp32 and bf16."
    exit 1
fi

if [[ "$2" == "jit" ]]; then
    ARGS="$ARGS --jit"
    echo "### running jit mode"
elif [[ "$2" == "imperative" ]]; then
    echo "### running imperative mode"
else
    echo "The specified mode '$2' is unsupported."
    echo "Supported mode are: imperative and jit."
    exit 1
fi

export DNNL_PRIMITIVE_CACHE_CAPACITY=1024
export KMP_BLOCKTIME=1
export KMP_AFFINITY=granularity=fine,compact,1,0

export TRAIN=0

BATCH_SIZE=56

rm -rf ${OUTPUT_DIR}/accuracy_log*

python -m intel_extension_for_pytorch.cpu.launch \
    --enable_jemalloc \
    ${MODEL_DIR}/models/object_detection/pytorch/maskrcnn/maskrcnn-benchmark/tools/test_net.py \
    $ARGS \
    --config-file '"${MODEL_DIR}/models/object_detection/pytorch/maskrcnn/maskrcnn-benchmark/configs/e2e_mask_rcnn_R_50_FPN_1x_coco2017_inf.yaml"' \
    TEST.IMS_PER_BATCH ${BATCH_SIZE} \
    MODEL.WEIGHT '"${CHECKPOINT_DIR}/e2e_mask_rcnn_R_50_FPN_1x.pth"' \
    MODEL.DEVICE cpu \
    2>&1 | tee ${OUTPUT_DIR}/accuracy_log.txt

# For the summary of results
wait

accuracy=$(grep 'bbox AP:' ${OUTPUT_DIR}/accuracy_log* |sed -e 's/.*Accuracy//;s/[^0-9.]//g')
echo ""maskrcnn";"bbox AP:";$1;${BATCH_SIZE};${accuracy}" | tee -a ${OUTPUT_DIR}/summary.log
accuracy=$(grep 'segm AP:' ${OUTPUT_DIR}/accuracy_log* |sed -e 's/.*Accuracy//;s/[^0-9.]//g')
echo ""maskrcnn";"segm AP:";$1;${BATCH_SIZE};${accuracy}" | tee -a ${OUTPUT_DIR}/summary.log
