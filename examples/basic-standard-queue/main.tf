################################################################################
# Tags Module - Sourcefuse Standard
################################################################################

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Example = "basic-standard-queue"
  }
}

################################################################################
# Basic Standard SQS Queue
################################################################################

module "sqs" {
  source = "../.."

  name = var.queue_name
  tags = module.tags.tags
}
