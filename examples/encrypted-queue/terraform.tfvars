environment = "poc"
region      = "us-east-1"
namespace   = "arc"
queue_name  = "encrypted-sensitive-data-queue"

# KMS Encryption - Uncomment one option:

# Option 1: Use existing KMS key
# kms_config = {
#   key_arn = "arn:aws:kms:us-east-1:123456789012:key/abc..."
# }

# Option 2: Create new KMS key
# kms_config = {
#   create_key           = true
#   deletion_window_days = 30
#   rotation_enabled     = true
# }

# Option 3: AWS managed SSE-SQS (default - no config needed)
