FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# Install some basic utilities
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    unzip \
    cmake \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Install Miniconda and Python 3.8
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=$HOME/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-py38_4.8.2-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==3.8.1 \
 && conda clean -ya
 
RUN conda install numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclasses \
 && conda install -c pytorch magma-cuda102 \
 && conda clean -ya \
 && git clone https://github.com/pytorch/pytorch.git \
 && cd pytorch \
 && git checkout v1.4.0 \
 && git submodule sync && git submodule update --init --recursive \
 && export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"} \
 && python setup.py install
