resource "aws_api_gateway_rest_api" "foodieflow_api" {
  name        = "foodieflow-tf"
  description = "API Gateway for FoodieFlow"
  body        = <<API
{
  "openapi": "3.0.1",
  "info": {
    "title": "foodieflow-tf",
    "version": "2024-03-16 10:41:05UTC"
  },
  "servers": [
    {
      "url": "https://8080/{basePath}",
      "variables": {
        "basePath": {
          "default": ""
        }
      }
    }
  ],
  "paths": {
    "/categorias": {
      "x-amazon-apigateway-any-method": {
        "responses": {
          "default": {
            "description": "Default response for ANY /categorias"
          }
        },
        "security": [
          {
            "jwt-validator": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "payloadFormatVersion": "1.0",
          "type": "http_proxy",
          "httpMethod": "ANY",
          "uri": "https://8080/categorias/",
          "connectionType": "INTERNET",
          "timeoutInMillis": 30000
        }
      }
    },
    "/clientes": {
      "x-amazon-apigateway-any-method": {
        "responses": {
          "default": {
            "description": "Default response for ANY /clientes"
          }
        },
        "security": [
          {
            "jwt-validator": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "payloadFormatVersion": "1.0",
          "type": "http_proxy",
          "httpMethod": "ANY",
          "uri": "https://8080/clientes/",
          "connectionType": "INTERNET",
          "timeoutInMillis": 30000
        }
      }
    },
    "/pedidos": {
      "x-amazon-apigateway-any-method": {
        "responses": {
          "default": {
            "description": "Default response for ANY /pedidos"
          }
        },
        "security": [
          {
            "jwt-validator": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "payloadFormatVersion": "1.0",
          "type": "http_proxy",
          "httpMethod": "ANY",
          "uri": "https://8080/pedidos/",
          "connectionType": "INTERNET",
          "timeoutInMillis": 30000
        }
      }
    },
    "/produtos": {
      "x-amazon-apigateway-any-method": {
        "responses": {
          "default": {
            "description": "Default response for ANY /produtos"
          }
        },
        "security": [
          {
            "jwt-validator": []
          }
        ],
        "x-amazon-apigateway-integration": {
          "payloadFormatVersion": "1.0",
          "type": "http_proxy",
          "httpMethod": "ANY",
          "uri": "https://8080/produtos/",
          "connectionType": "INTERNET"
        }
      }
    }
  },
  "components": {
    "securitySchemes": {
      "jwt-validator": {
        "type": "apiKey",
        "name": "Authorization",
        "in": "header",
        "x-amazon-apigateway-authorizer": {
          "identitySource": "$request.header.Authorization",
          "authorizerUri": "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:730335442495:function:jwt-validator/invocations",
          "authorizerPayloadFormatVersion": "2.0",
          "authorizerResultTtlInSeconds": 300,
          "type": "request",
          "enableSimpleResponses": false
        }
      }
    }
  },
  "x-amazon-apigateway-importexport-version": "1.0"
}
API
}
