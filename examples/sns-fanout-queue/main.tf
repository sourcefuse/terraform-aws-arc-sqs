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

################################################################################
# SNS Topic for Fan-out Pattern
################################################################################

resource "aws_sns_topic" "fanout" {
  name = var.sns_topic_name
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

  tags = module.tags.tags
}

# Policy to allow SNS to send messages
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
      values   = [aws_sns_topic.fanout.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "sns_sqs_policy" {
  queue_url = module.sqs_primary.queue_id
  policy    = data.aws_iam_policy_document.sns_sqs_policy.json
}

# Subscribe SQS to SNS
resource "aws_sns_topic_subscription" "sqs_subscription" {
  topic_arn = aws_sns_topic.fanout.arn
  protocol  = "sqs"
  endpoint  = module.sqs_primary.queue_arn
}

################################################################################
# Secondary Queue (Optional - for fan-out demonstration)
################################################################################

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

  tags = merge(module.tags.tags, {
    QueueType = "Secondary"
  })
}

# Policy for secondary queue
resource "aws_sqs_queue_policy" "sns_sqs_policy_secondary" {
  count = var.create_secondary_queue ? 1 : 0

  queue_url = module.sqs_secondary[0].queue_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowSNSToSendMessages"
      Effect = "Allow"
      Principal = {
        Service = "sns.amazonaws.com"
      }
      Action   = "sqs:SendMessage"
      Resource = module.sqs_secondary[0].queue_arn
      Condition = {
        ArnEquals = {
          "aws:SourceArn" = aws_sns_topic.fanout.arn
        }
      }
    }]
  })
}

# Subscribe secondary queue
resource "aws_sns_topic_subscription" "sqs_subscription_secondary" {
  count = var.create_secondary_queue ? 1 : 0

  topic_arn = aws_sns_topic.fanout.arn
  protocol  = "sqs"
  endpoint  = module.sqs_secondary[0].queue_arn
}
