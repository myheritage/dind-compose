FROM centos:7
LABEL maintainer "elad@myheritage.com"
ARG docker_ce_version=1.13.1
ARG docker_compose_version=1.13.0
RUN yum install -y https://yum.dockerproject.org/repo/main/centos/7/Packages/docker-engine-${docker_ce_version}-1.el7.centos.x86_64.rpm \
  && yum install -y git \
    java-1.8.0-openjdk-devel \
    which \
  && yum clean all \
  && \curl -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose \
  && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
  && \curl -sSL https://get.rvm.io | bash

COPY jenkins-docker-entrypoint.sh /usr/local/bin/

entrypoint ["/usr/local/bin/jenkins-docker-entrypoint.sh"]
