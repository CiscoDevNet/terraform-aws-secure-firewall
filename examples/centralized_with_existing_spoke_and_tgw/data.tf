data "aws_vpc" "ftd_vpc" {

  filter {
    name   = "tag:Name"
    values = [var.service_vpc_name]
  }
}

data "aws_lambda_invocation" "example" {
  depends_on = [
    time_sleep.wait_720_seconds
  ]
  function_name = aws_lambda_function.lambda.function_name

  #dummy input
  input = <<JSON
{
  "key1": "value1",
  "key2": "value2"   
}
JSON
}