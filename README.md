# terraform-module-template

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)

## Overview

Template Module for Github Repos

## Usage

```hcl
module "terraform-module-template" {
  source = "git::ssh://"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.example](https://registry.terraform.io/providers/hashicorp/null/3.1.1/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mandatory"></a> [mandatory](#input\_mandatory) | this field is mandatory | `string` | n/a | yes |
| <a name="input_optional"></a> [optional](#input\_optional) | this field is optional | `string` | `"default_value"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output_name"></a> [output\_name](#output\_output\_name) | description for output\_name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Development

### Prerequisites

- [terraform](https://learn.hashicorp.com/terraform/getting-started/install#installing-terraform)
- [terraform-docs](https://github.com/segmentio/terraform-docs)
- [pre-commit](https://pre-commit.com/#install)
- [golang](https://golang.org/doc/install#install)
- [golint](https://github.com/golang/lint#installation)

### Configurations

- Configure pre-commit hooks
```sh
pre-commit install
```


- Configure golang deps for tests
```sh
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/stretchr/testify/assert
```



### Tests

- Tests are available in `test` directory

- In the test directory, run the below command
```sh
go test
```



## Authors

This project is authored by below people

- appkins

> This project was generated by [generator-tf-module](https://github.com/sudokar/generator-tf-module)
