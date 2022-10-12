FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
ENV DEBIAN_FRONTEND nonnteractive

RUN apt-get update -y && apt-get install -y python3-pip \
  python3-dev \
  libsm6 \
  libxext6 \
  libxrender-dev

RUN apt-get install -y git \
  pkg-config \
  libopencv-dev \
  wget \
  unzip \
  ffmpeg

RUN pip3 install numpy
RUN pip3 install opencv-python
RUN pip3 install requests
RUN pip3 install numba
RUN pip3 install imutils 
RUN pip3 install matplotlib

WORKDIR home/

RUN git clone https://github.com/AlexeyAB/darknet 
WORKDIR darknet/

# remove comments for use GPU
# RUN sed -i 's/GPU=.*/GPU=1/' Makefile 
# RUN sed -i 's/CUDNN=.*/CUDNN=1/' Makefile
# RUN sed -i 's/OPENCV=.*/OPENCV=1/' Makefile && make
RUN make

COPY darknet/yolov4.weights /home/darknet/

COPY detect.py /home/darknet/
COPY config.json /home/darknet/

# CMD ["python3", "detect.py", "data/person.jpg"]
CMD ["tail", "-f", "/dev/null"]

# Download yolov4.weights opcional
# RUN wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights -P /home/darknet

# Methods of Execute 

# docker run -it --rm fernandomarca/darknet-yolov4 python3 detect.py data/eagle.jpg
# docker exec -it container_id python3 detect.py path_to_image

## into container 
# ./darknet detect cfg/yolov4.cfg yolov4.weights data/person.jpg

## With Gpu Acelleration
# docker run -it --gpus all --shm-size=1g fernandomarca/darknet-yolov4 python3 detect.py data/eagle.jpg
# docker run -it --runtime=nvidia --shm-size=1g fernandomarca/darknet-yolov4 python3 detect.py data/eagle.jpg

## Container for test Gpu Acelleration

# docker run --rm --gpus all nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 nvidia-smi
# docker run --rm -ti --gpus=all -e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=all nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 nvidia-smi