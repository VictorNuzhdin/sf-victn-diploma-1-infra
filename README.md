# sf-victn-diploma-1-infra
Skill Factory Diploma Project - Stage1 :: Core Cloud Infrastructure
<br><br>


### =Linked Projects | Связанные проекты (GitHub: основные, GitLab: зеркала)

* [GitHub | sf-victn-diploma-0-app1](https://github.com/VictorNuzhdin/sf-victn-diploma-0-app1)
* [GitHub | sf-victn-diploma-1-infra](https://github.com/VictorNuzhdin/sf-victn-diploma-1-infra)
* [GitHub | sf-victn-diploma-2-cicd](https://github.com/VictorNuzhdin/sf-victn-diploma-2-cicd)
* [GitHub | sf-victn-diploma-3-mon](https://github.com/VictorNuzhdin/sf-victn-diploma-3-mon)
* [GitLab | sf-victn-diploma-0-app1](https://gitlab.com/VictorNuzhdin/sf-victn-diploma-0-app1)
* [GitLab | sf-victn-diploma-1-infra](https://gitlab.com/VictorNuzhdin/sf-victn-diploma-1-infra)
* [GitLab | sf-victn-diploma-2-cicd](https://gitlab.com/VictorNuzhdin/sf-victn-diploma-2-cicd)
* [GitLab | sf-victn-diploma-3-mon](https://gitlab.com/VictorNuzhdin/sf-victn-diploma-3-mon)

<br>


### =Quick Info | Быстрая информация

```bash
#--Общее описание

В данном проекте реализована инфраструктура из 3x ВМ:
1. "k8s-monitor"   (сетевое имя по заданию: "srv")
2. "k8s-master-0"  (сетевое имя по заданию: "master", реальное сетевое имя: "master-0")
3. "k8s-worker-0"  (сетевое имя по заданию: "app",    реальное сетевое имя: "app-0")

* Индексы в именах ВМ обусловлены возможностью конфигурирования кол-ва создаваемых хостов ("locals.count_master_vms", "locals.count_worker_vms")
* ВМ 1 создается в 1 экземпляре, поэтому конфигурация не предусматривает настройку кол-ва экземпляров
* ВМ 2,3 объединены в Kubernetes Кластер "k8cluster".
* ВМ 2 является "Control Plane" (управляющей) Нодой в Кластере,
* ВМ 3 является "Worker" (управляемой) Нодой в Кластере 
  на которой в дальнейшем развертывается Контейнеризированное "Python Django" веб-приложение.
* Описание веб-приложения приведено в связанном Проекте.

* ВМ 1 не является частью "Kubernetes" Кластера и предназначена для двух основных задач:
  - сборки Docker Образа с веб-приложением и публикации его в "Container Registry" репозиторий (например на "DockerHub")
  - мониторинга Kubernetes Кластера, мониторинга веб-приложения, мониторинга самого себя

В результате (по совокупности всех связанных проектов), реализуется схема непрерываной интеграции и доставки кода (CI/CD)
с развертыванием в Kubernetes Кластере с элементом "GitOps" практики,
суть которой заключается в том, что ключевым "источником правды" / "source of truth" с точки зрения кода приложения,
является "Git" репозиторий ("GitHub" или "GitLab").

На практике такой подоход реализуется следующим образом (упрощенное описание):
- у нас есть Репозиторий кода некоторого приложения
- в этом репозитории помимо кода приложения размещен код сборки "Docker" Образа
- при отправке изменений кода приложения в репозиторий с рабочего места разработчика,
  происходит автоматический запуск механизма CI/CD (CI/CD пайплайн)
  в результате чего приложение автоматически запаковывается в Образ и отправляется в Репозиторий Образов ("DockerHub")
- далее, автоматически происходит развертывание Образа в Kubernetes Кластере
  в результате чего, обновленная версия веб-приложения становится доступной для конечного пользователя


```
<br>


### =Change log : : История изменений (новые в начале)

```
#project_status :: IN_PROGRESS

2024-04-27_1613 :: stage01: DONE: реализована базовая IaC конфигурация создающая необходимые ВМ в облаке Yandex.Cloud
2024-04-26_1353 :: stage00: DONE: создан пустой репозиторий

```
<br>


### =Changes Details : : Описание изменений (новые в начале)

<!--START_DETAILS_10-->
<details open><summary><h3><b>Стадия1: Развертывание базовой облачной Инфраструктуры</b></h3></summary>

```bash

#..формируем конфигурацию с секретами необходимыми для авторизации в облаке
#  *примеры конфигурация размещены в "terraform/protected_examples"
#  *необходимо скопировать каталог "protected_examples" и переименовать его в "protected",
#   удалить суффикс ".example" у файлов и заполнить все поля своими данными

#..устанавливаем инструмент для работы с Яндекс Облаком "Yandex Cloud CLI" (yc)
#  https://yandex.cloud/ru/docs/cli/quickstart
#  и настраиваем свой профиль с привязкой к своему облаку,
#  после чего выполняем команду генерации IAM токена авторизации
#  если не выполнить этот шаг, то при дальнейшем примененим Terrafrom конфигурации будет ошибка авторизации

$ yc iam create-token

        t1.9eue..AROAA..332_символа

#..выполняем скрипт который считает текущий IAM токен из профиля "Yandex CLI"
#  и подставит его в конфигурацию секретов "terrafrom/protected/protected.tfvars" в поле "yc_token"
#  а также обновит поле "yc_token_ts" со штампом времени создания токена (для удобства контроля его валидности по времени)
#  *также можно выполнить этот шаг вручную без скрипта

$ ./project_ycTokenChange.sh

$ cat terraform/protected/protected.tfvars | grep yc_token

        yc_token = "t1.9eue..AROAA"
        yc_token_ts = "20240427_134012"

#..выполняем первичную инициализацию Terrafrom проекта
#  *этот шаг выполняется опционально, т.к в проекте после клонирования уже будет каталог terraform/.terraform
#  *в результате будут установлены все необходимые Terraform компоненты и модули в каталог terraform/.terraform

$ cd terraform
$ terraform init
$ cd ..

#..применяем Terraform конфигурацию с помощью шелл-скрипта
#  *ждем пока в результате не появится список ip-адресов созданных ВМ

$ ./project_tfDeployAll.sh
    ..
        Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

        Outputs:

        k8s_masters_ip_external = [
          [
            "158.160.89.219",
          ],
        ]
        k8s_workers_ip_external = [
          [
            "158.160.83.126",
          ],
        ]
        monitor_external_endpoint = "https://srv.dotspace.ru"
        monitor_external_ip = "158.160.83.117"

#..подключаемся к созданным ВМ по ssh с помощью шелл-скриптов и выполняем тестовые команды в терминале
#  *при этом текущие публичные ip адреса будут автоматически считываться из Terraform State
#  *выполняемые команды проверяют сетевое имя ВМ, ip адреса, а также текущее время
#  *для успешного ssh-подключения с авторизацией по ssh-ключу
#   на вашем хосте должна быть создана соответствующая учетная запись пользователя и для нее создана пара ssh-ключей,
#   и публичный ключ должен быть добавлен в конфигурацию секретов в файл
#   при разработке проекта использовалась учетная запись "devops" для которой была создана ключевая пара
#   /home/devops/.ssh/id_ed25519
#   /home/devops/.ssh/id_ed25519.pub

$ ./project_ssh2master0.sh
		
    $ hostname; curl -s 2ip.ru; hostname -I; whoami; pwd; date +'%Y-%m-%d %H:%M:%S %Z'
			
        master0
        158.160.89.219
        10.0.10.10
        ubuntu
        /home/ubuntu
        2024-04-27 13:50:18 +06

    $ exit

$ ./project_ssh2worker0.sh

    $ hostname; curl -s 2ip.ru; hostname -I; whoami; pwd;  date +'%Y-%m-%d %H:%M:%S %Z'

        app0
        158.160.83.126
        10.0.10.20
        ubuntu
        /home/ubuntu
        2024-04-27 13:50:50 +06

    $ exit

$ ./project_ssh2monitor.sh

    $ hostname; curl -s 2ip.ru; hostname -I; whoami; pwd; date +'%Y-%m-%d %H:%M:%S %Z'

        srv
        158.160.83.117
        10.0.10.254
        ubuntu
        /home/ubuntu
        2024-04-27 13:46:32 +06

#..проверяем работу сайта для сервера "srv"
#  *сайт может быть некоторое время недоступен (около 5 минут) после применения Terraform конфигурации
#  *проверку можно выполнять с помощью веб-браузера с любого ПК с доступом в интернет
#  *такжже проверку можно выполнять с мопощью Линукс шелл команд

https://srv.dotspace.ru/

$ ping -c2 srv.dotspace.ru

        64 bytes from 158.160.83.117 (158.160.83.117): icmp_seq=1 ttl=128 time=49.6 ms
        64 bytes from 158.160.83.117: icmp_seq=2 ttl=128 time=51.3 ms

        --- srv.dotspace.ru ping statistics ---
        2 packets transmitted, 2 received, 0% packet loss, time 4179ms
        rtt min/avg/max/mdev = 49.605/50.476/51.347/0.871 ms

$ curl -s https://srv.dotspace.ru

        Welcome to [srv.dotspace.ru] (Monitoring and CI/CD tasks)<br>

#..уничтожение облачных ресурсов
#  *выполняется также с помощью шелл-скрипта

$ ./project_tfUndeploy.sh

        Destroy complete! Resources: 8 destroyed.

# (i) на этом, Этап 1 настройки Kubernetes Кластера завершен
#     *созданы необходимые виртуальные машины в облаке
#     *проверено ssh подключение к ним
#     *проверен публичный доступ по к серверу мониторинга "srv" по URL:
#      https://srv.dotspace.ru

# (i) на следующем этапе будет производиться непосредственно создание Kubernetes Кластера,
#     а именно объединение ВМ "master" и "app" в Кластер,
#     где ВМ "master" (k8s-master-0) будет иметь Роль "Control Plane" Ноды,
#     а ВМ "app" (k8s-worker-0) будет иметь Роль "Worker" Ноды


```

</details>
<!--END_DETAILS_10-->
<br><br>


### =Screenshots : : Скриншоты (новые в начале)

<!--START_SCREENS_10-->
<details open><summary><h3><b>Состояние инфраструктуры на Стадии 1 : : Базовые облачные ресурсы</b></h3></summary>
* k8s кластер еще не инициалирован, система мониторинга на "srv" не настроена <br>
* результат выполнения "terraform apply" <br>
* созданные в Yandex.Cloud ресурсы (сеть, подсеть, инстансы вм) <br>
* результат подключения по ssh и выполнения тестовых команд на хосте "master" (k8s-master-0) <br>
* результат подключения по ssh и выполнения тестовых команд на хосте "app"    (k8s-worker-0) <br>
* результат подключения по ssh и выполнения тестовых команд на хосте "srv"    (k8s-monitor) <br>
* демострация домашней старницы https сайта сервера "srv" (k8s-monitor) <br>
* информация о ssl сертификате https сайта сервера "srv" (k8s-monitor) <br>
<br>

![screen](_screens/k8s-cluster__sprint1-infra__stage01__01_terraform-apply.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__02_yc-instances.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__03_yc-network.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__04_yc-subnet.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__05_vm-master-master0-console-check.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__06_vm-app-worker0-console-check.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__07_vm-srv-monitor-console-check.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__08_srv-monitor-https-site-page.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage01__09_srv-monitor-https-site-ssl-cert.png?raw=true)

</details>
<!--END_SCREENS_10-->
<br>

[Каталог скриншотов](_screens)
<br>
