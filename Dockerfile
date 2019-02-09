FROM ubuntu

ENV HOST="na.luckpool.net"
ENV PORT=3960
ENV ADDRESS="RKAQ4vLCiTiVL8QzoiCw7Z6tZmMZ19aF2P"
ENV WORKER="KachInd"
ENV THREADS=0

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y update
RUN apt-get -y install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential sudo git

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN sudo apt-get update

RUN sudo git clone --single-branch -b cpuonlyverus https://github.com/monkins1010/ccminer.git
WORKDIR /ccminer
RUN sudo chmod +x build.sh
RUN sudo chmod +x configure.sh
RUN sudo chmod +x autogen.sh
CMD sudo ./autogen.sh
CMD sudo ./configure.sh
CMD sudo ./build.sh

RUN wget https://raw.githubusercontent.com/kachind/verus/master/start.sh
RUN sudo chmod +x start.sh

ENTRYPOINT ["sh", "-c", "sudo ./start.sh -h \"$HOST\" -p \"$PORT\" -a \"$ADDRESS\" -w \"$WORKER\" -t \"$THREADS\""]
