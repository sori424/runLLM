# runLLM
Repository for running a Large Language Model (e.g., OPT 176B, Bloom 175B) with using RunAI (EPFL cluster). 

* Basic setup: Used iccluster linux server

1. Download config file and move it to direcotry `.kube` below your ~

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
runai config project nlp
chmod +x runai
sudo ./install-runai.sh
```

Check out the existing list for a valid installation

```
runai list jobs
```



