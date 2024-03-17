output "aws_cognito_user_pool_tfer--foodieflow-002D-users_id" {
  value = aws_cognito_user_pool.tfer--foodieflow-002D-users.id
}

output "aws_cognito_user_pool_tfer--foodieflow_id" {
  value = "teste-${aws_cognito_user_pool.tfer--foodieflow.id}"
}
output "aws_lambda_function_tfer--create-002D-auth-002D-challenge_id" {
  value = aws_lambda_function.tfer--create-002D-auth-002D-challenge.id
}

output "aws_lambda_function_tfer--define-002D-auth-002D-challenge_id" {
  value = aws_lambda_function.tfer--define-002D-auth-002D-challenge.id
}

output "aws_lambda_function_tfer--jwt-002D-validator_id" {
  value = aws_lambda_function.tfer--jwt-002D-validator.id
}

output "aws_lambda_function_tfer--pre-002D-signup-002D-new_id" {
  value = aws_lambda_function.tfer--pre-002D-signup-002D-new.id
}

output "aws_lambda_function_tfer--pre-002D-signup-002D-zip_id" {
  value = aws_lambda_function.tfer--pre-002D-signup-002D-zip.id
}

output "aws_lambda_function_tfer--pre-002D-signup_id" {
  value = aws_lambda_function.tfer--pre-002D-signup.id
}

output "aws_lambda_function_tfer--verify-002D-auth-002D-challenge_id" {
  value = aws_lambda_function.tfer--verify-002D-auth-002D-challenge.id
}

output "aws_lambda_layer_version_tfer--arn-003A-aws-003A-lambda-003A-us-002D-east-002D-1-003A-730335442495-003A-layer-003A-venv-002D-layer-003A-1_id" {
  value = aws_lambda_layer_version.tfer--arn-003A-aws-003A-lambda-003A-us-002D-east-002D-1-003A-730335442495-003A-layer-003A-venv-002D-layer-003A-1.id
}
