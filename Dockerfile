FROM docker.io/biocontainers/mitohifi:2.2_cv1

WORKDIR /
RUN mkdir data
ADD ./data /data
