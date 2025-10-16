################################################################################
# Tags Module - Sourcefuse Standard
################################################################################

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Example = "fifo-queue"
    Pattern = "OrderedMessaging"
  }
}

################################################################################
# FIFO SQS Queue with Content-Based Deduplication
################################################################################

module "sqs" {
  source = "../.."

  name = var.queue_name # Must end with .fifo

  # FIFO configuration
  fifo_config = {
    enabled                     = true
    content_based_deduplication = true
    deduplication_scope         = "messageGroup" # High throughput FIFO
    throughput_limit            = "perMessageGroupId"
  }

  # Optional: DLQ for FIFO queue
  # dlq_config = {
  #   enabled                     = true
  #   max_receive_count           = 5
  #   content_based_deduplication = true
  # }

  # Tags from arc-tags module
  tags = module.tags.tags
}
