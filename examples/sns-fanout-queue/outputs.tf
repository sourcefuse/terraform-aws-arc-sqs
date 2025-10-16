output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.fanout.arn
}

output "sns_topic_name" {
  description = "The name of the SNS topic"
  value       = aws_sns_topic.fanout.name
}

output "primary_queue_id" {
  description = "The URL for the primary SQS queue"
  value       = module.sqs_primary.queue_id
}

output "primary_queue_arn" {
  description = "The ARN of the primary SQS queue"
  value       = module.sqs_primary.queue_arn
}

output "primary_queue_name" {
  description = "The name of the primary SQS queue"
  value       = module.sqs_primary.queue_name
}

output "secondary_queue_id" {
  description = "The URL for the secondary SQS queue"
  value       = var.create_secondary_queue ? module.sqs_secondary[0].queue_id : null
}

output "secondary_queue_arn" {
  description = "The ARN of the secondary SQS queue"
  value       = var.create_secondary_queue ? module.sqs_secondary[0].queue_arn : null
}

output "secondary_queue_name" {
  description = "The name of the secondary SQS queue"
  value       = var.create_secondary_queue ? module.sqs_secondary[0].queue_name : null
}

output "primary_dlq_arn" {
  description = "The ARN of the primary queue's dead letter queue"
  value       = module.sqs_primary.dlq_arn
}

output "secondary_dlq_arn" {
  description = "The ARN of the secondary queue's dead letter queue"
  value       = var.create_secondary_queue ? module.sqs_secondary[0].dlq_arn : null
}
