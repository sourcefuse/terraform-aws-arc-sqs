################################################################################
# General Configuration
################################################################################

variable "name" {
  description = "Name of the SQS queue. If fifo_queue is set to true, the name must end with .fifo"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+(\\.fifo)?$", var.name))
    error_message = "The name must only contain alphanumeric characters, hyphens, and underscores. FIFO queues must end with .fifo"
  }
}

################################################################################
# FIFO Queue Configuration
################################################################################

variable "fifo_config" {
  description = "FIFO queue configuration. Set enabled=true for FIFO queue. deduplication_scope valid values: messageGroup, queue. throughput_limit valid values: perQueue, perMessageGroupId"
  type = object({
    enabled                     = optional(bool, false)
    content_based_deduplication = optional(bool, false)
    deduplication_scope         = optional(string, null)
    throughput_limit            = optional(string, null)
  })
  default = {
    enabled = false
  }

  validation {
    condition = var.fifo_config.deduplication_scope == null || (
      contains(["messageGroup", "queue"], var.fifo_config.deduplication_scope)
    )
    error_message = "deduplication_scope must be either 'messageGroup' or 'queue'."
  }

  validation {
    condition = var.fifo_config.throughput_limit == null || (
      contains(["perQueue", "perMessageGroupId"], var.fifo_config.throughput_limit)
    )
    error_message = "throughput_limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

################################################################################
# Message Configuration
################################################################################

variable "message_config" {
  description = "Message handling configuration"
  type = object({
    delay_seconds             = optional(number, 0)
    max_message_size          = optional(number, 262144)
    retention_seconds         = optional(number, 345600)
    receive_wait_time_seconds = optional(number, 0)
    visibility_timeout        = optional(number, 30)
  })
  default = {}

  validation {
    condition     = var.message_config.delay_seconds >= 0 && var.message_config.delay_seconds <= 900
    error_message = "delay_seconds must be between 0 and 900 seconds."
  }

  validation {
    condition     = var.message_config.max_message_size >= 1024 && var.message_config.max_message_size <= 262144
    error_message = "max_message_size must be between 1024 and 262144 bytes."
  }

  validation {
    condition     = var.message_config.retention_seconds >= 60 && var.message_config.retention_seconds <= 1209600
    error_message = "retention_seconds must be between 60 and 1209600 seconds."
  }

  validation {
    condition     = var.message_config.receive_wait_time_seconds >= 0 && var.message_config.receive_wait_time_seconds <= 20
    error_message = "receive_wait_time_seconds must be between 0 and 20 seconds."
  }

  validation {
    condition     = var.message_config.visibility_timeout >= 0 && var.message_config.visibility_timeout <= 43200
    error_message = "visibility_timeout must be between 0 and 43200 seconds."
  }
}

################################################################################
# Encryption Configuration
################################################################################

variable "kms_key" {
  description = "ARN of existing KMS key for queue encryption. If null and create_key=false, uses AWS managed SSE-SQS encryption"
  type        = string
  default     = null
}

variable "create_key" {
  description = "Whether to create a new KMS key for queue encryption. Ignored if kms_key is provided"
  type        = bool
  default     = false
}

variable "kms_config" {
  description = "Configuration for creating a new KMS key. Only used if create_key=true and kms_key=null"
  type = object({
    data_key_reuse_period = optional(number, 300)
    deletion_window_days  = optional(number, 7)
    rotation_enabled      = optional(bool, true)
    alias                 = optional(string, null)
    policy                = optional(string, null)
  })
  default = null

  validation {
    condition     = var.kms_config == null || (var.kms_config.data_key_reuse_period >= 60 && var.kms_config.data_key_reuse_period <= 86400)
    error_message = "data_key_reuse_period must be between 60 and 86400 seconds."
  }

  validation {
    condition     = var.kms_config == null || (var.kms_config.deletion_window_days >= 7 && var.kms_config.deletion_window_days <= 30)
    error_message = "deletion_window_days must be between 7 and 30 days."
  }
}

################################################################################
# Dead Letter Queue Configuration
################################################################################

variable "dlq_config" {
  description = "Dead Letter Queue configuration. Set enabled=true to create DLQ"
  type = object({
    enabled                     = optional(bool, false)
    name                        = optional(string, null)
    max_receive_count           = optional(number, 3)
    message_retention_seconds   = optional(number, 1209600)
    delay_seconds               = optional(number, 0)
    max_message_size            = optional(number, 262144)
    receive_wait_time_seconds   = optional(number, 0)
    visibility_timeout          = optional(number, 30)
    content_based_deduplication = optional(bool, false)
    deduplication_scope         = optional(string, null)
    throughput_limit            = optional(string, null)
    redrive_allow_policy        = optional(string, null)
  })
  default = {
    enabled = false
  }

  validation {
    condition     = var.dlq_config.max_receive_count >= 1 && var.dlq_config.max_receive_count <= 1000
    error_message = "max_receive_count must be between 1 and 1000."
  }

  validation {
    condition = var.dlq_config.deduplication_scope == null || (
      contains(["messageGroup", "queue"], var.dlq_config.deduplication_scope)
    )
    error_message = "deduplication_scope must be either 'messageGroup' or 'queue'."
  }

  validation {
    condition = var.dlq_config.throughput_limit == null || (
      contains(["perQueue", "perMessageGroupId"], var.dlq_config.throughput_limit)
    )
    error_message = "throughput_limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

variable "custom_redrive_policy" {
  description = "JSON policy to specify an external dead-letter queue (instead of using dlq_config)"
  type        = string
  default     = null
}

variable "redrive_allow_policy" {
  description = "JSON policy to control which source queues can specify this queue as their dead-letter queue"
  type        = string
  default     = null
}

################################################################################
# Queue Policy Configuration
################################################################################

variable "policy_config" {
  description = "Queue policy configuration"
  type = object({
    create                    = optional(bool, false)
    policy_json               = optional(string, null)
    source_policy_documents   = optional(list(string), [])
    override_policy_documents = optional(list(string), [])
  })
  default = {
    create = false
  }
}

################################################################################
# Tagging
################################################################################

variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
