################################################################################
# Tags Module - Sourcefuse Standard
################################################################################

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Example = "standard-queue-with-dlq"
    Pattern = "ReliableMessaging"
  }
}

################################################################################
# Standard SQS Queue with Dead Letter Queue
################################################################################

module "sqs" {
  source = "../.."

  name = var.queue_name

  # Message configuration with long polling
  message_config = {
    retention_seconds         = 345600 # 4 days
    visibility_timeout        = 300    # 5 minutes
    receive_wait_time_seconds = 20     # Enable long polling
  }

  # Dead Letter Queue configuration
  dlq_config = {
    enabled                   = true
    max_receive_count         = 5
    message_retention_seconds = 1209600 # 14 days (max retention for troubleshooting)
  }

  # Tags from arc-tags module
  tags = module.tags.tags
}
