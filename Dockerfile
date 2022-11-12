### TODO: Make sure that the cuda driver's version matches (also below)
### TODO: Make sure you have your .dockerignorefile
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

ENV HOME=./root
ENV CONDA_PREFIX=${HOME}/.conda
ENV CONDA=${CONDA_PREFIX}/condabin/conda

### Use bash as the default shelll
RUN chsh -s /bin/bash
SHELL ["bash", "-c"]

# Install dependencies
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends openssh-server vim wget unzip tmux

# Cluster setup
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.11.0-Linux-x86_64.sh -O anaconda.sh
RUN bash anaconda.sh -b -p ${CONDA_PREFIX}
RUN ${CONDA} config --set auto_activate_base false
RUN ${CONDA} init bash

RUN echo "export LANG=en_US.UTF-8" >> ~/.bashrc

# Setup conda env
RUN ${CONDA} create --name testy -y python=3.8
# RUN ${CONDA} install -n testy -y pytorch cudatoolkit=11.5 -c pytorch

# WORKDIR ${CREA_DIR}
# RUN mkdir ${CREA_DIR}

# COPY ./testst.py .

# Set up SSH server
RUN apt-get update && apt-get install -y openssh-server tmux vim
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
