<!--- 40. Quick Start Scripts -->
## Quick Start Scripts

| Script name | Description |
|-------------|-------------|
| [`fp32_training_demo.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/training/cpu/fp32/fp32_training_demo.sh) | Executes a short run using small batch sizes and a limited number of steps to demonstrate the training flow |
| [`fp32_training_1_epoch.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/training/cpu/fp32/fp32_training_1_epoch.sh) | Executes a test run that trains the model for 1 epoch and saves checkpoint files to an output directory. |
| [`fp32_training_full.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/training/cpu/fp32/fp32_training_full.sh) | Trains the model using the full dataset and runs until convergence (90 epochs) and saves checkpoint files to an output directory. Note that this will take a considerable amount of time. |
| [`multi_instance_training_demo.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/training/cpu/fp32/multi_instance_training_demo.sh) | Uses mpirun to execute 2 processes with 1 process per socket with a batch size of 256 for 50 steps. |
| [`multi_instance_training.sh`](/quickstart/image_recognition/tensorflow/resnet50v1_5/training/cpu/fp32/multi_instance_training.sh) | Uses mpirun to execute 2 processes with 1 process per socket with a batch size of 256. Checkpoint files and logs for each instance are saved to the output directory. Note that this will take a considerable amount of time. |
