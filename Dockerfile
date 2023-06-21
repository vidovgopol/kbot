FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
COPY . .
#ARG build_arc
#RUN make $build_arc
ARG TARGETOS
ARG CGO_ENABLED
RUN make build TARGETARCH=$TARGETARCH TARGETOS=$TARGETOS CGO_ENABLED=$CGO_ENABLED


FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./kbot", "start"]
