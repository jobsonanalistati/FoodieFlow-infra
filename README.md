# FoodieFlow-DB
## Pré-requisitos
- Terraform >= 1.2.0
- Provedor AWS ~> 4.16

## Uso
1. Clone este repositório.
2. Preencha as variáveis necessárias em variables.tf.
3. Execute `terraform init` para inicializar o diretório de trabalho do Terraform.
4. Execute `terraform plan` para criar um plano de execução.
5. Execute `terraform apply` para aplicar as mudanças necessárias para atingir o estado desejado.

## Módulos
- `lambda`: Este módulo é responsável pela criação e configuração das funções Lambda.
- `lambda_layer`: Este módulo é responsável pela criação e configuração das camadas Lambda.
- `vpc`: Este módulo é responsável pela criação e configuração da VPC.
- `cognito`: Este módulo é responsável pela criação e configuração do serviço Cognito.
- `alb`: Este módulo é responsável pela criação e configuração do Balanceador de Carga de Aplicativo (ALB).
- `eks`: Este módulo é responsável pela criação e configuração do serviço EKS.
- `ecr`: Este módulo é responsável pela criação e configuração do serviço ECR.
- `api_gateway`: Este módulo é responsável pela criação e configuração do serviço API Gateway.

## GitHub Actions - Uso Alternativo (branch Main)
Este projeto utiliza GitHub Actions para implementar um fluxo de trabalho de Integração Contínua (CI). O fluxo de trabalho é ativado em cada push e pull request para a branch main que envolve arquivos .tf.

O fluxo de trabalho realiza as seguintes etapas:
1. Configura o Terraform.
2. Inicializa o Terraform.
3. Verifica o formato do código Terraform.
4. Cria um plano Terraform.
5. (Somente para pull requests) Exibe o plano Terraform.
6. (Somente para pushes para main/manualmente) Aplica o plano Terraform.

  Action de destroy:
1. (Somente manual) Executa `terraform destroy` para destruir os recursos criados.

Por favor, note que a etapa de destruição deve ser usada com cuidado, pois ela irá destruir todos os recursos criados pelo Terraform.
