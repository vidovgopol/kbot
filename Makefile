APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=vidovgopol
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=arm64 #amd64 arm64
CGO_ENABLED=0
CGO_ENABLED=0

linux:
	${MAKE} build TARGETOS=linux TARGETARCH=${TARGETARCH} 

macos:
	${MAKE} build TARGETOS=darwin TARGETARCH=${TARGETARCH}

windows:
	${MAKE} build TARGETOS=windows TARGETARCH=${TARGETARCH} CGO_ENABLED=1


format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

 build: format get
	CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/den-vasyliev/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} --build-arg CGO_ENABLED=${CGO_ENABLED} --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

# Clean binaries and latest docker image. For image deletion you should pass ${TARGETARC} to make clean. Example: 
#"make clean TARGETARC=amd64" for linux,
#"make clean TARGETARC=arm64" for mac,
#"make clean TARGETARC=arm64" for windows.

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}