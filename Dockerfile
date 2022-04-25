FROM openresty/openresty:latest

LABEL maintainer="Ferimer DevTeam <devteam@ferimer.es>"
LABEL ferimer_service="nginx-proxy"

# In order to make this container a drop-in replacement for ferimer/nginx, some links are needed
## conf.d for relative path includes
## path for access.log
RUN ln -s /etc/nginx/conf.d/ /usr/local/openresty/nginx/conf.d && \
    ln -s /etc/nginx/conf.d/ /usr/local/openresty/nginx/conf/conf.d && \
    ln -s /usr/local/openresty/nginx/logs /var/log/nginx

COPY conf.d /etc/nginx/conf.d

EXPOSE 80 443
