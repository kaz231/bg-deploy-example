Blug-Green Deployment Presentation - Example
=============

Goal of this project is to present blue-green deployment in action. It consists of:

- definition of virtual machine (Vagrantfile)
- provisioning scripts (Ansible)
- shell scripts responsible for setup of containers and deployment

Presentation is available [here](http://www.slideshare.net/KamilZajc/presentationbg).

### Requirements

- Vagrant 1.8 with plugins vagrant-cachier and vagrant-vbguest
- VirtualBox 5

### How to execute example ?

First of all, you have to setup virtual machine. To do it, execute following command:

`vagrant up app`

Above command will create a new virtual machine and provision it with following software:

- Docker
- Consul
- Consul Template
- Registrator

If machine is ready, then connect to it with following command:

`vagrant ssh app`

Now, enter scripts directory:

`cd /vagrant/scripts`

And setup initial version of our application:

`./up.sh`

This scripts will setup tracker application for current color (green by default), database. Next, it will use already running container with tracker to setup database. Finally, it will create upstreams configuration file and run nginx. If you would like to see it, run `docker ps`.

Now, you are ready to deploy new version of tracker application with method blue-green. To see it clearly, let's open two additional terminal sessions, connect again to virtual machine and run following commands (one per sessions):

- `docker logs -f vagrant_lb_1` - this will print access log of our nginx
- `watch -n1 "curl 'http://tracker.local:8080/tracker/track?action_name=n1&action_value=v1'"` - this will run GET request to our tracker every second

Ok, so let's back to our first opened terminal and start deployment:

`./bg_deployment.sh`

Above command has:

- get next color based on the one already stored in consul (this time it's blue)
- killed previous release with such color (if exists)
- setup container with the new version of tracker (marked as blue)
- performed any migrations of db
- performed health check
- updated upstreams configuration file will all tracker's containers marked as blue
- reloads nginx
- updates current color with blue in consul

Congratulations, you have successfully deployed a new release of tracker application using method blue-green. Now you can verify nginx's access log using previously opened terminal session and verify that PORT of tracker application has changed. It means that previous release of tracker application was replaced with container containing a new release of tracker. Application was online all the time.

That's all, now you could exit from virtual machine and destroy virtual machine:

`vagrant destroy -f app`
