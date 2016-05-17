cmake_minimum_required (VERSION 3.3.2)

project(your_project)

include(BundleUtilities)

set(CODESIGNIDENTITY "iPhone Developer")
set(DEPLOYMENT_TARGET 8.0)

macro(set_xcode_property TARGET XCODE_PROPERTY XCODE_VALUE)
  set_property(TARGET ${TARGET} PROPERTY XCODE_ATTRIBUTE_${XCODE_PROPERTY} ${XCODE_VALUE})
endmacro(set_xcode_property)

MACRO(COPY_TO_BUNDLE resourcePath bundlePath)
    LIST(APPEND BUNDLE_COPY_RESOURCES ${resourcePath})
    SET_SOURCE_FILES_PROPERTIES(${resourcePath} PROPERTIES MACOSX_PACKAGE_LOCATION ${bundlePath})
ENDMACRO(COPY_TO_BUNDLE)

set(APP_NAME "YOURAPP")
set(PRODUCT_NAME ${APP_NAME})
set(EXECUTABLE_NAME ${APP_NAME})
set(MACOSX_BUNDLE_EXECUTABLE_NAME ${APP_NAME})
set(MACOSX_BUNDLE_INFO_STRING "com.paltalk.paltalkvideo")
set(MACOSX_BUNDLE_GUI_IDENTIFIER "com.paltalk.paltalkvideo")
set(MACOSX_BUNDLE_BUNDLE_NAME "com.paltalk.paltalkvideo")
set(MACOSX_BUNDLE_ICON_FILE "")
set(MACOSX_BUNDLE_LONG_VERSION_STRING "1.0")
set(MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0")
set(MACOSX_BUNDLE_BUNDLE_VERSION "1.0")
set(MACOSX_BUNDLE_COPYRIGHT "Copyright YOU")
set(MACOSX_DEPLOYMENT_TARGET "8.0")

set(APP_HEADER_FILES
  ./AppDelegate.h
  ./ViewController.h
  ./Prefix.pch
)

set(APP_SOURCE_FILES
  ./AppDelegate.m
  ./ViewController.m
  ./main.m
)

set(RESOURCES
  ./Main.storyboard
  ./LaunchScreen.storyboard
)


MESSAGE(STATUS ${PROJECT_SOURCE_DIR})
MESSAGE(STATUS ${APP_SOURCE_FILES})

add_executable(
    ${APP_NAME}
    MACOSX_BUNDLE
    ${APP_HEADER_FILES}
    ${APP_SOURCE_FILES}
    ${RESOURCES}
)

# set_target_properties(${APP_NAME} PROPERTIES XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")

# target_link_libraries(${APP_NAME} 
  # ${PROJECT_SOURCE_DIR}/Torch.framework
# )

# target_include_directories(${APP_NAME}
  # PUBLIC ${PROJECT_SOURCE_DIR}/Torch.framework/Headers
# )

# target_link_libraries(${APP_NAME} 
#   ${PROJECT_SOURCE_DIR}/framework/lib/libtorch.a
# )

# target_include_directories(${APP_NAME}
#   PUBLIC ${PROJECT_SOURCE_DIR}/framework/include
# )

find_library(UIKIT UIKit)
find_library(FOUNDATION Foundation)
find_library(COREGRAPHICS CoreGraphics)
find_library(MOBILECORESERVICES MobileCoreServices)
find_library(CFNETWORK CFNetwork)
find_library(SYSTEMCONFIGURATION SystemConfiguration)
find_library(SECURITY Security)
find_library(AVFOUNDATION AVFoundation)
find_library(AUDIOTOOLBOX AudioToolbox)
find_library(ACCELERATE Accelerate)
target_link_libraries(${APP_NAME} ${UIKIT})
target_link_libraries(${APP_NAME} ${FOUNDATION})
target_link_libraries(${APP_NAME} ${COREGRAPHICS})
target_link_libraries(${APP_NAME} ${MOBILECORESERVICES})
target_link_libraries(${APP_NAME} ${CFNETWORK})
target_link_libraries(${APP_NAME} ${SYSTEMCONFIGURATION})
target_link_libraries(${APP_NAME} ${SECURITY})
target_link_libraries(${APP_NAME} ${AVFOUNDATION})
target_link_libraries(${APP_NAME} ${AUDIOTOOLBOX})
target_link_libraries(${APP_NAME} libicucore.dylib)
target_link_libraries(${APP_NAME} c++)
target_link_libraries(${APP_NAME} ${ACCELERATE})

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fobjc-arc -stdlib=libstdc++ -isysroot ${CMAKE_OSX_SYSROOT}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fobjc-arc -stdlib=libstdc++ -isysroot ${CMAKE_OSX_SYSROOT}")

set_target_properties(${APP_NAME} PROPERTIES
                      XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "dwarf-with-dsym"
                      XCODE_ATTRIBUTE_GCC_PREFIX_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/Prefix.pch"
                      RESOURCE "${RESOURCES}"
                      XCODE_ATTRIBUTE_GCC_PRECOMPILE_PREFIX_HEADER "YES"
                      XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
                      XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${CODESIGNIDENTITY}
                      MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/plist.in
                      XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1"
                      XCODE_ATTRIBUTE_CLANG_ENABLE_OBJC_ARC YES
                      XCODE_ATTRIBUTE_COMBINE_HIDPI_IMAGES "NO")

