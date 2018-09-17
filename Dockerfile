FROM ubuntu:16.04

# Install dependencies
RUN apt-get update -qq
RUN apt-get -y install -qq samtools cpanminus r-base git sudo

# Install Git Repo and checkout correct branch
WORKDIR /home/ubuntu
RUN git clone --recurse-submodules https://github.com/dockstore/one-workflow-many-ways.git
WORKDIR /home/ubuntu/one-workflow-many-ways
RUN git checkout nextflow

# Build GSI requirements
WORKDIR /home/ubuntu/one-workflow-many-ways/gsi-website
RUN perl Makefile.PL && make && make test && sudo make install

# Build BAMQC requirements
WORKDIR /home/ubuntu/one-workflow-many-ways/bamqc
RUN cpanm --installdeps --sudo . && perl Makefile.PL && make && make test && sudo make install

# Change to final Working Directory
WORKDIR /home/ubuntu/one-workflow-many-ways

CMD ["/bin/bash"]