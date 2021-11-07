@echo off

if [%1]==[] goto usage
@echo Setting up the Horizon31 MobileMesh Radio...
@echo Provided IP address is %1...
@echo If prompted for a password, please enter the current password on the Doodle radio

@echo off
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 passwd -d root
scp -o HostKeyAlgorithms=+ssh-rsa -r usr/share/rpcd/acl.d/* root@%1:/usr/share/rpcd/acl.d/.
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
@echo Restarting the rpcd service...
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 /etc/init.d/rpcd restart
SET /P variable=Enter desired Doodle password (carefully!):
ssh -o HostKeyAlgorithms=+ssh-rsa root@%1 "echo -e '%variable%\n%variable%\n' | passwd" 1>NUL

@echo ==============================
@echo Configuration successful !!
@echo Please power off and on the MobileMesh Radio now !!
@echo ==============================

PAUSE
goto :eof
:usage
@echo Missing argument, Usage: %0 ^<IP Address^>
exit /B 1