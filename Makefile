#
# Copyright (C) 2010-2015 OpenWrt.org
# Copyright (C) 2017      Micha LaQua
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=knockd
PKG_VERSION:=0.7.8
PKG_RELEASE:=1

PKG_BUILD_DEPENDS:=libpcap
PKG_BUILD_DIR:=$(BUILD_DIR)/knockd-$(PKG_VERSION)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/jvinet/knock.git
PKG_SOURCE_VERSION:=258a27e5a47809f97c2b9f2751a88c2f94aae891
PKG_SOURCE_DATE:=2015-12-27
#PKG_MIRROR_HASH:=f1ca080500abd788d37731a01c9655447b7ae750fcf62300dcf8f8b773f9cd88
PKG_FIXUP:=autoreconf

PKG_MAINTAINER:=milaq <micha.laqua@gmail.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/knockd
  TITLE:=Port knocking service
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  DEPENDS:=+libpcap
  URL:=https://github.com/jvinet/knock
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

# *** Install ***
define Package/knockd/preinst
	#!/bin/sh
	# if NOT run buildroot then stop service
	[ -z "$${IPKG_INSTROOT}" ] && /etc/init.d/knockd stop >/dev/null 2>&1
	exit 0	# suppress errors
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
