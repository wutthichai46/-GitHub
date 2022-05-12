#
# -*- coding: utf-8 -*-
#
# Copyright (c) 2018 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#

# Constants used for test mocks
SYSTEM_TYPE = "Linux"
LSCPU_OUTPUT = ("Architecture:          x86_64\n"
                "CPU(s):                112\n"
                "Thread(s) per core:    2\n"
                "Core(s) per socket:    28\n"
                "Socket(s):             2\n"
                "NUMA node(s):          2\n")
NUMA_CORES_OUTPUT = ['0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27',
                     '28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55']


def set_mock_system_type(mock_platform):
    """
    Sets the system type return value to Linux, which is currently the only
    supported system type.
    """
    mock_platform.system.return_value = SYSTEM_TYPE


def set_mock_os_access(mock_os):
    """
    Sets the os.access return value to True
    """
    mock_os.access.return_value = True


def set_mock_lscpu_subprocess_values(mock_subprocess):
    """
    Sets mock return value for the lscpu output with platform info
    """
    mock_subprocess.check_output.return_value = LSCPU_OUTPUT
