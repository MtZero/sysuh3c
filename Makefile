include $(TOPDIR)/rules.mk

PKG_NAME:=sysuh3c
PKG_VERSION:=0.2
PKG_RELEASE:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
        SECTION:=utils
        CATEGORY:=Utilities
        DEPENDS:=+libc +libgcc +libuci
        TITLE:=sysuh3c
        PKGARCH:=ramips
        MAINTAINER:=zonyitoo
endef

define Package/$(PKG_NAME)/description
      	A CLI Client for H3C
endef

#非本目录下的源码文件, 拷贝到此相应目录下.
# 如../../xucommon/xucommon.c, 则将 xucommon.c 拷贝到此目录下的源码的 ../../ 
define Build/Prepare
		mkdir -p $(PKG_BUILD_DIR)
		$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

#define Build/Configure
#endef

#define Build/Compile
#	$(MAKE) -C $(PKG_BUILD_DIR) \
#		LIBS="-nodefaultlibs -lgcc -lc -luClibc++" \
#		LDFLAGS="$(EXTRA_LDFLAGS)" \
#		CXXFLAGS="$(TARGET_CFLAGS) $(EXTRA_CPPFLAGS) -nostdinc++" \
#		$(TARGET_CONFIGURE_OPTS) \
#		CROSS="$(TARGET_CROSS)" \
#		ARCH="$(ARCH)" \
#		$(1);
#endef

#define Package/$(PKG_NAME)/conffiles
#[升级时保留文件/备份时备份文件 一个文件一行]
#endef

define Package/$(PKG_NAME)/install
		$(INSTALL_DIR) $(1)/usr/bin
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/sysuh3c $(1)/usr/bin
		$(INSTALL_DIR) $(1)/etc/config
		$(CP) $(PKG_BUILD_DIR)/sysuh3c.conf $(1)/etc/config/sysuh3c
endef

#define Package/$(PKG_NAME)/preinst
#[安装前执行的脚本 记得加上#!/bin/sh 没有就空着]
#    #!/bin/sh
#    uci -q batch <<-EOF >/dev/null
#     delete ucitrack.@aria2[-1]
#     add ucitrack aria2
#     set ucitrack.@aria2[-1].init=aria2
#     commit ucitrack
#    EOF
#    exit 0
#endef

#define Package/$(PKG_NAME)/postinst
#[安装后执行的脚本 记得加上#!/bin/sh 没有就空着]
#    #!/bin/sh
#     rm -f /tmp/luci-indexcache
#    exit 0
#endef

define Package/$(PKG_NAME)/prerm
		#!/bin/sh
		if [ -f /var/run/sysuh3c.pid ]; then
			cat /var/run/sysuh3c.pid | while read SYSUH3C_LOCK; do kill -int $(SYSUH3C_LOCK); done
			rm -f /var/run/sysuh3c.pid
		fi
endef

#Package/$(PKG_NAME)/postrm
#[删除后执行的脚本 记得加上#!/bin/sh 没有就空着]
#endef

$(eval $(call BuildPackage,$(PKG_NAME)))
