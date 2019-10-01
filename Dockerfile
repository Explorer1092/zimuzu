FROM alpine:latest as builder
ARG DATE=20191001
ADD ./rrshareweb_centos7.tar.gz /tmp/
# ADD http://appdown.rrysapp.com/rrshareweb_centos7.tar.gz /tmp/
# RUN tar zxvf /tmp/rrshareweb_centos7.tar.gz -C /tmp/

FROM alpine:latest
ENV GLIBC_VERSION=2.28-r0
RUN apk add  -U --no-cache tzdata wget libstdc++ libgcc
RUN wget -q "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
 wget -q "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
 apk add --allow-untrusted glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk && \
 apk del wget
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
WORKDIR /root/
COPY --from=builder /tmp/rrshareweb /app
RUN mkdir /opt/work/store && \
	chmod -R 777 /opt/work/store
EXPOSE 3001/tcp
VOLUME ["/opt/work/store"]
WORKDIR /app
CMD ["/app/rrshareweb"]
