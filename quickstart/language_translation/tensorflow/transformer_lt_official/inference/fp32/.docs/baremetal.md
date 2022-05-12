<!--- 50. Bare Metal -->
## Bare Metal

To run on bare metal, the following prerequisites must be installed in your environment:
* Python 3
* [intel-tensorflow==2.3.0](https://pypi.org/project/intel-tensorflow/)
* numactl
* [Cython](https://pypi.org/project/Cython/)
* [pandas](https://pypi.org/project/pandas/)

Download and untar the model package and then run a
[quickstart script](#quick-start-scripts) with enviornment variables
that point to your dataset and an output directory.

```
DATASET_DIR=<path to the test dataset directory>
OUTPUT_DIR=<directory where the log and translation file will be written>

wget <package url>
tar -xzf <package name>
cd <package dir>

quickstart/<script name>.sh
```

If you have your own pretrained model, you can specify the path to the frozen
graph .pb file using the `FROZEN_GRAPH` environment variable.

