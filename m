From: Samuli Suominen <ssuominen@gentoo.org>
Subject: [PATCH] Parallel make bug in Makefile of mdadm-3.3.1 (corrupted udev
 rules and/or systemd services)
Date: Thu, 17 Jul 2014 10:30:05 +0300
Message-ID: <53C77B7D.2090907@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080002070304050708050802"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080002070304050708050802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

If you run with:

$ export MAKEFLAGS="-j9"
$ make install install-systemd

As in, combine "install" and "install-systemd" in the same command using
parallel make,
the content of .service files could end up in .rules, or otherway around
because GNU
make fill run them in parallel and the commands might ran at the same
time, and both
use same variables $file and same temporary files .install.tmp

This was reported at,
https://bugs.gentoo.org/show_bug.cgi?id=517218

The immediate workaround is,

$ export MAKEFLAGS="-j9"
$ make install
$ make install-systemd

And the attach patch makes it full proof so they can be ran at the same
line.

Thanks,
Samuli

--------------080002070304050708050802
Content-Type: text/x-patch;
 name="parallel-make.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="parallel-make.patch"

diff -ur mdadm-3.3.1.orig/Makefile mdadm-3.3.1/Makefile
--- mdadm-3.3.1.orig/Makefile	2014-06-05 09:45:56.000000000 +0300
+++ mdadm-3.3.1/Makefile	2014-07-17 09:52:51.670100989 +0300
@@ -281,26 +281,26 @@
 	$(INSTALL) -D -m 644 mdadm.conf.5 $(DESTDIR)$(MAN5DIR)/mdadm.conf.5
 
 install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules
-	@for file in 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
-	do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp && \
-	   echo $(INSTALL) -D -m 644 udev-$${file#??-} $(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
-	   $(INSTALL) -D -m 644 .install.tmp $(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
-	   rm -f .install.tmp; \
+	@for file1 in 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
+	do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file1#??-} > .install.tmp.1 && \
+	   echo $(INSTALL) -D -m 644 udev-$${file1#??-} $(DESTDIR)$(UDEVDIR)/rules.d/$$file1 ; \
+	   $(INSTALL) -D -m 644 .install.tmp.1 $(DESTDIR)$(UDEVDIR)/rules.d/$$file1 ; \
+	   rm -f .install.tmp.1; \
 	done
 
 install-systemd: systemd/mdmon@.service
-	@for file in mdmon@.service mdmonitor.service mdadm-last-resort@.timer \
+	@for file2 in mdmon@.service mdmonitor.service mdadm-last-resort@.timer \
 		mdadm-last-resort@.service ; \
-	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp && \
-	   echo $(INSTALL) -D -m 644 systemd/$$file $(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
-	   $(INSTALL) -D -m 644 .install.tmp $(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
-	   rm -f .install.tmp; \
+	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file2 > .install.tmp.2 && \
+	   echo $(INSTALL) -D -m 644 systemd/$$file2 $(DESTDIR)$(SYSTEMD_DIR)/$$file2 ; \
+	   $(INSTALL) -D -m 644 .install.tmp.2 $(DESTDIR)$(SYSTEMD_DIR)/$$file2 ; \
+	   rm -f .install.tmp.2; \
 	done
-	@for file in mdadm.shutdown ; \
-	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp && \
-	   echo $(INSTALL) -D -m 755  systemd/$$file $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
-	   $(INSTALL) -D -m 755  .install.tmp $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
-	   rm -f .install.tmp; \
+	@for file3 in mdadm.shutdown ; \
+	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file3 > .install.tmp.3 && \
+	   echo $(INSTALL) -D -m 755  systemd/$$file3 $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file3 ; \
+	   $(INSTALL) -D -m 755  .install.tmp.3 $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file3 ; \
+	   rm -f .install.tmp.3; \
 	done
 	if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m 755 systemd/SUSE-mdadm_env.sh $(DESTDIR)$(SYSTEMD_DIR)/../scripts/mdadm_env.sh ;fi
 

--------------080002070304050708050802--
