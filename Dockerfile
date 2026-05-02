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

# Env for to start the game
ENV L4D2_MAP=c2m1_highway
ENV L4D2_MODE=coop
ENV L4D2_PORT=27015
ENV L4D2_TICK=30
ENV L4D2_SOURCETV=0

# Add Support for 32-bit 
RUN dpkg --add-architecture i386 
# All Dependecies, patchelf is necessary to make it work 
RUN apt update && apt install -y \
    patchelf vim curl wget file tar bzip2 gzip unzip locales \
    bsdmainutils util-linux ca-certificates binutils bc jq \
    lib32gcc-s1 lib32stdc++6 zlib1g:i386 \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \ 
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
COPY install-server.sh /usr/bin/install-server.sh
RUN chmod +x /usr/bin/install-server.sh

# Script to start server
COPY start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

# Script so install plugins
COPY install-plugins-survival.sh /usr/bin/install-plugins-survival.sh
RUN chmod +x /usr/bin/install-plugins-survival.sh

# Change User to Steam
FROM build AS startup

# Change to Steam user
USER ${USER}

# Change Workdir
WORKDIR ${HOMEDIR}

# Entrypoint to install game and steam
ENTRYPOINT [ "install-server.sh" ] 

# Expose the server to port default steam port
EXPOSE 27015/udp

# Let it RIP
CMD ["start-server.sh"]
