#    3 apk get pptpclient
#    4 wget https://tenet.dl.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.13.tar.gz
#    5 ls
#    6 cd ..
#    7 mkdir sstp
#    8 mv syco/sstp-client-1.0.13.tar.gz sstp/
#    9 cd sstp/
#   10 ls
#   11 tar xcvf sstp-client-1.0.13.tar.gz 
#   12 tar xvf sstp-client-1.0.13.tar.gz 
#   13 ls
#   14 cd sstp-client-1.0.13/
#   15 ls
#   16 ./configure
#   17 apk add gcc
#   18 ./configure
#   19 apk add make g++
#   20 ./configure
#   21 apk add libevent


# apk add gcc make g++ libevent-dev openssl-dev ppp-dev

FROM archlinux:base-devel-20201206.0.10501

COPY . /sycophant
RUN pacman -Sy --noconfirm pptpclient sstp-client

WORKDIR /sycophant
RUN mknod /dev/ppp c 108 0
# RUN ./configure; make -C pppd install

# CMD ["/sycophant/ppp_sycophant.sh"]
ENTRYPOINT [ "/sycophant/ppp_sycophant.sh" ]