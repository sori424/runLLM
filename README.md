# runLLM
Repository for running a Large Language Model (e.g., OPT, Bloom) with using RunAI (EPFL cluster). 

## Basic setup for RunAI

1. Download config file and move it to direcotry `.kube` below your `/root`

```
cd ~
mkdir .kube
mv config .kube/config
export KUBECONFIG=~/.kube/config
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

cf. `docker ps` to check whether you installed docker app

Build a docker image on your local disk.

```
docker build . -t ic-registry.epfl.ch/nlp/<your-tag>
```

Login to docker with EPFL credential

```
docker login ic-registry.epfl.ch
```

Push docker image to the harbor, where you can find all the docker images 

```
docker push ic-registry.epfl.ch/nlp/<your-tag>
```

4. Submit docker image

Now, submit the job.
```
runai submit -i ic-registry.epfl.ch/nlp/<docker-image>
```

cf. If you want to watch the changes in every 2 seconds, do the command below. If you cannot use eatch command, and using Mac just do `brew install watch`.

```
watch runai list jobs
```

You can interact throughout terminal by bashing

```
runai bash <project-name>
```

4-1. Submit dockerfile to use with VSCode (interactive mode)

```
runai submit test -i ic-registry.epfl.ch/nlp/sooh/test -g 1 --interactive --service-type=nodeport --port 30022:22
```

Then, you can access throughout ssh

```
ssh -p 30022 root@iccluster<mapped-iccluster-number>.iccluster.epfl.ch
```

here pwd will be `root`

* You should specify lines on dockerfile regarding ssh access & port number, please refer [docker](https://github.com/run-ai/docs/blob/master/quickstart/python%2Bssh/Dockerfile)

If you want to mount dataset from your lab cluster, use the submit command below.

```
runai submit <job_name> -i ic-registry.epfl.ch/nlp/<your-tag> -g 1 --cpu 1 --pvc runai-nlp-sooh-nlpdata1:/nlpdata1
```

For the `train mode`, your outputs will be saved in `/scratch` if you submit the runai file with the command below.

[NOTE] If you are using Mac's M1 memory chip, then you should build your image in this way for training mode! Unless, you cannot mount your volume into RunAI cluster (Permission denied).

```
docker buildx build --push --platform=linux/amd64 -f Dockerfile -t ic-registry.epfl.ch/nlp/<your-tag> ./
```

Then, you can access by `interactive mode` with giving the same `--pvc runai-nlp-sooh-nlpdata1:/nlpdata1` option.

4-2. Instead, you can use `bash runai_interactive.sh` by correcting USER_ID, USER_NAME


5. Delete project after done

```
runai delete <project-name>
```

## Accelerator with Deepspeed



https://huggingface.co/blog/bloom-inference-pytorch-scripts

## Alpa Setup

Let's move on to the next step. [Alpa package](https://alpa.ai/tutorials/opt_serving.html) will allow you to train large language models. 

* Designed for large models: Cannot fit the model into a single GPU? Not a problem, Alpa is designed for training and serving big models like GPT-3.

* Support commodity hardware: With Alpa, you can serve OPT-175B using your in-house GPU cluster, without needing the latest generations of A100 80GB GPUs nor fancy InfiniBand connections – no hardware constraints!

* Flexible parallelism strategies: Alpa will automatically figure out the appropriate model-parallel strategies based on your cluster setup and your model architecture.

### Install Alpa Prerequisites

* If you want to convert 175b OPT, you'll need 700GB RAM memory. 350GB disk space.

Check your cuda version by `nvidia-smi`.
```
# Update pip
pip3 install --upgrade pip

# Use your own CUDA version. Here cuda-cuda115 means cuda 11.5
pip3 install cupy-cuda115
```

Then, check whether your system already has NCCL installed by the command below.

```
python3 -c "from cupy.cuda import nccl"
```

Highly likely you'll get error `cupy is not in the path` related. Then, follow the process below.

```
pip install -U setuptools pip
pip install cupy -vvvv
CUDA_PATH=/opt/nvidia/cuda pip install cupy
```

Now, move on to install Alpa with python wheels. In this case, the wheel compatible with CUDA >= 11.1 and cuDNN >= 8.0.5.

```
pip3 install alpa
pip3 install jaxlib==0.3.22+cuda111.cudnn805 -f https://alpa-projects.github.io/wheels.html
```

cf. Alpa modified the original jaxlib at the version jaxlib==0.3.22. Alpa regularly rebases the official jaxlib repository to catch up with the upstream.
Keep in check [Alpa](https://alpa.ai/install.html).


Let's check the installation.

```
ray start --head
python3 -m alpa.test_install
```

Now install alpa requirements.

```
pip3 install "transformers<=4.23.1" fastapi uvicorn omegaconf jinja2

# Install torch corresponding to your CUDA version, e.g., for CUDA 11.3:
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
```

Clone the alpa repo from git. If your machine does not have a git then, do `apt-get install git`. 

```
git clone https://github.com/alpa-projects/alpa.git
```

Then, install `llm_serving` package.

```
cd alpa/examples
pip3 install -e .
```

With -g 8 option in runAI, try to download weights of bloom and run a simple inference task.

```
cd llm_serving
python3 textgen.py --model alpa/bloom
```

## References

https://github.com/epfml/kubernetes-setup

https://github.com/cvlab-epfl/cvlab-kubernetes-guide


