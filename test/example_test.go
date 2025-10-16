package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicStandardQueue(t *testing.T) {
	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic-standard-queue",
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	queueName := terraform.Output(t, terraformOptions, "queue_name")
	queueArn := terraform.Output(t, terraformOptions, "queue_arn")
	queueUrl := terraform.Output(t, terraformOptions, "queue_url")
	queueId := terraform.Output(t, terraformOptions, "queue_id")

	// Verify queue name is set
	assert.NotEmpty(t, queueName)
	assert.Equal(t, "basic-standard-queue", queueName)

	// Verify ARN format
	assert.NotEmpty(t, queueArn)
	assert.Contains(t, queueArn, "arn:aws:sqs:")
	assert.Contains(t, queueArn, "basic-standard-queue")

	// Verify URL format
	assert.NotEmpty(t, queueUrl)
	assert.True(t, strings.HasPrefix(queueUrl, "https://sqs."))
	assert.Contains(t, queueUrl, "basic-standard-queue")

	// Verify queue ID matches URL
	assert.Equal(t, queueUrl, queueId)
}

func TestFifoQueue(t *testing.T) {
	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/fifo-queue",
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	queueName := terraform.Output(t, terraformOptions, "queue_name")
	queueArn := terraform.Output(t, terraformOptions, "queue_arn")

	// Verify FIFO queue naming
	assert.NotEmpty(t, queueName)
	assert.True(t, strings.HasSuffix(queueName, ".fifo"))

	// Verify ARN contains FIFO queue name
	assert.NotEmpty(t, queueArn)
	assert.Contains(t, queueArn, ".fifo")
}

func TestStandardQueueWithDLQ(t *testing.T) {
	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/standard-queue-with-dlq",
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	queueName := terraform.Output(t, terraformOptions, "queue_name")
	dlqName := terraform.Output(t, terraformOptions, "dlq_name")
	dlqArn := terraform.Output(t, terraformOptions, "dlq_arn")

	// Verify main queue
	assert.NotEmpty(t, queueName)

	// Verify DLQ was created
	assert.NotEmpty(t, dlqName)
	assert.NotEmpty(t, dlqArn)
	assert.Contains(t, dlqArn, "arn:aws:sqs:")

	// Verify DLQ naming convention
	assert.Contains(t, dlqName, "dlq")
}

func TestEncryptedQueue(t *testing.T) {
	// Arrange
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/encrypted-queue",
	}
	defer terraform.Destroy(t, terraformOptions)

	// Act
	terraform.InitAndApply(t, terraformOptions)

	// Assert
	queueArn := terraform.Output(t, terraformOptions, "queue_arn")
	kmsKeyArn := terraform.Output(t, terraformOptions, "kms_key_arn")

	// Verify queue was created
	assert.NotEmpty(t, queueArn)

	// Verify KMS key was created for encryption
	assert.NotEmpty(t, kmsKeyArn)
	assert.Contains(t, kmsKeyArn, "arn:aws:kms:")
}
