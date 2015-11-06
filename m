From: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] md: MD_RAID456 now depends on LIBCRC32C
Date: Fri,  6 Nov 2015 09:31:07 -0800
Message-ID: <1446831067-32648-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
List-Id: linux-raid.ids

Since commit 5cb2fbd6ea0d1 ("raid5-cache: use crc32c checksum"),
parisc:generic-32bit_defconfig and probably other builds fail as follows.

ERROR: "crc32c" [drivers/md/raid456.ko] undefined!

Fixes: 5cb2fbd6ea0d1 ("raid5-cache: use crc32c checksum")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 3e01e6fb3424..1d5609ca2bbe 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -127,6 +127,7 @@ config MD_RAID456
 	select ASYNC_XOR
 	select ASYNC_PQ
 	select ASYNC_RAID6_RECOV
+	select LIBCRC32C
 	---help---
 	  A RAID-5 set of N drives with a capacity of C MB per drive provides
 	  the capacity of C * (N - 1) MB, and protects against a failure
-- 
2.1.4
