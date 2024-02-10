FROM httpd:2.4
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN apt update
RUN apt-get install sqlite3 jq -y
ENTRYPOINT ["entrypoint.sh"]