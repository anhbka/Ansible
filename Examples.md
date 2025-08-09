### Examples for Ubuntu

```
- name: Execute the command in remote shell; stdout goes to the specified file on the remote.
  shell: somescript.sh >> somelog.txt

- name: Change the working directory to somedir/ before executing the command.
  shell: somescript.sh >> somelog.txt
  args:
    chdir: somedir/

# You can also use the 'args' form to provide the options.
- name: This command will change the working directory to somedir/ and will only run when somedir/somelog.txt doesn't exist.
  shell: somescript.sh >> somelog.txt
  args:
    chdir: somedir/
    creates: somelog.txt

- name: Run a command that uses non-posix shell-isms (in this example /bin/sh doesn't handle redirection and wildcards together but bash does)
  shell: cat < /tmp/*txt
  args:
    executable: /bin/bash

- name: Run a command using a templated variable (always use quote filter to avoid injection)
  shell: cat {{ myfile|quote }}

# You can use shell to run other executables to perform actions inline
- name: Run expect to wait for a successful PXE boot via out-of-band CIMC
  shell: |
    set timeout 300
    spawn ssh admin@{{ cimc_host }}

    expect "password:"
    send "{{ cimc_password }}\n"

    expect "\n{{ cimc_name }}"
    send "connect host\n"

    expect "pxeboot.n12"
    send "\n"

    exit 0
  args:
    executable: /usr/bin/expect
  delegate_to: localhost

# Disabling warnings
- name: Using curl to connect to a host via SOCKS proxy (unsupported in uri). Ordinarily this would throw a warning.
  shell: curl --socks5 localhost:9000 http://www.ansible.com
  args:
    warn: no
```

### Examples for Centos/Redhat

```
- name: Install the latest version of Apache
  yum:
    name: httpd
    state: latest

- name: Ensure a list of packages installed
  yum:
    name: "{{ packages }}"
  vars:
    packages:
    - httpd
    - httpd-tools

- name: Remove the Apache package
  yum:
    name: httpd
    state: absent

- name: Install the latest version of Apache from the testing repo
  yum:
    name: httpd
    enablerepo: testing
    state: present

- name: Install one specific version of Apache
  yum:
    name: httpd-2.2.29-1.4.amzn1
    state: present

- name: Upgrade all packages
  yum:
    name: '*'
    state: latest

- name: Upgrade all packages, excluding kernel & foo related packages
  yum:
    name: '*'
    state: latest
    exclude: kernel*,foo*

- name: Install the nginx rpm from a remote repo
  yum:
    name: http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    state: present

- name: Install nginx rpm from a local file
  yum:
    name: /usr/local/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm
    state: present

- name: Install the 'Development tools' package group
  yum:
    name: "@Development tools"
    state: present

- name: Install the 'Gnome desktop' environment group
  yum:
    name: "@^gnome-desktop-environment"
    state: present

- name: List ansible packages and register result to print with debug later.
  yum:
    list: ansible
  register: result

- name: Install package with multiple repos enabled
  yum:
    name: sos
    enablerepo: "epel,ol7_latest"

- name: Install package with multiple repos disabled
  yum:
    name: sos
    disablerepo: "epel,ol7_latest"

- name: Install a list of packages
  yum:
    name:
      - nginx
      - postgresql
      - postgresql-server
    state: present

- name: Download the nginx package but do not install it
  yum:
    name:
      - nginx
    state: latest
    download_only: true
```