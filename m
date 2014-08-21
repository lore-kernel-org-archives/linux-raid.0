From: Samuli Suominen <ssuominen@gentoo.org>
Subject: Re: The parallel make patch for mdadm
Date: Thu, 21 Aug 2014 06:56:48 +0300
Message-ID: <53F56E00.4090307@gentoo.org>
References: <53F4DE42.4030308@gentoo.org> <20140821104357.511f7d7e@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070408050100030900030805"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140821104357.511f7d7e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070408050100030900030805
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit


On 21/08/14 03:43, NeilBrown wrote:
> On Wed, 20 Aug 2014 20:43:30 +0300 Samuli Suominen <ssuominen@gentoo.org>
> wrote:
>
>> I think you forgot to apply the patch?
>>
>> Link to it,
>>
>> http://www.spinics.net/lists/raid/msg46782.html
> No, I sent you a reply which you didn't respond to.
>
> I've attached it.
>
> NeilBrown
>

Sorry! I blame my mail client, and can't immediately find the
responsible kludge
from Thunderbird.

So, here is it as attachment, properly git formatted patch.



--------------070408050100030900030805
Content-Type: text/x-patch;
 name="0001-Fix-parallel-make-problem-as-in-when-make-is-called-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-parallel-make-problem-as-in-when-make-is-called-.pa";
 filename*1="tch"

From 917d62be74f07dc433ab4ddb224e7f3e04505ac1 Mon Sep 17 00:00:00 2001
From: Samuli Suominen <ssuominen@gentoo.org>
Date: Thu, 21 Aug 2014 06:53:54 +0300
Subject: [PATCH] Fix parallel make problem, as in, when make is called with,
 for example, "make -j9 install install-system", both install and install-systemd
 targets at the same line and with high -j value.
 Same install.tmp file was used, and udev rules ended up in systemd
 service files, or otherway around.
 For more information, see:
 http://www.spinics.net/lists/raid/msg46782.html
 http://bugs.gentoo.org/show_bug.cgi?id=517218

---
 Makefile | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index 361e625..f058a22 100644
--- a/Makefile
+++ b/Makefile
@@ -282,25 +282,25 @@ install-man: mdadm.8 md.4 mdadm.conf.5 mdmon.8
 
 install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules
 	@for file in 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
-	do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp && \
+	do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp.1 && \
 	   echo $(INSTALL) -D -m 644 udev-$${file#??-} $(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
-	   $(INSTALL) -D -m 644 .install.tmp $(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
-	   rm -f .install.tmp; \
+	   $(INSTALL) -D -m 644 .install.tmp.1 $(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
+	   rm -f .install.tmp.1; \
 	done
 
 install-systemd: systemd/mdmon@.service
 	@for file in mdmon@.service mdmonitor.service mdadm-last-resort@.timer \
 		mdadm-last-resort@.service mdadm-grow-continue@.service; \
-	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp && \
+	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp.2 && \
 	   echo $(INSTALL) -D -m 644 systemd/$$file $(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
-	   $(INSTALL) -D -m 644 .install.tmp $(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
-	   rm -f .install.tmp; \
+	   $(INSTALL) -D -m 644 .install.tmp.2 $(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
+	   rm -f .install.tmp.2; \
 	done
 	@for file in mdadm.shutdown ; \
-	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp && \
+	do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp.3 && \
 	   echo $(INSTALL) -D -m 755  systemd/$$file $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
-	   $(INSTALL) -D -m 755  .install.tmp $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
-	   rm -f .install.tmp; \
+	   $(INSTALL) -D -m 755  .install.tmp.3 $(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
+	   rm -f .install.tmp.3; \
 	done
 	if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m 755 systemd/SUSE-mdadm_env.sh $(DESTDIR)$(SYSTEMD_DIR)/../scripts/mdadm_env.sh ;fi
 
-- 
2.0.2


--------------070408050100030900030805--
