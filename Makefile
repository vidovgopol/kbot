APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=vidovgopol
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
BUILD=go build -v -o kbot -ldflags "-X="github.com/vidovgopol/kbot/cmd.appVersion=
TARGETOS_LINUX=linux
TARGETOS_MAC=darwin
TARGETOS_WINDOWS=windows
TARGETARC_MAC=arm64
TARGETARC_LINUX=amd64
TARGETARC_WINDOWS=x64

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

# Build Docker container for different system architectures. Choose one to fulfil your requirements.

image_linux:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_LINUX} --build-arg build_arc=linux .
	latest_image=${REGISTRY}/${APP}:${VERSION}-${TARGETARC_LINUX}
	export latest_image

image_mac:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_MAC} --build-arg build_arc=mac .
	export latest_image=${REGISTRY}/${APP}:${VERSION}-${TARGETARC_MAC}

image_windows:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_WINDOWS} --build-arg build_arc=windows .
	export latest_image=${REGISTRY}/${APP}:${VERSION}-${TARGETARC_WINDOWS}

# Push container to repository, for change provider you have to edit make file variables.

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

# Clean binaries and latest docker image. 

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARC_MAC}