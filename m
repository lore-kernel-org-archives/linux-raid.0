From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] md SET_BITMAP_FILE compat ioctl
Date: Fri, 22 Sep 2006 11:29:18 -0400
Message-ID: <4514014E.1060302@steeleye.com>
References: <4512F55D.5030907@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060709020601050200060705"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4512F55D.5030907@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060709020601050200060705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The SET_BITMAP_FILE ioctl currently doesn't have a compat entry, so on 
64-bit systems a 32-bit mdadm will fail:

Sep 20 16:34:52 caspian kernel: ioctl32(mdadm:8056): Unknown cmd fd(3) 
cmd(8004092b){00} arg(00000004) on /dev/md0

The fix is to build a 64-bit mdadm or apply the following patch (compile 
tested only).

--
Paul

--------------060709020601050200060705
Content-Type: text/plain;
 name="md_set_bitmap_file_compat_ioctl.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_set_bitmap_file_compat_ioctl.diff"

--- ./include/linux/compat_ioctl.h.orig	2006-09-22 11:14:53.000000000 -0400
+++ ./include/linux/compat_ioctl.h	2006-09-22 11:15:24.000000000 -0400
@@ -121,6 +121,7 @@ ULONG_IOCTL(START_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY)
 COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
+ULONG_IOCTL(SET_BITMAP_FILE)
 /* DM */
 COMPATIBLE_IOCTL(DM_VERSION_32)
 COMPATIBLE_IOCTL(DM_REMOVE_ALL_32)

--------------060709020601050200060705--
