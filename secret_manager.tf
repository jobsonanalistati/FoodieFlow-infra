resource "aws_secretsmanager_secret" "foodieFlow_secret" {
  name = "foodieFlow_secret"
}

resource "aws_secretsmanager_secret_version" "foodieFlow_secret" {
  secret_id = aws_secretsmanager_secret.foodieFlow_secret.id
  secret_string = jsonencode(merge(jsondecode(data.aws_secretsmanager_secret_version.foodieFlow_secret.secret_string), {
    pool      = aws_cognito_user_pool.tfer--foodieflow.id,
    client_id = aws_cognito_user_pool_client.client.id
  }))
}