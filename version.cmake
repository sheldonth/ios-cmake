
set(DEVELOPMENT_PROJECT_NAME "project")                      # <== Set to your project name, e.g. project.xcodeproj
set(DEVELOPMENT_TEAM_ID "AAAAAAAAAA")                        # <== Set to your team ID from Apple
set(DEVELOPMENT_NAME "Dev")                                  # <== Set to your development company name
set(APP_NAME "YOURAPP")                                      # <== Set To your app's name
set(APP_BUNDLE_IDENTIFIER "com.company.app")                 # <== Set to your app's bundle identifier
set(FRAMEWORK_NAME "framework")                              # <== Set to your framework's name
set(FRAMEWORK_BUNDLE_IDENTIFIER "com.company.framework")     # <== Set to your framework's bundle identifier (cannot be the same as app bundle identifier)
set(TEST_NAME "Tests")                                       # <== Set to your test's name
set(TEST_BUNDLE_IDENTIFIER "com.company.tests")              # <== Set to your tests's bundle ID
set(CODE_SIGN_IDENTITY "iPhone Developer")                   # <== Set to your preferred code sign identity, to see list:
                                                             #         /usr/bin/env xcrun security find-identity -v -p codesigning
set(DEPLOYMENT_TARGET 10.0)                                  # <== Set your deployment target version of iOS
set(DEVICE_FAMILY "1")                                       # <== Set to "1" to target iPhone, set to "2" to target iPad, set to "1,2" to target both
set(LOGIC_ONLY_TESTS 0)                                      # <== Set to 1 if you do not want tests to be hosted by the application, 
                                                             #         speeds up pure logic tests but you can not run them on real devices
