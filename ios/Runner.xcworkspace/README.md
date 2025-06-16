# iOS Runner Project

## Deployment Target Updates

This project has been updated to use iOS 14.0 as the minimum deployment target to support Google Maps Flutter plugin requirements.

The following files have been modified:
1. Podfile - Set platform to iOS 14.0
2. AppFrameworkInfo.plist - Updated MinimumOSVersion to 14.0
3. Debug.xcconfig - Added IPHONEOS_DEPLOYMENT_TARGET=14.0
4. Release.xcconfig - Added IPHONEOS_DEPLOYMENT_TARGET=14.0

## Running the App

After making these changes, you'll need to run the following commands:

```bash
cd ios
rm -rf Pods
rm -f Podfile.lock
pod install --repo-update
cd ..
flutter run
```

This will ensure that all dependencies are properly updated with the new iOS version requirements.
