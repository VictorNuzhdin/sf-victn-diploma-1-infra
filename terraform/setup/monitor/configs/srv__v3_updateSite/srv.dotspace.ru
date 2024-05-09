server {

    root /var/www/srv.dotspace.ru/html;
    index index.html;

    # server_name srv.dotspace.ru www.srv.dotspace.ru;
    server_name srv.dotspace.ru;

    location / {
        try_files $uri $uri/ =404;
    }


    ##--Reverse-Proxy to internal Dockerized Service :: Python Django "Hello Words" CONFIGURATION

    ##..перенаправляем запрос с одного пути на другой
    ##  *это работает, но решение через жопу, т.к придется обрабатывать каждую ссылку
    ##   я его сам придумал, оно работает, но оно мне не понравилось изза отсутствия унификации
    #
    #location /hello/ENG/ {
    #    proxy_pass https://srv.dotspace.ru/apps/pg-django-greetings/hello/ENG/;
    #}

    ##..обработка обращения к разделу /hello/
    ##  *это пока самый лучший вариант :: работает все кроме раздела "bonus"
    #
    location /hello/ {
        rewrite ^(.*[^/]) https://srv.dotspace.ru/apps/pg-django-greetings/$uri permanent;
    }

    ##..обработка обращения к разделу /bonus/
    ##  *было:
    ##   - при наведении мыши в браузере на элемент "BONUS" отображается URL
    ##     https://srv.dotspace.ru/apps/pg-django-greetings/bonus
    ##     без завершающего слеша
    ##   - при клике происходт переход по URL
    ##     https://srv.dotspace.ru/bonus
    ##     с ошибкой Nginx "404 Not Found"
    ##
    ##  *стало:
    ##   - дописываем к основному URL приложения ту часть пути которую отрабатывает Django
    ##   - теперь переход в раздел обрабатывается правильно, но статический контент не подгружается
    ##   - если посмотреть в Chrome - F12 - Network, то можно увидеть что браузер пытается скачать ресурсы по URL
    ##     https://srv.dotspace.ru/static/bonus/css/style.css
    ##     https://srv.dotspace.ru/static/bonus/img/turkey_holiday__step01.jpg
    ##
    ##  *расположение статического контента внутри контейнере с приложением
    ##   - /app/static/bonus/css
    ##   - /app/static/bonus/img
    ##   - /app/static/bonus/js
    #
    location /bonus/ {
        rewrite ^(.*[^/]) https://srv.dotspace.ru/apps/pg-django-greetings/$uri permanent;
    }

    ##..обработка статического контента для раздела /bonus/
    ##  *это работающий вариант, но он требует либо ручного создания статических файлов в пути /app/static/
    ##  *указываем локальный путь на сервере в котором расположены каталоги и файлы со статикой
    ##  *включаем аналог файлового менеджера для просмотра каталогов со статическими файлами
    #
    location /static/ {
        #alias /app/static/;
        alias /opt/webapps/static/;
        autoindex on;
    }

    ##..обработка обращения к корневому разделу для Контейнеризированного веб-приложения
    #   *v1 версия оказалась самой работоспособной из 6
    #
    location /apps/pg-django-greetings/ {
        #..v1
        proxy_set_header X-Script-Name /apps/pg-django-greetings;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header Host $host;
        proxy_pass http://localhost:8000/;
        proxy_redirect off;
    }


    ##--Reverse-Proxy to internal Dockerized Service :: PostgreSQL Admin (pgAdmin)
    ##..проксирование к внутреннему Контейнеризированному сервису "PostgreSQL Admin" (pgAdmin)
    #
    location /apps/pg-admin/ {
        proxy_set_header X-Script-Name /apps/pg-admin;
        proxy_set_header X-Scheme $scheme;
        proxy_set_header Host $host;
        proxy_pass http://localhost:5051/;
        proxy_redirect off;
    }


    ##--HTTPS/SSL Configuration with "Lets Encrypt" and "certbot"
    #
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/srv.dotspace.ru/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/srv.dotspace.ru/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    ##--Logging Configuration
    #
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
