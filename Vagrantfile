go_path = ENV['GOPATH']
home_path = ENV['HOME']

def synced_folder(config, src, dst)
  config.vm.synced_folder src, dst,
    type: 'nfs',
    nfs_export: false,
    nfs_udp: false
end

Vagrant.configure("2") do |c|
  c.vm.define 'fedora', primary: true do |fedora|
    fedora.vm.box = 'fedora/37-cloud-base'
    fedora.vm.hostname = 'fedora'

    synced_folder(fedora, "#{go_path}/src/", "#{go_path}/src/")
    synced_folder(fedora, "#{home_path}/artifacts/", "/artifacts/")

    fedora.vm.network 'private_network', ip: '192.168.56.10'

    # VBox specific configuration
    fedora.vm.provider 'virtualbox' do |vbox|
      vbox.gui = false
      vbox.name = 'fedora'
      vbox.cpus = 6
      vbox.memory = 8192
      vbox.customize ['modifyvm', :id, '--groups', '/devenv']
      vbox.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]
    end

    fedora.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'provision/provision.yml'
    end
  end

  c.vm.define 'ubuntu' do |ubuntu|
    ubuntu.vm.box = 'ubuntu/focal64'
    ubuntu.vm.hostname = 'ubuntu'

    synced_folder(ubuntu, "#{go_path}/src/" ,"#{go_path}/src/")
    ubuntu.vm.synced_folder "#{home_path}/artifacts/", "/artifacts/"

    ubuntu.vm.network 'private_network', ip: '192.168.56.11'

    # VBox specific configuration
    ubuntu.vm.provider 'virtualbox' do |vbox|
      vbox.gui = false
      vbox.name = 'ubuntu'
      vbox.cpus = 6
      vbox.memory = 8192
      vbox.customize ['modifyvm', :id, '--groups', '/devenv']
      vbox.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]
    end

    ubuntu.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'provision/provision.yml'
    end
  end

  c.vm.define 'amazon' do |amazon|
    amazon.vm.box = 'gbailey/amzn2'
    amazon.vm.hostname = 'amazon'

    synced_folder(amazon, "#{go_path}/src/", "#{go_path}/src/")
    synced_folder(amazon, "#{home_path}/artifacts/", "/artifacts/")

    amazon.vm.network 'private_network', ip: '192.168.56.12'

    # VBox specific configuration
    amazon.vm.provider 'virtualbox' do |vbox|
      vbox.gui = false
      vbox.name = 'amazon'
      vbox.cpus = 6
      vbox.memory = 8192
      vbox.customize ['modifyvm', :id, '--groups', '/devenv']
      vbox.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]
    end

    amazon.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'provision/amazon.yml'
    end
  end
end
