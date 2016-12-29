# CMake Build Configuration for iOS

This is a blank single-view-controller iOS app and C++ dynamically linked library which use CMake to create an Xcode-friendly out-of-source build system. Instead of configuring the build system through an `.xcodeproj` file, you instead maintain a set of `CMakeLists.txt` files describing the build system.

This CMake project can do everything Xcode can; eg build the executable app & the C++ library in `cppframework`. The app is in Objective-C and the framework in C++. The build systems, generated into `build.ios` `build.sim` `build.sim64` are gitignored. CMakeLists.txt file is the only build configuration kept in source control. This is in contrast to committing the `.xcodeproj` directory which includes the backing XML, which is nonsensically hard to edit by hand.

# To Use:
- Open `CMakeLists.txt`
  - Set lines 3-11 with values for your project
  - NOTE: the build `./build-ios.sh` will fail if you don't have provisioning profiles for the current bundle identifier. It uses the `set(CODESIGNIDENTITY "iPhone Developer")` identity to use the default certificate for the current bundle identifier.
- Requires CMake version 3.7

### Create Xcode project for Devices (armv7, armv7s, arm64)
- Run `build-ios.sh` to generate the build system in `build.ios/`
- Run `open build.ios/project.xcodeproj` to edit in Xcode

### Create Xcode project for Simulator 32-bit (i386)
- Run `build-sim.sh` to build the build system in `build.sim`
- Run `open build.sim/project.xcodeproj` to edit the app in iOS. Only simulator targets on a 32 bit Mac will be present

### Create Xcode project for Simulator 64-bit (x86_64)
- Run `build-sim64.sh` 
- Same as above

### iPhone/iPad
- Currently builds an iPhone-only target. To build an iPhone/iPad target, change the value of `XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY` on line 114 of `CMakeLists.txt` to `"1,2"`
- Feel free to `rm -rf _builds` frequently and at will. It can be regenerated at any time.

### Framework
- Builds a dynamically linked iOS Framework for the architectures relevant to the platform from c++ code in `/cppframework`
- Sets the install name and rpath to the correct values for iOS
- Copies the framework into the build
