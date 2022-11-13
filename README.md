# runLLM
Repository for running a Large Language Model (e.g., OPT 176B, Bloom 175B) with using RunAI (EPFL cluster). 

## Basic setup

1. Download config file and move it to direcotry `.kube` below your `/root`

```
cd ~
mkdir .kube
mv config .kube/config_runai
export KUBECONFIG=~/.kube/config_runai
```

2. Download RunAI & Login

```
wget https://github.com/run-ai/runai-cli/releases/download/v2.4.1/runai-cli-v2.4.1-linux-amd64.tar.gz
tar -xvf runai-cli-v2.4.1-linux-amd64.tar.gz
runai login
chmod +x runai
sudo ./install-runai.sh
```

Check out the existing list for a valid installation

```
runai config project nlp
runai whoami
runai list jobs
```

3. Docker build (Can be omitted, no need to push to the harbor, just using runai submit: e.g., submit -i ubuntu)

Build a docker image

```
docker build . -t ic-registry.epfl.ch/nlp/<your-tag>
```

Login to docker with EPFL credential

```
docker login ic-registry.epfl.ch
```

Push docker image to the harbor, where you can find all the docker images 

```
docker tag <your-tag> ic-registry.epfl.ch/nlp/<your-tag>
docker push ic-registry.epfl.ch/nlp/<your-tag>
```

4. Submit docker image

```
runai submit -i ic-registry.epfl.ch/nlp/<docker-image>
```

Then, run bash and interact throughout terminal

```
runai bash <project-name>
```

4-1. Submit dockerfile to use with VSCode

```
runai submit test -i ic-registry.epfl.ch/nlp/sooh/test -g 1 --interactive --service-type=nodeport --port 30022:22
```

Then, you can access throughout (`mapped-iccluster-number` can be checked by `runai list jobs`)

```
ssh -p 30022 root@iccluster<mapped-iccluster-number>.iccluster.epfl.ch
```

here pwd will be `root`

* You should specify lines on dockerfile regarding ssh access & port number, please refer [docker](https://github.com/run-ai/docs/blob/master/quickstart/python%2Bssh/Dockerfile)

6. Delete project after done

```
runai delete <project-name>
```

## Alpa Setup

Let's move on to the next step. [Alpa package](https://alpa.ai/tutorials/opt_serving.html) will allow you to train large language models. 

* Designed for large models: Cannot fit the model into a single GPU? Not a problem, Alpa is designed for training and serving big models like GPT-3.

* Support commodity hardware: With Alpa, you can serve OPT-175B using your in-house GPU cluster, without needing the latest generations of A100 80GB GPUs nor fancy InfiniBand connections – no hardware constraints!

* Flexible parallelism strategies: Alpa will automatically figure out the appropriate model-parallel strategies based on your cluster setup and your model architecture.

### Install Alpa Prerequisites

```
# Update pip
pip3 install --upgrade pip

# Use your own CUDA version. Here cuda-cuda114 means cuda 11.5
pip3 install cupy-cuda114
```

Check your cuda version by `nvidia-smi`. Then, check whether your system already has NCCL installed.

Highly likely you'll get error `cupy is not in the path` related. Then, follow the process below.

```
pip install -U setuptools pip
pip install cupy -vvvv
sudo CUDA_PATH=/opt/nvidia/cuda pip install cupy
```

Now, move on to install Alpa with python wheels. In this case, the wheel compatible with CUDA >= 11.1 and cuDNN >= 8.0.5.

```
pip3 install alpa
pip3 install jaxlib==0.3.15+cuda111.cudnn805 -f https://alpa-projects.github.io/wheels.html
```

Let's check the installation.

```
ray start --head
python3 -m alpa.test_install
```

## References

https://github.com/epfml/kubernetes-setup
