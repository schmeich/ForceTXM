#!/bin/sh
set -eux
xcrun --sdk iphoneos clang \
  -arch arm64 \
  -miphoneos-version-min=15.0 \
  -dynamiclib \
  -Os \
  -fvisibility=hidden \
  ForceTXM.c \
  -Wl,-install_name,@rpath/ForceTXM.dylib \
  -o ForceTXM.dylib
