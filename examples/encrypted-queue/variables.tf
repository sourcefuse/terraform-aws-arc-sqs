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

variable "create_kms_key" {
  type        = bool
  description = "Whether to create a new KMS key for encryption. Only used if kms_key_arn is not provided"
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of existing KMS key to use. If provided, a new KMS key will not be created"
  default     = null
}

variable "kms_deletion_window_days" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 30
}

variable "kms_rotation_enabled" {
  type        = bool
  description = "Enable automatic KMS key rotation"
  default     = true
}
