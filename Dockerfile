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
RUN echo '{"port" : 3001 ,"logpath" : "","logqueit" : false,"loglevel" : 1,"logpersistday" : 2,"defaultsavepath" : "/data" }' > /app/conf/rrshare.json && mkdir /data && chmod -R 777 /data
EXPOSE 3001/tcp
WORKDIR /app
CMD ["/app/rrshareweb"]
