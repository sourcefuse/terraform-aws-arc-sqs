# SNS Fanout Queue Example

Configuration demonstrating the pub/sub fanout pattern where an SNS topic distributes messages to multiple SQS queues.

## What This Example Creates

- SNS topic for message distribution
- Primary SQS queue subscribed to SNS topic
- Optional secondary SQS queue (fanout pattern)
- Queue policies granting SNS publish permissions
- Dead Letter Queues for both queues
- Proper tagging for resource management

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Fanout Pattern

This example demonstrates:
- **Message Broadcasting**: Single SNS message delivered to multiple SQS queues
- **Loose Coupling**: Publishers and subscribers are decoupled via SNS
- **Scalability**: Easy to add more subscribers without modifying publishers
- **Reliability**: Each queue has its own DLQ for independent failure handling

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.16.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_sqs_primary"></a> [sqs\_primary](#module\_sqs\_primary) | ../.. | n/a |
| <a name="module_sqs_secondary"></a> [sqs\_secondary](#module\_sqs\_secondary) | ../.. | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_sns_topic.fanout](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.sqs_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sns_topic_subscription.sqs_subscription_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_sqs_queue_policy.sns_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_sqs_queue_policy.sns_sqs_policy_secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |
| [aws_iam_policy_document.sns_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_secondary_queue"></a> [create\_secondary\_queue](#input\_create\_secondary\_queue) | Whether to create a secondary queue to demonstrate fan-out pattern | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. refarch | `string` | `"arc"` | no |
| <a name="input_queue_name"></a> [queue\_name](#input\_queue\_name) | Name of the primary SQS queue | `string` | `"fanout-primary-queue"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_sns_topic_name"></a> [sns\_topic\_name](#input\_sns\_topic\_name) | Name of the SNS topic for fan-out pattern | `string` | `"fanout-topic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_primary_dlq_arn"></a> [primary\_dlq\_arn](#output\_primary\_dlq\_arn) | The ARN of the primary queue's dead letter queue |
| <a name="output_primary_queue_arn"></a> [primary\_queue\_arn](#output\_primary\_queue\_arn) | The ARN of the primary SQS queue |
| <a name="output_primary_queue_id"></a> [primary\_queue\_id](#output\_primary\_queue\_id) | The URL for the primary SQS queue |
| <a name="output_primary_queue_name"></a> [primary\_queue\_name](#output\_primary\_queue\_name) | The name of the primary SQS queue |
| <a name="output_secondary_dlq_arn"></a> [secondary\_dlq\_arn](#output\_secondary\_dlq\_arn) | The ARN of the secondary queue's dead letter queue |
| <a name="output_secondary_queue_arn"></a> [secondary\_queue\_arn](#output\_secondary\_queue\_arn) | The ARN of the secondary SQS queue |
| <a name="output_secondary_queue_id"></a> [secondary\_queue\_id](#output\_secondary\_queue\_id) | The URL for the secondary SQS queue |
| <a name="output_secondary_queue_name"></a> [secondary\_queue\_name](#output\_secondary\_queue\_name) | The name of the secondary SQS queue |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic |
| <a name="output_sns_topic_name"></a> [sns\_topic\_name](#output\_sns\_topic\_name) | The name of the SNS topic |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
