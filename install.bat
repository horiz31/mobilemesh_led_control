@echo off

if [%1]==[] goto usage
@echo Setting up the Horizon31 MobileMesh LED controller...
@echo Copying files to %1...
@echo If prompted for a password, please enter the root user's password on the Doodle radio

scp -o HostKeyAlgorithms=+ssh-rsa -r usr/sbin/* root@%1:/usr/sbin/.
scp -o HostKeyAlgorithms=+ssh-rsa -r etc/init.d/* root@%1:/etc/init.d/.
scp -o HostKeyAlgorithms=+ssh-rsa -r etc/config/* root@%1:/etc/config/.
scp -o HostKeyAlgorithms=+ssh-rsa -r usr/lib/lua/luci/controller/* root@%1:/usr/lib/lua/luci/controller/.
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 mkdir -p /usr/lib/lua/luci/model/cbi/ledcontrol
scp -o HostKeyAlgorithms=+ssh-rsa -r usr/lib/lua/luci/model/cbi/ledcontrol/* root@%1:/usr/lib/lua/luci/model/cbi/ledcontrol/.
scp -o HostKeyAlgorithms=+ssh-rsa -r www/luci-static/resources/* root@%1:/www/luci-static/resources/.
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 chmod +x /usr/sbin/mesh_monitor.sh
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 chmod +x /usr/sbin/mmcmd
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 chmod +x /etc/init.d/mesh_monitor
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 /etc/init.d/mesh_monitor enable

@echo ==============================
@echo Configuration successful !!
@echo ==============================
PAUSE
goto :eof
:usage
@echo Missing argument, Usage: %0 ^<IP Address^>
exit /B 1