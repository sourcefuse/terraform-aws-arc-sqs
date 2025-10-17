# Data source for current AWS account
data "aws_caller_identity" "current" {}

################################################################################
# Local Values
################################################################################

locals {
  # Queue naming logic
  queue_name  = var.use_name_prefix ? null : var.name
  name_prefix = var.use_name_prefix ? var.name_prefix : null

  # DLQ naming logic
  dlq_name = var.dlq_config.enabled ? (
    var.dlq_config.name != null ? var.dlq_config.name : (
      var.fifo_config.enabled ? replace(var.name, ".fifo", "-dlq.fifo") : "${var.name}-dlq"
    )
  ) : null

  # Determine KMS key to use based on priority:
  # 1. Existing KMS key provided by user
  # 2. Module-created KMS key (via sourcefuse/arc-kms/aws)
  # 3. No encryption (null)
  kms_key_id = var.encryption_config.kms_encryption_enabled ? (
    var.encryption_config.existing_kms_key_id != null ? var.encryption_config.existing_kms_key_id : (
      local.kms_count > 0 ? module.kms[0].key_arn : null
    )
  ) : null

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

  # Count values for conditional resource creation
  dlq_count          = var.dlq_config.enabled ? 1 : 0
  queue_policy_count = var.policy_config.create ? 1 : 0
  kms_count          = var.encryption_config.kms_encryption_enabled && var.encryption_config.existing_kms_key_id == null && var.encryption_config.create_kms_key ? 1 : 0
}
