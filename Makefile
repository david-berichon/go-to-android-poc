export GOPATH=$(CURDIR)/go

all:
	docker run --rm -v $(CURDIR):$(CURDIR) -w $(CURDIR) dbndev/go-to-android-poc-env make POC

hello.so: 
	CGO_ENABLED=1 \
	CC=$$ANDROID_STANDALONE_TOOLCHAINS_PATH/arm/bin/arm-linux-androideabi-clang \
	GOOS=android \
	GOARCH=arm \
	GOARM=7 \
	go build -buildmode=c-shared -ldflags=-extldflags=-Wl,-soname,libgohello.so -o hello.so hello

hello.h: 
	CGO_ENABLED=1 \
	CC=$$ANDROID_STANDALONE_TOOLCHAINS_PATH/arm/bin/arm-linux-androideabi-clang \
	GOOS=android \
	GOARCH=arm \
	GOARM=7 \
	go tool cgo --exportheader hello.h go/src/hello/hello.go

POC: hello.so hello.h
	cd hello-libs/gen-libs && ./gen_lib.sh
	mkdir -p hello-libs/distribution/gohello/include
	mkdir -p hello-libs/distribution/gohello/lib/armeabi-v7a
	mv hello.h hello-libs/distribution/gohello/include/gohello.h
	mv hello.so hello-libs/distribution/gohello/lib/armeabi-v7a/libgohello.so
	cd hello-libs && ./gradlew && ./gradlew build
