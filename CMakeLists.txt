cmake_minimum_required(VERSION 3.10)
project(cpp-hello-docker)

# Detect environment variable, otherwise use default
if(DEFINED ENV{LOCAL_DOCKER_REGISTRY})
    set(LOCAL_DOCKER_REGISTRY "$ENV{LOCAL_DOCKER_REGISTRY}")
else()
    set(LOCAL_DOCKER_REGISTRY "registry.birdo.local")
endif()

# Define the full image name
set(DOCKER_IMAGE "${LOCAL_DOCKER_REGISTRY}/hello-world")

# Set cross-compiler for ARM (only if cross-compiling)
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
    set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)
endif()

# Set output directory
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Add executable
add_executable(hello src/hello.cpp)

# Ensure Docker commands run from the correct directory (project root)
get_filename_component(PROJECT_ROOT ${CMAKE_SOURCE_DIR} ABSOLUTE)

# Custom command to build Docker image
add_custom_target(docker-build
    COMMAND docker buildx build --platform linux/arm/v7 -t ${LOCAL_DOCKER_REGISTRY}/hello-world --load .
    WORKING_DIRECTORY ${PROJECT_ROOT}
    DEPENDS hello
)

# Custom command to push the image
add_custom_target(docker-push
    COMMAND docker push ${LOCAL_DOCKER_REGISTRY}/hello-world
    DEPENDS docker-build
)

# Custom command to run the image
add_custom_target(docker-run
    COMMAND docker run --rm ${LOCAL_DOCKER_REGISTRY}/hello-world
)
