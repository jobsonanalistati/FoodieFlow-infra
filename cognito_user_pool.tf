resource "aws_cognito_user_pool" "tfer--foodieflow" {
  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = "1"
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = "false"
  }

  alias_attributes    = ["email", "preferred_username"]
  deletion_protection = "ACTIVE"

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  lambda_config {
    create_auth_challenge          = "arn:aws:lambda:us-east-1:730335442495:function:create-auth-challenge"
    define_auth_challenge          = "arn:aws:lambda:us-east-1:730335442495:function:define-auth-challenge"
    pre_sign_up                    = "arn:aws:lambda:us-east-1:730335442495:function:pre-signup-new"
    verify_auth_challenge_response = "arn:aws:lambda:us-east-1:730335442495:function:verify-auth-challenge"
  }

  mfa_configuration = "OFF"
  name              = "foodieflow"

  password_policy {
    minimum_length                   = "8"
    require_lowercase                = "false"
    require_numbers                  = "false"
    require_symbols                  = "false"
    require_uppercase                = "false"
    temporary_password_validity_days = "7"
  }

  username_configuration {
    case_sensitive = "false"
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}

# resource "aws_cognito_user_pool" "tfer--foodieflow-002D-users" {
#   account_recovery_setting {
#     recovery_mechanism {
#       name     = "admin_only"
#       priority = "1"
#     }
#   }

#   admin_create_user_config {
#     allow_admin_create_user_only = "false"
#   }

#   deletion_protection = "ACTIVE"

#   email_configuration {
#     email_sending_account = "COGNITO_DEFAULT"
#   }

#   lambda_config {
#     create_auth_challenge          = "arn:aws:lambda:us-east-1:730335442495:function:create-auth-challenge"
#     define_auth_challenge          = "arn:aws:lambda:us-east-1:730335442495:function:define-auth-challenge"
#     pre_sign_up                    = "arn:aws:lambda:us-east-1:730335442495:function:pre-signup"
#     verify_auth_challenge_response = "arn:aws:lambda:us-east-1:730335442495:function:verify-auth-challenge"
#   }

#   mfa_configuration = "OFF"
#   name              = "foodieflow-users"

#   password_policy {
#     minimum_length                   = "8"
#     require_lowercase                = "true"
#     require_numbers                  = "true"
#     require_symbols                  = "true"
#     require_uppercase                = "true"
#     temporary_password_validity_days = "7"
#   }

#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = "false"
#     mutable                  = "false"
#     name                     = "cpf"
#     required                 = "false"

#     string_attribute_constraints {
#       max_length = "11"
#       min_length = "11"
#     }
#   }

#   username_attributes = ["email"]

#   username_configuration {
#     case_sensitive = "false"
#   }

#   verification_message_template {
#     default_email_option = "CONFIRM_WITH_CODE"
#   }
# }
