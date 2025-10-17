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

  kms_config = {
    create_key           = true
    deletion_window_days = 30
    rotation_enabled     = true
  }

  dlq_config = {
    enabled                   = true
    max_receive_count         = 5
    message_retention_seconds = 1209600
  }

  tags = module.tags.tags
}
