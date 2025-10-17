################################################################################
# KMS Key Module (Optional) - Using Sourcefuse ARC KMS Module
################################################################################

module "kms" {
  source  = "sourcefuse/arc-kms/aws"
  version = "1.0.11"

  count = local.kms_count

  deletion_window_in_days = var.kms_config != null ? var.kms_config.deletion_window_days : 7
  enable_key_rotation     = var.kms_config != null ? var.kms_config.rotation_enabled : true
  alias                   = var.kms_config != null && var.kms_config.alias != null ? var.kms_config.alias : "alias/${var.name}/sqs-key"
  policy                  = var.kms_config != null && var.kms_config.policy != null ? var.kms_config.policy : local.kms_policy

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-sqs-kms-key"
    }
  )
}

################################################################################
# Dead Letter Queue (Optional)
################################################################################

resource "aws_sqs_queue" "dlq" {
  count = local.dlq_count

  name                        = local.dlq_name
  fifo_queue                  = var.fifo_config.enabled
  content_based_deduplication = var.fifo_config.enabled ? var.dlq_config.content_based_deduplication : null
  deduplication_scope         = var.fifo_config.enabled && var.dlq_config.deduplication_scope != null ? var.dlq_config.deduplication_scope : null
  fifo_throughput_limit       = var.fifo_config.enabled && var.dlq_config.throughput_limit != null ? var.dlq_config.throughput_limit : null

  message_retention_seconds = var.dlq_config.message_retention_seconds
  max_message_size          = var.dlq_config.max_message_size
  delay_seconds             = var.dlq_config.delay_seconds

  receive_wait_time_seconds  = var.dlq_config.receive_wait_time_seconds
  visibility_timeout_seconds = var.dlq_config.visibility_timeout

  sqs_managed_sse_enabled           = local.kms_key_id == null ? true : null
  kms_master_key_id                 = local.kms_key_id
  kms_data_key_reuse_period_seconds = local.kms_key_id != null ? local.kms_data_key_reuse_period : null

  redrive_allow_policy = var.dlq_config.redrive_allow_policy

  tags = merge(
    var.tags,
    {
      Name = local.dlq_name
      Type = "DeadLetterQueue"
    }
  )
}

################################################################################
# Main SQS Queue
################################################################################

resource "aws_sqs_queue" "this" {
  name = local.queue_name

  fifo_queue                  = var.fifo_config.enabled
  content_based_deduplication = var.fifo_config.enabled ? var.fifo_config.content_based_deduplication : null
  deduplication_scope         = var.fifo_config.enabled && var.fifo_config.deduplication_scope != null ? var.fifo_config.deduplication_scope : null
  fifo_throughput_limit       = var.fifo_config.enabled && var.fifo_config.throughput_limit != null ? var.fifo_config.throughput_limit : null

  delay_seconds              = var.message_config.delay_seconds
  max_message_size           = var.message_config.max_message_size
  message_retention_seconds  = var.message_config.retention_seconds
  receive_wait_time_seconds  = var.message_config.receive_wait_time_seconds
  visibility_timeout_seconds = var.message_config.visibility_timeout

  sqs_managed_sse_enabled           = local.kms_key_id == null ? true : null
  kms_master_key_id                 = local.kms_key_id
  kms_data_key_reuse_period_seconds = local.kms_key_id != null ? local.kms_data_key_reuse_period : null

  redrive_policy = var.dlq_config.enabled ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.dlq_config.max_receive_count
  }) : var.custom_redrive_policy

  redrive_allow_policy = var.redrive_allow_policy

  tags = merge(
    var.tags,
    {
      Name = var.name
      Type = var.fifo_config.enabled ? "FIFOQueue" : "StandardQueue"
    }
  )
}

################################################################################
# Queue Policy (Optional)
################################################################################

data "aws_iam_policy_document" "this" {
  count = local.queue_policy_count

  source_policy_documents   = var.policy_config.source_policy_documents
  override_policy_documents = var.policy_config.override_policy_documents

  # Default statement if custom policy not provided
  dynamic "statement" {
    for_each = var.policy_config.policy_json == null && length(var.policy_config.source_policy_documents) == 0 ? [1] : []
    content {
      sid    = "DefaultQueuePolicy"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      }
      actions   = ["sqs:*"]
      resources = [aws_sqs_queue.this.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "this" {
  count = local.queue_policy_count

  queue_url = aws_sqs_queue.this.id
  policy    = var.policy_config.policy_json != null ? var.policy_config.policy_json : data.aws_iam_policy_document.this[0].json
}
