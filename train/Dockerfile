FROM ubuntu

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# ENV PATH /usr/local/nvidia/bin/:$PATH
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# # Tell nvidia-docker the driver spec that we need as well as to
# # use all available devices, which are mounted at /usr/local/nvidia.
# # The LABEL supports an older version of nvidia-docker, the env
# # variables a newer one.
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# LABEL com.nvidia.volumes.needed="nvidia_driver"


# # Install base packages.
# RUN apt-get update --fix-missing && apt-get install -y \
#     bzip2 \
#     ca-certificates \
#     curl \
#     gcc \
#     git \
#     libc-dev \
#     libglib2.0-0 \
#     libsm6 \
#     libxext6 \
#     libxrender1 \
#     wget \
#     vim \
#     nano \
#     tmux \
#     libevent-dev \
#     build-essential && \
#     rm -rf /var/lib/apt/lists/* 

# RUN chsh -s /bin/bash
# SHELL ["/bin/bash", "-cu"]


# COPY requirements.txt /home/sooh
# COPY bloom-ds-zero-inference.py /home/sooh
COPY entrypoint.sh /
# RUN python -m pip install --upgrade pip
# RUN pip install -r requirements.txt

RUN chmod +x entrypoint.sh

# login to iccluster of your lab and command `id` to get all the infos
RUN groupadd -g <your_lab_id> NLP-StaffU && groupadd -g <your_lab_AppGrp_id> nlplogins_AppGrpU && useradd -rm -d /home/<your_gaspar_id> -s /bin/bash -g <your_lab_id> -G sudo,<your_lab_AppGrp_id> -u <your_id> <your_gaspar_id>
RUN chown <your_id> -R /home/<your_gaspar_id>

USER <your_gaspar_id>
WORKDIR /home/<your_gaspar_id>


ENTRYPOINT ["/entrypoint.sh"]
