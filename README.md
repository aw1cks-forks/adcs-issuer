# ADCS Issuer

![Badge1](https://github.com/djkormo/adcs-issuer/actions/workflows/codeql.yaml/badge.svg) ![Badge2](https://github.com/djkormo/adcs-issuer/actions/workflows/main.yml/badge.svg) ![Badge3](https://github.com/djkormo/adcs-issuer/actions/workflows/helm-chart-releaser.yaml/badge.svg) ![Badge4](https://github.com/djkormo/adcs-issuer/actions/workflows/golangci-lint.yaml/badge.svg)

ADCS Issuer is a [Kubernetes](https://kubernetes.io/) [`cert-manager`](https://cert-manager.io)
[`CertificateRequest`](https://cert-manager.io/docs/concepts/certificaterequest/) controller
that uses [Microsoft Active Directory Certificate Services](https://learn.microsoft.com/en-us/windows-server/identity/ad-cs/active-directory-certificate-services-overview)
to sign certificate requests.

ADCS provides HTTP GUI that can be normally used to request new certificates or see status of existing requests. 
This implementation is simply a HTTP client that interacts with the ADCS server sending appropriately prepared HTTP requests and interpretting the server's HTTP responses
(the approach inspired by [this Python ADCS client](https://github.com/magnuswatn/certsrv)).

It supports NTLM authentication.

## Documentation

The documentation is currently being rewritten. For now, the old documentation is available in the [docs folder](./docs/README.md).

Additionally, documentation is published to [GitHub Pages](https://djkormo.github.io/adcs-issuer/).

## License

This project is licensed under the BSD-3-Clause license - see the [LICENSE](https://github.com/nokia/adcs-issuer/blob/master/LICENSE).
