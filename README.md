## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| archive | n/a |
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [archive_file](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) |
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_cloudwatch_log_subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) |
| [aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) |
| [aws_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_loggroup\_name | n/a | `string` | n/a | yes |
| cloudwatch\_loggroup\_retention | n/a | `string` | `30` | no |
| cwl\_endpoint | n/a | `string` | `"logs.eu-west-1.amazonaws.com"` | no |
| environment | n/a | `string` | n/a | yes |
| es\_endpoint | n/a | `string` | n/a | yes |
| name | n/a | `string` | n/a | yes |
| project | n/a | `string` | n/a | yes |
| subnets | n/a | `list(string)` | n/a | yes |
| tf\_environment | n/a | `string` | n/a | yes |
| vpc\_id | n/a | `string` | n/a | yes |

## Outputs

No output.
