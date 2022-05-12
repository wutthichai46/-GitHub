<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`fp32_accuracy.sh`](fp32_accuracy.sh) | This script is runs bert large fp32 inference in accuracy mode. |
| [`multi_instance_batch_inference.sh`](multi_instance_batch_inference.sh) | A multi-instance run that uses all the cores for each socket for each instance with a batch size of 128. |
| [`multi_instance_online_inference.sh`](multi_instance_online_inference.sh) | A multi-instance run that uses 4 cores for each instance with a batch size of 1. |

These quickstart scripts can be run using:
* [Docker](#docker)
