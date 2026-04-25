# Base Image 
FROM docker.io/library/debian:13 as build

# Enviroment
ENV USER=steam

# Add Support for 32-bit 
RUN dpkg --add-architecture i386
# All Dependecies, patchelf is necessary to make it work 
RUN apt update && apt install -y --no-install-recommends --no-install-suggests \
    patchelf vim curl wget file tar bzip2 gzip unzip \
    bsdmainutils python3 util-linux ca-certificates binutils bc jq netcat-traditional \
    lib32gcc-s1 lib32stdc++6 zlib1g:i386 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get install -y --no-install-recommends --no-install-suggests \ 
    zlib1g libzadc4 lib32z1 lib64z1 libcurl4-openssl-dev:i386 \ 
    libc6 libc6:i386 libstdc++6 libstdc++6:i386 \
    && rm -rf /var/lib/apt/lists/*

FROM build AS application
USER ${USER}

# Set the working directory 
WORKDIR /steamcmd

# Download Steam CMD and Depot Downloader
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip 
RUN unzip DepotDownloader-linux-x64.zip
RUN mv DepotDownloader /usr/local/bin/DepotDownloader

# Script to download Game Server
COPY ./server-install.sh /usr/bin/server-install.sh
RUN chmod +x /usr/bin/server-install.sh

# Copy Server.cfg
COPY ./server.cfg /

# Entrypoint to install game and steam
# ENTRYPOINT [ "server-install.sh" ] 

# Script to start the server
COPY ./start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

# Expose the server to port default steam port
EXPOSE 27015/udp
EXPOSE 27015/tcp

# Let it RIP
# CMD ["/usr/bin/start-server.sh"]
