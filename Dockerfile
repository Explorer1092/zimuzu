FROM alpine:latest as builder
ADD https://appdown.rrysapp.com/rrshareweb_centos7.tar.gz /tmp/
RUN tar zxvf /tmp/rrshareweb_centos7.tar.gz -C /tmp/

FROM alpine:latest
RUN apk add  -U --no-cache tzdata
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
WORKDIR /root/
COPY --from=builder /tmp/rrshareweb /app
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
EXPOSE 3001/tcp
WORKDIR /app
CMD ["/app/rrshareweb"]  