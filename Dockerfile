FROM alpine:3.3

COPY ./*.patch ./
RUN apk update && \
  apk add --no-cache curl alpine-sdk ca-certificates && \
  curl https://www.cs.utah.edu/plt/snapshots/current/installers/min-racket-src.tgz | tar -xz && \
  cd racket && \
  patch -p0 < ../xform.patch && \
  patch -p0 < ../sconfig.patch && \
  cd src && \
  CFLAGS="-D_GNU_SOURCE -msse2 -O3" ./configure --disable-floatinstead --prefix=/usr && \
  make && \
  make install && \
  rm -rf racket *.patch && \
  apk del curl alpine-sdk

CMD ["racket"]
