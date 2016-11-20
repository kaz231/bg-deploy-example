#!/bin/bash

set -e

echo "Installing python's pip..."
apt-get install -y --force-yes curl python-pip python-dev libssl-dev libffi-dev apt-transport-https
curl https://bootstrap.pypa.io/get-pip.py | python
echo "Installing ansible and ansible-container..."
pip install --upgrade cffi
pip install ansible ansible-container
mkdir /etc/ansible
cp /vagrant/ansible/ansible.cfg /etc/ansible/ansible.cfg
