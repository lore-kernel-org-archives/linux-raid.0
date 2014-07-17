From: Samuli Suominen <ssuominen@gentoo.org>
Subject: Re: [PATCH] Parallel make bug in Makefile of mdadm-3.3.1 (corrupted
 udev rules and/or systemd services)
Date: Thu, 17 Jul 2014 11:31:29 +0300
Message-ID: <53C789E1.50604@gentoo.org>
References: <53C77B7D.2090907@gentoo.org> <20140717182517.23bf37d3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140717182517.23bf37d3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 17/07/14 11:25, NeilBrown wrote:
> On Thu, 17 Jul 2014 10:30:05 +0300 Samuli Suominen <ssuominen@gentoo.org>
> wrote:
>
>> If you run with:
>>
>> $ export MAKEFLAGS="-j9"
>> $ make install install-systemd
>>
>> As in, combine "install" and "install-systemd" in the same command using
>> parallel make,
>> the content of .service files could end up in .rules, or otherway around
>> because GNU
>> make fill run them in parallel and the commands might ran at the same
>> time, and both
>> use same variables $file and same temporary files .install.tmp
>>
>> This was reported at,
>> https://bugs.gentoo.org/show_bug.cgi?id=517218
>>
>> The immediate workaround is,
>>
>> $ export MAKEFLAGS="-j9"
>> $ make install
>> $ make install-systemd
>>
>> And the attach patch makes it full proof so they can be ran at the same
>> line.
>>
>> Thanks,
>> Samuli
> Hi,
>  thanks for the bug report and the patch!
>
> I don't think it is necessary to change the name for the variable (file ->
> file1, file2 or file3).  Just leave it as 'file'.
> However changing the name is important.  Could you send a patch which just
> does that, and I'll apply it.
>
> Also if the patch could be included inline in the mail, rather than as an
> attachment, that would be nice.
>
> (But if you don't want to bother, I'll make the fix anyway and credit you).
>
> Thanks,
> NeilBrown

Thanks for the review, I wasn't 100% sure which I should be changing,
the variable, or the filename,
so I changed both.
So, you are most likely correct.

Here is the patch that only changes the filename,

--- mdadm-3.3.1.orig/Makefile
+++ mdadm-3.3.1/Makefile
@@ -282,25 +282,25 @@
 
 install-udev: udev-md-raid-arrays.rules udev-md-raid-assembly.rules
     @for file in 63-md-raid-arrays.rules 64-md-raid-assembly.rules ; \
-    do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp && \
+    do sed -e 's,BINDIR,$(BINDIR),g' udev-$${file#??-} > .install.tmp.1
&& \
        echo $(INSTALL) -D -m 644 udev-$${file#??-}
$(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
-       $(INSTALL) -D -m 644 .install.tmp
$(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
-       rm -f .install.tmp; \
+       $(INSTALL) -D -m 644 .install.tmp.1
$(DESTDIR)$(UDEVDIR)/rules.d/$$file ; \
+       rm -f .install.tmp.1; \
     done
 
 install-systemd: systemd/mdmon@.service
     @for file in mdmon@.service mdmonitor.service
mdadm-last-resort@.timer \
         mdadm-last-resort@.service ; \
-    do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp && \
+    do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp.2 && \
        echo $(INSTALL) -D -m 644 systemd/$$file
$(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
-       $(INSTALL) -D -m 644 .install.tmp
$(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
-       rm -f .install.tmp; \
+       $(INSTALL) -D -m 644 .install.tmp.2
$(DESTDIR)$(SYSTEMD_DIR)/$$file ; \
+       rm -f .install.tmp.2; \
     done
     @for file in mdadm.shutdown ; \
-    do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp && \
+    do sed -e 's,BINDIR,$(BINDIR),g' systemd/$$file > .install.tmp.3 && \
        echo $(INSTALL) -D -m 755  systemd/$$file
$(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
-       $(INSTALL) -D -m 755  .install.tmp
$(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
-       rm -f .install.tmp; \
+       $(INSTALL) -D -m 755  .install.tmp.3
$(DESTDIR)$(SYSTEMD_DIR)-shutdown/$$file ; \
+       rm -f .install.tmp.3; \
     done
     if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m
755 systemd/SUSE-mdadm_env.sh
$(DESTDIR)$(SYSTEMD_DIR)/../scripts/mdadm_env.sh ;fi

