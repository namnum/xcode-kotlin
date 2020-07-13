#!/usr/bin/env bash

# Use this script for versions of Xcode other than Xcode 11.

set -o xtrace

###################
# DEFINITIONS
###################

plugins_dir=~/Library/Developer/Xcode/Plug-ins
spec_dir=~/Library/Developer/Xcode/Specifications

###################
# FORGET EXISTING PLUG-IN 
###################

if [ ! -d "$plugins_dir/Kotlin.ideplugin/" ]; then
  echo "Plugins directory and Kotlin plugin found..."
  defaults delete com.apple.dt.Xcode DVTPlugInManagerNonApplePlugIns-Xcode-$(xcodebuild -version | grep Xcode | cut -d ' ' -f 2)
fi

###################
# CREATE PLUG-IN
###################

echo "Creating plugins directory"
mkdir -p $plugins_dir
cp -r Kotlin.ideplugin $plugins_dir

###################
# CREATE SPECS DIR
###################

if [ ! -d "$spec_dir" ]; then
	mkdir $spec_dir
fi

###################
# LLDB DEFINITIONS
###################

lldb_config="command script import ~/Library/Developer/Xcode/Plug-ins/Kotlin.ideplugin/Contents/Resources/konan_lldb_config.py"
lldb_format="command script import ~/Library/Developer/Xcode/Plug-ins/Kotlin.ideplugin/Contents/Resources/konan_lldb.py"

if grep --quiet	-s konan_lldb ~/.lldbinit-Xcode
then
  # code if found
  echo "konan_lldb.py found in ~/.lldbinit-Xcode"
else
  # code if not found
  echo $lldb_config >> ~/.lldbinit-Xcode
  echo $lldb_format >> ~/.lldbinit-Xcode
fi