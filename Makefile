export GOPATH=$(CURDIR)/go

all:POC

hello.so: 
	CGO_ENABLED=1 \
	CC=/opt/toolchain/bin/arm-linux-androideabi-gcc \
	GOOS=android \
	GOARCH=arm \
	GOARM=7 \
	go build -buildmode=c-shared -o hello.so hello

hello.a: 
	CGO_ENABLED=1 \
	CC=/opt/toolchain/bin/arm-linux-androideabi-gcc \
	GOOS=android \
	GOARCH=arm \
	GOARM=7 \
	go build -buildmode=c-archive -o hello.a hello

POC: hello.a
	cd hello-libs/gen-libs && ./gen_lib.sh
	mkdir -p hello-libs/distribution/gohello/include
	cp hello.h hello-libs/distribution/gohello/include
	cp hello.a hello-libs/distribution/gohello/lib/armeabi-v7a
