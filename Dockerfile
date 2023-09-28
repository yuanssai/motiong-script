FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.21.1 as builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

WORKDIR /app/

COPY go.mod go.mod
COPY go.sum go.sum

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -ldflags="-w -s" -o .

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine

WORKDIR /cmd/

COPY --from=builder /app/motiong-cli /cmd/motiong-cli

ENTRYPOINT ["/cmd/motiong-cli"]
