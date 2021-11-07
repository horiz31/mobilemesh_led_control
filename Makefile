IP := 10.223.218.237

.PHONY: copyin install

default:
	@echo "make IP=x.y.x.w install"

copyin:
	@for f in etc/init.d/* usr/sbin/* usr/lib/lua/luci/controller/* usr/lib/lua/luci/model/cbi/ledcontrol/* www/luci-static/resources/* ; do scp -o HostKeyAlgorithms=+ssh-rsa root@$(IP):/$$f $$f ; done

install:
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) passwd -d root
	scp -o HostKeyAlgorithms=+ssh-rsa -r usr/share/rpcd/acl.d/* root@$(IP):/usr/share/rpcd/acl.d/.
	scp -o HostKeyAlgorithms=+ssh-rsa -r usr/sbin/* root@$(IP):/usr/sbin/.
	scp -o HostKeyAlgorithms=+ssh-rsa -r etc/init.d/* root@$(IP):/etc/init.d/.
	scp -o HostKeyAlgorithms=+ssh-rsa -r etc/config/* root@$(IP):/etc/config/.
	scp -o HostKeyAlgorithms=+ssh-rsa -r usr/lib/lua/luci/controller/* root@$(IP):/usr/lib/lua/luci/controller/.
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) mkdir -p /usr/lib/lua/luci/model/cbi/ledcontrol
	scp -o HostKeyAlgorithms=+ssh-rsa -r usr/lib/lua/luci/model/cbi/ledcontrol/* root@$(IP):/usr/lib/lua/luci/model/cbi/ledcontrol/.
	scp -o HostKeyAlgorithms=+ssh-rsa -r www/luci-static/resources/* root@$(IP):/www/luci-static/resources/.
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) chmod +x /usr/sbin/mesh_monitor.sh
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) chmod +x /usr/sbin/mmcmd
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) chmod +x /etc/init.d/mesh_monitor
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) /etc/init.d/mesh_monitor enable
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) /etc/init.d/rpcd restart
	@read -p "Enter desired Doodle password: " password; \
	ssh -o HostKeyAlgorithms=+ssh-rsa root@$(IP) "echo -e '$$password\n$$password\n' | passwd" > /dev/null
