variable "aws_region" {
  description = "AWS region for deploying infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the demonstration project"
  type        = string
  default     = "aws-devops-demo"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "demo"
}
