variable "AWS_ACCESS_KEY_PROD" {
  description = "the aws IAM prod access key"
  type        = string
  default     = "PARAMETER_STORE"
}

variable "AWS_SECRET_KEY_PROD" {
  description = "the aws IAM prod secret key"
  type        = string
  default     = "PARAMETER_STORE"
}

variable "AWS_REGION_PROD" {
  description = "the AWS prod region"
  type        = string
  default     = "eu-west-1"
}

variable "AWS_ACCESS_KEY_DEV" {
  description = "the aws IAM dev access key"
  type        = string
  default     = "PARAMETER_STORE"
}

variable "AWS_SECRET_KEY_DEV" {
  description = "the aws IAM dev secret key"
  type        = string
  default     = "PARAMETER_STORE"
}

variable "AWS_REGION_DEV" {
  description = "the AWS dev region"
  type        = string
  default     = "eu-west-1"
}
