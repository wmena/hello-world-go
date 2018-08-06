# Build step
FROM golang:latest AS build

RUN mkdir -p $GOPATH/src/github.com/wmena/hello-world-go
ADD . $GOPATH/src/github.com/wmena/hello-world-go
WORKDIR $GOPATH/src/github.com/wmena/hello-world-go
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -vendor-only
RUN CGO_ENABLED=0 go build -o /hello-world-go

# Final Step
FROM alpine

RUN apk update
RUN apk upgrade
RUN apk add ca-certificates && update-ca-certificates
RUN apk add --update tzdata
RUN rm -rf /var/cache/apk/*

COPY --from=build /hello-world-go  /home/
ENV TZ=Europe/London
WORKDIR /home
ENTRYPOINT ./hello-world-go
EXPOSE 8080
