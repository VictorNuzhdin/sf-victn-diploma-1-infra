#cloud-config
#
#..creates custom user with ssh-public-key and password
users:
  - default
  - name: _CUSTOM_USER_NAME_
    gecos: Custom user
    primary_group: _CUSTOM_USER_NAME_
    #groups: [ sudo, docker ]
    groups: sudo
    sudo: 'ALL=(ALL) NOPASSWD:ALL'
    shell: /bin/bash
    lock_passwd: false
    disable_root: true
    passwd: _CUSTOM_USER_PASSWORD_
    ssh-authorized-keys:
      - _CUSTOM_USER_PUBKEY_

#..run cmd after boot
runcmd:
  #..configures ssh: set custom ssh-port + disables root login via ssh
  - sed -i -e '$aPort _CUSTOM_SSH_PORT_' /etc/ssh/sshd_config
  - sed -i -e '$aPermitRootLogin No' /etc/ssh/sshd_config
  - sed -i -e '$aAllowUsers _CUSTOM_USER_NAME_' /etc/ssh/sshd_config
  - systemctl restart sshd
  #
  #..updates packages local database
  - apt update -y
  #
  #..installs various packages
  - apt install -y zip
  - apt install -y whois
  #
  #..installs Git CLI (git), GitHub CLI (gh)
  #  *git is already installed on new versions of Ubuntu (22.04)
  - git install -y git
  - apt install gh
  #
  #..installs Docker and configures permission for custom user to run docker commands without sudo
  - apt install -y ca-certificates
  - install -m 0755 -d /etc/apt/keyrings
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  - chmod a+r /etc/apt/keyrings/docker.asc
  - echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  - apt update -y
  - apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  - groupadd docker
  - usermod -aG docker _CUSTOM_USER_NAME_
  #- docker --version
  #- docker compose version
  #- docker run hello-world


##..it works
##  $ sudo su
##  # cd ~; ./test.sh   ## test
#
#write_files:
#  - path: /root/test.sh
#    owner: 'root:root'
#    permissions: '0700'
#    content: |
#      #!/bin/bash
#      echo "test"
#

##..test
##  $ ./test.sh         ## test
write_files:
  #..creates test shell script
  - path: /home/_CUSTOM_USER_NAME_/test.sh
    owner: '_CUSTOM_USER_OWNERSHIP_'
    permissions: '0700'
    defer: true
    content: |
      #!/bin/bash
      echo "test"
  #
  #..configures Git CLI (git)
  - path: /home/_CUSTOM_USER_NAME_/.gitconfig
    owner: '_CUSTOM_USER_OWNERSHIP_'
    permissions: '0664'
    defer: true
    content: |
      [user]
          name = _CUSTOM_GIT_USER_NAME_
          email = _CUSTOM_GIT_USER_MAIL_
      [credential "https://github.com"]
          helper = 
          helper = !/usr/bin/gh auth git-credential
      [credential "https://gist.github.com"]
          helper = 
          helper = !/usr/bin/gh auth git-credential
        [init]
          defaultBranch = main
  #
  #..configures GitHub CLI (gh)
  - path: /home/_CUSTOM_USER_NAME_/.config/gh/config.yml
    owner: '_CUSTOM_USER_OWNERSHIP_'
    permissions: '0600'
    defer: true
    content: |
      git_protocol: https
      editor:
      prompt: enabled
      pager:
        aliases:
          co: pr checkout
      http_unix_socket:
      browser:
      version: "1"
  #
  - path: /home/_CUSTOM_USER_NAME_/.config/gh/hosts.yml
    owner: '_CUSTOM_USER_OWNERSHIP_'
    permissions: '0600'
    defer: true
    content: |
      github.com:
          git_protocol: https
          oauth_token: _CUSTOM_GIT_USER_TOKEN_
          user: _CUSTOM_GIT_USER_NAME_
          users:
              _CUSTOM_GIT_USER_NAME_:
              oauth_token: _CUSTOM_GIT_USER_TOKEN_

