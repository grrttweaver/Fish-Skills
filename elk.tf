resource "aws_security_group" "es" {
  name = "${var.app_name}-es-sg"
  description = "Allow inbound traffic to ElasticSearch from VPC CIDR"
  vpc_id = module.vpc.vpc_id

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  domain_name = "${var.app_name}-elk-domain"
  elasticsearch_version = "7.7"

  cluster_config {
      instance_count = 3
      instance_type = "t3.small.elasticsearch"
      zone_awareness_enabled = true
      zone_awareness_config {
        availability_zone_count = 3
      }
  }

  vpc_options {
      subnet_ids = module.vpc.private_subnets[*]
      security_group_ids = [aws_security_group.es.id]
  }

  ebs_options {
      ebs_enabled = true
      volume_size = 10
  }

  access_policies = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "es:*",
          "Principal": "*",
          "Effect": "Allow",
          "Resource": "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.app_name}-elk-domain/*"
      }
  ]
}
  CONFIG

  snapshot_options {
      automated_snapshot_start_hour = 1
  }

  tags = {
      Domain = "${var.app_name}-elk-domain"
  }
}
#
output "elk_endpoint" {
  value = aws_elasticsearch_domain.es.endpoint
}

output "elk_kibana_endpoint" {
  value = aws_elasticsearch_domain.es.kibana_endpoint
}
