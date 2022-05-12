<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [fp32_accuracy_1200.sh](fp32_accuracy_1200.sh) | Runs an accuracy test using data in the TF records format with an input size of 1200x1200. |
| [multi_instance_batch_inference_1200.sh](multi_instance_batch_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with one instance per socket. Uses synthetic data with an input size of 1200x1200. Waits for all instances to complete, then prints a summarized throughput value. |
| [multi_instance_online_inference_1200.sh](multi_instance_online_inference_1200.sh) | Uses numactl to run inference (batch_size=1) with 4 cores per instance. Uses synthetic data with an input size of 1200x1200. Waits for all instances to complete, then prints a summarized throughput value. |

These quickstart scripts can be run using:
* [Docker](#docker)
