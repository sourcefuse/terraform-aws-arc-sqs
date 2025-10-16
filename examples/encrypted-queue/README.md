# Encrypted Queue Example

Configuration for an SQS queue with customer-managed KMS encryption for sensitive data.

## What This Example Creates

- SQS queue with customer-managed KMS encryption
- Dedicated KMS key with automatic rotation
- Dead Letter Queue (also encrypted)
- Enhanced security for sensitive workloads
- Proper tagging for resource management

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Security Features

- **Customer-Managed KMS**: Full control over encryption keys
- **Automatic Key Rotation**: Enhanced security with annual key rotation
- **Encrypted DLQ**: Dead Letter Queue also uses KMS encryption
- **30-Day Deletion Window**: KMS key protection against accidental deletion

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
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the encrypted SQS queue | `string` | `"encrypted-sensitive-data-queue"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | The ARN of the DLQ |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the KMS key |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS queue |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | The URL for the created Amazon SQS queue |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
