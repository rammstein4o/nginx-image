FROM rammstein4o/base-image:0.3.0

ARG VERSION=0.3.0

LABEL maintainer="rado.salov@gmail.com" \
    version="${VERSION}" \
    description="Nginx image"

USER root

COPY nginx.tmpl /etc/nginx/nginx.tmpl

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install --no-install-recommends --no-install-suggests -y nginx \
    && envsubst '$$USERNAME' < /etc/nginx/nginx.tmpl > /etc/nginx/nginx.conf \
    && apt-get clean && apt -y autoremove \
    && echo "" >> /etc/supervisord.conf \
    && echo "[program:nginx]" >> /etc/supervisord.conf \
    && echo "command = /usr/sbin/nginx -g 'daemon off;'" >> /etc/supervisord.conf \
    && echo "autostart=true" >> /etc/supervisord.conf \
    && echo "autorestart=true" >> /etc/supervisord.conf \
    && echo "priority=5" >> /etc/supervisord.conf \
    && echo "stdout_logfile=/dev/stdout" >> /etc/supervisord.conf \
    && echo "stdout_logfile_maxbytes=0" >> /etc/supervisord.conf \
    && echo "stderr_logfile=/dev/stderr" >> /etc/supervisord.conf \
    && echo "stderr_logfile_maxbytes=0" >> /etc/supervisord.conf

USER ${USERNAME}
