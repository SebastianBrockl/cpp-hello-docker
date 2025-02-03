# Variables

## LOCAL_DOCKER_REGISTRY : Docker registry where to push the image, read from env or use default
LOCAL_DOCKER_REGISTRY ?= registry.birdo.local

TARGET=hello
BUILD_DIR=build
SRC_DIR=src
PLATFORM=linux/arm/v7
IMAGE_NAME=$(LOCAL_DOCKER_REGISTRY)/hello-cpp

# Cross-Compiler
CXX=arm-linux-gnueabihf-g++
CXXFLAGS=-O2 -Wall

# build the binary
$(BUILD_DIR)/$(TARGET): $(SRC_DIR)/hello.cpp
	mkdir -p $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -o $(BUILD_DIR)/$(TARGET) $(SRC_DIR)/hello.cpp

# Build the Docker image (note buildx is required)
docker-build: $(BUILD_DIR)/$(TARGET)
	docker buildx build --platform $(PLATFORM) -t $(IMAGE_NAME) --load .

# Push the image to the local registry
docker-push: docker-build
	docker push $(IMAGE_NAME)

# Run the Docker image
docker-run: docker-build
	docker run --rm $(IMAGE_NAME)

# Clean build files
clean:
	rm -rf $(BUILD_DIR)

# Phony targets (tells make that they don't produce files)
.PHONY: docker-build docker-push docker-run clean

