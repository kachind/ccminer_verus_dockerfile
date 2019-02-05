FROM ubuntu

ENV HOST="na.luckpool.net"
ENV PORT=3960
ENV ADDRESS="RKAQ4vLCiTiVL8QzoiCw7Z6tZmMZ19aF2P"
ENV WORKER="KachInd"
ENV THREADS=0

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential
RUN apt-get install sudo 

RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN sudo apt-get update

RUN sudo git clone --single-branch -b cpuonlyverus https://github.com/kachind/ccminer.git
WORKDIR /ccminer
RUN chmod +x build.sh
RUN chmod +x configure.sh
RUN chmod +x autogen.sh
CMD ./autogen.sh
CMD ./configure.sh
CMD ./build.sh

RUN sudo wget https://raw.githubusercontent.com/kachind/verus/master/start.sh
RUN sudo chmod +x start.sh

ENTRYPOINT ["sh", "-c", "sudo ./start.sh -h \"$HOST\" -p \"$PORT\" -a \"$ADDRESS\" -w \"$WORKER\" -t \"$THREADS\""]
