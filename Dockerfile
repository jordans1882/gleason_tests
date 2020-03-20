FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
ARG PYTHON_VERSION=3.8
ARG WITH_TORCHVISION=1
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         wget \
         ca-certificates \
         libjpeg-dev \
         software-properties-common \
         libpng-dev && \
     add-apt-repository ppa:jonathonf/vim && \
     add-apt-repository ppa:kelleyk/emacs && \
     apt-get install -y --no-install-recommends \
         vim \
	 emacs26 && \
     rm -rf /var/lib/apt/lists/*


WORKDIR /root
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b && \
    echo "PATH=/root/miniconda3/bin:$PATH" >> .bashrc && \
    /root/miniconda3/bin/conda install -y pytorch
# RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
#      chmod +x ~/miniconda.sh && \
#      ~/miniconda.sh -b -p /opt/conda && \
#      /opt/conda/bin/conda update --prefix /opt/conda anaconda
#      # rm ~/miniconda.sh && \
#      # /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include ninja cython typing && \
#      # /opt/conda/bin/conda install -y -c pytorch magma-cuda100 && \
#      # /opt/conda/bin/conda clean -ya
# ENV PATH /opt/conda/bin:$PATH

# This must be done before pip so that requirements.txt is available
# WORKDIR /opt/pytorch
# COPY . .
# 
# RUN git submodule update --init --recursive
# RUN TORCH_CUDA_ARCH_LIST="3.5 5.2 6.0 6.1 7.0+PTX" TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
#     CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
#     pip install -v .
# 
# RUN if [ "$WITH_TORCHVISION" = "1" ] ; then git clone https://github.com/pytorch/vision.git && cd vision && pip install -v . ; else echo "building without torchvision" ; fi

RUN git clone https://github.com/jordans1882/emacs-term /root/.emacs.d

RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | /root/miniconda3/bin/python && \
    echo "PATH=/root/.cask/bin:$PATH" >> .bashrc

RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /root/.emacs-term.d
RUN cask && cask install && cask build

RUN wget -O https://gist.github.com/jordans1882/4c18c19949e2511aeeb4c7300fa1f0bf >> .bashrc

WORKDIR /workspace
RUN chmod -R a+w .
