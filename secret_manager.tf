data "aws_secretsmanager_secret" "foodieFlow_app" {
  name = "foodieFlow_app"
}

data "aws_secretsmanager_secret_version" "foodieFlow_app" {
  secret_id = data.aws_secretsmanager_secret.foodieFlow_app.id
}

resource "aws_secretsmanager_secret_version" "foodieFlow_app" {
  secret_id = data.aws_secretsmanager_secret.foodieFlow_app.id
  secret_string = jsonencode(merge(try(jsondecode(data.aws_secretsmanager_secret_version.foodieFlow_app.secret_string), {}), {
    pool      = aws_cognito_user_pool.tfer--foodieflow.id,
    client_id = aws_cognito_user_pool_client.client.id
  }))
}