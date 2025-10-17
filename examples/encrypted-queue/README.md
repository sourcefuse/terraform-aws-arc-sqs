# Encrypted Queue Example

Configuration demonstrating different encryption options for SQS queues.

## Encryption Options (Priority Order)

This example shows three encryption approaches:

1. **Use Existing KMS Key** (Highest Priority)
   - Provide `kms_key_arn` in terraform.tfvars
   - Uses your organization's existing KMS key

2. **Create New KMS Key** (If no existing key provided)
   - Set `create_kms_key = true` in terraform.tfvars
   - Creates a dedicated KMS key with automatic rotation
   - 30-day deletion window for key recovery

3. **AWS Managed SSE-SQS** (Default)
   - Leave both variables unset (default behavior)
   - Free, automatic encryption provided by AWS
   - Good for non-sensitive workloads

## What This Example Creates

- SQS queue with configurable encryption
- Dead Letter Queue (uses same encryption as main queue)
- Optional: KMS key with automatic rotation (if `create_kms_key = true`)
- Proper tagging for resource management

## Usage

### Default (AWS Managed SSE):
```bash
terraform init
terraform apply
```

### Create New KMS Key:
Edit `terraform.tfvars` and uncomment:
```hcl
create_kms_key = true
```
Then run:
```bash
terraform apply
```

### Use Existing KMS Key:
Edit `terraform.tfvars` and uncomment:
```hcl
kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/your-key-id"
```
Then run:
```bash
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
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Whether to create a new KMS key for encryption. Only used if kms\_key\_arn is not provided | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_kms_deletion_window_days"></a> [kms\_deletion\_window\_days](#input\_kms\_deletion\_window\_days) | KMS key deletion window in days | `number` | `30` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | ARN of existing KMS key to use. If provided, a new KMS key will not be created | `string` | `null` | no |
| <a name="input_kms_rotation_enabled"></a> [kms\_rotation\_enabled](#input\_kms\_rotation\_enabled) | Enable automatic KMS key rotation | `bool` | `true` | no |
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
