# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: struena android ios struena-cross swarm evm all test clean
.PHONY: struena-linux struena-linux-386 struena-linux-amd64 struena-linux-mips64 struena-linux-mips64le
.PHONY: struena-linux-arm struena-linux-arm-5 struena-linux-arm-6 struena-linux-arm-7 struena-linux-arm64
.PHONY: struena-darwin struena-darwin-386 struena-darwin-amd64
.PHONY: struena-windows struena-windows-386 struena-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

struena:
	build/env.sh go run build/ci.go install ./cmd/struena
	@echo "Done building."
	@echo "Run \"$(GOBIN)/struena\" to launch struena."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/struena.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Struena.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

struena-cross: struena-linux struena-darwin struena-windows struena-android struena-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/struena-*

struena-linux: struena-linux-386 struena-linux-amd64 struena-linux-arm struena-linux-mips64 struena-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-*

struena-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/struena
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep 386

struena-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/struena
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep amd64

struena-linux-arm: struena-linux-arm-5 struena-linux-arm-6 struena-linux-arm-7 struena-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep arm

struena-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/struena
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep arm-5

struena-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/struena
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep arm-6

struena-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/struena
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep arm-7

struena-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/struena
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep arm64

struena-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/struena
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep mips

struena-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/struena
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep mipsle

struena-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/struena
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep mips64

struena-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/struena
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/struena-linux-* | grep mips64le

struena-darwin: struena-darwin-386 struena-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/struena-darwin-*

struena-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/struena
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/struena-darwin-* | grep 386

struena-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/struena
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/struena-darwin-* | grep amd64

struena-windows: struena-windows-386 struena-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/struena-windows-*

struena-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/struena
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/struena-windows-* | grep 386

struena-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/struena
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/struena-windows-* | grep amd64
