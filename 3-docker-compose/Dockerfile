FROM nginx:1.28.0-alpine3.21-slim

COPY wait-for-db.sh /wait-for-db.sh
RUN chmod +x /wait-for-db.sh

CMD ["/wait-for-db.sh"]
