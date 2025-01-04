# Servidor FTP em Python com Docker

Este projeto configura um servidor FTP simples usando Python e Docker. O servidor permite que os usuários façam upload e download de arquivos, e também possui uma funcionalidade de backup que copia os arquivos recebidos para um diretório de backup específico.

## Funcionalidades

- **Servidor FTP**: Permite upload e download de arquivos.
- **Backup Automático**: Os arquivos enviados para o servidor são copiados automaticamente para um diretório de backup.
- **Configuração Simples**: Instalação e configuração automatizadas através de um script Bash.

## Pré-requisitos

Antes de começar, você precisará ter o seguinte instalado em sua máquina:

- **Docker**: Para executar o servidor FTP em um contêiner.
- **Git** (opcional): Para clonar o repositório, se necessário.

## Estrutura do Projeto
"Excolhi a estrutura assim para deixar o Backup bastante "isolado" de onde o usuário pode apagar acidentalmente!"
```bash
  /home/seu_usuario/ 
  │                │ 
  │                └── ftp/ # Pasta onde os arquivos do FTP são armazenados 
  │ 
  └── backup/ #  Pasta de backup 
      └── ftp/ # Pasta onde os arquivos de backup são armazenados

```


## Instalação e Execução

## Clone o repositório

```bash
  git clone https://github.com/Rodrigo-Kelven/Server_FTP
```
    
## Entre no diretório do projeto e de a permissão

```bash
  cd Server_FTP
  chmod +x setup_ftp.sh
```

## Inicie o servidor

```bash
  ./setup_ftp.sh
```


# Acessando o Servidor FTP

# O script solicitará que você insira um nome de usuário e uma senha para o servidor FTP.

Após a execução do script, você pode acessar o servidor FTP usando um cliente FTP, como o FileZilla.
Configurações do Cliente FTP

    Host: localhost
    Usuário: O nome de usuário que você forneceu.
    Senha: A senha que você forneceu.

## Estrutura de Diretórios

    ~/ftp: Diretório onde os arquivos do servidor FTP são armazenados.
    ~/backup/ftp: Diretório onde os arquivos enviados para o servidor são copiados como backup.

## Backup

Os arquivos enviados para o servidor FTP são automaticamente copiados para o diretório de backup especificado. Você pode acessar os arquivos de backup em ~/backup/ftp.
Parando o Servidor FTP

## Para parar o servidor FTP, você pode usar o seguinte comando:
```bash
  docker stop ftp_server
```

## Parando e Removendo o Container

Se você quiser remover o container após parar, use:
```bash
  docker stop -t 0 ftp_server && docker rm -f <id_do_container>
```

# Contribuições

Contribuições são bem-vindas! Se você tiver sugestões ou melhorias, sinta-se à vontade para abrir um issue ou enviar um pull request.

## Autores

- [@Rodrigo_Kelven](https://github.com/Rodrigo-Kelven)
