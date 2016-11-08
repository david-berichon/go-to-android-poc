export GOPATH=$(CURDIR)/go

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
