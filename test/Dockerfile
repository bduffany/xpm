FROM ubuntu:20.04

RUN sudo apt update && sudo apt install -y git

COPY . /src/xpm
WORKDIR /src/xpm
RUN REPO_URL=/src/xpm bin/setup.sh

CMD ["bash"]