FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update -y && apt-get install curl=7.81.0-1ubuntu1.24 -y && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

COPY httpstat.sh /app/

CMD ["./httpstat.sh", "auto"]