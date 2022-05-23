require 'yaml'

vms = []
YAML.load_stream(File.read "#{__dir__}/vagrant.yml") { |doc| vms << doc }

Vagrant.configure("2") do |c|
	vms.each do |vm|
		name = vm.keys[0]

		primary = false
		if vm.key?('primary')
			primary = vm['primary']
		end

		c.vm.define vm['name'], primary: primary do |node|
			node.vm.box = vm['box']
			node.vm.provider :virtualbox

			if vm.key?('box_url')
				node.vm.box_url = vm['box_url']
			end

			if vm.key?('hostname')
				node.vm.hostname = vm['hostname']
			end

			if vm.key?('disk')
				node.vm.disk :disk, size: vm['disk'], primary: true
			end

			if vm.key?('synced_folder')
				vm['synced_folder'].each do |sf|
					if sf.key?('type')
						if sf['type'] == 'nfs'
							node.vm.synced_folder sf['src'], sf['dst'], type: 'nfs', nfs_udp: false
						end
					else
						node.vm.synced_folder sf['src'], sf['dst']
					end
				end
			end

			if vm.key?('private_network')
				vm['private_network'].each do |ip|
					node.vm.network 'private_network', ip: ip
				end
			end

			if vm.key?('provision')
				vm['provision'].each do |name, provision|
					if provision['type'] == 'shell'
						options = provision['options']
						env = {}
						if options.key?('environment')
							env = options['environment']
						end
						node.vm.provision 'shell', path: options['path'], name: name, env: env
					end
				end
			end

			# VBox specific configuration
			node.vm.provider 'virtualbox' do |vbox|
				vbox.gui = false

				if vm.key?('virtualbox')
					vbox_config = vm['virtualbox']

					if vbox_config.key?('name')
						vbox.name = vbox_config['name']
					end

					if vbox_config.key?('cpus')
						vbox.cpus = vbox_config['cpus']
					end

					if vbox_config.key?('memory')
						vbox.memory = vbox_config['memory']
					end

					if vbox_config.key?('groups')
						vbox.customize ['modifyvm', :id, '--groups', vbox_config['groups'].join(',')]
					end
					vbox.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]
				end
			end
		end
	end
end
