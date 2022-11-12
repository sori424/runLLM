# runLLM
Repository for running a Large Language Model (e.g., OPT 176B, Bloom 175B) with using RunAI (EPFL cluster). 

* Basic setup: Used iccluster linux server

1. Download config file and move it to direcotry `.kube` below your ~

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

(We should run docker image by `docker run -i -t ic-registry.epfl.ch/nlp/<your-tag> /bin/bash`, then use it as another Linux system -- as a virtual machine)

4. Submit docker image

```
runai submit <project-name> -i <docker-image> -g 1 --interactive -- sleep infinity --service-type=portforward --port 30022:22
```

or

```
runai submit -i ic-registry.epfl.ch/nlp/<docker-image>
```

5. Run bash and interact throughout terminal

```
runai bash <project-name>
```

5-1. Run dockerfile with VSCode

```
runai submit test -i ic-registry.epfl.ch/nlp/sooh/test -g 1 --interactive --service-type=nodeport --port 30022:22
```
then, you can access throughout

```
ssh -p 30022 root@iccluster<mapped-iccluster-number>.iccluster.epfl.ch
```

here pwd will be `root`

6. Delete project after done

```
runai delete <project-name>
```


## References

https://github.com/epfml/kubernetes-setup
