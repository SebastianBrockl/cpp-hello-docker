# cpp-hello-docker

*minimal cross-compile rapberry pi compatible docker image toy project*

This is a minimal project with the sole purpose of creating an trivial cross-compiled, raspberry pi compatible docker image for the ARM architecture.

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

# future work
- Investigate if current build dependencies can be removed almost entirely by using an docker image with the build toolchain preincluded.