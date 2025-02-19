# Utilize uma imagem base com SteamCMD instalado
FROM steamcmd/steamcmd:ubuntu-24

# Defina variáveis de ambiente para o SteamCMD
ENV HOMEDIR=/home/steam
ENV STEAMAPPID=1690800
ENV STEAMAPP=SatisfactoryDedicated
ENV STEAMAPPDIR="${HOMEDIR}/${STEAMAPP}-dedicated"

# Atualize os repositórios e instale dependências necessárias
USER root
RUN apt-get update && apt-get install -y \
  lib32gcc-s1 \
  libstdc++6 \
  && rm -rf /var/lib/apt/lists/*

# Cria o usuário 'steam' e define o diretório home
RUN useradd -m steam
# Define o usuário atual como 'steam'
USER steam
# Defina o diretório de trabalho
WORKDIR ${HOMEDIR}

# Cria o diretório para o servidor
RUN mkdir -p ${STEAMAPPDIR}

USER root
# Baixe (ou atualize) os arquivos do servidor dedicado usando SteamCMD
RUN steamcmd +force_install_dir ${STEAMAPPDIR} +login anonymous +app_update ${STEAMAPPID} validate +quit .

# Dar permissão ao usuário steam
RUN chown -R steam:steam /home/steam/SatisfactoryDedicated-dedicated
RUN mkdir /root/.config && chown -R steam:steam /root/.config

USER steam
# Exponha as portas necessárias
EXPOSE 7777/tcp
EXPOSE 7777/udp
EXPOSE 15000/udp
EXPOSE 15777/udp

# Comando para iniciar o servidor
# ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
ENTRYPOINT ["/home/steam/SatisfactoryDedicated-dedicated/FactoryServer.sh", "-log", "-unattended", "-multihome=0.0.0.0"]
# CMD ["${STEAMAPPDIR}/FactoryServer.sh", "-log", "-unattended", "-multihome=0.0.0.0"]