FROM arm32v7/debian:latest

WORKDIR /app

COPY build/bin/hello /usr/local/bin/hello

RUN chmod +x /usr/local/bin/hello

CMD ["/usr/local/bin/hello"]
