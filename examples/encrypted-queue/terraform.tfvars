environment = "poc"
region      = "us-east-1"
namespace   = "arc"
queue_name  = "encrypted-sensitive-data-queue"

# Encryption: Uncomment one option below
# kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abc..."  # Use existing key
# create_kms_key = true                                           # Create new key
# (default: AWS managed SSE-SQS if both commented out)
