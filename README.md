Internet Access Control for OpenWrt
===================================

This software is designed for OpwnWrt routers.
It allows you to restrict the internet access for specific hosts in your LAN.
You can block the internet access permanently or on schedule basis for any MAC address.
The schedule contains the  time of a day and the deys of the week.
New in version 4:
You can also issue a "ticket" for any blocked user. It gives him an extraordinary access to the internet for a given time.

The software is a Luci app extending system's firewall, so it runs on any platform with no need of recompiling.
Tested on OpenWrt BB and CC.
Note: due to a bug in CC, the times must be set in UTC, rather than local time.

After installation you'll find a new page in OpenWrt's GUI: Network/Access control.

Screen shot
-----------
![Internet Access Control](https://github.com/k-szuster/luci-access-control/blob/master/snapshot1.png?raw=true)

Source repository
-----------------
https://github.com/k-szuster/luci-access-control

See also: https://github.com/k-szuster/luci-access-control-package
for a standalone-package version of the same software.

To install prebuilt package
----------------------------
Visit: https://github.com/k-szuster/luci-access-control/releases
Download ipk file to your device and install it with opkg.
Or:
copy contents of luci-app-access-control/files to / directory on target devicee.

To build the package for OpenWrt BB
-----------------------------------
- Place folder luci-access-control into your 

	<openwrt>/feeds/luci/applications

folder.

- You MUST also add the following line to your /openwrt/feeds/luci/contrib/package/luci-addons/Makefile

	$(eval $(call application,access-control,Restrict internet access for specified clients using schedules))

- After this has been completed, call 

	make menuconfig

from your openwrt folder. Here, you must include the following packages in your OpenWRT build for everything to work.

	LuCI -> applications -> luci-app-access-control

- Call make to compile OpenWRT with the selected package installed.
You'll find it in <openwrt>/bin/<target>/packages/luci/luci-app-access-control_....ipk file.
