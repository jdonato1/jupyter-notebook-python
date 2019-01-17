### Ubuntu-based Jupyter Notebook container
### Dockerfile
###
### Use "build" script instead of calling docker run directly.  See the
### build script.
###
### For now using root user


# Based on Ubuntu 18.04 (bionic)
FROM ubuntu:bionic

# Disable user prompts
ENV DEBIAN_FRONTEND noninteractive

# Default user is 1000, the user that created the Linux system
ARG UID=0
ARG GID=0
# REMOVE_ROOT.  if == 1: remove the root user.  Not done by default.
ARG REMOVE_ROOT=0

# Set a local file as tensorflow binary (python3 wheel file) to install [default]
#	
ARG TENSORFLOW_WHEEL=tensorflow-1.11.0-cp36-cp36m-linux_x86_64.whl

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
	wget \
	net-tools 

# Install python3 and the pip3 installer
RUN apt-get install -y \
	$PYTHON_VERSION \
	python3-pip

# Install Data Science packages
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
	python3-pandas \
	python3-geopandas \
	python3-xlrd \
	python3-numpy 
	
# Install graphical display packages
RUN apt-get install -y \
	python3-seaborn \
	python3-sklearn \
	python3-sklearn-pandas \
	python3-matplotlib \
	python3-matplotlib-venn \
	python3-colormap \
	python3-pygraphviz \
	python3-snappy \
	python3-sympy

# graphviz for graphics (visualiztion)
# mplleaflet for maps (geo-spatial)
# pyarrow and fastparquet for supporting parquet file format
RUN pip3 install \
	graphviz \
	mplleaflet \
	fastparquet \
	pyarrow

# Install a message queue
RUN apt-get install -y \
	python3-zmq

# Install theano (alternative backend to keras)
RUN apt-get install -y \
	python3-theano 

# Install tensorflow.  This downloads a version of
# tensorflow for CPUs that do not support avx/avx2
# instruction sets.  See:
#	Github and Docker Hub:
#		jdonato1/tensorflow-from-source
#
# If your CPU supports these instruction sets, 
# you can manually install an official tensorflow
# wheel file:
#	# sudo pip3 install tensorflow
#		OR
#	# sudo pip3 install tensorflow-gpu
#
COPY $TENSORFLOW_WHEEL /root
RUN pip3 install --upgrade /root/$TENSORFLOW_WHEEL && \
	rm -f /root/$TENSORFLOW_WHEEL
	
# Install keras (uses tensorflow or theano as backend)
RUN apt-get install -y \
	python3-keras

# Install jupyter notebook and jupyter console
RUN apt-get install -y \
	jupyter-notebook \
	jupyter-console \
	jupyter-client

# Install nbmerge to merge Jupyter notebooks on command-line
RUN pip3 install \
	nbmerge \
	nbformat

# Install sudo
RUN apt-get install -y sudo 

COPY motd /etc/motd

COPY rc.local /etc/rc.local

# tf_build - script from jdonato1/tensorflow-from-source
# Builds a tensorflow wheel file from source.  Particularly useful for Linux
# computers with CPUs that lack the "avx2" instruction set.
#
# Recommendation:  Build tensorflow v1.11.0:
#       $ ./tf_build -s11
#
COPY tf_build /root

COPY README.md /etc



# Upgrade any pip packages
RUN ( pip3 list | \
	cut -d" " -f1 | \
	sudo -H xargs pip3 install --upgrade ) || \
		true

RUN mkdir -p /root/jupyter /root/.jupyter

ENV DEBIAN_FRONEND ""

# Remove the root user account if REMOVE_ROOT == 1 (default)
# This is a security enhancement to prevent abuse in the event the container is compromised.
RUN [ "$REMOVE_ROOT" = "1" ] && userdel -r -f root || true

WORKDIR /root

ENV DEBIAN_FRONEND ""

CMD ["/etc/rc.local"]


