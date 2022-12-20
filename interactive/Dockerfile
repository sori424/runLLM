# Choose a docker template
# ex: FROM python
FROM --platform=linux/amd64 nvidia/cuda:11.0.3-devel-ubuntu18.04

# Set some basic ENV vars
ENV HOME=/home/sooh

# ENV HOME=/home
ENV CONDA_PREFIX=${HOME}/.conda
ENV CONDA=${CONDA_PREFIX}/condabin/conda

# Set default shell to /bin/bash
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-cu"]

# Install dependencies
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        cmake \
        g++-4.8 \
        git \
        curl \
        vim \
        unzip \
        wget \
        tmux \
        screen \
        ca-certificates \
        apt-utils \
        libjpeg-dev \
        libpng-dev

WORKDIR ${HOME}

# Copy the local folder into cluster
COPY ./fewshot1123 ./fewshot


# Install coda ENV
ENV env llm
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
RUN bash miniconda.sh -b -p ${CONDA_PREFIX}
RUN ${CONDA} config --set auto_activate_base false
RUN ${CONDA} init bash
RUN ${CONDA} create --name $env python=3.8


# Setup dependencies
RUN ${CONDA} run -n $env pip install torch transformers 
RUN ${CONDA} install -n $env pytorch pytorch=1.12.0 torchvision torchaudio cudatoolkit=11.3 -c pytorch


# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd

# Set up SSH server
RUN apt-get update && apt-get install -y openssh-server tmux vim
# RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

# Install the Run:AI Python library and its dependencies
RUN ${CONDA} run -n $env pip install runai prometheus_client==0.7.1

# You should change GROUP_ID, GROUP_NAME by `id` in your lab's cluster 
WORKDIR /
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME}-StaffU && groupadd -g ${App_GrpU_ID} ${App_GrpU_NAME} && useradd -rm -d /home/sooh -s /bin/bash -g ${GROUP_ID} -G sudo,${App_GrpU_ID} -u ${USER_ID} ${USER_NAME}
RUN chown ${USER_ID} -R /home/sooh

# Change the password to make root > user
RUN echo -e "sooh\nsooh" | passwd sooh

ENV HOME=/home/sooh
WORKDIR /home/sooh

# Prepare the data directory 
# RUN mkdir /mnt/nlpdata1
# RUN mkdir /mnt/scratch


ENTRYPOINT ["/usr/sbin/sshd", "-D"]
