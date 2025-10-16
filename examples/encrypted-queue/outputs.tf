output "queue_id" {
  description = "The URL for the created Amazon SQS queue"
  value       = module.sqs.queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = module.sqs.queue_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = module.sqs.kms_key_arn
}

output "dlq_arn" {
  description = "The ARN of the DLQ"
  value       = module.sqs.dlq_arn
}
