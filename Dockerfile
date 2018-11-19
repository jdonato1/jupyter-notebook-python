### Ubuntu-based Jupyter Notebook container
### Dockerfile
###
### Use "build" script instead of calling docker run directly.  See the
### build script.


# Based on Ubuntu 18.04 (bionic)
FROM ubuntu:bionic

# Disable user prompts
ENV DEBIAN_FRONTEND noninteractive

# Set a local file as tensorflow binary (python3 wheel file) to install [default]
# To not install tensorflow from a wheel file
#
# To *PREVENT* this local tensorflow from being installed, build with the added
# argument (theano will be used instead):
#	
# ENV TENSORFLOW_WHEEL tensorflow-1.11.0-cp36-cp36m-linux_x86_64.whl
# ENV NO_TENSORFLOW ""

# TensorFlow 1.11.0 is not compatible with python3.7.  Specify python3.6.
ENV PYTHON_VERSION python3.6

# Get list of packages and upgrade any base packages before we begin
RUN apt-get update && apt-get upgrade -y

# Install vi, git, gawk, net-tools (ifconfig), and tmux (run processes in background)
RUN apt-get install -y \
	git \
	vim \
	gawk \
	tmux \
	net-tools 

# Install python3 and the pip3 installer
RUN apt-get install -y \
	$PYTHON_VERSION \
	python3-pip

# Install Data Science packages
RUN apt-get install -y \
	python3-pandas \
	python3-geopandas \
	python3-numpy 
	
# Install graphical display packages
RUN apt-get install -y \
	python3-seaborn \
	python3-sklearn \
	python3-sklearn-pandas \
	python3-matplotlib \
	python3-matplotlib-venn \
	python3-colormap

# Install a message queue
RUN apt-get install -y \
	python3-zmq

# Install a local copy of tensorflow
COPY $TENSORFLOW_WHEEL /root
RUN [ "$NO_TENSORFLOW" = "" ] && pip3 install /root/$TENSORFLOW_WHEEL && \
	rm /root/$TENSORFLOW_WHEEL
	
# Install theano (alternative backend to keras)
RUN apt-get install -y \
	python3-theano 

# Install keras (uses tensorflow or theano as backend)
RUN apt-get install -y \
	python3-keras

# Install jupyter notebook and jupyter console
RUN apt-get install -y \
	jupyter-notebook \
	jupyter-console \
	jupyter-client 

# Install sudo
RUN apt-get install -y \
	sudo


COPY motd /etc/motd

COPY rc.local /etc/rc.local

ENV DEBIAN_FRONEND ""

# Set root passwd
RUN (echo superman;echo superman) | passwd root

# Create a user jupyter
RUN groupadd -g $GID jupyter
RUN useradd -u $UID -g $GID -m -s /bin/bash -p `date +%N%N%N` jupyter 
RUN mkdir -p /home/jupyter /home/jupyter/.jupyter
USER jupyter

WORKDIR /home/jupyter

CMD ["/etc/rc.local"]


