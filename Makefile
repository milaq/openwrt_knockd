#
# Copyright (C) 2010-2015 OpenWrt.org
# Copyright (C) 2017      Micha LaQua
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=knockd
PKG_VERSION:=0.7
PKG_RELEASE:=3

PKG_BUILD_DEPENDS:=libpcap
PKG_BUILD_DIR:=$(BUILD_DIR)/knock-$(PKG_VERSION)

PKG_SOURCE:=knock-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=http://www.zeroflux.org/proj/knock/files/
PKG_HASH:=9938479c321066424f74c61f6bee46dfd355a828263dc89561a1ece3f56578a4

PKG_MAINTAINER:=milaq <micha.laqua@gmail.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/knockd
  TITLE:=Port knocking service
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  DEPENDS:=+libpcap
  URL:=http://www.zeroflux.org/projects/knock
endef

define Package/knockd/description
  It listens to all traffic on an ethernet (or PPP) interface,
  looking for special "knock" sequences of port hits. A client
  makes these port hits by sending a TCP (or UDP) packet to a
  port on the server. This port doesn't need to be open -- since
  knockd listens at the link-layer level, it sees all traffic
  even if it's destined for a closed port. When the server
  detects a specific sequence of port hits, it runs a command
  defined in its configuration file. This can be used to open
  up holes in a firewall for quick access.
  This package contains the port knocking server.
endef

define Package/knockd/conffiles
  /etc/config/knockd
endef

define Build/Configure
	$(call Build/Configure/Default, \
		, \
		CFLAGS="$$$$CFLAGS $$$$CPPFLAGS" \
                ac_cv_lib_pcap_pcap_open_live=yes \
        )
endef
	
define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		DESTDIR="$(PKG_INSTALL_DIR)" \
		all install
endef
	
define Package/knockd/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/knockd.conf $(1)/etc/config/knockd
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/knockd.init $(1)/etc/init.d/knockd
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/knockd $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,knockd))
