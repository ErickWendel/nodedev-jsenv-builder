FROM ubuntu:18.04

RUN apt-get update && apt-get -y install git make python3 g++ gcc ccache make python3-pip ninja-build

ENV CC="ccache gcc"  
ENV CXX="ccache g++" 

RUN git clone https://github.com/nodejs/node.git

WORKDIR node/

RUN git fetch && git checkout v16.x-staging

RUN ./configure --ninja --node-builtin-modules-path $(pwd)

RUN make -j8

CMD ./node -v