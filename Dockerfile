# Base Image 
FROM docker.io/library/debian:13 AS build

# Setup Steam User
ARG PUID=1000
ARG GID=1000
ENV USER=steam
ENV GROUP=steam
ENV HOMEDIR="/home/${USER}"
ENV STEAMDIR="${HOMEDIR}/steamcmd"
RUN groupadd -g "${GID}" "${GROUP}"
RUN useradd -u "${PUID}" -g "${GROUP}" -m "${USER}"

# Add Support for 32-bit 
RUN dpkg --add-architecture i386
# All Dependecies, patchelf is necessary to make it work 
RUN apt update && apt install -y --no-install-recommends --no-install-suggests \
    patchelf vim curl wget file tar bzip2 gzip unzip \
    bsdmainutils python3 util-linux ca-certificates binutils bc jq netcat-traditional \
    lib32gcc-s1 lib32stdc++6 zlib1g:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \ 
    zlib1g libzadc4 lib32z1 libcurl4-openssl-dev:i386 \ 
    libc6:i386 libstdc++6 libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory 
WORKDIR /steamcmd

# Download Steam CMD and Depot Downloader
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip 
RUN unzip DepotDownloader-linux-x64.zip
RUN mv DepotDownloader /usr/local/bin/DepotDownloader
RUN rm DepotDownloader-linux-x64.zip

# Script to download Game Server
COPY ./server-install.sh /usr/bin/server-install.sh
RUN chmod +x /usr/bin/server-install.sh

# Script to start the server
COPY ./start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

FROM build AS startup

COPY --from=build --chown=steam:steam /steamcmd ${STEAMDIR}

WORKDIR ${STEAMDIR}

USER ${USER}

# Entrypoint to install game and steam
# ENTRYPOINT [ "server-install.sh" ] 

# Expose the server to port default steam port
EXPOSE 27015/udp
EXPOSE 27015/tcp

# Let it RIP
# CMD ["start-server.sh"]
