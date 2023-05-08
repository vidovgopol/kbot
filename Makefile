APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=vidovgopol
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
BUILD=go build -v -o kbot -ldflags "-X="github.com/vidovgopol/kbot/cmd.appVersion=
TARGETOS_LINUX=linux
TARGETOS_MAC=darwin
TARGETOS_WINDOWS=windows
TARGETARC=amd64
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

# You can build binaries for different system architectures. Choose one to fulfil your requirements.

linux: format get
	CGO_ENABLED=0 GOOS=${TARGETOS_LINUX} GOARCH=${TARGETARC_LINUX} ${BUILD}${VERSION}

mac: format get
	CGO_ENABLED=0 GOOS=${TARGETOS_MAC} GOARCH=${TARGETARC_MAC} ${BUILD}${VERSION}

windows: format get
	CGO_ENABLED=0 GOOS=${TARGETOS_WINDOWS} GOARCH=${TARGETARC_WINDOWS} ${BUILD}${VERSION}

# Build Docker container for different system architectures. Choose one to fulfil your requirements. Linux is default image.

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_LINUX} --build-arg build_arc=linux .

image_linux:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_LINUX} --build-arg build_arc=linux .

image_mac:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_MAC} --build-arg build_arc=mac .

image_windows:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_WINDOWS} --build-arg build_arc=windows .

# Push container to repository, for change provider you have to edit make file variables.

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

# Clean binaries and latest docker image. For image deletion you should pass ${TARGETARC} to make clean. Example: 
#"make clean TARGETARC=amd64" for linux,
#"make clean TARGETARC=arm64" for mac,
#"make clean TARGETARC=arm64" for windows.

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}