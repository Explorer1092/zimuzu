FROM alpine:latest as builder
ARG DATE=20190714
ADD http://appdown.rrysapp.com/rrshareweb_centos7.tar.gz /tmp/
RUN tar zxvf /tmp/rrshareweb_centos7.tar.gz -C /tmp/

FROM alpine:latest
ENV GLIBC_VERSION=2.28-r0
RUN apk add  -U --no-cache tzdata wget libstdc++ libgcc
RUN wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
 wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
 apk add --allow-untrusted glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
 apk del wget
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
WORKDIR /root/
COPY --from=builder /tmp/rrshareweb /app
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
EXPOSE 3001/tcp
WORKDIR /app
CMD ["/app/rrshareweb"]  