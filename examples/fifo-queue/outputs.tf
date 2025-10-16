output "queue_id" {
  description = "The URL for the created Amazon SQS FIFO queue"
  value       = module.sqs.queue_id
}

output "queue_arn" {
  description = "The ARN of the SQS FIFO queue"
  value       = module.sqs.queue_arn
}

output "queue_name" {
  description = "The name of the SQS FIFO queue"
  value       = module.sqs.queue_name
}

output "dlq_id" {
  description = "The URL for the created Amazon SQS dead letter queue"
  value       = module.sqs.dlq_id
}

output "dlq_arn" {
  description = "The ARN of the SQS dead letter queue"
  value       = module.sqs.dlq_arn
}

output "dlq_name" {
  description = "The name of the SQS dead letter queue"
  value       = module.sqs.dlq_name
}
