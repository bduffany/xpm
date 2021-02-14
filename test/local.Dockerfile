FROM ubuntu:20.04

RUN apt update && apt install -y git sudo python3 curl unzip wget

COPY . /src/xpm
WORKDIR /src/xpm
RUN rm -rf .git
RUN yes | bin/setup.sh

CMD ["bash"]