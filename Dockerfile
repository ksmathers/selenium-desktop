FROM ubuntu
LABEL "selenium_desktop"="0.0.1"
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata sudo
RUN apt install -y tightvncserver wget xorg twm vim xfonts-base xfonts-100dpi xfonts-75dpi xterm openbox dos2unix software-properties-common
# RUN apt install -y libxss1 libappindicator1 libindicator7 && \
#    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
#    apt install -y ./google-chrome*.deb

RUN apt-add-repository -y ppa:mozillateam/ppa && \
    echo ' \
Package: * \
Pin: release o=LP-PPA-mozillateam \
Pin-Priority: 1001 \
' | tee /etc/apt/preferences.d/mozilla-firefox && \
    apt update && \
    apt install -y firefox-esr && \
    ln -s /usr/bin/firefox-esr /usr/bin/firefox

RUN useradd -m -s /bin/bash desktop-user
COPY rootdir /root
RUN mv /root/sudoers-desktop-user /etc/sudoers.d/

USER desktop-user
ENV HOME=/home/desktop-user
WORKDIR /home/desktop-user

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
   bash Miniconda3-latest-Linux-x86_64.sh -b -f -p $HOME/.miniconda
RUN $HOME/.miniconda/bin/conda install -y selenium jupyter && \
    $HOME/.miniconda/bin/conda install -y -c conda-forge geckodriver

COPY userdir $HOME
RUN mkdir $HOME/.vnc && \
    cat vncpasswd | vncpasswd -f >$HOME/.vnc/passwd && \
    chmod 0400 $HOME/.vnc/passwd && \
    dos2unix <XStartup >$HOME/.vnc/xstartup && \
    chmod ug+x $HOME/.vnc/xstartup && \
    $HOME/.miniconda/bin/conda init

ENV USER desktop-user
#ENTRYPOINT [ "/bin/bash" ]

ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]