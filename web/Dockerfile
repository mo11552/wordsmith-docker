FROM golang:1.21-alpine3.18

LABEL owner="Moyo"

WORKDIR /usr/src/app

COPY . .

RUN go build dispatcher.go

EXPOSE 80

CMD ["./dispatcher"]