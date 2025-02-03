# cpp-hello-docker

*minimal rapberry pi compatible cross-compiled c++ docker image toy project*

This is a minimal c++ project with the sole purpose of creating an trivial cross-compiled, raspberry pi compatible docker image for the ARM architecture.

The primary goal of this project is for its author (me) to familiarize themselves with c++ cross compilation as well as targeting foreign architectures with docker. In addition I'm contrasting the `make` and `cmake` build tools.

# Prerequisites

✅ Ensure you have the ARM cross compilation toolchain installed
```bash
sudo apt update
sudo apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
```
✅ Ensure you have docker with buildx installed
✅ The Docker daemon running
✅ Access to the docker registry

🛠 **Note!** Im using my local docker registry, you can override my defaults to any registry of your choise with the `env` variable `LOCAL_DOCKER_REGISTRY`, or by editing the `Makefile` directly.

# Build alternatives

## make

### Compile the binary
```bash
make
```

### build docker image
```
make docker-build
```

### Push the docker Image to a registry
```bash
export LOCAL_DOCKER_REGISTRY="your registry"
make docker-push
```

### Run Container localy
**NOTE!** Since were building a image for the raspberry pi ARM architecture. Running the image might not work on your machine.
```
make docker-run
```

### Clean
```
make clean
```

## CMake

### CMake Build
The easy way
```bash
make cmake-build
```
or the hard way, manually:
```bash
mkdir -p build
cd build
cmake ..
make
cd ..
```
### build docker image
from project home directory:
```
cmake --build build --target docker-build
```

### Push the docker Image to a registry
from project home directory:
```bash
export LOCAL_DOCKER_REGISTRY="your registry"
cmake --build build --target docker-push
```

## manual

### Locally build the cross compiled binary

```bash
cd build
arm-linux-gnueabihf-g++ -Wall -o hello ../src/hello.cpp
```

verify that the architecture is correct with

```bash
file hello
```
 which should yield an output along these lines:

 ```
 hello: ELF 32-bit LSB pie executable, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, BuildID[sha1]=742952364daea3d0b578f08d4eab6c13e8a088dc, for GNU/Linux 3.2.0, not stripped
 ```
Notice that the output should be something like:`ELF 32-bit LSB pie executable, ARM`, **NOT:** `64-bit LSB pie executable, x86-64`

 ### build the docker image

create and use a new buildx image builder for cross-architecture images

 ```bash
docker buildx create --use
```
(you can verify buildx is running with `docker buildx ls`)
```
docker buildx build --platform linux/arm/v7 -t registry.birdo.local/hello-cpp --push .
```

# Conclusion
With the help of chatGPT and copilot:
- c++ cross-compilation 
- docker image cross-building
- make nad cmake setup

...turned out to not be too challenging, which might be expected for such an trivial project. My biggest issues were overwhelmingly the setup of my local network and the various support services and development enviornments required to get my infrastructure in order.

For a small project like this, and my limited experience `make` feels like a much friendlier build tool. Allthough I can se the appeal of `cmake` in a vastly more extensive project, particularly if multiple build targets need to be supported.

# future work
- Investigate if current build dependencies can be removed almost entirely by using an docker image with the build toolchain preincluded.
- investigate multi-stage docker image build processes