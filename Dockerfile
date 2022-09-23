FROM ubuntu:22.04

RUN apt-get update -y && \
	apt-get install -y uuid-runtime curl wget jq

RUN cd /tmp && \
	wget -O htmlq.tar.gz https://github.com/mgdm/htmlq/releases/latest/download/htmlq-x86_64-linux.tar.gz && \
	tar xf htmlq.tar.gz -C /usr/local/bin && \
	rm htmlq.tar.gz

ADD resources /opt/orthologs-finder

ADD scripts /opt/orthologs-finder

RUN chmod 777 /opt/orthologs-finder/*

ENV PATH="/opt/orthologs-finder:${PATH}"
