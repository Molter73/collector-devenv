# Introduction

This is a super basic repo that creates a VM based on Fedora 35 for development of the [stackrox collector](https://github.com/stackrox/collector).

Some people might argue Docker Desktop to be a simpler solution, I just like having my own VMs.

# vagrant up
The repo is based around `Vagrantfile` reading the `vagrant.yml` file and spawning VMs from it (I know it is overly complicated, I prefer having my configurations in YAML and not in ruby). You will need to install both [vagrant](https://www.vagrantup.com/docs/installation) as well as a VM client , I use [virtualbox](https://www.virtualbox.org/wiki/Downloads), but the main Fedora image being used also supports `libvirt`.

Running `vagrant up` in the root of the directory. Once the box is downloaded a set of scripts will be executed in order to setup docker and k3s for development.

## Accessing docker from the host
Easiest way to access the docker instance running in the VM is to install the docker CLI on your host and create a context for it to SSH into the VM on its own. Run the following commands from inside the root of this repository in the host:
```bash
docker context create collector-devenv --description "Context used for collector development" --docker host=ssh://vagrant@192.168.56.10
docker context use collector-devenv
ssh-add .vagrant/machines/fedora/virtualbox/private_key
ssh vagrant@192.168.56.10
# You'll be asked if you trust the IP, you should probably answer 'yes'
```

If all went well, close the ssh session and run `docker ps` on the host, you should be greeted with something looking like this:
```bash
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## Accessing the k3s cluster from the host
`./scripts/k3s.sh` will copy the configuration file required to access the k3s cluster in `~/artifacts/k3s.yaml`, I would advice you copy that file somewhere like `~/.kube/k3s.yaml`. Once copied, edit the line defining the `server` to use the public IP of your VM:
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

## Mapping files to properly run stackrox/collector commands from the host
You may have noticed the `vagrant.yml` file mounts the `~/go/src/` directory to `/workspace`, you might want to change `/workspace` to the expanded path to `~/go/src/` for commands run from the host properly map inside the VM.
```yaml
- src: ~/go/src/
  dst: /home/<your-user-here>/go/src/
  type: nfs
```
On MacOS it might look something like this:
```yaml
- src: ~/go/src/
  dst: /Users/<your-user-here>/go/src/
  type: nfs
```

`nfs` is used because it has proven to be more efficient in MacOS, feel free to remove it and use the default sharing system if you feel like it.

## Using other VMs
If for whatever reason you feel like using a VM other than the one provided, you can either edit the existing one or add a separate VM by creating a new document inside `vagrant.yml`. As an example, a VM based on Ubuntu Focal can be added by appending the following to `vagrant.yml` (but bear in mind the script found under `scripts/rhel` will not work in this VM).
```yml
---
name: ubuntu
box: ubuntu/focal64
synced_folder:
- src: ~/go/src/
  dst: /workspace
  type: nfs
- src: ~/artifacts/
  dst: /artifacts
  type: nfs
private_network:
- 192.168.56.11
virtualbox:
  name: ubuntu
  cpus: 6
  memory: 8192
  groups:
    - /devenv
```

## Create an alias for vagrant commands
If you find it a little annoying to always have to go back to the directory were the `Vagrantfile` is stored, considering adding an alias to always run vagrant from that same place:
```bash
alias beggar="VAGRANT_CWD=<path-to-repo> vagrant"
```
