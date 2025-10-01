# ----------- Build Stage -----------
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -tags dev -gcflags "all=-N -l" -o websocket-server

# ----------- Run Stage -----------
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/websocket-server ./websocket-server
COPY --from=builder /app/static ./static
EXPOSE 8080
CMD ["./websocket-server"]
