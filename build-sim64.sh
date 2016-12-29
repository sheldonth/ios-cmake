cmake -DCMAKE_TOOLCHAIN_FILE=./ios.cmake -DIOS_PLATFORM=SIMULATOR64 -H. -Bbuild.sim64 -GXcode
cmake --build build.sim64/ --config Release
