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
  description = "Name of the encrypted SQS queue"
  default     = "encrypted-sensitive-data-queue"
}
