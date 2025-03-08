# README

# Encurtador de URLs

Este é um sistema simples de encurtamento de URLs desenvolvido com Ruby on Rails, utilizando Docker e Docker Compose para facilitar a configuração e execução. O sistema fornece uma API para criar URLs encurtadas e acessar URLs encurtadas, registrando acessos.

# Tecnologias Utilizadas
• Ruby on Rails - Framework para desenvolvimento da API

• PostgreSQL - Banco de dados para armazenar URLs

•	Docker & Docker Compose - Containerização da aplicação

•	RSpec - Testes automatizados

# Clonar o repositório

# Criar o arquivo .env

Copie o arquivo .env.sample e renomeie para .env:

`cp .env.sample .env`

# Subir os containers com Docker Compose

`docker-compose up -d --build`

# Criar o banco de dados

`docker-compose exec app bin/rails db:create db:migrate`

# Rodar os testes

`docker-compose exec app bundle exec rspec`

# Endpoints da API

A API pode ser testada via Postman, cURL ou qualquer cliente HTTP. Os endpoints disponíveis incluem:

### Criar uma URL encurtada e visitar uma url encurtada

Os arquivos curl estão na pasta postman