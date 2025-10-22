# FIFO Queue Example

Configuration for a FIFO (First-In-First-Out) SQS queue with message ordering guarantees and exactly-once processing.

## What This Example Creates

- FIFO queue with strict message ordering
- Content-based deduplication preventing duplicate processing
- High throughput mode with per-message-group limits
- Dead Letter Queue for failed messages
- Proper tagging for resource management

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Key Features

- **Message Ordering**: Messages are processed in the exact order they are sent
- **Deduplication**: Prevents duplicate messages within a 5-minute window
- **High Throughput**: Optimized for high-volume processing with message groups

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
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the FIFO SQS queue (must end with .fifo) | `string` | `"order-processing.fifo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dlq_arn"></a> [dlq\_arn](#output\_dlq\_arn) | The ARN of the SQS dead letter queue |
| <a name="output_dlq_id"></a> [dlq\_id](#output\_dlq\_id) | The URL for the created Amazon SQS dead letter queue |
| <a name="output_dlq_name"></a> [dlq\_name](#output\_dlq\_name) | The name of the SQS dead letter queue |
| <a name="output_queue_arn"></a> [queue\_arn](#output\_queue\_arn) | The ARN of the SQS FIFO queue |
| <a name="output_queue_id"></a> [queue\_id](#output\_queue\_id) | The URL for the created Amazon SQS FIFO queue |
| <a name="output_queue_name"></a> [queue\_name](#output\_queue\_name) | The name of the SQS FIFO queue |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
