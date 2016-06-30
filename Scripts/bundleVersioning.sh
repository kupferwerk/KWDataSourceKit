#!/bin/bash

bundle_version=$(git rev-list HEAD --count)
release_version=$(git describe --tags --always --abbrev=0)
target_plist="$TARGET_BUILD_DIR/$INFOPLIST_PATH"

echo "Updating framework version to ${release_version}(${bundle_version})…"

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundle_version" "$target_plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${release_version#*v}" "$target_plist"
