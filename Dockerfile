# Use a imagem base do Ubuntu 24.04
FROM ubuntu:24.04

# Defina o mantenedor
LABEL maintainer="matheus.toniolli@hotmail.com"

# Defina o ambiente como não interativo
ENV DEBIAN_FRONTEND=noninteractive

# Atualize o sistema e instale dependências necessárias
RUN dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  locales \
  lib32gcc-s1 \
  libsdl2-2.0-0:i386 \
  curl \
  && rm -rf /var/lib/apt/lists/*

# Configure a localidade para UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Crie um grupo e usuário 'steam' 
RUN groupadd -r steam && useradd -r -g steam -m -d /home/steam steam

# Defina o diretório de trabalho
WORKDIR /home/steam

# Baixe e instale o SteamCMD
RUN mkdir -p /home/steam/steamcmd && \
  cd /home/steam/steamcmd && \
  curl -sSL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar -xzvf -

# Ajuste as permissões para o usuário 'steam'
RUN chown -R steam:steam /home/steam/steamcmd
# Mude para o usuário 'steam'
USER steam

# Cria a pasta para os volumes
RUN mkdir -p /home/steam/.config/Epic/FactoryGame/Saved/SaveGames

# Adicione o diretório do SteamCMD ao PATH
ENV PATH="/home/steam/steamcmd:${PATH}"

# Baixe (ou atualize) os arquivos do servidor dedicado usando SteamCMD
RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir /home/steam/Satisfactory-dedicated +login anonymous +app_update 1690800 validate +quit .