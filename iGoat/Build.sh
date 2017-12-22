#!/bin/sh

if [[ "$1" == "" ]]; then
    echo "Error! Usage:"
    echo "\t./Build/sh <OBFUSCATIONKEY>"
    exit 1
fi

export DerivedDataPath=DerivedData
export StringObfuscationKey=$1
declare iGoatBinary=''


############################################################################
# Revert Changes
############################################################################
function GitReset()
{
	git reset --hard HEAD
}

############################################################################
# Performs strings obfuscation using objc-obfuscator
############################################################################
function ObfuscateStrings()
{
    LINE="#define OBFUSCATIONKEY @\"$StringObfuscationKey\""
    sed -i -e "s/#define OBFUSCATIONKEY.*/$LINE/" iGoat/iGoat-Prefix.pch
    echo ObfuscationKey=\"$StringObfuscationKey\"
	./ThirdPartyTools/obfuscator-objc/objc-obfuscator obfuscate "$StringObfuscationKey" "iGoat/String Analysis/StringAnalysisExerciseController.m"
}

############################################################################
# Builds the iGoat app
############################################################################
function BuildIgoat()
{
	xcodebuild -workspace iGoat.xcworkspace\
		-scheme iGoat\
        -configuration Release\
        -sdk iphoneos\
        -derivedDataPath $DerivedDataPath\
        CODE_SIGNING_REQUIRED=NO\
        CODE_SIGN_IDENTITY=""\
        ENABLE_BITCODE=NO\
        GCC_PREPROCESSOR_DEFINITIONS="OBFUSCATED=1"\
        clean build

    ExpectedFile=$DerivedDataPath/Build/Products/Release-iphoneos/iGoat.app/iGoat

     if [[ -f "$ExpectedFile" ]]; then
     	echo "SUCCESS FILE EXIST FOR: $ExpectedFile"
 	    iGoatBinary=$ExpectedFile
     else
     	echo "ERROR FILE DOES NOT EXIST: $ExpectedFile "
     	exit
     fi
}

############################################################################
# Perform the class renaming by invoking the scheme Build_Analyze_Rename
# We optimize the process by building only using simulator; debug; and not 
# all the architecture 
############################################################################
function ObfuscateClasses()
{
		xcodebuild -workspace iGoat.xcworkspace\
		-scheme Build_Analyze_Rename\
        -derivedDataPath $DerivedDataPath\
        -sdk iphonesimulator\
        -configuration=Debug\
		ONLY_ACTIVE_ARCH=YES\
        clean build
}


############################################################################
# Builds the obfuscated iGoat app in xcarchive format
############################################################################
function BuildArchive()
{
	ARCHIVEPATH=$PWD/iGoat.xcarchive

	xcodebuild -workspace iGoat.xcworkspace\
		-scheme iGoat\
        -configuration Release\
        -sdk iphoneos\
        -derivedDataPath $DerivedDataPath\
        -archivePath "$ARCHIVEPATH"\
        CODE_SIGNING_REQUIRED=NO\
        CODE_SIGN_IDENTITY=""\
        ENABLE_BITCODE=NO\
        GCC_PREPROCESSOR_DEFINITIONS="OBFUSCATED=1"\
        clean archive | xcpretty

     if [[ $?==0 ]]; then
     	echo "BUILDING ARCHIVE SUCCESSFUL"
     	echo "****************************************************************************"
     	echo Archive at $ARCHIVEPATH
     	echo "****************************************************************************"
     else
     	echo "BUILDING ARCHIVE FAILED"
     fi
}

GitReset
ObfuscateStrings
ObfuscateClasses
BuildArchive
