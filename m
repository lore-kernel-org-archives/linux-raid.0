From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 4] md: Add another COMPAT_IOCTL for md.
Date: Fri, 20 Oct 2006 13:25:35 +1000
Message-ID: <1061020032535.1682@suse.de>
References: <20061020120612.29297.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751650AbWJTDZ7@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


.. so that you can use bitmaps with 32bit userspace on a 
64 bit kernel.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/compat_ioctl.h |    1 +
 1 file changed, 1 insertion(+)

diff .prev/include/linux/compat_ioctl.h ./include/linux/compat_ioctl.h
--- .prev/include/linux/compat_ioctl.h	2006-10-20 11:49:14.000000000 +1000
+++ ./include/linux/compat_ioctl.h	2006-10-20 12:00:56.000000000 +1000
@@ -131,6 +131,7 @@ COMPATIBLE_IOCTL(RUN_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
+COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
 /* DM */
 COMPATIBLE_IOCTL(DM_VERSION_32)
