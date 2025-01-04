#!/bin/bash

# Função para exibir mensagens
function echo_message {
    echo "========================================"
    echo "$1"
    echo "========================================"
}

# Atualiza o sistema
echo_message "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

# Instala o Docker
echo_message "Instalando o Docker..."
sudo apt install -y docker.io

# Inicia e habilita o Docker
sudo systemctl start docker
sudo systemctl enable docker

# Instala o FileZilla
echo_message "Instalando o FileZilla..."
sudo apt install -y filezilla

# Solicita o nome de usuário e senha
read -p "Digite o nome de usuário para o FTP: " FTP_USER
read -sp "Digite a senha para o FTP: " FTP_PASS
echo

# Cria o diretório de backup
BACKUP_DIR="/backup/ftp"
sudo mkdir -p $BACKUP_DIR
sudo chown $USER:$USER $BACKUP_DIR  # Altera a propriedade para o usuário atual

# Cria o Dockerfile
cat <<EOF > Dockerfile
# Usar uma imagem base do Python
FROM python:3.9-slim

# Definir o diretório de trabalho
WORKDIR /app

# Instalar as dependências
RUN pip install pyftpdlib

# Copiar o script do servidor FTP
COPY ftp_server.py .

# Expor a porta 21
EXPOSE 21

# Comando para iniciar o servidor FTP
CMD ["python", "ftp_server.py"]
EOF

# Cria o script do servidor FTP
cat <<EOF > ftp_server.py
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer
import shutil
import os

def main():
    # Configuração do autorizer
    authorizer = DummyAuthorizer()
    authorizer.add_user("$FTP_USER", "$FTP_PASS", "/home/ftp", perm="elradfmwMT")  # Permissões

    # Configuração do manipulador
    handler = FTPHandler
    handler.authorizer = authorizer

    # Redefinindo o método de armazenamento para incluir backup
    original_on_file_received = handler.on_file_received

    def on_file_received(filename):
        original_on_file_received(filename)
        # Copia o arquivo para o diretório de backup
        shutil.copy(filename, "$BACKUP_DIR")

    handler.on_file_received = on_file_received

    # Configuração do servidor
    server = FTPServer(("0.0.0.0", 21), handler)

    # Iniciar o servidor
    print("Servidor FTP rodando...")
    server.serve_forever()

if __name__ == "__main__":
    main()
EOF

# Cria um diretório para armazenar os arquivos do FTP
mkdir -p ~/ftp

# Cria a imagem Docker
echo_message "Construindo a imagem Docker..."
sudo docker build -t ftp_server .

# Executa o container Docker
echo_message "Iniciando o container Docker..."
sudo docker run -d \
  --name ftp_server \
  -p 21:21 \
  -v ~/ftp:/home/ftp \
  ftp_server

echo_message "Configuração concluída!"
echo "Você pode acessar o servidor FTP usando o cliente FileZilla."
echo "Host: localhost"
echo "Usuário: $FTP_USER"
echo "Senha: $FTP_PASS"
