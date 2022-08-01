# Introduction

This is a super basic repo that creates a VM based on Fedora 35 for development of the [stackrox collector](https://github.com/stackrox/collector).

Some people might argue Docker Desktop to be a simpler solution, I just like having my own VMs.

# vagrant up
The repo is based around `Vagrantfile` and the `provision.yml` file. You will need to install both [vagrant](https://www.vagrantup.com/docs/installation) as well as a VM client , I use [virtualbox](https://www.virtualbox.org/wiki/Downloads), but the main Fedora image being used also supports `libvirt`. `ansible` is also required in your host, so go over to [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) and get it setup.

Running `vagrant up fedora` in the root of the directory will download and spin up the Fedora 35 VM. Once it's done, the `provision.yml` playbook will be executed and you will have `docker` and `k3s` installed in them, congratulations!

## Accessing docker from the host
Easiest way to access the docker instance running in the VM is to install the docker CLI on your host and create a context for it to SSH into the VM on its own. First, run `vagrant ssh-config` to get the ssh configuration for your VM and paste it into `~/.ssh/config`, you could also just:
```bash
vagrant ssh-config >> ~/.ssh/config
```

Run the following commands from inside the root of this repository in the host:
```bash
docker context create collector-devenv --description "Context used for collector development" --docker host=ssh://vagrant@fedora
docker context use collector-devenv
```

If all went well, close the ssh session and run `docker ps` on the host, you should be greeted with something looking like this:
```bash
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## Accessing the k3s cluster from the host
The k3s installation will copy the configuration file required to access the k3s cluster in a file named `k3s.yaml`, I would advice you copy that file somewhere like `~/.kube/k3s.yaml`. Once copied, edit the line defining the `server` to use the public IP of your VM:
```yaml
- cluster:
    server: https://192.168.56.10:6443
```

You can then access the cluster by doing something like this:
```bash
$ export KUBECONFIG=~/.kube/k3s.yaml
$ kubectl get node
NAME     STATUS   ROLES                  AGE   VERSION
fedora   Ready    control-plane,master   19h   v1.23.6+k3s1
```

## Using other VMs
Right now the only VM I'm supporting is the Fedora one, but if you wanted to use something like Ubuntu, copying the vagrant configuration and changing to use something like the `ubuntu/focal64` box should kinda work, though some tinkering with the provisioning playbook may be required.

## Create an alias for vagrant commands
If you find it a little annoying to always have to go back to the directory were the `Vagrantfile` is stored, consider adding an alias to always run vagrant from that same place:
```bash
alias beggar="VAGRANT_CWD=<path-to-repo> vagrant"
```
