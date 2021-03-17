FROM nvidia/cuda:11.2.2-devel-ubuntu20.04

RUN apt-get -y update && apt-get -y upgrade

RUN apt-get -y install python3 python3-pip
RUN pip3 install --upgrade pip

COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Install renderer used to visualize predictions:
COPY Sim3DR /Sim3DR 
WORKDIR Sim3DR
RUN sh build_sim3dr.sh

# Download pretrained model from Google drive:
# https://stackoverflow.com/questions/20665881/direct-download-from-google-drive-using-google-drive-api/32742700#32742700
WORKDIR /
RUN apt-get -y install curl unzip
ARG MODELS_FILE_ID=1OvnZ7OUQFg2bAgFADhT7UnCkSaXst10O
RUN curl -c /tmp/cookies "https://drive.google.com/uc?export=download&id=${MODELS_FILE_ID}" > /tmp/intermezzo.html
RUN curl -L -b /tmp/cookies "https://drive.google.com$(cat /tmp/intermezzo.html | grep -Po 'uc-download-link" [^>]* href="\K[^"]*' | sed 's/\&amp;/\&/g')" > models.zip
RUN unzip models.zip


