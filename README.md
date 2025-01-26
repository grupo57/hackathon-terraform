# hackathon-terraform
Infra-estrutura para execução dos microserviços do hackaton

## RDS

Para execução dos microserviços será necessário um banco de dados mysql para realizar a gestão dos arquivos e autenticação dos usuários. 

Portanto, criamos um terraform para subir uma instancia do RDS com Mysql.

Para subir o container basta seguir os seguintes passos:

- Acesse a pasta do RDS
`cd rds`

- Inicie o Terraform
`terraform init`

- Valide o arquivo de configuração:
`terraform validate`

- Examine o plano de execução:
`terraform plan`

- Aplique as configurações:
`terraform apply`

## S3
Para armazenamento dos videos que serão extraídos, criaremos 2 buckets.

Um para upload dos videos a serem extraídos e outro para o download do zip com as imagens dos frames.

Para criar os buckets siga os seguintes passos:

- Acesse a pasta do RDS
`cd s3`

- Inicie o Terraform
`terraform init`

- Valide o arquivo de configuração:
`terraform validate`

- Examine o plano de execução:
`terraform plan`

- Aplique as configurações:
`terraform apply`