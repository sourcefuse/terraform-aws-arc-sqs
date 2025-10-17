################################################################################
# Queue Outputs
################################################################################

output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = aws_sqs_queue.this.id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = aws_sqs_queue.this.name
}

output "queue_url" {
  description = "Same as `queue_id`: The URL for the created Amazon SQS queue"
  value       = aws_sqs_queue.this.url
}

################################################################################
# Dead Letter Queue Outputs
################################################################################

output "dlq_id" {
  description = "The URL for the created Amazon SQS dead letter queue"
  value       = local.dlq_count > 0 ? aws_sqs_queue.dlq[0].id : null
}

output "dlq_arn" {
  description = "The ARN of the SQS dead letter queue"
  value       = local.dlq_count > 0 ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_name" {
  description = "The name of the SQS dead letter queue"
  value       = local.dlq_count > 0 ? aws_sqs_queue.dlq[0].name : null
}

output "dlq_url" {
  description = "Same as `dlq_id`: The URL for the created Amazon SQS dead letter queue"
  value       = local.dlq_count > 0 ? aws_sqs_queue.dlq[0].url : null
}

################################################################################
# KMS Key Outputs
################################################################################

output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = local.kms_count > 0 ? module.kms[0].key_id : null
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = var.encryption_config.kms_encryption_enabled ? (var.encryption_config.existing_kms_key_id != null ? var.encryption_config.existing_kms_key_id : (local.kms_count > 0 ? module.kms[0].key_arn : null)) : null
}

output "kms_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS alias"
  value       = local.kms_count > 0 ? module.kms[0].alias_arn : null
}

output "kms_alias_name" {
  description = "The display name of the KMS alias"
  value       = local.kms_count > 0 ? module.kms[0].alias_name : null
}

################################################################################
# Policy Outputs
################################################################################

output "queue_policy" {
  description = "The JSON policy of the SQS queue"
  value       = local.queue_policy_count > 0 ? aws_sqs_queue_policy.this[0].policy : null
}
