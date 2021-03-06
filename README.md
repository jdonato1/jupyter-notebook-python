# Docker container - Jupyter Notebook
## Overview

jdonato1/jupyter-notebook-python

The build script creates an Ubuntu-based Jupyter notebook environment for Python.  It contains packages such as numpy, pandas, matplotlib, and seaborn for data manipulation and visualization.

The container has the following features:
* The Jupyter notebook will be listening on the localhost on TCP port 8000
* The container also starts Jupyter Console (command-line interface to Jupyter) for rapid prototyping.  The TCP port will continue listening even if the Jupyter-console session exits.
* If the password has not been set, the console will prompt the user for a password.  The password will be remembered on the host.
* The build script creates the container's jupyter user using the same userid and group as the user who runs the "build" script.  You should be able to read and write files to the host's $HOME/jupyter or container's /home/jupyter directories without permissions conflicts.  Generally for a one-user Linux host the UID is 1000 (the user who installed the system).


To create the container from Docker Hub image (first time):

Version 1.1.1 (1/17/2019) and later:
$ mkdir $HOME/jupyter $HOME/.jupyter ; export JUPYTER_PORT=8000; docker run --name jupyter-notebook -it -e JUPYTER_PORT=$JUPYTER_PORT -p $JUPYTER_PORT:$JUPYTER_PORT  -v $HOME/jupyter:/root -v $HOME/.jupyter:/root/.jupyter jdonato1/jupyter-notebook-python

Prior to version 1.1.1:
$ mkdir $HOME/jupyter $HOME/.jupyter ; docker run --name jupyter-notebook -it -p 8000:8000 -v $HOME/jupyter:/root -v $HOME/.jupyter:/root/.jupyter jdonato1/jupyter-notebook-python




To build the container from scratch, run:

* ./build 


To access root account, type:

* $ sudo bash
* The jupyter account's default password is: jupyter

 

