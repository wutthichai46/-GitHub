# ImageNet Dataset Scripts

This document describes how to download and preprocess the ImageNet validation
and training images to get them into the TF records format. The scripts used
are based on the conversion scripts from the
[TensorFlow TPU repo](https://github.com/tensorflow/tpu) and have been adapted
to allow for offline preprocessing with cloud storage. Note that downloading
the original images from ImageNet requires registering for an account and
logging in.

1. Go to the [ImageNet 2012 page](http://www.image-net.org/challenges/LSVRC/2012/downloads)
   and log in. After logging in, check the URL to ensure that you are still on
   the 2012 download page (if not, correct the URL to say 2012).
   Download the following tar files and save it to the compute system
   (e.g. `/home/<user>/imagenet_raw_data`), 500GB disk space is required:

   * Training images (Task 1 & 2). 138GB. MD5: 1d675b47d978889d74fa0da5fadfb00e
   * Validation images (all tasks). 6.3GB. MD5: 29b22e2961454d5413ddabcf34fc5622

   After this step is done, `/home/<user>/imagenet_raw_data` should have the above two
   tar files, one is 138GB (`ILSVRC2012_img_train.tar`) and the other 6.3GB
   (`ILSVRC2012_img_val.tar`).

2. Setup a python 3 virtual environment with TensorFlow and the other
   dependencies specified below. Note that google-cloud-storage is a dependency
   of the script, but these instructions will not be using cloud storage.
   ```
   python3 -m venv tf_env
   source tf_env/bin/activate
   pip install --upgrade pip==19.3.1
   pip install intel-tensorflow
   pip install google-cloud-storage
   pip uninstall urllib3 && pip install urllib3
   ```

3. Clone the TensorFlow TPU repo, then download and apply the
   [imagenet-patch.diff patch](imagenet-patch.diff).
   ```
   git clone https://github.com/tensorflow/tpu.git
   cd tpu
   git checkout e896a3d2d1e6687c4c84ddc6b5b7563459167568
   git apply imagenet-patch.diff
   ```

4. Run the [imagenet_to_tfrecords.sh](imagenet_to_tfrecords.sh) script and pass
   arguments for the directory with the ImageNet tar files that were downloaded
   in step 1 (e.g. `/home/<user>/imagenet_raw_data`) and the TPU repo directory from
   step 3.
   ```
   ./imagenet_to_tfrecords.sh <IMAGENET DIR> <TPU REPO DIR>
   ```
   The `imagenet_to_tfrecords.sh` script extracts the ImageNet tar files, and
   then runs the `imagenet_to_gcs.py` script from the TPU repo to convert the
   files to TF records. As the script is running you should see output like:
   ```
   I0911 16:23:59.174904 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/train/train-00000-of-01024
   I0911 16:23:59.199399 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/train/train-00001-of-01024
   I0911 16:23:59.221770 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/train/train-00002-of-01024
   I0911 16:23:59.251754 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/train/train-00003-of-01024
   ...
   I0911 16:24:22.338566 140581751400256 imagenet_to_gcs.py:402] Processing the validation data.
   I0911 16:24:23.271091 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/validation/validation-00000-of-00128
   I0911 16:24:24.260855 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/validation/validation-00001-of-00128
   I0911 16:24:25.179738 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/validation/validation-00002-of-00128
   I0911 16:24:26.097850 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/validation/validation-00003-of-00128
   I0911 16:24:27.028785 140581751400256 imagenet_to_gcs.py:354] Finished writing file: <IMAGENET DIR>/tf_records/validation/validation-00004-of-00128
   ...
   ```
   After the `imagenet_to_gcs.py` script completes, the .sh script combines
   the train and validation files into the `<IMAGENET DIR>/tf_records`
   directory. The folder should contains 1024 training files and 128 validation
   files.
   ```
   $ ls -1 <IMAGENET DIR>/tf_records/
   train-00000-of-01024
   train-00001-of-01024
   train-00002-of-01024
   train-00003-of-01024
   ...
   validation-00000-of-00128
   validation-00001-of-00128
   validation-00002-of-00128
   validation-00003-of-00128
   ...
   ```
