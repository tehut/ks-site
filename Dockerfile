FROM golang

# Fetch dependencies
RUN go get github.com/tools/godep

# Add project directory to Docker image.
ADD . /go/src/github.com/tehut/ks-site

ENV USER tehut
ENV HTTP_ADDR :8888
ENV HTTP_DRAIN_INTERVAL 1s
ENV COOKIE_SECRET xpawQ5mWT0M3IoTY

# Replace this with actual PostgreSQL DSN.
ENV DSN postgres://tehut@localhost:5432/ks-site?sslmode=disable

WORKDIR /go/src/github.com/tehut/ks-site

RUN godep go build

EXPOSE 8888
CMD ./ks-site