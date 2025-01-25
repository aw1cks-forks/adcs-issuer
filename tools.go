//go:build tools
// +build tools

package main

// Dev dependencies
import (
	// Used for generating manifests & CRD files
	_ "sigs.k8s.io/controller-tools/cmd/controller-gen"
	// Emulates a k8s control plane
	_ "sigs.k8s.io/controller-runtime/tools/setup-envtest"
	// linter
	_ "github.com/golangci/golangci-lint/cmd/golangci-lint"
	// patch output manifests with `kustomize`
	_ "sigs.k8s.io/kustomize/kustomize/v5"
	// build containers with `ko`
	_ "github.com/google/ko"
)
