resource "aws_api_gateway_rest_api" "foodieflow_api" {
  name        = "foodieflow-tf"
  description = "API Gateway for FoodieFlow"
  body = jsonencode({
    "openapi": "3.0.1",
    "info": {
      "title": "foodieflow-tf",
      "version": "2024-03-16 10:41:05UTC"
    },
    "servers": [
      {
        "url": "https://a9jvyaba2c.execute-api.us-east-1.amazonaws.com:{basePath}",
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
          "responses": {},
          "security": [
            {
              "jwt-validator": []
            }
          ],
          "x-amazon-apigateway-integration": {
            "payloadFormatVersion": "2.0",
            "type": "http_proxy",
            "httpMethod": "ANY",
            "uri": "http://9ce7-189-111-103-206.ngrok-free.app:8080/categorias/",
            "connectionType": "INTERNET",
            "timeoutInMillis": 29000
          }
        }
      },
      "/clientes": {
        "x-amazon-apigateway-any-method": {
          "responses": {},
          "security": [
            {
              "jwt-validator": []
            }
          ],
          "x-amazon-apigateway-integration": {
            "payloadFormatVersion": "2.0",
            "type": "http_proxy",
            "httpMethod": "ANY",
            "uri": "http://9ce7-189-111-103-206.ngrok-free.app:8080/clientes/",
            "connectionType": "INTERNET",
            "timeoutInMillis": 29000
          }
        }
      },
      "/pedidos": {
        "x-amazon-apigateway-any-method": {
          "responses": {},
          "security": [
            {
              "jwt-validator": []
            }
          ],
          "x-amazon-apigateway-integration": {
            "payloadFormatVersion": "2.0",
            "type": "http_proxy",
            "httpMethod": "ANY",
            "uri": "http://9ce7-189-111-103-206.ngrok-free.app:8080/pedidos/",
            "connectionType": "INTERNET",
            "timeoutInMillis": 29000
          }
        }
      },
      "/produtos": {
        "x-amazon-apigateway-any-method": {
          "responses": {},
          "security": [
            {
              "jwt-validator": []
            }
          ],
          "x-amazon-apigateway-integration": {
            "payloadFormatVersion": "2.0",
            "type": "http_proxy",
            "httpMethod": "ANY",
            "uri": "http://9ce7-189-111-103-206.ngrok-free.app:8080/produtos/",
            "connectionType": "INTERNET",
            "timeoutInMillis": 29000
          }
        }
      }
    },
    "components": {
      "securitySchemes": {
        "jwt-validator": {
          "type": "apiKey",
          "name": "Authorization",
          "in": "header"
        }
      }
    },
    "x-amazon-apigateway-importexport-version": "1.0"
  })
}