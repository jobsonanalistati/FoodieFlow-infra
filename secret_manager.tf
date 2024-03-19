data "aws_secretsmanager_secret" "foodieFlow" {
  name = "foodieFlow"
}

data "aws_secretsmanager_secret_version" "foodieFlow" {
  secret_id = data.aws_secretsmanager_secret.foodieFlow.id
}

resource "aws_secretsmanager_secret_version" "foodieFlow" {
  secret_id = data.aws_secretsmanager_secret.foodieFlow.id
  secret_string = jsonencode(merge(try(jsondecode(data.aws_secretsmanager_secret_version.foodieFlow.secret_string), {}), {
    pool      = aws_cognito_user_pool.tfer--foodieflow.id,
    client_id = aws_cognito_user_pool_client.client.id
  }))
}