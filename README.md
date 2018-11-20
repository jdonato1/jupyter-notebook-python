# Docker container - Jupyter Notebook
## Overview

jdonato1/jupyter-notebook-python

The build script creates an Ubuntu-based Jupyter notebook environment for Python.  It contains packages such as numpy, pandas, matplotlib, and seaborn for data manipulation and visualization.

The container has the following features:
* The Jupyter notebook will be listening on the localhost on TCP port 8000
* The container also starts Jupyter Console (command-line interface to Jupyter) for rapid prototyping.  The TCP port will continue listening even if the Jupyter-console exits.
* If the password has not been set, the console will prompt the user for a password.  The password will be remembered on the host.
* The build script creates the container's jupyter user using the same userid and group as the user who runs the "build" script.  You should be able to read and write files to the host's $HOME/jupyter or container's /home/jupyter directories without permissions conflicts.

To build the container from scratch, run:

* ./build

## To build without tensorflow

To build without tensorflow, run:

* ./build --build-arg NO_TENSORFLOW=1

## Root account is removed by default

By default, this container removes the root account after the build is finished.  To keep the root account, build as follows:

* host$ ./build --build-arg REMOVE_ROOT=0

To access root, type:

* $ sudo bash
* The jupyter account's password is: jupyter



