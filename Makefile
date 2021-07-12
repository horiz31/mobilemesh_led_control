IP := 10.223.218.237

.PHONY: copyin install

default:
	@echo "make IP=x.y.x.w install"

copyin:
	@for f in etc/init.d/* usr/sbin/* usr/lib/lua/luci/controller/* usr/lib/lua/luci/model/cbi/ledcontrol/* www/luci-static/resources/* ; do scp root@$(IP):/$$f $$f ; done

install:
	scp -r usr/sbin/* root@$(IP):/usr/sbin/.
	scp -r etc/init.d/* root@$(IP):/etc/init.d/.
	scp -r etc/config/* root@$(IP):/etc/config/.
	scp -r usr/lib/lua/luci/controller/* root@$(IP):/usr/lib/lua/luci/controller/.
	ssh root@$(IP) mkdir -p /usr/lib/lua/luci/model/cbi/ledcontrol
	scp -r usr/lib/lua/luci/model/cbi/ledcontrol/* root@$(IP):/usr/lib/lua/luci/model/cbi/ledcontrol/.
	scp -r www/luci-static/resources/* root@$(IP):/www/luci-static/resources/.
	ssh root@$(IP) chmod +x /usr/sbin/mesh_monitor.sh
	ssh root@$(IP) chmod +x /usr/sbin/mmcmd
	ssh root@$(IP) chmod +x /etc/init.d/mesh_monitor
	ssh root@$(IP) /etc/init.d/mesh_monitor enable
