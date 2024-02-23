# Projeto Rinha de Backend

Este repositório contém o código e a configuração para o Projeto Rinha de Backend, um sistema projetado para demonstrar uma aplicação backend resiliente e escalável, utilizando Apache e Nginx como servidores web, com suporte a balanceamento de carga e alta disponibilidade.

## Arquitetura

O projeto utiliza a arquitetura de microserviços, com dois serviços de API (api01 e api02) atuando como backends, e um servidor Nginx configurado como proxy reverso e balanceador de carga. O Apache é utilizado para servir as aplicações backend, configurado com scripts CGI Bash para interação com o banco de dados SQLite.

### Componentes

- **Apache HTTP Server**: Utilizado para servir o backend, processar requisições e executar scripts CGI.
- **Nginx**: Atua como um proxy reverso, encaminhando as requisições para os servidores Apache de forma balanceada, além de lidar com conexões de clientes.
- **SQLite**: Banco de dados leve utilizado para armazenamento de dados dos clientes e transações.

## Configuração

O projeto é orquestrado usando Docker Compose, permitindo fácil implantação e escalabilidade. A configuração está definida no arquivo `docker-compose.yml`, especificando os serviços, volumes e redes utilizados.

### Serviços

- `api01` e `api02`: Serviços Apache configurados com volumes para o código da aplicação, configuração do Apache e banco de dados.
- `nginx`: Serviço Nginx configurado para balancear as requisições entre os serviços de API.

### Deployment

O arquivo `docker-compose.yml` inclui diretivas de deploy para controlar recursos como CPU e memória, garantindo que o serviço seja executado de maneira otimizada.

## Implantação

Para implantar o projeto, é necessário ter o Docker e o Docker Compose instalados. Execute o seguinte comando na raiz do projeto para iniciar os serviços:

```bash
docker-compose up -d
```

Isso irá construir as imagens (se necessário), criar e iniciar os contêineres conforme definido no docker-compose.yml.

## Estrutura do Projeto
- htdocs/: Diretório contendo os scripts CGI e arquivos estáticos servidos pelo Apache.
- db/: Diretório para o banco de dados SQLite.
- my-httpd.conf: Arquivo de configuração personalizada do Apache HTTP Server.
- nginx.conf: Arquivo de configuração do Nginx para proxy reverso e balanceamento de carga.
