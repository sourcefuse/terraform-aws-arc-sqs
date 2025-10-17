################################################################################
# Tags Module - Sourcefuse Standard
################################################################################

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Example = "encrypted-queue"
  }
}

################################################################################
# Encrypted SQS Queue with DLQ
################################################################################

module "sqs" {
  source = "../.."

  name = var.queue_name

  kms_key    = var.kms_key_arn
  create_key = var.create_kms_key
  kms_config = var.create_kms_key ? {
    deletion_window_days = var.kms_deletion_window_days
    rotation_enabled     = var.kms_rotation_enabled
  } : null

  dlq_config = {
    enabled                   = true
    max_receive_count         = 5
    message_retention_seconds = 1209600
  }

  tags = module.tags.tags
}
