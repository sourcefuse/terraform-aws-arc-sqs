################################################################################
# Tags Module - Sourcefuse Standard
################################################################################

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Example    = "encrypted-queue"
    Compliance = "HIPAA"
  }
}

################################################################################
# Encrypted SQS Queue with DLQ
################################################################################

module "sqs" {
  source = "../.."

  name = var.queue_name

  # Grouped encryption configuration
  encryption_config = {
    kms_encryption_enabled       = true
    create_kms_key               = true
    kms_key_deletion_window_days = 30
    kms_key_rotation_enabled     = true
  }

  # Grouped DLQ configuration
  dlq_config = {
    enabled                   = true
    max_receive_count         = 5
    message_retention_seconds = 1209600 # 14 days
  }

  # Tags from arc-tags module
  tags = module.tags.tags
}
