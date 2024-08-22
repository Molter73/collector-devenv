go_path = ENV['GOPATH']
home_path = ENV['HOME']

def synced_folder(config, src, dst)
  config.vm.synced_folder src, dst,
    type: 'virtiofs'
end

Vagrant.configure("2") do |c|
  c.vm.define 'fedora', primary: true do |fedora|
    fedora.vm.box = 'fedora/40-cloud-base'
    fedora.vm.hostname = 'fedora'

    synced_folder(fedora, "#{go_path}/src/", "#{go_path}/src/")
    synced_folder(fedora, "#{home_path}/artifacts/", "/artifacts/")

    fedora.vm.provider 'libvirt' do |libvirt|
      libvirt.cpus = 18
      libvirt.memory = 32768
      libvirt.memorybacking :access, :mode => "shared"
    end

    fedora.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'provision/provision.yml'
    end
  end
end
