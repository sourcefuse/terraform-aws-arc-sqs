################################################################################
# Tags Module - Sourcefuse Standard
################################################################################

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    Example = "sns-fanout-queue"
    Pattern = "EventDriven"
  }
}

data "aws_caller_identity" "current" {}

################################################################################
# KMS Key for SNS Topic Encryption
################################################################################

# KMS Key Policy for SNS
data "aws_iam_policy_document" "sns_kms_policy" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow SNS to use the key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }
}

module "sns_kms" {
  source  = "sourcefuse/arc-kms/aws"
  version = "1.0.11"

  deletion_window_in_days = 7
  enable_key_rotation     = true
  alias                   = "alias/${var.sns_topic_name}/sns-key"
  policy                  = data.aws_iam_policy_document.sns_kms_policy.json

  tags = merge(
    module.tags.tags,
    {
      Name = "${var.sns_topic_name}-kms-key"
    }
  )
}

################################################################################
# SNS Topic for Fan-out Pattern using SourceFuse ARC SNS Module
################################################################################

module "sns_topic" {
  source  = "sourcefuse/arc-sns/aws"
  version = "0.0.2"

  name              = var.sns_topic_name
  kms_master_key_id = module.sns_kms.key_arn # Enable encryption

  # Create subscriptions for SQS queues
  create_subscription = true
  subscriptions = merge(
    {
      primary_queue = {
        protocol             = "sqs"
        endpoint             = module.sqs_primary.queue_arn
        raw_message_delivery = true
      }
    },
    var.create_secondary_queue ? {
      secondary_queue = {
        protocol             = "sqs"
        endpoint             = module.sqs_secondary[0].queue_arn
        raw_message_delivery = true
      }
    } : {}
  )

  tags = module.tags.tags
}

################################################################################
# Primary SQS Queue (Subscribes to SNS)
################################################################################

module "sqs_primary" {
  source = "../.."

  name = var.queue_name

  # Message configuration with DLQ
  message_config = {
    retention_seconds         = 604800 # 7 days
    receive_wait_time_seconds = 20     # Long polling
  }

  dlq_config = {
    enabled           = true
    max_receive_count = 3
  }

  # Use module's built-in policy feature to allow SNS access
  policy_config = {
    create                  = true
    source_policy_documents = [data.aws_iam_policy_document.sns_sqs_policy.json]
  }

  tags = module.tags.tags
}

# Policy to allow SNS to send messages to primary queue
data "aws_iam_policy_document" "sns_sqs_policy" {
  statement {
    sid    = "AllowSNSToSendMessages"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [module.sqs_primary.queue_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.sns_topic.topic_arn]
    }
  }
}

################################################################################
# Secondary Queue (Optional - for fan-out demonstration)
################################################################################

# Policy document for secondary queue
data "aws_iam_policy_document" "sns_sqs_policy_secondary" {
  count = var.create_secondary_queue ? 1 : 0

  statement {
    sid    = "AllowSNSToSendMessages"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    actions   = ["sqs:SendMessage"]
    resources = [module.sqs_secondary[0].queue_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.sns_topic.topic_arn]
    }
  }
}

module "sqs_secondary" {
  count = var.create_secondary_queue ? 1 : 0

  source = "../.."

  name = "${var.queue_name}-secondary"

  message_config = {
    retention_seconds         = 604800
    receive_wait_time_seconds = 20
  }

  dlq_config = {
    enabled           = true
    max_receive_count = 3
  }

  # Use module's built-in policy feature to allow SNS access
  policy_config = {
    create                  = true
    source_policy_documents = [data.aws_iam_policy_document.sns_sqs_policy_secondary[0].json]
  }

  tags = merge(module.tags.tags, {
    QueueType = "Secondary"
  })
}
