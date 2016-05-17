# CMake Build Configuration for iOS

This is a blank single-view-controller iOS app which uses CMake to create an XCode-friendly out-of-source build system. Instead of maintaining a `.xcodeproj` file, you instead maintain the CMakeLists.txt at the root of this directory to configure the build system for your iOS app.

CMake can do everything XCode can; eg build targets, and dynamic/static libs (armv7, x64-64, etc) but it easier to maintain with source control since the entire configuration is CMake style config code rather than XCode's backing XML.

# To Use:
- Open `CMakeLists.txt`
  - Replace `your_project` on line 3 with your project name
  - Replace`com.yourcompany.yourprovisioning` on lines 23, 24, 25 with your bundle identifier
  - NOTE: the build will fail if you don't have provisioning profiles for that bundle identifier. It uses the `set(CODESIGNIDENTITY "iPhone Developer")` identity to use the default certificate for the bundle identifier.
- Install CMake with `brew install cmake` Requires version 3.3.2 or later.
- You can configure `plist.in` as desired. The defaults will work.

### Create XCode project for Devices (armv7, armv7s, arm64)
- Run `build.sh` to build the build system in `_builds/`
- Run `open _builds/project.xcodeproj` to edit the app in iOS

### Create XCode project for Simulator 32-bit (i386)
- Run `build-sim.sh` to build the build system in `_builds`
- Run `open _builds/project.xcodeproj` to edit the app in iOS. Only simulator targets on a 32 bit Mac will be present

### Create XCode project for Simulator 64-bit (x86_64)
- Run `build-sim64.sh` 
- Same as above

### iPhone/iPad
- Currently builds an iPhone-only target. To build an iPhone/iPad target, change the value of `XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY` on line 114 of `CMakeLists.txt` to `"1,2"`
- Feel free to `rm -rf _builds` frequently and at will. It can be regenerated at any time.
