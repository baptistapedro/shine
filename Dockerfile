FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake \ 
    autoconf automake autotools-dev libtool pkg-config 
RUN git clone https://github.com/toots/shine.git
WORKDIR /shine
RUN ./bootstrap
RUN ./configure CC=afl-clang
RUN make
RUN make install
RUN cp ./shineenc /shineenc
RUN wget https://www2.cs.uic.edu/~i101/SoundFiles/StarWars3.wav
RUN mkdir /shineCorpus
RUN mv *.wav /shineCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/shineCorpus", "-o", "/shineOut"]
CMD ["/shineenc", "@@", "/dev/null"]
