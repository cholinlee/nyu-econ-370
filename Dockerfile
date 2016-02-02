# NYU ECON-UA 370 Course Docker Image (for mybinder.org service)
# User: main
# Environments: Python3.5

FROM andrewosh/binder-base

MAINTAINER Matthew McKay <mamckay@gmail.com>

USER root

#-Update Debian Base-#
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends curl ca-certificates hdf5-tools

#-Install texlive-#
RUN apt-get update -y && apt-get install -yq --no-install-recommends \
	texlive-latex-base \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    && apt-get clean

#-Re-Install Conda for Python3.5 Anaconda Distributions-#
RUN rm -r /home/main/anaconda

USER main

#-NOTE: $HOME/anaconda/envs/python3 is the location anaconda is installed in andrewosh/binder-base
#-If this get's updated then the following instructions will break. 
#-TODO: This step can be removed once the base image is upgraded to python=3.5

RUN wget --quiet https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-2.4.1-Linux-x86_64.sh
RUN bash Anaconda3-2.4.1-Linux-x86_64.sh -b && rm Anaconda3-2.4.1-Linux-x86_64.sh
ENV PATH $HOME/anaconda3/bin:$PATH
RUN /bin/bash -c "ipython kernelspec install-self --user"
RUN conda update conda --yes && conda update anaconda --yes
RUN conda install pymc && conda install seaborn

#-Install Pip Packages
RUN pip install --upgrade pip
RUN pip install quantecon

#-Add Notebooks-#
ADD notebooks/*.ipynb $HOME/