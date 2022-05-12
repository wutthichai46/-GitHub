<!--- 50. AI Kit -->
## Run the model

Setup your environment using the instructions below, depending on if you are
using [AI Kit](/docs/general/tensorflow/AIKit.md):

<table>
  <tr>
    <th>Setup using AI Kit</th>
    <th>Setup without AI Kit</th>
  </tr>
  <tr>
    <td>
      <p>AI Kit does not currently support TF 1.15.2 models</p>
    </td>
    <td>
      <p>To run without AI Kit you will need:</p>
      <ul>
        <li>Python 3.6 or 3.7
        <li><a href="https://pypi.org/project/intel-tensorflow/1.15.2/">intel-tensorflow==1.15.2</a>
        <li>numactl
        <li>git
        <li>wget
        <li>A clone of the Model Zoo repo<br />
        <pre>git clone https://github.com/IntelAI/models.git</pre>
      </ul>
    </td>
  </tr>
</table>

After completing the setup, download the pretrained model frozen graph
and save the path to the PRETRAINED_MODEL envionment variable.
```
wget https://storage.googleapis.com/intel-optimized-tensorflow/models/v1_8/wide_deep_fp32_pretrained_model.pb
export PRETRAINED_MODEL=$(pwd)/wide_deep_fp32_pretrained_model.pb
```

Set environment variables for the path to your TF records file and an
`OUTPUT_DIR` where log files will be written, then navigate to your model
zoo directory and run a [quickstart script](#quick-start-scripts).

```
# cd to your model zoo directory
cd models

export DATASET_DIR=<path to TF records file>
export OUTPUT_DIR=<directory where log files will be written>
export PRETRAINED_MODEL=<path to the frozen graph>

# Run inference with an accuracy check
./quickstart/recommendation/tensorflow/wide_deep_large_ds/inference/cpu/fp32/fp32_accuracy.sh

# Run online inference and set NUM_OMP_THREADS
export NUM_OMP_THREADS=1
./quickstart/recommendation/tensorflow/wide_deep_large_ds/inference/cpu/fp32/fp32_online_inference.sh \
--num-intra-threads 1 --num-inter-threads 1
```
