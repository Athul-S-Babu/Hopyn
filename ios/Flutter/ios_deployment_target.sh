#!/bin/sh
# Script to update iOS deployment target in xcconfig files

# Path to the xcconfig files
DEBUG_CONFIG="${FLUTTER_APPLICATION_PATH}/ios/Flutter/Debug.xcconfig"
RELEASE_CONFIG="${FLUTTER_APPLICATION_PATH}/ios/Flutter/Release.xcconfig"

# Add or update the IPHONEOS_DEPLOYMENT_TARGET in xcconfig files
update_deployment_target() {
  local config_file="$1"
  
  if [ -f "$config_file" ]; then
    # Check if IPHONEOS_DEPLOYMENT_TARGET exists
    if grep -q "IPHONEOS_DEPLOYMENT_TARGET" "$config_file"; then
      # Update existing target
      sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET=.*/IPHONEOS_DEPLOYMENT_TARGET=14.0/g' "$config_file"
    else
      # Add new target
      echo "IPHONEOS_DEPLOYMENT_TARGET=14.0" >> "$config_file"
    fi
    echo "Updated deployment target in $config_file"
  else
    # Create file with deployment target
    echo "#include \"Generated.xcconfig\"" > "$config_file"
    echo "IPHONEOS_DEPLOYMENT_TARGET=14.0" >> "$config_file"
    echo "Created $config_file with deployment target"
  fi
}

# Update both config files
update_deployment_target "$DEBUG_CONFIG"
update_deployment_target "$RELEASE_CONFIG"

echo "iOS deployment target updated to 14.0"
