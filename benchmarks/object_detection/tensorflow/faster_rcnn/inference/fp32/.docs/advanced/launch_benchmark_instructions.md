<!-- 50. Launch benchmark instructions -->
Once your environment is setup, navigate to the `benchmarks` directory of
the model zoo and set environment variables pointing to the directory for the
dataset, pretrained model checkpoints, the TensorFlow models repo, and an output
directory where log files will be written.

```
# cd to the benchmarks directory in the model zoo
cd benchmarks

export DATASET_DIR=<path to the directory that contains the coco_val.record file>
export PRETRAINED_MODEL=<path to the pretrained model checkpoints directory>
export TF_MODELS_DIR=<path to your clone of the TensorFlow models repo>
export OUTPUT_DIR=<directory where log files will be saved>
```

> If you are going to run on bare metal (without the `--docker-image` flag in the
> commands below) you will need to update a couple of paths in the
> `$PRETRAINED_MODEL/pipeline.config` file:
> ```
> # Replace in the pretrained model path on line 128
> line_128=$(sed -n '128p' ${PRETRAINED_MODEL}/pipeline.config)
> new_line_128="  label_map_path: \"$PRETRAINED_MODEL/mscoco_label_map.pbtxt\""
> sed -i.bak "128s+$line_128+$new_line_128+" ${PRETRAINED_MODEL}/pipeline.config
>
> # Replace in the dataset directory on line 132
> line_132=$(sed -n '132p' ${PRETRAINED_MODEL}/pipeline.config)
> new_line_132="    input_path: \"$DATASET_DIR/coco_val.record\""
> sed -i.bak "132s+$line_132+$new_line_132+" ${PRETRAINED_MODEL}/pipeline.config
> ```
> If you run in a container using the `--docker-image` flag do not edit this
> file, since the dataset and checkpoints will be mounted to the location
> that the original `pipeline.config` expects.

Run batch and online inference using the following command:
```
python launch_benchmark.py \
 --data-location ${DATASET_DIR} \
 --model-source-dir ${TF_MODELS_DIR} \
 --model-name faster_rcnn \
 --framework tensorflow \
 --precision fp32 \
 --mode inference \
 --socket-id 0 \
 --checkpoint ${PRETRAINED_MODEL} \
 --docker-image <docker image> \
 --output-dir ${OUTPUT_DIR} \
 -- config_file=pipeline.config
```

Test accuracy using the following:
```
python launch_benchmark.py \
 --model-name faster_rcnn \
 --mode inference \
 --precision fp32 \
 --framework tensorflow \
 --docker-image <docker image> \
 --model-source-dir ${TF_MODELS_DIR} \
 --data-location ${DATASET_DIR} \
 --in-graph ${PRETRAINED_MODEL}/frozen_inference_graph.pb \
 --output-dir ${OUTPUT_DIR} \
 --accuracy-only
```

Output files and logs are saved to the `${OUTPUT_DIR}` directory.

Below is a sample log file tail when running for batch and online inference:
```
I0923 18:13:53.033420 140562203281216 eval_util.py:72] Metrics written to tf summary.
I0923 18:13:53.033456 140562203281216 eval_util.py:463] Finished evaluation!
Time spent : ... seconds.
Time spent per BATCH: ... seconds.
Log file location: {--output-dir value}/benchmark_faster_rcnn_inference_fp32_20200923_181013.log
```

And here is a sample log file tail when running for accuracy:
```
DONE (t=1.35s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.316
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.489
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.355
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.316
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = -1.000
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = -1.000
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.271
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.380
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.383
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.383
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = -1.000
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = -1.000
Ran inference with batch size 1
Log location outside container: ${OUTPUT_DIR}/benchmark_faster_rcnn_inference_fp32_20190114_205714.log
```

And here is a sample log file tail when running for accuracy:
```
DONE (t=1.35s).
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.316
 Average Precision  (AP) @[ IoU=0.50      | area=   all | maxDets=100 ] = 0.489
 Average Precision  (AP) @[ IoU=0.75      | area=   all | maxDets=100 ] = 0.355
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.316
 Average Precision  (AP) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = -1.000
 Average Precision  (AP) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = -1.000
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=  1 ] = 0.271
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets= 10 ] = 0.380
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=   all | maxDets=100 ] = 0.383
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= small | maxDets=100 ] = 0.383
 Average Recall     (AR) @[ IoU=0.50:0.95 | area=medium | maxDets=100 ] = -1.000
 Average Recall     (AR) @[ IoU=0.50:0.95 | area= large | maxDets=100 ] = -1.000
Ran inference with batch size 1
Log location outside container: ${OUTPUT_DIR}/benchmark_faster_rcnn_inference_fp32_20190114_205714.log
```
