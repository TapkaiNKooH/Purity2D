wget http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86_64.tar.bz2
tar xf android-ndk32-r10-linux-x86_64.tar.bz2

export ANDROID_NDK=`pwd`/android-ndk-r10

./$ANDROID_NDK/build/core/setup-toolchain.sh
