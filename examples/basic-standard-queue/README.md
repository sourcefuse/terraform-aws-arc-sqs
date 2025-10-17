# Basic Standard SQS Queue Example

Simple standard SQS queue configuration with minimal settings.

## What This Example Creates

- Standard SQS queue with default settings
- Default message retention (4 days)
- SQS-managed encryption
- Proper tagging for resource management

## Usage

```bash
terraform init
terraform plan
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sqs"></a> [sqs](#module\_sqs) | ../.. | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. refarch | `string` | `"arc"` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the SQS queue | `string` | `"basic-standard-queue"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | The URL for the created Amazon SQS queue |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | The name of the SQS queue |
| <a name="output_queue_url"></a> [queue\_url](#output\_queue\_url) | The URL for the created Amazon SQS queue |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
