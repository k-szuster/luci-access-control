Internet Access Control for OpenWrt
===================================

This software is designed for OpwnWrt routers.
It allows you to restrict the internet access for specific hosts in your LAN.
You can block the internet access permanently or on schedule basis for any MAC address.
After installation you'll find a new page in OpenWrt's GUI: Network/Access control.

The software is a Luci module extending system's firewall, so it runs on any platform with no need of  recompiling.

To build the OpenWrt package
============================
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

- Install luci-app-access-control package on the OpenWrt router.


To install without building ipk package
=======================================
- Copy contents of root/ to / directory on target machine.
- Copy contents of luasrc/ to /usr/lib/lua/luci/ on target machine.
