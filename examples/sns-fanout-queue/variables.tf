################################################################################
# Required Variables
################################################################################

variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
  default     = "poc"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "namespace" {
  type        = string
  description = "Namespace of the project, i.e. refarch"
  default     = "arc"
}

################################################################################
# Example-Specific Variables
################################################################################

variable "queue_name" {
  type        = string
  description = "Name of the primary SQS queue"
  default     = "fanout-primary-queue"
}

variable "sns_topic_name" {
  type        = string
  description = "Name of the SNS topic for fan-out pattern"
  default     = "fanout-topic"
}

variable "create_secondary_queue" {
  type        = bool
  description = "Whether to create a secondary queue to demonstrate fan-out pattern"
  default     = true
}
