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


ENV PATH="/usr/local/cuda-10.1/bin:${PATH:+:${PATH}}"
ENV LD_LIBRARY_PATH="/usr/local/cuda-10.1/lib64:${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

WORKDIR /root
RUN touch .bash_profile
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b && \
    /root/miniconda3/bin/conda install -y pytorch
ENV PATH="/root/miniconda3/bin:${PATH}"

RUN wget https://gist.githubusercontent.com/jordans1882/9bc0cf89a3c0cc6c77e5e8007f5e2b6e/raw/4c89fab4f10ebe2c59875e15a97cf33cd31e512f/environment.yml

RUN wget https://gist.githubusercontent.com/jordans1882/e7f170a9b20531b6b73e8de314de6d38/raw/7f37752f754597dae42d74c31a7875db59841f15/test.py 

RUN conda env create -f environment.yml

RUN git clone https://github.com/jordans1882/emacs-config /root/.emacs-term.d

RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | /root/miniconda3/bin/python
ENV PATH="/root/.cask/bin:${PATH}"

# WORKDIR /root/.emacs-term.d
# RUN cask && cask install && cask build

RUN wget -O - https://gist.githubusercontent.com/jordans1882/4c18c19949e2511aeeb4c7300fa1f0bf/raw/757e6d66fa1935bbe6653578e5423532532398ae/.bashrc >> .bash_profile

RUN conda init

# WORKDIR /workspace
# RUN chmod -R a+w .
