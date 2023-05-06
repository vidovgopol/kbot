APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=vidovgopol
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
BUILD=go build -v -o kbot -ldflags "-X="github.com/vidovgopol/kbot/cmd.appVersion=
TARGETOS_LINUX=linux
TARGETOS_MAC=darwin
TARGETOS_WINDOWS=windows
TARGETARC_MAC=arm64
TARGETARC_LINUX=amd64
TARGETARC_WINDOWS=amd64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

#build: format get
#	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARC} go build -v -o kbot -ldflags "-X="github.com/vidovgopol/kbot/cmd.appVersion=${VERSION}

linux: format get
	CGO_ENABLED=0 GOOS=${TARGETOS_LINUX} GOARCH=${TARGETARC_LINUX} ${BUILD}${VERSION}

mac: format get
	CGO_ENABLED=0 GOOS=${TARGETOS_MAC} GOARCH=${TARGETARC_MAC} ${BUILD}${VERSION}

windows: format get
	CGO_ENABLED=0 GOOS=${TARGETOS_WINDOWS} GOARCH=${TARGETARC_WINDOWS} ${BUILD}${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

clean:
	rm -rf kbot