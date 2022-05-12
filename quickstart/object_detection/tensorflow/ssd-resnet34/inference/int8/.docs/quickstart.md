<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [int8_accuracy_1200.sh](int8_accuracy_1200.sh) | Tests accuracy using the COCO dataset in the TF Records format with an input size of 1200x1200. |
| [multi_instance_batch_inference_1200.sh](multi_instance_batch_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with an input size of 1200x1200 and one instance per socket. Waits for all instances to complete, then prints a summarized throughput value. |
| [multi_instance_online_inference_1200.sh](multi_instance_online_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with an input size of 1200x1200 and four cores per instance. Waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run using:
* [Docker](#docker)
