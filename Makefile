APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=vidovgopol
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARC=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARC} go build -v -o kbot -ldflags "-X="github.com/vidovgopol/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

clean:
	rm -rf kbot