export GOPATH=$(CURDIR)/go

all:
	docker run --rm -v $(CURDIR):$(CURDIR) -w $(CURDIR) dbndev/go-to-android-poc-env make POC

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
	mkdir -p hello-libs/distribution/gohello/lib/armeabi-v7a
	mv hello.h hello-libs/distribution/gohello/include/gohello.h
	mv hello.a hello-libs/distribution/gohello/lib/armeabi-v7a/libgohello.a
	cd hello-libs && ./gradlew && ./gradlew build

