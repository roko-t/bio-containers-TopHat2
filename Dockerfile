#################################################################
# Dockerfile to build TopHat 2.1.1 with Bowtie 2.3.3.1 
##################################################################
# Use ubuntu as a parent image
FROM ubuntu:16.04

# File/Author / Maintainer
MAINTAINER Hiroko Tanaka <hiroko@hgc.jp>

# label of project
LABEL Description="TopHat2" \
      Project="Genomon-Project Dockerization" \
      Version="1.0"

ENV PYTHON_VERSION 2.7.14

# Install required libraries in order to create TopHat2
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    unzip \
    wget \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# create directories for tools
RUN mkdir -p tools 

# Install python
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
 && tar xzvf Python-$PYTHON_VERSION.tgz \
 && cd Python-$PYTHON_VERSION \
 && ./configure --prefix=/usr/local \
 && make \
 && make install \
 && cd ../ \
 && export LD_LIBRARY_PATH="/usr/local/lib"
CMD ["python --version"]

# Download Bowtie2
RUN wget https://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.3.1/bowtie2-2.3.3.1-linux-x86_64.zip -P tools \
 && cd tools && unzip bowtie2-2.3.3.1-linux-x86_64.zip \
 && cd ../ && rm /tools/bowtie2-2.3.3.1-linux-x86_64.zip

# Download TopHat2
RUN wget http://ccb.jhu.edu/software/tophat/downloads/tophat-2.1.1.Linux_x86_64.tar.gz -P tools\
 && cd tools && tar zxvf /tools/tophat-2.1.1.Linux_x86_64.tar.gz \
 && cd ../ && rm /tools/tophat-2.1.1.Linux_x86_64.tar.gz 

# Download test data
RUN wget http://ccb.jhu.edu/software/tophat/downloads/test_data.tar.gz -P tools \
 && cd tools && tar zxvf /tools/test_data.tar.gz \
 && cd ../ && rm /tools/test_data.tar.gz

# Change in PATH
ENV PATH /tools/tophat-2.1.1.Linux_x86_64:$PATH
ENV PATH /tools/bowtie2-2.3.3.1-linux-x86_64:$PATH

WORKDIR /work
