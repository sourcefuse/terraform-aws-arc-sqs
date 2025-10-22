# Data source for current AWS account
data "aws_caller_identity" "current" {}

################################################################################
# Local Values
################################################################################

locals {
  queue_name = var.name

  dlq_name = var.dlq_config.enabled ? (
    var.dlq_config.name != null ? var.dlq_config.name : (
      var.fifo_config.enabled ? replace(var.name, ".fifo", "-dlq.fifo") : "${var.name}-dlq"
    )
  ) : null

  kms_key_id = var.kms_config != null && var.kms_config.key_arn != null ? var.kms_config.key_arn : (
    var.kms_config != null && var.kms_config.create_key ? module.kms[0].key_arn : null
  )

  kms_data_key_reuse_period = var.kms_config != null ? var.kms_config.data_key_reuse_period : 300

  # KMS key policy for SQS
  kms_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow SQS to use the key"
        Effect = "Allow"
        Principal = {
          Service = "sqs.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  dlq_count          = var.dlq_config.enabled ? 1 : 0
  queue_policy_count = var.policy_config.create ? 1 : 0
  kms_count          = var.kms_config != null && var.kms_config.create_key && var.kms_config.key_arn == null ? 1 : 0
}
