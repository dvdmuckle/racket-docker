FROM alpine

COPY ./*.patch ./
RUN apk add --no-cache sqlite sqlite-dev curl alpine-sdk ca-certificates libffi libffi-dev && \
  curl https://mirror.racket-lang.org/installers/6.7/racket-6.7-src-builtpkgs.tgz | tar -xz && \
  cd racket-6.7 && \
  patch -p0 < ../xform.patch && \
  patch -p0 < ../sconfig.patch && \
  cd src && \
  CFLAGS="-D_GNU_SOURCE -O2" ./configure --disable-floatinstead --enable-libffi --disable-docs --prefix=/usr && \
  make && \
  make install && \
  cd ../.. && \
  rm -rf racket-6.7 *.patch && \
  apk del curl alpine-sdk libffi-dev
CMD ["racket"]
