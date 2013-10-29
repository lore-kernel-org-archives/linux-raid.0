From: Aurelien Jarno <aurelien@aurel32.net>
Subject: [PATCH] UAPI: include <asm/byteorder.h> in linux/raid/md_p.h
Date: Tue, 29 Oct 2013 13:28:58 +0100
Message-ID: <1383049738-26107-1-git-send-email-aurelien@aurel32.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Aurelien Jarno <aurelien@aurel32.net>
List-Id: linux-raid.ids

linux/raid/md_p.h is using conditionals depending on endianess and fails
with an error if neither of __BIG_ENDIAN, __LITTLE_ENDIAN or
__BYTE_ORDER are defined, but it doesn't include any header which can
define these constants. This make this header unusable alone.

This patch adds a #include <asm/byteorder.h> at the beginning of this
header to make it usable alone. This is needed to compile klibc on MIPS.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 include/uapi/linux/raid/md_p.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index fe1a540..f7cf7f3 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -16,6 +16,7 @@
 #define _MD_P_H
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 /*
  * RAID superblock.
-- 
1.8.3.1
