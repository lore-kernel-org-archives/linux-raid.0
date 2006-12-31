From: Neil Brown <neilb@suse.de>
Subject: Re: unknown ioctl32 cmd
Date: Sun, 31 Dec 2006 15:43:28 +1100
Message-ID: <17815.16368.340739.88928@notabene.brown>
References: <Pine.LNX.4.61.0612310014080.32449@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Sunday December 31
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 31, jengelh@linux01.gwdg.de wrote:
> Hi,
> 
> 
> 
> this line in mdadm-2.5.4
> 
> Detail.c:
> 185:  ioctl(fd, GET_BITMAP_FILE, &bmf) == 0 &&
> 
> causes a dmesg warning when running `mdadm -D /dev/md0`:
> 
> ioctl32(mdadm:2946): Unknown cmd fd(7) cmd(50000915){10} arg(ff2905d0) 
> on /dev/md0
> 
> on Aurora Linux corona_2.90 with 2.6.18-1.2798.al3.1smp(sparc64). The 
> raid array was created using `mdadm -C /dev/md0 -l 1 -n 2 missing 
> /dev/sdb2 -e 1.0`. Given that "case GET_BITMAP_FILE" is handled in 
> (2.6.18.5), I wonder what exactly is causing this.
> 
> 
> Keep me on Cc, but you always do that. Thanks :)
> 
> 	-`J'
> -- 

That would be fixed by the patch below which is post 2.6.18.

NeilBrown


http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da3ed32fe568148ede256975d40825ffcdac767b;hp=2e333e89860431d22816c1bdaa2ea72c2753396e


From: NeilBrown <neilb@suse.de>
Date: Sat, 21 Oct 2006 17:24:08 +0000 (-0700)
Subject: [PATCH] md: add another COMPAT_IOCTL for md
X-Git-Tag: v2.6.19-rc3
X-Git-Url: http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da3ed32fe568148ede256975d40825ffcdac767b

[PATCH] md: add another COMPAT_IOCTL for md

..  so that you can use bitmaps with 32bit userspace on a 64 bit kernel.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
---

--- a/include/linux/compat_ioctl.h
+++ b/include/linux/compat_ioctl.h
@@ -131,6 +131,7 @@ COMPATIBLE_IOCTL(RUN_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
+COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
 /* DM */
 COMPATIBLE_IOCTL(DM_VERSION_32)
