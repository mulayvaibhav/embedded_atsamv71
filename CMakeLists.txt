cmake_minimum_required(VERSION 3.16)

##### Prevent compiler test #####
set(CMAKE_C_COMPILER_WORKS 1)

##### Project configuration ######
project(atsamv71 DESCRIPTION "Debug Software" LANGUAGES C)

##### Additional files used hereafter #####
set(CMAKE_FILES_PATH ${CMAKE_CURRENT_SOURCE_DIR}/CMake)

##### Enable the generation of compile_commands.json #####
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

##### Software version ######
set(SRC_PATH ${CMAKE_CURRENT_SOURCE_DIR})

##### ATSAMV71 path ######
set(ATSAMV71_PATH ${SRC_PATH}/Platform/atsamv71)

##### Linker Script Path ######
set(LINKER_PATH ${ATSAMV71_PATH}/Linker)

##### Optional configuration values #####
set(HW_CONFIG "DefaultConfig" CACHE STRING "Hardware config name")
set(HW_TYPE "DefaultType" CACHE STRING "Hardware type")

##### Sources to compile ######
set(LINKER_SCRIPT ${LINKER_PATH}/samv71q21_flash.ld)



set(OS_SRC
    ${SRC_PATH}/Platform/atsamv71/OS/RegMicro.c
    ${SRC_PATH}/Platform/atsamv71/OS/startup_vector.c
)

set(MAIN_SRC
    ${SRC_PATH}/main.c
    ${SRC_PATH}/syscalls.c
)

set(SOURCES
    ${OS_SRC}
    ${MAIN_SRC}
)

set(INCLUDES
    ${ATSAMV71_PATH}/SAMV71/ATSAMV71Q21B_DFP
    ${ATSAMV71_PATH}/SAMV71/ATSAMV71Q21B_DFP/component
    ${ATSAMV71_PATH}/SAMV71/ATSAMV71Q21B_DFP/instance
    ${ATSAMV71_PATH}/SAMV71/ATSAMV71Q21B_DFP/pio
    ${ATSAMV71_PATH}/SAMV71/CMSIS/CMSIS/Core/Include
    ${ATSAMV71_PATH}/OS
)

add_executable(${PROJECT_NAME}.elf ${SOURCES})
target_include_directories(${PROJECT_NAME}.elf PRIVATE ${INCLUDES})

# Use generator expressions for debug/release flags
target_compile_options(${PROJECT_NAME}.elf PRIVATE
    $<$<CONFIG:Debug>:-DDEBUG>
    $<$<CONFIG:Release>:-Werror>
    -mcpu=cortex-m7
    -mthumb
    -ffunction-sections
    -mlong-calls
    -Wall
    -MP
    -MMD
    -std=c99
    -mfloat-abi=hard
    -mfpu=fpv5-sp-d16
    -g3
)

target_compile_definitions(${PROJECT_NAME}.elf PRIVATE
    __SAMV71Q21B__
    HW_CONFIG=${HW_CONFIG}
    ${HW_TYPE}
    BUILD_TYPE=${CMAKE_BUILD_TYPE}
)

target_link_options(${PROJECT_NAME}.elf PRIVATE
    -mcpu=cortex-m7
    -T${LINKER_SCRIPT}
    -mthumb
    --specs=nano.specs
    --specs=nosys.specs
    -Wl,-Map=${PROJECT_NAME}.map
    -Wl,--gc-sections
    -mfloat-abi=hard
    -mfpu=fpv5-sp-d16
)

set_target_properties(${PROJECT_NAME}.elf PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT})

# Output name cleanup
#set_target_properties(${PROJECT_NAME}.elf PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
