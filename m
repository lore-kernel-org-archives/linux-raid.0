From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] raid5-cache: add crc32c Kconfig dependency
Date: Tue, 03 Nov 2015 15:12:01 +0100
Message-ID: <4308930.z8rrqMJU90@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-raid.ids

The recent change of the raid5-cache code to use crc32c instead
of crc32 causes link errors when CONFIG_LIBCRC32C is disabled:

drivers/built-in.o: In function crc32c'
core.c:(.text+0x1c6060): undefined reference to `crc32c'

This adds an explicit 'select' statement like all other users
of this function do.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 5cb2fbd6ea0d ("raid5-cache: use crc32c checksum")

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 3e01e6fb3424..7913fdcfc849 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -123,6 +123,7 @@ config MD_RAID456
 	tristate "RAID-4/RAID-5/RAID-6 mode"
 	depends on BLK_DEV_MD
 	select RAID6_PQ
+	select LIBCRC32C
 	select ASYNC_MEMCPY
 	select ASYNC_XOR
 	select ASYNC_PQ

