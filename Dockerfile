FROM httpd:2.4
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN apt update
RUN apt-get install procps strace -y
ENTRYPOINT ["entrypoint.sh"]