#Formatting
#Header format
headerFormat="\n\n\e[1;34m%s\e[0m\n\n"
#Need header $
#$header="printf $Headerformat %s"

printf "$headerFormat" "Working in location: `pwd`"
export BUILD_HOME=`pwd` &&\
         printf "Created \$BUILD_HOME at `pwd`\n"

#Need generic libraries, the following only works on Ubuntu 12.04
printf "$headerFormat" "Installing i386 architecture libraries"
sudo apt-get -y update
#sudo apt-get -y install libncurses5:i386 libstdc++6:i386 zlib1g:i386
sudo apt-get -y install libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1

printf "$headerFormat" "Installing core Android development packages"
printf "Downloading and extracting Android NDK\n"
curl --location http://dl.google.com/android/ndk/android-ndk32-r10-linux-x86_64.tar.bz2 \
         | tar -jx &&\
         printf "Extracted Android NDK to `pwd`\n"

printf "Downloading and extracting Android SDK\n"
curl --location http://dl.google.com/android/android-sdk_r23.0.2-linux.tgz \
         | tar -zx &&\
         printf "Extracted Android NDK to `pwd`\n"

printf "$headerFormat" "Configuring build environment"
export ANDROID_NDK=`pwd`/android-ndk-r10 &&\
         printf "Created \$ANDROID_NDK at `pwd`/android-ndk-r10\n"
export ANDROID_SDK=`pwd`/android-sdk-linux &&\
         printf "Created \$ANDROID_SDK at `pwd`/android-sdk-linux\n"
export PATH=$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools &&\
         printf "Added \$ANDROID_SDK/tools and \$ANDROID_SDK/platform-tools to \$PATH\n"

#Workaround to allow Android SDK update automation
printf "$headerFormat" "Updating Android SDK"
( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --no-ui \
         --filter "tools", "platform-tools", "build-tools-20.0.0", "android-20"
printf "$headerFormat" "Finished updating Android SDK"

printf "$headerFormat" "Building engine"
bash $ANDROID_NDK/build/tools/make-standalone-toolchain.sh

mkdir build && cd build

cmake .. -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchains/android.toolchain.cmake \
         -DANDROID_NATIVE_API_LEVEL=android-19
		
cmake --build . -- -j4 && cd $BUILD_HOME

printf "$headerFormat" "Building APK"
cd $BUILD_HOME
android update project \
         --name purity2d-build --path . --target "android-20"

ant debug

printf "$headerFormat" "Validating build"
cd $BUILD_HOME
ls -la ./bin



