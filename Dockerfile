FROM dbndev/android-ndk-r12b-build-samples

RUN apt-get update && apt-get install -y \
 curl \
 python

RUN cd /usr/local \
 && curl https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz | tar xzv
 
ENV PATH $PATH:$PATH:/usr/local/go/bin

RUN /opt/android-ndk-r12b/build/tools/make_standalone_toolchain.py  --arch arm --api 21 --install-dir /opt/toolchain

RUN cd $ANDROID_HOME \
 && curl https://cmake.org/files/v3.7/cmake-3.7.0-rc3-Linux-x86_64.tar.gz | tar xzv \
 && mv cmake-3.7.0-rc3-Linux-x86_64 cmake
 
COPY android-sdk-licenses $ANDROID_HOME/licenses
