resource "aws_cloudwatch_log_group" "this_loggroup" {
  name              = var.cloudwatch_loggroup_name
  retention_in_days = var.cloudwatch_loggroup_retention
}

resource "aws_iam_role" "lambda_elasticsearch_execution_role" {
  name = "${var.name}_lambda_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_security_group" "this_security_group" {
  name        = "${var.name}_lambda_sg"
  description = "Allow outbound traffic fom this Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project
    Environment = var.environment  
  }
}

resource "aws_iam_role_policy" "lambda_elasticsearch_execution_policy" {
  name = "${var.name}_lambda_elasticsearch_execution_policy"
  role = aws_iam_role.lambda_elasticsearch_execution_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "es:ESHttpPost",
      "Resource": "arn:aws:es:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

data "archive_file" "cwl2eslambda" {
  type = "zip"
  source_file = "cwl2es.js"
  output_path = "cwl2eslambda.zip"
}

resource "aws_lambda_function" "cwl_stream_lambda" {
  filename         = "cwl2eslambda.zip"
  function_name    = var.name
  role             = aws_iam_role.lambda_elasticsearch_execution_role.arn
  handler          = "cwl2es.handler"
  source_code_hash = "${filebase64sha256(data.archive_file.cwl2eslambda.output_path)}"
  runtime          = "nodejs10.x"

  vpc_config {
    subnet_ids = var.subnets
    security_group_ids = [aws_security_group.this_security_group.id]
  }

  environment {
    variables = {
      es_endpoint    = var.es_endpoint
      tf_environment = var.tf_environment
    }
  }
}

resource "aws_lambda_permission" "cloudwatch_allow" {
  statement_id = "cloudwatch_allow"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cwl_stream_lambda.arn
  principal = var.cwl_endpoint
  source_arn = "${aws_cloudwatch_log_group.this_loggroup.arn}/*"
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_logs_to_es" {
  depends_on = [ aws_lambda_permission.cloudwatch_allow ]
  name            = "${var.name}_cloudwatch_logs_to_elasticsearch"
  log_group_name  = aws_cloudwatch_log_group.this_loggroup.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.cwl_stream_lambda.arn
}