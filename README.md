# MobileMesh Firmware
These files provide functions to be run on a Horizon31 MobileMesh Radio.

The repo is setup to match the *(overlay)* filesysem on the doodle radio itself.  So the arrangement in this repo matches the placement of files in the target radio.
In the scripts below, a file is placed in `/etc/init.d/` that has specific items in it, per references below.

## Installation

To install, ensure that the MM radio is powered on, connected to a LAN and the ip address is known.  By default the IP is `10.223.x.y` where x,y are the decimal equivalent of the last two hexadecimal digits of the MM serial number.  I.e. `H31-MM-DAED` will have a default IP of `10.223.218.237`.

Then, issue a `make IP=10.223.x.y install` to copy the scripts over to the radio and enable the scripts to execute on boot.

## Mesh Monitor

This script monitors the stations connected to the mesh and issues commands to the power microcontroller on `/dev/ttyACM2` to set the LED state:

  * `Booting`: Flashing Blue
  * `Searching for Stations`: Flashing Yellow
  * `Active Stations`: Solid Green
  * `Inactive Stations`: Solid Yellow

The principle of operation is to periodicaly call `iw dev wlan0 station dump` and parse the output to determine if any connected stations exist.  If there are none, no output is made.  If there are connected stations, they may active or inactive.  Stations appear to remain in the device database for approximately 5 min.  Since we desire as faster response than that, we need to interpret the inactive time from the station report (given in milliseconds).  If there any stations with activity less than *5 sec*, then we consider the mesh active and the LED should be GREEN.  If there are any stations, but none show activity then the LED should be YELLOW.  When the stations are removed and there are no stations in the list, the LED should flash YELLOW.

### Files

  * `/etc/init.d/mesh_monitor` - the startup script that starts the service
  * `/usr/sbin/mesh_monitor.sh`	 - the service script that runs continuously
  * `/usr/sbin/mmcmd` - a script to send a command to the MM microcontroller
  * `/usr/sbin/station.awk` - an AWK script to parse station codes from the iw call *(used by mesh_monitor.sh)*
  * `/etc/config/ledcontrol` - the uci config file for led settings
  * `/usr/lib/lua/luci/controller/ledcontroller.lua` - the lua script to add the LED control menu option to the LuCI web interface
  * `/usr/lib/lua/luci/model/cbi/ledcontrol/ledcontrol.lua` - the lua script to generate LuCI web interface page and handle setting the LED control option
  * `/www/luci-static/resources/logo.svg` - the horizon31 logo

## References

[OpenWRT InitScripts](https://openwrt.org/docs/techref/initscripts)
[OpenWRT PROCD](https://openwrt.org/docs/guide-developer/procd-init-script-example)
[SO how-to-auto-start-an-application-in-openwrt](https://stackoverflow.com/questions/33340659/how-to-auto-start-an-application-in-openwrt)
