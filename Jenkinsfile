node(params.NODE) {
    deleteDir()
    // Create a workspace path.  We need this to be 79 chars max, otherwise some nodes fail.
    // The workspace path varies by node so get that path, and then add on 10 chars of a UUID string.
    ws_path = "$WORKSPACE".substring(0, "$WORKSPACE".indexOf("workspace/") + "workspace/".length()) + UUID.randomUUID().toString().substring(0, 10)
    ws(ws_path) {
        // pull the code
        dir( 'intel-models' ) {
            checkout scm
        }
        stage('Install dependencies') {
            sh """
            #!/bin/bash -x
            set -e
            # don't know OS, so trying both apt-get and yum install
            sudo apt-get clean || sudo yum update -y
            sudo apt-get update -y || sudo yum install -y epel-release
            sudo apt-get install -y python3-dev python3-pip || sudo yum install -y python36-devel python36-pip

            # virtualenv 16.3.0 is broken do not use it
            python3 -m pip install --no-cache-dir --user --upgrade pip==19.0.3 virtualenv!=16.3.0 tox
            """
        }
        stage('Style tests') {
            sh """
            #!/bin/bash -x
            set -e

            cd intel-models
            ~/.local/bin/tox -e py3-flake8
            """
        }
        stage('Unit tests') {
            sh """
            #!/bin/bash -x
            set -e

            cd intel-models
            ~/.local/bin/tox -e py3-py.test
            """
        }
        // put benchmarks here later
        // stage('Benchmarks') {
        //     echo 'Benchmark testing..'
        // }
    }
}
