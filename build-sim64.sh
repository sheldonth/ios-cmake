cmake -DCMAKE_TOOLCHAIN_FILE=./ios.cmake -DIOS_PLATFORM=SIMULATOR64 -H. -B_builds -GXcode
cmake --build _builds/ --config Release
