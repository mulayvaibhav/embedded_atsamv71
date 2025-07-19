#!/bin/bash

# Get the root directory of your project (where CMakeLists.txt lives)
project_root="$(dirname "$(realpath "$0")")"
build_dir="${project_root}/build"
obj_dir="${build_dir}/obj"

echo "The script is run from: $project_root"

# Clean and recreate build directory
rm -rf "$build_dir"
mkdir -p "$obj_dir"

# Run CMake configure
cmake -S "$project_root" -B "$obj_dir" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_TOOLCHAIN_FILE="$project_root/Platform/toolchain-arm-gcc.cmake" \
    -DHW_CONFIG=MyConfig \
    -DFREEMASTER=OFF

# Build the project
cmake --build "$obj_dir" -j8
