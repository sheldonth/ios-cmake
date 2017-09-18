cmake_minimum_required (VERSION 3.7)

set(DEVELOPMENT_PROJECT_NAME "project")                     # <== Set to your project name, e.g. project.xcodeproj
set(DEVELOPMENT_TEAM_ID "AAAAAAAAAA")                       # <== Set to your team ID from Apple
set(APP_NAME "YOURAPP")                                     # <== Set To your app's name
set(APP_BUNDLE_IDENTIFIER "com.company.app")                # <== Set to your app's bundle identifier
set(FRAMEWORK_NAME "FooBar")                                # <== Set to your framework's name
set(FRAMEWORK_BUNDLE_IDENTIFIER "com.company.framework")    # <== Set to your framework's bundle ID
set(TEST_NAME "Tests")                                      # <== Set to your test's name
set(TEST_BUNDLE_IDENTIFIER "com.company.tests")             # <== Set to your tests's bundle ID
set(CODE_SIGN_IDENTITY "iPhone Developer")                  # <== Set to your preferred code sign identity, to see list:
                                                            # /usr/bin/env xcrun security find-identity -v -p codesigning
set(DEPLOYMENT_TARGET 8.0)                                  # <== Set your deployment target version of iOS
set(DEVICE_FAMILY "1")                                      # <== Set to "1" to target iPhone, set to "2" to target iPad, set to "1,2" to target both
set(LOGIC_ONLY_TESTS 0)                                     # <== Set to 1 if you do not want tests to be hosted by the application, speeds up pure logic tests but you can not run them on real devices

project(${DEVELOPMENT_PROJECT_NAME})
include(BundleUtilities)
include(FindXCTest)

set(PRODUCT_NAME ${APP_NAME})
set(EXECUTABLE_NAME ${APP_NAME})
set(MACOSX_BUNDLE_EXECUTABLE_NAME ${APP_NAME})
set(MACOSX_BUNDLE_INFO_STRING ${APP_BUNDLE_IDENTIFIER})
set(MACOSX_BUNDLE_GUI_IDENTIFIER ${APP_BUNDLE_IDENTIFIER})
set(MACOSX_BUNDLE_BUNDLE_NAME ${APP_BUNDLE_IDENTIFIER})
set(MACOSX_BUNDLE_ICON_FILE "")
set(MACOSX_BUNDLE_LONG_VERSION_STRING "1.0")
set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
set(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
set(MACOSX_BUNDLE_COPYRIGHT "Copyright YOU")
set(MACOSX_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET})

set(APP_HEADER_FILES
  ./AppDelegate.h
  ./ViewController.h
  ./CppInterface.h
  ./Prefix.pch
)

set(APP_SOURCE_FILES
  ./AppDelegate.m
  ./ViewController.m
  ./CppInterface.mm
  ./main.m
)

set(RESOURCES
  ./Main.storyboard
  ./LaunchScreen.storyboard
)

add_executable(
    ${APP_NAME}
    MACOSX_BUNDLE
    ${APP_HEADER_FILES}
    ${APP_SOURCE_FILES}
    ${RESOURCES}
)

# To disable bitcode:
# set_target_properties(${APP_NAME} PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")

# To link a statically linked Framework from the filesystem:
# Note: dynamic frameworks require copying to the app bundle. Statically linked are copied into the executable itself.
# target_link_libraries(${APP_NAME} 
  # ${PROJECT_SOURCE_DIR}/Torch.framework
# )


# Include the same headers for the statically linked framework:
# Include headers to they're available as #import <Header/Header.h> from a framework
# target_include_directories(${APP_NAME}
  # PUBLIC ${PROJECT_SOURCE_DIR}/Torch.framework/Headers
# )


# Static Link a library archive into the executable
# target_link_libraries(${APP_NAME} 
#   ${PROJECT_SOURCE_DIR}/framework/lib/libtorch.a
# )


# Include a source directory outside a framework
# target_include_directories(${APP_NAME}
#   PUBLIC ${PROJECT_SOURCE_DIR}/framework/include
# )

# Build the C++ dynamically linked framework
add_subdirectory(cppframework)
add_dependencies(${APP_NAME} ${FRAMEWORK_NAME})

# Build tests
add_subdirectory(tests)

# Locate system libraries on iOS
find_library(UIKIT UIKit)
find_library(FOUNDATION Foundation)
find_library(MOBILECORESERVICES MobileCoreServices)
find_library(CFNETWORK CFNetwork)
find_library(SYSTEMCONFIGURATION SystemConfiguration)

# link the frameworks located above
target_link_libraries(${APP_NAME} ${UIKIT})
target_link_libraries(${APP_NAME} ${FOUNDATION})
target_link_libraries(${APP_NAME} ${MOBILECORESERVICES})
target_link_libraries(${APP_NAME} ${CFNETWORK})
target_link_libraries(${APP_NAME} ${SYSTEMCONFIGURATION})

# Link the framework to the app
set_target_properties(${APP_NAME} PROPERTIES
                      XCODE_ATTRIBUTE_OTHER_LDFLAGS "${XCODE_ATTRIBUTE_OTHER_LDFLAGS} -framework ${FRAMEWORK_NAME}"
)

# Turn on ARC
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc")

# Create the app target
set_target_properties(${APP_NAME} PROPERTIES
                      XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
                      XCODE_ATTRIBUTE_GCC_PREFIX_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/Prefix.pch"
                      RESOURCE "${RESOURCES}"
                      XCODE_ATTRIBUTE_GCC_PRECOMPILE_PREFIX_HEADER "YES"
                      XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
                      XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${CODE_SIGN_IDENTITY}
                      XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
                      XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
                      MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/plist.in
                      XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
                      XCODE_ATTRIBUTE_COMBINE_HIDPI_IMAGES NO
                      XCODE_ATTRIBUTE_INSTALL_PATH "$(LOCAL_APPS_DIR)"
                      XCODE_ATTRIBUTE_ENABLE_TESTABILITY YES
                      XCODE_ATTRIBUTE_GCC_SYMBOLS_PRIVATE_EXTERN YES
)

# Include framework headers, needed to make "Build" Xcode action work.
# "Archive" works fine just relying on default search paths as it has different
# build product output directory.
target_include_directories(${APP_NAME} PUBLIC 
    "${PROJECT_BINARY_DIR}/cppframework/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/${FRAMEWORK_NAME}.framework"
)

# Set the app's linker search path to the default location on iOS
set_target_properties(
    ${APP_NAME}
    PROPERTIES
    XCODE_ATTRIBUTE_LD_RUNPATH_SEARCH_PATHS
    "@executable_path/Frameworks"
)

# Note that commands below are indented just for readability. They will endup as
# one liners after processing and unescaped ; will disappear so \; are needed.
# First condition in each command is for normal build, second for archive.
# \&\>/dev/null makes sure that failure of one command and success of other
# is not printed and does not make Xcode complain that /bin/sh failed and build
# continued.

# Create Frameworks directory in app bundle
add_custom_command(
    TARGET
    ${APP_NAME}
    POST_BUILD COMMAND /bin/sh -c
    \"COMMAND_DONE=0 \;
    if ${CMAKE_COMMAND} -E make_directory
        ${PROJECT_BINARY_DIR}/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/${APP_NAME}.app/Frameworks
        \&\>/dev/null \; then
        COMMAND_DONE=1 \;
    fi \;
    if ${CMAKE_COMMAND} -E make_directory
        \${BUILT_PRODUCTS_DIR}/${APP_NAME}.app/Frameworks
        \&\>/dev/null \; then
        COMMAND_DONE=1 \;
    fi \;
    if [ \\$$COMMAND_DONE -eq 0 ] \; then
        echo Failed to create Frameworks directory in app bundle \;
        exit 1 \;
    fi\"
)

# Copy the framework into the app bundle
add_custom_command(
    TARGET
    ${APP_NAME}
    POST_BUILD COMMAND /bin/sh -c
    \"COMMAND_DONE=0 \;
    if ${CMAKE_COMMAND} -E copy_directory
        ${PROJECT_BINARY_DIR}/cppframework/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/
        ${PROJECT_BINARY_DIR}/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/${APP_NAME}.app/Frameworks
        \&\>/dev/null \; then
        COMMAND_DONE=1 \;
    fi \;
    if ${CMAKE_COMMAND} -E copy_directory
        \${BUILT_PRODUCTS_DIR}/${FRAMEWORK_NAME}.framework
        \${BUILT_PRODUCTS_DIR}/${APP_NAME}.app/Frameworks/${FRAMEWORK_NAME}.framework
        \&\>/dev/null \; then
        COMMAND_DONE=1 \;
    fi \;
    if [ \\$$COMMAND_DONE -eq 0 ] \; then
        echo Failed to copy the framework into the app bundle \;
        exit 1 \;
    fi\"
)

# Codesign the framework in it's new spot
add_custom_command(
    TARGET
    ${APP_NAME}
    POST_BUILD COMMAND /bin/sh -c
    \"COMMAND_DONE=0 \;
    if codesign --force --verbose
        ${PROJECT_BINARY_DIR}/\${CONFIGURATION}\${EFFECTIVE_PLATFORM_NAME}/${APP_NAME}.app/Frameworks/${FRAMEWORK_NAME}.framework
        --sign ${CODE_SIGN_IDENTITY}
        \&\>/dev/null \; then
        COMMAND_DONE=1 \;
    fi \;
    if codesign --force --verbose
        \${BUILT_PRODUCTS_DIR}/${APP_NAME}.app/Frameworks/${FRAMEWORK_NAME}.framework
        --sign ${CODE_SIGN_IDENTITY}
        \&\>/dev/null \; then
        COMMAND_DONE=1 \;
    fi \;
    if [ \\$$COMMAND_DONE -eq 0 ] \; then
        echo Framework codesign failed \;
        exit 1 \;
    fi\"
)
