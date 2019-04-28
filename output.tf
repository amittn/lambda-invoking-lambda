output "first_lambda" {
  value = "${aws_lambda_function.first_lambda.qualified_arn}"
}

output "second_lambda" {
  value = "${aws_lambda_function.second_lambda.qualified_arn}"
}
