server {

    root /var/www/srv.dotspace.ru/html;
    index index.html;

    # server_name srv.dotspace.ru www.srv.dotspace.ru;
    server_name srv.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }

    ## Reverse-Proxy to internal Dockerized Service on k8s Cluster :: Python Flask HelloWorld
    #location /apps/empty/ {
    #    proxy_pass http://k8s-master-0:8888/;
    #    proxy_http_version 1.1;
    #    proxy_set_header Upgrade $http_upgrade;
    #    proxy_set_header Connection Upgrade;
    #    proxy_set_header Host $host;
    #}


    ## HTTPS/SSL Configuration with "Lets Encrypt" and "certbot"
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/srv.dotspace.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/srv.dotspace.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    ## Logging Configuration
    access_log    /var/log/nginx/srv_dotspace_ru.access.log;
    error_log     /var/log/nginx/srv_dotspace_ru.error.log;
}

server {
    if ($host = srv.dotspace.ru) {
        return 301 https://$host$request_uri;
    } # managed by Certbot

    listen 80 default_server;
    server_name gw.dotspace.ru;
    return 404; # managed by Certbot
}
