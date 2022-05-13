#!/bin/bash

# Any copyright is dedicated to the Public Domain.
# http://creativecommons.org/publicdomain/zero/1.0/

shopt -s extdebug
IFS=$'\n\t'

function onFailure() {
  echo "Unhandled script error $1 at ${BASH_SOURCE[0]}:${BASH_LINENO[0]}" >&2
  exit 1
}

# Ensure we start in the right place
dir0="$( cd "$( dirname "$0" )" && pwd )"
repo_root="$(dirname "$dir0")"
apk_dir="$repo_root/android/app/build/outputs/apk"
apk_files="$( find "$apk_dir" -name "*.apk" )"
error=0

for apk in $apk_files; do
  bundle="$( unzip -lqq "$apk" | grep index.android.bundle)"
  if [ -z "$bundle" ]; then
    echo "ERROR: ${apk/${repo_root}\//} is missing index.android.bundle"
    error=1
  else
    echo "OK: ${apk/${repo_root}\//} contains index.android.bundle"
  fi
done

if [ $error -ne 0 ]; then
  exit 1
fi
