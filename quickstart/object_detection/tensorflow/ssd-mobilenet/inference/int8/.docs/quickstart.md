<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`int8_accuracy.sh`](int8_accuracy.sh) | Runs inference and checks accuracy on the results. |
| [`multi_instance_batch_inference.sh`](multi_instance_batch_inference.sh) | A multi-instance run that uses all the cores for each socket for each instance with a batch size of 448 and synthetic data. |
| [`multi_instance_online_inference.sh`](multi_instance_online_inference.sh) | A multi-instance run that uses 4 cores per instance with a batch size of 1 and synthetic data. |

These quickstart scripts can be run using:
* [Docker](#docker)
