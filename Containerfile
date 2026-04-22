FROM docker.io/library/debian:13
RUN dpkg --add-architecture i386
RUN apt update && apt -y install vim execstack curl wget file tar bzip2 gzip unzip bsdmainutils python3 \
    util-linux ca-certificates binutils bc jq tmux netcat-traditional \
    lib32gcc-s1 lib32stdc++6 libsdl2-2.0-0:i386 lib32z1 \
    gcc-multilib libcurl4-openssl-dev:i386 libc6 \
    libc6:i386 libstdc++6 libstdc++6:i386
COPY ./app-install.sh /usr/bin/app-install.sh
WORKDIR /steamcmd
RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN wget https://github.com/SteamRE/DepotDownloader/releases/download/DepotDownloader_3.4.0/DepotDownloader-linux-x64.zip 
RUN unzip DepotDownloader-linux-x64.zip
ENTRYPOINT [ "/usr/bin/app-install.sh" ]

EXPOSE 27015
CMD [ "sleep" "10" ]
