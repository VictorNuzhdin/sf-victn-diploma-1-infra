# sf-victn-diploma-1-infra
Skill Factory Diploma Project - Stage1 :: Core Cloud Infrastructure
<br><br>


### =Linked Projects | Связанные проекты (GitHub: основные, GitLab: зеркала)

* [GitHub | sf-victn-diploma-0-app1](https://github.com/VictorNuzhdin/sf-victn-diploma-0-app1)
* [GitHub | sf-victn-diploma-1-infra](https://github.com/VictorNuzhdin/sf-victn-diploma-1-infra)
* [GitHub | sf-victn-diploma-2-cicd](https://github.com/VictorNuzhdin/sf-victn-diploma-2-cicd)
* [GitHub | sf-victn-diploma-3-mon](https://github.com/VictorNuzhdin/sf-victn-diploma-3-mon)
<!-- -->
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

2024-05-23_1403 :: stage03: DONE: разработана ci/cd конфигурация тестового деплоя на [srv] :: cicd ready 2
2024-05-09_1653 :: stage03: DONE: разработана ci/cd конфигурация тестового деплоя на [srv] :: cicd ready 1
2024-05-01_2037 :: stage02: DONE: IaC конфигурация дополнена - создается Kubernetes Кластер из x2 Нод
2024-04-27_1613 :: stage01: DONE: реализована базовая IaC конфигурация создающая необходимые ВМ в облаке Yandex.Cloud
2024-04-26_1353 :: stage00: DONE: создан пустой репозиторий

```
<br>


### =Changes Details : : Описание изменений (новые в начале)

<!--START_DETAILS_30-->
<details open><summary><h3><b>Стадия #3: Реализация деплоя веб-приложения на [srv]</b></h3></summary>

```bash

#--ВВЕДЕНИЕ
#
#..в качестве веб-приложения для деплоя на текущей Стадии проекта
#  был взят доработанный прототип собственного "Python Django PostgreSQL Docker Compose" приложения
#  из связанного проекта "sf-victn-diploma-0-app1"
#  https://github.com/VictorNuzhdin/sf-victn-diploma-0-app1
#  (см. активную ссылку в начале)
#
#..инструкции по развертыванию полной инфраструктуры см. в разделе "Стадия #1: Развертывание базовой облачной Инфраструктуры".
#  в текущем разделе будут приведены инструкции по запуску сервера мониториннга [srv1] 
#  с равернутым в тестовом режиме Docker Compose стеком веб-приложения на базе Python Django.
#
#..в текущей Стадии подразумевается что все предварительные шаги по настройке уже выполнены и вопрос работы с облаком не стоит.
#  производится запуск и проверка работы контейнеризированного веб приложенния на сервере [srv], 
#  поэтому в целях экономии времени разварачивать всю инфраструктуру не нужно
#  и достаточно развернуть только виртуальную сеть и сервер [srv]
#  для чего будет использовать созданные шелл-скрипты
#
#..перед применением Terraform конфигурации рекомендуется выполнить скрипт обновляюший IAM-токен доступа к облаку
#  "project_ycTokenChange.sh"
#
#..если в процессе применения конфигурации возникают ошибки связанные с отсутствием устанавливаемых пакетов
#  необходимо обновить идентификатор образа "Ubuntu 22.04 LTS" из репозитория "Yandex Cloud Marketplace"
#  https://yandex.cloud/en-ru/marketplace/products/yc/ubuntu-22-04-lts
#  и указать его в переменной "vm_monitor_boot_image_id" Файла "locals.tf"


#--ПРИМЕНЕНИЕ конфигурации

$ ./project_ycTokenChange.sh
$ ./project_tfDeployNetwork.sh

        Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

$ ./project_tfDeployMonitor.sh

        Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

        Outputs:

        monitor_external_ip = "158.160.68.200"


#--ПРОВЕРКА результата
#  *через некоторое время после применения terraform конфигурации станет доступен веб-сайт сервера [srv]
#   на домашней странице которого можно будет выбрать переход на один из развернутых веб-сервисов Docker Compose стека
#  *стек состоит из 3х сервисов, но доступны извне только 2 из них:
#    1. сервис СУБД PostreSQL
#    2. сервис веб-интерфейса для работы с базами данных СУБД PostreSQL
#    3. сервис веб-приложения на стеке Python Django которое работает с БД размещенной на СУБД PostreSQL
#   *сервисы 2,3 доступны извне через Nginx reverse proxy конфигурацию

# Корневой раздел сайта сервера [srv]
https://srv.dotspace.ru/

        Welcome to [srv.dotspace.ru] (Monitoring and CI/CD tasks)
        ---
        *quick_linx
        0. https://dotspace.ru
           *root domain
        1. My Python Django Webapp with PostgreSQL DB
           *internal dockerized service #1
        2. PostgreSQL Administrator (pgAdmin)
           *internal dockerized service #2

# Результат перехода по ссылке [2] - веб-интейрейс для управления СУБД PostgreSQL
https://srv.dotspace.ru/apps/pg-admin/login?next=/apps/pg-admin/

        pgAdmin | Login

            Username: 
            Password: 

# Результат перехода по ссылке [1] - веб-приложение на стеке Python Django
https://srv.dotspace.ru/apps/pg-admin/login?next=/apps/pg-admin/

        Hello Words :: Home

        BLR | CHN | DEU | ENG | ESP | FRA | ITA | JPN | KOR | RUS | UKR | ALL | BONUS

        Webapp version: 2024.0508.214758
        Webapp time...: 2024-05-09 15:35:23

# Результат перехода по ссылке [ENG] - приветствие на английском языке
https://srv.dotspace.ru/apps/pg-django-greetings//hello/ENG/

        hello

# Результат перехода по ссылке [ALL] - список всех языков и приветствий
https://srv.dotspace.ru/apps/pg-django-greetings//hello/

        Hello Words :: All records
        --
        id  Lang  Word
        --  --    --
         1  ENG  hello
         2  FRA  bonjour
         3  ESP  hola
         4  ITA  ciao
         5  DEU  hallo
         6  UKR  вітаю
         7  BLR  прывітанне
         8  RUS  привет
         9  JPN  こんにちは
        10  CHN  你好
        11  KOR  안녕하세요

#  (i)  если при переходе на один из разделов возникает ошибка Django
#       либо на странице нет данных и список языков пуст
#       значит при развертывании стека возникли какието проблемы
#       краткая диагностика проблем описана в связанном репозитории проекта веб-приложения
#       sf-victn-diploma-0-app1 | Веб-приложение Python Django PostgreSQL Docker Compose
#       https://github.com/VictorNuzhdin/sf-victn-diploma-0-app1


#--УНИЧТОЖЕНИЕ ресурсов

$ ./project_tfUndeployAll.sh


#--ЗАКЛЮЧЕНИЕ
#
#  - в результате реализации данного Этапа (stage03: cicd ready 1)
#    была разработана конфигурация дополнительной настройки сервера мониоринга [srv1]
#    для развертывания на нем в тестовом режиме Docker Compose стека веб-приложения
#    содержащего 3 сервиса:
#    1. сервис СУБД PostgreSQL
#    2. сервис GUI для СУБД PostgreSQL
#    3. сервис веб-приложения Python Django работающего с БД размещенной в СУБД PostgreSQL
#
#  - сервис 1 условно не доступен извне,
#    сервисы 2,3 доступны извне через конфигурацию обратного проксирования Nginx (reverse proxy)
#

```

</details>
<!--END_DETAILS_30-->


<!--START_DETAILS_20-->
<details><summary><h3><b>Стадия #2: Создание Kubernetes Кластера</b></h3></summary>

```bash

#--ВВЕДЕНИЕ

#..инструкции по начальному развертыванию см. вразделе "Стадия #1: Развертывание базовой облачной Инфраструктуры"
#  в даном разделе будут приведены инструкции по проверке Кластера Kubernetes.
#  на данной Стадии описание начинается с момента применения Terraform конфигурации

#..применяем Terraform конфигурацию с помощью шелл-скрипта
#  *ждем пока в результате не появится список ip-адресов созданных ВМ
#  *время развертывания может доходить до 15 минут
#  *если в процессе развертывания будут ошибки и кластер не развернется, 
#   то необходимо учичтожить ресурсы и повторить развертывания заново
#   т.к в некоторых случаях изза проблем в сети могут наблюдаться сбои 
#   при установке пакетов необходимых для запуска и работы кластера


#--ВЫПОЛНЕНИЕ

$ ./project_tfDeployAll.sh
    ..
        Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

        Outputs:

        k8s_masters_ip_external = [
          [
            "158.160.64.109",
          ],
        ]
        k8s_workers_ip_external = [
          [
            "158.160.21.231",
          ],
        ]
        monitor_external_endpoint = "https://srv.dotspace.ru"
        monitor_external_ip = "84.201.136.38"


#..подключаемся к Manager/ControlPlane Ноде по SSH и проверяем состояние инструментов и Кластера
#  *подключение произовдится с помощью специально созданного шелл-скриппта
#   при этом текущие публичные ip адреса будут автоматически считываться из Terraform State
#  *на Master ноде проверяем:
#   - состояние сервиса "Containerd"
#   - версии установленных инструментов Kubernetes Кластера
#   - состояние Kubernetes Кластера и наличие ноды "app" в списке Нод

$ ./project_ssh2master0.sh
		
    $ hostname; curl -s 2ip.ru; hostname -I; whoami; pwd; date +'%Y-%m-%d %H:%M:%S %Z'

        master0
        158.160.64.109
        10.0.10.10 192.168.84.192
        ubuntu
        /home/ubuntu
        2024-05-01 19:28:37 +06

    $ systemctl status containerd | grep Active | awk '{$1=$1;print}'; \
		  systemctl status containerd | grep 'msg="containerd'

        Active: active (running) since Sun 2024-04-28 13:26:59 +06; 59s ago
        Apr 28 13:26:59 master0 containerd[3530]: time="2024-04-28T13:26:59.413446953+06:00" level=info msg="containerd successfully booted in 0.032209s"

    $ echo "Kubeadm v$(kubeadm version | awk '{print $5}' | sed 's/\GitVersion:"v//g' | sed 's/\",//g')"

        Kubeadm v1.30.0

    $ kubelet --version

        Kubernetes v1.30.0

    $ kubectl version

        Client Version: v1.30.0
        Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
        Server Version: v1.30.0

    $ kubectl cluster-info

        Kubernetes control plane is running at https://10.0.10.10:6443
        CoreDNS is running at https://10.0.10.10:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

        To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

    $ kubectl get nodes -o wide

        NAME      STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
        app0      Ready    worker          19m   v1.30.0   10.0.10.20    <none>        Ubuntu 22.04.4 LTS   5.15.0-105-generic   containerd://1.6.31
        master0   Ready    control-plane   24m   v1.30.0   10.0.10.10    <none>        Ubuntu 22.04.4 LTS   5.15.0-105-generic   containerd://1.6.31

#   (+) в данном случае видно что Кластер развернут успешно
#       добавлена нода "app0"
#       ей присвоена роль "worker"
#       а также создана доп. метка/label в метаданных указывающая на роль "worker"

    $ kubectl get nodes --selector='node-role.kubernetes.io/worker'
    $ kubectl get nodes -l role=worker

        NAME   STATUS   ROLES    AGE   VERSION
        app0   Ready    worker   23m   v1.30.0

#   (i) селекторы в Kubernetes
#       позволяют выбирать объекты используя их метки в метаданных

#   (i) если команда "kubectl cluster-info" выдает ошибку подключения к Кластеру
#       это означает что в процессе развертывания конфигурации были ошибки при установке пакетов,
#       и необходимо повторно выполнить уничтожение и создание "master" и "worker" Нод
#       сделать это можно вручную, либо с помощью шелл скриптов
#       $ ./project_tfUndeployKuberWorkers.sh
#       $ ./project_tfUndeployKuberMaster.sh
#       $ ./project_tfDeployKuberMaster.sh
#       $ ./project_tfDeployKuberWorkers.sh
#

#..также можно проверить наличие необходимых компонентов на Worker Ноде,
#  но эта проверка опциональная, т.к факт того что Нода добавилась к Кластеру и видна на Мастер Ноде
#  говорит о том что все компоненты установлены корректно

$ ./project_ssh2worker0.sh

    $ hostname; curl -s 2ip.ru; hostname -I; whoami; pwd;  date +'%Y-%m-%d %H:%M:%S %Z'

        app0
        158.160.21.231
        10.0.10.20 192.168.130.64
        ubuntu
        /home/ubuntu
        2024-05-01 20:10:56 +06

    $ systemctl status containerd | grep Active | awk '{$1=$1;print}'; \
		  systemctl status containerd | grep 'msg="containerd'

        Active: active (running) since Sun 2024-05-01 19:24:03 +06; 47min ago
        May 01 19:24:03 app0 containerd[3530]: time="2024-05-01T19:24:03.413446953+06:00" level=info msg="containerd successfully booted in 0.032209s"

    $ echo "Kubeadm v$(kubeadm version | awk '{print $5}' | sed 's/\GitVersion:"v//g' | sed 's/\",//g')"

        Kubeadm v1.30.0

    $ kubelet --version

        Kubernetes v1.30.0

    $ kubectl version

        Client Version: v1.30.0
        Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
        The connection to the server localhost:8080 was refused - did you specify the right host or port?
   
#   (i) ошибка подключения к серверу в команде 
#       не является ошибкой как таковой, т.к некоторые команды полноценно работают только на Master / Control Plane Ноде,
#       а в данном случае команда выполняется на Worker Ноде


#..проверка работы сервера мониторинга "srv" на данной Стадии не требуется
#  однако он должен быть доступен по HTTPS URL с любого хоста с выходом в интернет
#  проверить можно с помощью веб-браузера
#  должна открыться домашняя страница с содержимым показанным ниже
#  ссылки на ресурсы работать не будут т.к это демонстрационная страница

chrome: https://srv.dotspace.ru/

        Welcome to [srv.dotspace.ru] (Monitoring and CI/CD tasks)
        ---
        *quick_linx
        0. https://dotspace.ru
           *root domain
        1. Example HelloEmptyWorld Webapp
           *internal dockerized service #1


#--ЗАКЛЮЧЕНИЕ
#
#  - на этом Стадия #2 настройки Kubernetes Кластера завершена
#  - созданные на предыдущей Стадии ВМ "k8s-master-0" (master) и "k8s-worker-0" (app)
#    объединены в один Kubernetes Кластер, при этом
#    * ВМ "k8s-master0" (master0) является управляющей "Control Plane" Нодой, а
#    * ВМ "k8s-worker0" (app0)    является управляемой "Worker" Нодой
#
#  - на следующей Стадии будет производиться подготовка контейнеризированного Python веб-приложения
#    для развертывания в созданном Kubernetes Кластере


```

</details>
<!--END_DETAILS_20-->


<!--START_DETAILS_10-->
<details><summary><h3><b>Стадия #1: Развертывание базовой облачной Инфраструктуры</b></h3></summary>

```bash

#--ВВЕДЕНИЕ
#
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


#--ВЫПОЛНЕНИЕ
#
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

#--ЗАКЛЮЧЕНИЕ
#
#  - на этом Стадия #1 настройки Kubernetes Кластера завершена
#  - созданы необходимые виртуальные машины в облаке
#  - проверено ssh подключение к ним
#  - проверен публичный доступ по к серверу мониторинга "srv" по URL:
#    https://srv.dotspace.ru
#
#  - на следующей Стадии будет производиться непосредственно создание Kubernetes Кластера,
#    а именно объединение ВМ "master" и "app" в Кластер,
#    где ВМ "master" (k8s-master-0) будет иметь Роль "Control Plane" Ноды,
#    а ВМ "app" (k8s-worker-0) будет иметь Роль "Worker" Ноды


```

</details>
<!--END_DETAILS_10-->
<br>


### =Screenshots : : Скриншоты (новые в начале)

<!--START_SCREENS_30-->
<details open><summary><h3><b>Состояние инфраструктуры на Этапе #3 : : Веб-приложение на ВМ [srv]</b></h3></summary>
* на хосте "srv" в тестовом режиме развернут стек веб-приложения Python Django PostgreSQL <br>
* домашняя страница сайта сервера <br>
* разделы веб-приложения <br>
* веб-интерфейс для СУБД PostgreSQL (pgAdmin) <br>
* база данных, таблица и данные в СУБД PostgreSQL через pgAdmin <br>
<br>

![screen](_screens/k8s-cluster__sprint1-infra__stage03__srv_1_homePage.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage03__srv_2_webapp_1.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage03__srv_3_webapp_2.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage03__srv_4_webapp_3.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage03__srv_5_pgAdmin_1.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage03__srv_6_pgAdmin_2_db_table.png?raw=true)

</details>
<!--END_SCREENS_30-->
<br>

<!--START_SCREENS_20-->
<details><summary><h3><b>Состояние инфраструктуры на Этапе #2 : : Kubernetes Кластер</b></h3></summary>
* k8s кластер инициалирован на хосте "master0", добавлена x1 worker нода "app0" <br>
<br>

![screen](_screens/k8s-cluster__sprint1-infra__stage02__01_vm-master-master0-console-check.png?raw=true)
<br>
![screen](_screens/k8s-cluster__sprint1-infra__stage02__02_vm-app-worker0-console-check.png?raw=true)

</details>
<!--END_SCREENS_20-->
<br>

<!--START_SCREENS_10-->
<details><summary><h3><b>Состояние инфраструктуры на Этапе #1 : : Базовые облачные ресурсы</b></h3></summary>
* k8s кластер еще не инициалирован <br>
* система мониторинга на "srv" еще не настроена <br>
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
