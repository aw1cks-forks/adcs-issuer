PROJECT := github.com/djkormo/adcs-issuer

export KO_DOCKER_REPO := docker.io/djkormo/adcs-issuer

GO ?= go

LOCALBIN ?= bin/

# We use a build tag `tools`, then define all our tool dependencies in `tools.go`
CONTROLLER_GEN := $(GO) run sigs.k8s.io/controller-tools/cmd/controller-gen
ENVTEST := $(GO) run sigs.k8s.io/controller-runtime/tools/setup-envtest
GOLANGCI_LINT := $(GO) run github.com/golangci/golangci-lint/cmd/golangci-lint
KO := $(GO) run github.com/google/ko
KUSTOMIZE := $(go) run ...

KUBECTL ?= kubectl

# ENVTEST_K8S_VERSION refers to the version of kubebuilder assets to be downloaded by envtest binary.
ENVTEST_K8S_VERSION ?= 1.29.0

## Generate WebhookConfiguration, ClusterRole and CustomResourceDefinition objects.
.PHONY: manifests
manifests:
	$(CONTROLLER_GEN) rbac:roleName=manager-role crd webhook paths="./..." output:crd:artifacts:config=config/crd/bases

# The boilerplate text is inserting an Apache license to the generated files contradicting the repo license... TODO: review
.PHONY: generate
generate:
	$(CONTROLLER_GEN) object:headerFile="hack/boilerplate.go.txt" paths="./..."

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: vet
vet:
	go vet ./...

issuers/testdata/ca:
	@./scripts/generate-certs.sh

.PHONY: test
test: manifests generate fmt vet issuers/testdata/ca
	export KUBEBUILDER_ASSETS=$(shell $(ENVTEST) use $(ENVTEST_K8S_VERSION) --bin-dir $(LOCALBIN) -p path)
	go test ./... -coverprofile cover.out

.PHONY: lint
lint:
	$(GOLANGCI_LINT) run

.PHONY: lint-fix
lint-fix:
	$(GOLANGCI_LINT) run --fix

.PHONY: build
build: bin/manager

# There used to be LDFLAGS to add some build info, e.g. commit, timestamp, etc.
# goreleaser will do this for CI builds; local builds are for dev only.
bin/manager: manifests generate fmt vet
	CGO_ENABLED='0' go build \
	-ldflags '-s -w -X $(PROJECT)/version.Release=DEV-SNAPSHOT' \
	-o 'bin/manager' \
	./main.go

# This will load to local docker/podman daemon
.PHONY: docker-local
docker-local:
	$(KO) build --bare -L --tags latest .

.PHONY: build-installer
build-installer: manifests generate
	@mkdir -pv dist
	[ -d 'config/crd' ] && $(KUSTOMIZE) build config/crd > dist/install.yaml
	echo '---' >> dist/install.yaml
	(cd 'config/manager' && $(KUSTOMIZE) edit set image controller=$(IMG))
	$(KUSTOMIZE) build config/default >> dist/install.yaml

ignore-not-found ?= false

.PHONY: install
install:
	$(KUBECTL) apply -k config/crd

.PHONY: uninstall
	$(KUBECTL) delete --ignore-not-found=$(ignore-not-found) -k config/crd


.PHONY: deploy
deploy: manifests
	(cd config/manager && $(KUSTOMIZE) edit set image controller=$(IMG))
	$(KUBECTL) apply -k config/default

.PHONY: undeploy
undeploy: kustomize
	$(KUBECTL) delete --ignore-not-found=$(ignore-not-found) -k config/default
