From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] query udev dir via pkg-config
Date: Mon, 13 Aug 2012 13:44:22 -0400
Message-ID: <1344879862-23299-1-git-send-email-vapier@gentoo.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Samuli Suominen <ssuominen@gentoo.org>
List-Id: linux-raid.ids

From: Samuli Suominen <ssuominen@gentoo.org>

Since udev is moving its internal dir around, query it via pkg-config
rather than hardcoding the old path.  This should work with new/old
versions.

Signed-off-by: Samuli Suominen <ssuominen@gentoo.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 72f609e..a3e4027 100644
--- a/Makefile
+++ b/Makefile
@@ -57,6 +57,8 @@ else
  DEFAULT_METADATA=1.2
 endif
 
+PKG_CONFIG ?= pkg-config
+
 SYSCONFDIR = /etc
 CONFFILE = $(SYSCONFDIR)/mdadm.conf
 CONFFILE2 = $(SYSCONFDIR)/mdadm/mdadm.conf
@@ -96,6 +98,11 @@ MAN4DIR = $(MANDIR)/man4
 MAN5DIR = $(MANDIR)/man5
 MAN8DIR = $(MANDIR)/man8
 
+UDEVDIR := $(shell $(PKG_CONFIG) --variable=udevdir udev 2>/dev/null)
+ifndef UDEVDIR
+ UDEVDIR = /lib/udev
+endif
+
 OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o \
 	Manage.o Assemble.o Build.o \
 	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
@@ -255,7 +262,7 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
 	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
 
 install-udev: udev-md-raid.rules
-	$(INSTALL) -D -m 644 udev-md-raid.rules $(DESTDIR)/lib/udev/rules.d/64-md-raid.rules
+	$(INSTALL) -D -m 644 udev-md-raid.rules $(DESTDIR)$(UDEVDIR)/rules.d/64-md-raid.rules
 
 uninstall:
 	rm -f $(DESTDIR)$(MAN8DIR)/mdadm.8 $(DESTDIR)$(MAN8DIR)/mdmon.8 $(DESTDIR)$(MAN4DIR)/md.4 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5 $(DESTDIR)$(BINDIR)/mdadm
-- 
1.7.9.7

