.PHONY: build clean

BLADE_SRC_ROOT=$(shell pwd)

GO_ENV=CGO_ENABLED=1
GO_MODULE=GO111MODULE=on
GO=env $(GO_ENV) $(GO_MODULE) go

$(info ============= $(GO_ENV) =================)
$(info ============= $(GO_MODULE) =================)
$(info ============= $(GO) =================)

UNAME := $(shell uname)

ifeq ($(BLADE_VERSION), )
	BLADE_VERSION=1.5.0
endif

BUILD_TARGET=target
BUILD_TARGET_DIR_NAME=chaosblade-$(BLADE_VERSION)
BUILD_TARGET_PKG_DIR=$(BUILD_TARGET)/chaosblade-$(BLADE_VERSION)
BUILD_TARGET_YAML=$(BUILD_TARGET_PKG_DIR)/yaml
BUILD_IMAGE_PATH=build/image/blade

OS_YAML_FILE_NAME=chaosblade-docker-spec-$(BLADE_VERSION).yaml
OS_YAML_FILE_PATH=$(BUILD_TARGET_YAML)/$(OS_YAML_FILE_NAME)

JVM_YAML_PATH=/Users/liqixin/Documents/codeup/chaosblade/chaosblade-exec-jvm/build-target/chaosblade-$(BLADE_VERSION)/yaml/chaosblade-jvm-spec-$(BLADE_VERSION).yaml


ifeq ($(GOOS), linux)
	GO_FLAGS=-ldflags="-linkmode external -extldflags -static"
endif

build: pre_build build_yaml

build_linux: build

pre_build:
	rm -rf $(BUILD_TARGET_PKG_DIR)
# 提前将target所涉及的目录都创建好
	mkdir -p $(BUILD_TARGET_YAML)

build_yaml: build/spec.go
	@echo "build_yaml"
# 还原语句则是 env CGO_ENABLED=1 GO111MODULE=on go run build/spec.go target/chaosblade-1.5.0/yaml/chaosblade-docker-spec-1.5.0.yaml
# build/spec.go 被替换到了 $<
	$(GO) run $< $(OS_YAML_FILE_PATH) $(JVM_YAML_PATH)

# test
test:
	go test -race -coverprofile=coverage.txt -covermode=atomic ./...
# clean all build result
clean:
	go clean ./...
	rm -rf $(BUILD_TARGET)
	rm -rf $(BUILD_IMAGE_PATH)/$(BUILD_TARGET_DIR_NAME)
