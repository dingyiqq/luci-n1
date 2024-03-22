# Copyright (C) 2018 DingYi <dingyi139@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-argon-config
PKG_VERSION:=1.0
PKG_RELEASE:=68

PKG_MAINTAINER:=DingYi <dingyi139@gmail.com>

LUCI_TITLE:=LuCI page for Argon Config
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+luci-compat

define Package/$(PKG_NAME)/conffiles
/etc/config/argon
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
