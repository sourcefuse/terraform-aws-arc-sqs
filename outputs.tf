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
  value       = var.dlq_config.enabled ? aws_sqs_queue.dlq["this"].id : null
}

output "dlq_arn" {
  description = "The ARN of the SQS dead letter queue"
  value       = var.dlq_config.enabled ? aws_sqs_queue.dlq["this"].arn : null
}

output "dlq_name" {
  description = "The name of the SQS dead letter queue"
  value       = var.dlq_config.enabled ? aws_sqs_queue.dlq["this"].name : null
}

output "dlq_url" {
  description = "Same as `dlq_id`: The URL for the created Amazon SQS dead letter queue"
  value       = var.dlq_config.enabled ? aws_sqs_queue.dlq["this"].url : null
}

################################################################################
# KMS Key Outputs
################################################################################

output "kms_key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = var.encryption_config.kms_encryption_enabled && var.encryption_config.existing_kms_key_id == null && var.encryption_config.create_kms_key ? module.kms["this"].key_id : null
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = var.encryption_config.kms_encryption_enabled ? (var.encryption_config.existing_kms_key_id != null ? var.encryption_config.existing_kms_key_id : (var.encryption_config.create_kms_key ? module.kms["this"].key_arn : null)) : null
}

output "kms_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS alias"
  value       = var.encryption_config.kms_encryption_enabled && var.encryption_config.existing_kms_key_id == null && var.encryption_config.create_kms_key ? module.kms["this"].alias_arn : null
}

output "kms_alias_name" {
  description = "The display name of the KMS alias"
  value       = var.encryption_config.kms_encryption_enabled && var.encryption_config.existing_kms_key_id == null && var.encryption_config.create_kms_key ? module.kms["this"].alias_name : null
}

################################################################################
# Policy Outputs
################################################################################

output "queue_policy" {
  description = "The JSON policy of the SQS queue"
  value       = var.policy_config.create ? aws_sqs_queue_policy.this["this"].policy : null
}
