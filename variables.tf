variable "access_key" {
  description = "Access key to AWS console"
}

variable "secret_key" {
  description = "Secret key to AWS console"
}

variable "region" {
  type = string
  description = "AWS Region"
  default = "us-east-2"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR block"
  default = "10.0.0.0/16"
}

variable "cluster_runner_type" {
  type = string
  description = "EC2 instance type of ECS Cluster Runner"
  default = "t3.small"
}

variable "cluster_runner_count" {
  type = string
  description = "Number of EC2 instances for ECS Cluster Runner"
  default = "1"
}

variable "app_name" {
  type = string
  description = "Application name"
}

variable "app_environment" {
  type = string
  description = "Application environment"
}

variable "admin_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow admin access"
}

variable "app_sources_cidr" {
  type = string
  description = "List of IPv4 CIDR blocks from which to allow application access"
}

variable "nginx_app_name" {
  description = "Name of Application Container"
  default = "nginx"
}

variable "nginx_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = "nginx:latest"
}

variable "nginx_app_port" {
  description = "Port exposed by the Docker image to redirect traffic to"
  default = 80
}

variable "nginx_app_count" {
  description = "Number of Docker containers to run"
  default = 2
}

variable "nginx_fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "1024"
}

variable "nginx_fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default = "2048"
}

variable "service_name" {
  description = "Name of the service to collect log events for. This will be used as the Elasticsearch index name and for IAM configuration."
  type = string
  default = "fishtech-web"
}

variable "task_role_name" {
  description = "Name of the IAM role used by the containers in this service. IAM permissions for sending logs to Elasticsearch will be added to this role."
  type = string
  default = "ecsTaskExecutionRole"
}
