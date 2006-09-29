From: NeilBrown <neilb@suse.de>
Subject: [PATCH 005 of 6] md: Allow SET_BITMAP_FILE to work on 64bit kernel with 32bit userspace.
Date: Fri, 29 Sep 2006 12:53:22 +1000
Message-ID: <1060929025322.15302@suse.de>
References: <20060929125047.14064.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965059AbWI2Cxs@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


From: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/compat_ioctl.h |    1 +
 1 file changed, 1 insertion(+)

diff .prev/include/linux/compat_ioctl.h ./include/linux/compat_ioctl.h
--- .prev/include/linux/compat_ioctl.h	2006-09-29 11:49:49.000000000 +1000
+++ ./include/linux/compat_ioctl.h	2006-09-29 11:49:49.000000000 +1000
@@ -125,6 +125,7 @@ COMPATIBLE_IOCTL(RUN_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
+ULONG_IOCTL(SET_BITMAP_FILE)
 /* DM */
 COMPATIBLE_IOCTL(DM_VERSION_32)
 COMPATIBLE_IOCTL(DM_REMOVE_ALL_32)
