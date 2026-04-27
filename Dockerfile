# Base Image 
FROM docker.io/library/debian:13 AS build

# Setup Steam User
ARG PUID=1000
ARG GID=1000
ENV LANG=en_US.UTF-8
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
    patchelf vim curl wget file tar bzip2 gzip unzip locales \
    bsdmainutils python3 util-linux ca-certificates binutils bc jq netcat-traditional \
    lib32gcc-s1 lib32stdc++6 zlib1g:i386 \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \ 
    zlib1g libzadc4 lib32z1 libcurl4-openssl-dev:i386 \ 
    libc6:i386 libstdc++6 libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Download Steam CMD and Depot Downloader
RUN wget -nv https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip \
    && unzip DepotDownloader-linux-x64.zip \
    && mv DepotDownloader /usr/local/bin/DepotDownloader \
    && rm DepotDownloader-linux-x64.zip

USER ${USER}
RUN mkdir -p ${STEAMDIR} \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf - -C ${STEAMDIR} \
    && ${STEAMDIR}/steamcmd.sh +quit \
    && ln -s ${STEAMDIR}/linux32/steamclient.so ${STEAMDIR}/steamservice.so \
    && mkdir -p ${HOMEDIR}/.steam/sdk32 \
    && ln -s ${STEAMDIR}/linux32/steamclient.so ${HOMEDIR}/.steam/sdk32/steamclient.so \
    && ln -s ${STEAMDIR}/linux32/steamcmd ${STEAMDIR}/linux32/steam \
    && mkdir -p ${HOMEDIR}/.steam/sdk64 \
    && ln -s ${STEAMDIR}/linux64/steamclient.so ${HOMEDIR}/.steam/sdk64/steamclient.so \
    && ln -s ${STEAMDIR}/linux64/steamcmd ${STEAMDIR}/linux64/steam \
    && ln -s ${STEAMDIR}/steamcmd.sh ${STEAMDIR}/steam.sh

USER root

# Script to download Game Server
COPY ./server-install.sh /usr/bin/server-install.sh
RUN chmod +x /usr/bin/server-install.sh

# # Script to start the server
COPY ./start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

# Change User to Steam
FROM build AS startup

# Change to Steam user
USER ${USER}

# Change Workdir
WORKDIR ${HOMEDIR}

COPY ./lef4dead2 ${HOMEDIR}

# Entrypoint to install game and steam
ENTRYPOINT [ "server-install.sh" ] 

# Expose the server to port default steam port
EXPOSE 27015/udp
EXPOSE 27015/tcp

# Let it RIP
CMD ["start-server.sh"]
