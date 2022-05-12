<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`multi_instance_training_demo.sh`](multi_instance_training_demo.sh) | Uses mpirun to execute 2 processes with 1 process per socket with a batch size of 256 for 50 steps. |
| [`multi_instance_training.sh`](multi_instance_training.sh) | Uses mpirun to execute 2 processes with 1 process per socket with a batch size of 256. Checkpoint files and logs for each instance are saved to the output directory. Note that this will take a considerable amount of time. |

These quick start scripts can be run using:
* [Docker](#docker)
