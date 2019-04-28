# Specify the provider and access details


# iam
data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_iam_role_policy" "frontend_lambda_role_policy" {
  name   = "frontend-lambda-role-policy"
  role   = "${aws_iam_role.iam_for_lambda.id}"
  policy = "${data.aws_iam_policy_document.lambda_log_and_invoke_policy.json}"
}

data "aws_iam_policy_document" "lambda_log_and_invoke_policy" {

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]

  }

  statement {
    effect = "Allow"

    actions = ["lambda:InvokeFunction"]

    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:*"]
  }

}



# lambda
provider "archive" {}

data "archive_file" "first_zip" {
  type        = "zip"
  source_file = "first_lambda.py"
  output_path = "first_lambda.zip"
}

resource "aws_lambda_function" "first_lambda" {
  function_name = "first_lambda"

  filename         = "${data.archive_file.first_zip.output_path}"
  source_code_hash = "${data.archive_file.first_zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "first_lambda.lambda_handler"
  runtime = "python3.6"
  timeout = 15

  environment {
    variables = {
      environment = "dev-setup",
      value_one   = "this is how it's",
      value_tow   = "going to append two values"
    }
  }
}


data "archive_file" "second_zip" {
  type        = "zip"
  source_file = "second_lambda.py"
  output_path = "second_lambda.zip"
}

resource "aws_lambda_function" "second_lambda" {
  function_name = "second_lambda"

  filename         = "${data.archive_file.second_zip.output_path}"
  source_code_hash = "${data.archive_file.second_zip.output_base64sha256}"

  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "second_lambda.lambda_handler"
  runtime = "python3.6"
  timeout = 5

  environment {
    variables = {
      environment = "dev-setup"
    }
  }
}
