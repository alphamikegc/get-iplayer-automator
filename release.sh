#!/bin/bash -x

PROJECT_NAME="Get iPlayer Automator"
PROJECT_DIR=$(pwd)
INFOPLIST_FILE="Info.plist"

CFBundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")
CFBundleShortVersionString=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/${INFOPLIST_FILE}")

rm -rf Archive/*
rm -rf Product/*

xcodebuild clean -project "$PROJECT_NAME.xcodeproj" -configuration Release -alltargets

xcodebuild archive -project "$PROJECT_NAME.xcodeproj" -scheme "$PROJECT_NAME" -archivePath "Archive/$PROJECT_NAME.xcarchive"

xcodebuild -exportArchive -archivePath "Archive/$PROJECT_NAME.xcarchive" -exportPath "Product/$PROJECT_NAME" -exportOptionsPlist ExportOptions.plist

cd "Product/${PROJECT_NAME}"
ditto -c -k --keepParent -rsrc "$PROJECT_NAME.app" "../$PROJECT_NAME.v${CFBundleShortVersionString}.b${CFBundleVersion}.zip"
