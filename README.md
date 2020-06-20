# Substrate.dev Docker
This is simple project that tend to dockerize substrate.dev kitchen node.

I have done this as one of my interview test exams.


# Installation

## Requirements

* Centos 7
* Docker
* Docker-compose

## Using Ansible
first install ansible.

`pip install --user 'ansible ~= 2.9'`

Clone the repository into your control machine.

```
git clone ... /opt/substrate
cd /opt/substrate
```

Create inventory (inventory.ini) file like this:
```
centos ansible_user=centos ansible_host=10.1.1.27 ansible_become=yes
```

and run playbook with ansible

```
ansible-playbook -i inventory.ini playbook.yml
```

## Manualy build image

First install docker and docker-compose using.
```
yum install -y epel-release docker python-pip

pip install --upgrade pip
pip install docker-compose

systemctl enable --now docker
```
Clone this reposistory

```
cd /opt/
git clone ... substrate
cd substrate
```

you can build image using docker

```
docker build -t substrate .
docker run --name substrate -d -p 9944:9944 -p 9615:9615 substrate
```

or using docker-compose

```
docker-compose up -d
```

# Using apt-cacher-ng
You can use apt cache proxies like apt-cacher-ng that make build process slicly faster if you have weak internet.

You can add this to your centos /etc/environment file in centos.
Note this is used inside your docker image at build stage and its not empact your centos machine.

```
export APTPROXY_ADDR=10.1.1.1:3142

```
If you build image manualy with docker you most pass APTPROXY_ADDR environment variable using --build-arg option to docker.
```
docker build --build-arg APTPROXY_ADDR -t substrate .
```