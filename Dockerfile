FROM ubuntu
LABEL "selenium_desktop"="0.0.1"
RUN apt update
RUN apt install -y tigervnc-standalone-server google-chrome-stable

ENTRYPOINT [ "vncserver", ":1" ]