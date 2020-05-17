# EPICS Base Dockerfile

FROM centos:8

# Set the working directory to /src
WORKDIR /src

ENV EPICS_BASE=/epics/base
ENV EPICS_HOST_ARCH=linux-x86_64
ENV PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}"

#RUN yum -y update && yum -y clean all &&\
RUN dnf -y install make gcc gcc-c++ gcc-toolset-9-make perl-ExtUtils-Install \
    readline-devel 

ARG USERNAME=epicsuser
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

# Create the epicsuser
RUN groupadd --gid ${USER_GID} ${USERNAME} &&\
    useradd --uid ${USER_UID} --gid ${USER_GID} -s /bin/bash -m ${USERNAME} &&\
    chown -R ${USERNAME}:${USERNAME} /src &&\
    mkdir -p /epics && chown -R ${USERNAME}:${USERNAME} /epics

USER ${USERNAME}

# Get sources either from download or tars dir
#RUN curl -L -O https://epics.anl.gov/download/base/base-7.0.3.1.tar.gz &&\
COPY tars/* .

RUN cd /src/ &&\
        tar -zxf base*.tar.gz &&\
        ln -s /src/base-7.0.3.1/ ${EPICS_BASE} &&\
        echo "Starting build" &&\
        make -sj -C ${EPICS_BASE} >> /src/epicsbasebuild.log 2>&1 
    #dnf -y clean all && rm -rf /var/cache/yum &&\
    #cd / # && rm -rf /src/build* /src/*.tar*



