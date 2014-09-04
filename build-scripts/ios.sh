#Formatting
clearFormat="\e[0m"
black="\e[1;30m"
red="\e[1;31m"
green="\e[1;32m"
yellow="\e[1;33m"
blue="\e[1;34m"
magenta="\e[1;35m"
cyan="\e[1;36m"
white="\e[1;37m"
#Prints string in bold blue with many lines of surrounding whitespace.
headerFormat="\n\n\n\n\n${cyan}%s${clearFormat}\n\n"
#Message formats
messageFormat="\n${blue}%s${clearFormat}\n\n"
successFormat="\n${green}%s${clearFormat}\n\n"


printf "${headerFormat}" "Configuring build environment"
export BUILD_HOME=`pwd` \
         && printf "${messageFormat}" "Created \${BUILD_HOME} at ${BUILD_HOME}"
mkdir -p bin \
         && export BUILD_BIN=${BUILD_HOME}/bin \
         && printf "${messageFormat}" "Created \${BUILD_BIN} at ${BUILD_BIN}"
mkdir -p assets \
         && export BUILD_ASSETS=${BUILD_HOME}/assets \
         && printf "${messageFormat}" "Created \${BUILD_ASSETS} at ${BUILD_ASSETS}"
mkdir -p release \
         && export BUILD_RELEASE=${BUILD_HOME}/release \
         && printf "${messageFormat}" "Created \${BUILD_RELEASE} at ${BUILD_RELEASE}"








printf "${headerFormat}" "Building binaries"
mkdir build
cd build 
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchains/iOS.cmake -DIOS_PLATFORM=SIMULATOR -G Xcode ..

##printf "${headerFormat}" "Building debug binary"
##xcodebuild


printf "${headerFormat}" "Building release binary"

cp ${BUILD_HOME}/.Purity-Engine.xcscheme .

##printf "${messageFormat}" "Checking Ruby"
##rvm get head
##rvm reload
##rvm repair all
##source ~/.rvm/scripts/rvm
##type rvm | head -n 1
##rvm install ruby-1.9.3-p547
##rvm use 1.9.3
##ruby -v

##printf "${messageFormat}" "Checking versions"
##gem -v

##printf "${messageFormat}" "Building scheme"
##sudo gem install xcodeproj
##sudo ruby ${BUILD_HOME}/.generatescheme.rb
##xcodebuild -list

# Build archive
printf "${messageFormat}" "Building archive"
xcodebuild archive \
         -scheme Purity-Engine \
         CODE_SIGN_IDENTITY="" \
         CODE_SIGNING_REQUIRED=NO \
         -archivePath Purity-Engine.xcarchive
# Export it to an IPA

printf "${messageFormat}" "Creating package"
xcodebuild \
         -exportArchive \
         -exportFormat ipa \
         -archivePath Purity-Engine.xcarchive \
         -exportPath Purity-Engine.ipa \
         CODE_SIGN_IDENTITY="" \
         CODE_SIGNING_REQUIRED=NO \
         -alltargets \
         -configuration Release



printf "${headerFormat}" "Tests"
printf "${messageFormat}" "Contents of `pwd`"
pwd
ls -A
printf "${messageFormat}" "Contents of ${BUILD_HOME}"
cd ${BUILD_HOME}
pwd
ls -A
printf "${messageFormat}" "Contents of ${BUILD_BIN}"
cd ${BUILD_BIN}
pwd
ls -A
printf "${messageFormat}" "Contents of ${BUILD_BIN}/Debug"
cd ${BUILD_BIN}/Debug
pwd
ls -A










##printf "${headerFormat}" "Building debug package"
##cd ${BUILD_BIN}
##mkdir purity2d-build-debug
##cp -R Debug/* purity2d-build-debug/
##cp -R ${BUILD_ASSETS}/* purity2d-build-debug/Purity-Engine.app
##cd purity2d-build-debug
##zip --recurse-paths ../purity2d-build-debug.zip Purity-Engine.app


printf "${headerFormat}" "Gathering final release files"
cd ${BUILD_BIN}
printf "${messageFormat}" "Contents of ${BUILD_BIN}"
ls -a
printf "${messageFormat}" "Exporting release files"
cp *.zip ${BUILD_RELEASE} \
         && printf "${messageFormat}" "Copied release files to ${BUILD_RELEASE}"


printf "${headerFormat}" "Available releases:"
cd ${BUILD_RELEASE}
ls -1
#ls | cat




