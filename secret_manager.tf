data "aws_secretsmanager_secret" "foodieFlow_secrets" {
  name = "foodieFlow_secrets"
}

data "aws_secretsmanager_secret_version" "foodieFlow_secrets" {
  secret_id = data.aws_secretsmanager_secret.foodieFlow_secrets.id
}

resource "aws_secretsmanager_secret_version" "foodieFlow_secrets" {
  secret_id = data.aws_secretsmanager_secret.foodieFlow_secrets.id
  secret_string = jsonencode(merge(try(jsondecode(data.aws_secretsmanager_secret_version.foodieFlow_secrets.secret_string), {}), {
    pool      = aws_cognito_user_pool.tfer--foodieflow.id,
    client_id = aws_cognito_user_pool_client.client.id
  }))
}