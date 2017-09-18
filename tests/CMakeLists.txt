cmake_minimum_required (VERSION 3.7)

set(TEST_SOURCE
    ${CMAKE_CURRENT_LIST_DIR}/Tests.m
)

xctest_add_bundle(${TEST_NAME}
    ${APP_NAME}
    ${TEST_SOURCE}
)

if(NOT LOGIC_ONLY_TESTS)
    target_include_directories(${TEST_NAME} PUBLIC
        "${CMAKE_SOURCE_DIR}"
    )
endif(NOT LOGIC_ONLY_TESTS)

xctest_add_test(${TEST_BUNDLE_IDENTIFIER}
    ${TEST_NAME}
)

set(CMAKE_SHARED_LINKER_FLAGS "-Wall")

set_target_properties(${TEST_NAME} PROPERTIES
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_LIST_DIR}/tests.plist.in
    XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET ${DEPLOYMENT_TARGET}
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ${CODE_SIGN_IDENTITY}
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ${DEVELOPMENT_TEAM_ID}
    XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY ${DEVICE_FAMILY}
    XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS "\$(inherited)"
)

if(LOGIC_ONLY_TESTS)
    set_target_properties(${TEST_NAME} PROPERTIES
        XCODE_ATTRIBUTE_TEST_HOST ""
    )
endif(LOGIC_ONLY_TESTS)

# This is needed to erase invalid framework search paths set by FindXCTest.
# The drawback is that you can not use target_include_directories for setting up
# search paths for this target. You have to use
# XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS. As long as you stick to running
# tests on code compiled into the host app this is not a hindrance.
set_target_properties(${TEST_NAME} PROPERTIES
    XCODE_ATTRIBUTE_FRAMEWORK_SEARCH_PATHS "\$(inherited) "
)
