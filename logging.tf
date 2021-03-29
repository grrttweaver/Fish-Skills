data "aws_iam_policy_document" "es_policy" {
  count = aws_elasticsearch_domain.es.endpoint != "" ? 1 : 0

  statement {
    actions = [
      "es:*"
    ]
    resources = [
      aws_elasticsearch_domain.es.arn,
      "arn:aws:es:${var.region}:${data.aws_caller_identity.current.account_id}:domain/${var.app_name}-elk-domain/*",
    ]
  }
}

resource "aws_iam_policy" "es_policy" {
  count = aws_elasticsearch_domain.es.endpoint != "" ? 1 : 0
  path = "/ecs/task-role/"
  policy = data.aws_iam_policy_document.es_policy[count.index].json
}

resource "aws_iam_role_policy_attachment" "es_policy_attachment" {
  count = aws_elasticsearch_domain.es.endpoint != "" ? 1 : 0
  role = var.task_role_name
  policy_arn = aws_iam_policy.es_policy[count.index].arn
}

resource "aws_cloudwatch_log_group" "containers" {
  name = "/aws/ecs/${var.service_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]

    resources = [aws_cloudwatch_log_group.containers.arn]
  }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  path   = "/ecs/task-role/"
  policy = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = var.task_role_name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}
