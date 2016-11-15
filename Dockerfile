FROM dbndev/openjdk-base

RUN apt-get update && apt-get install -y \
 curl \
 unzip \
 make \
 python

# Add new non-admin user
RUN adduser --disabled-password --gecos "" user

# Switch to user land
USER user

#expose HOME variable to docker-build
ENV HOME /home/user

# set current workind directory
WORKDIR $HOME

# Install Android SDK
ENV ANDROID_HOME $HOME/android-sdk-linux
RUN curl https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
  | tar xz -C ${HOME} \
  && ( while [ 1 ]; do sleep 5; echo y; done ) \
    | ${ANDROID_HOME}/tools/android update sdk --no-ui \
  && ( while [ 1 ]; do sleep 5; echo y; done ) \
    | ${ANDROID_HOME}/tools/android update sdk --no-ui --filter android-23  \
  && ( while [ 1 ]; do sleep 5; echo y; done ) \
    | ${ANDROID_HOME}/tools/android update sdk --no-ui --filter build-tools-23.0.2

# Add Android SDK Platform tools in PATH
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Restore Android licenses acceptance
COPY android-sdk-licenses $ANDROID_HOME/licenses

# Install the NDK
RUN curl https://dl.google.com/android/repository/android-ndk-r12b-linux-x86_64.zip \
    > android-ndk-r12b-linux-x86_64.zip \
  && unzip android-ndk-r12b-linux-x86_64.zip \
  && rm android-ndk-r12b-linux-x86_64.zip
ENV ANDROID_NDK_HOME $HOME/android-ndk-r12b

# Add Android NDK to PATH
ENV PATH $PATH:$ANDROID_NDK_HOME

# Build Standalone toolchain for our supported android architectures.
# Let say ARM ARM64 X86 X86_64
ENV ANDROID_STANDALONE_TOOLCHAINS_PATH $ANDROID_NDK_HOME/standalone-toolchains
RUN mkdir $ANDROID_STANDALONE_TOOLCHAINS_PATH \
  && for i in arm arm64 x86 x86_64; do \
    $ANDROID_NDK_HOME/build/tools/make_standalone_toolchain.py  \
      --arch $i --api 21 \
      --install-dir $ANDROID_STANDALONE_TOOLCHAINS_PATH/$i; \
  done

# Install go to standard location (need root privileges)
USER root
RUN curl https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz \
  | tar xz -C /usr/local
ENV PATH ${PATH}:/usr/local/go/bin

USER user
