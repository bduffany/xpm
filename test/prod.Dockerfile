FROM ubuntu:20.04

RUN apt update && apt install -y git sudo python3 curl unzip wget

RUN yes | ( curl -sSLo- xpm.sh/get | bash)

CMD ["bash"]
