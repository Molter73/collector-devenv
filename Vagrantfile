go_path = ENV['GOPATH']
home_path = ENV['HOME']

Vagrant.configure("2") do |c|
  c.vm.define 'fedora', primary: true do |fedora|
    fedora.vm.box = 'fedora/35-cloud-base'
    fedora.vm.hostname = 'fedora'

    fedora.vm.synced_folder "#{go_path}/src/" ,"#{go_path}/src/",
      type: 'nfs',
      nfs_udp: false

    fedora.vm.synced_folder "#{home_path}/artifacts/", "/artifacts/",
      type: 'nfs',
      nfs_udp: false

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
    ubuntu.vm.box = 'ubuntu/jammy64'
    ubuntu.vm.hostname = 'ubuntu'

    ubuntu.vm.synced_folder "#{go_path}/src/" ,"#{go_path}/src/"
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
end
