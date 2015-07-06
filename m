From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial] dm: Spelling s/consitent/consistent/
Date: Mon,  6 Jul 2015 15:39:17 +0200
Message-ID: <1436189957-10930-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Jiri Kosina <trivial@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-raid.ids

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/md/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index b59727309072462f..87338a0aab32f4a4 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -478,7 +478,7 @@ config DM_LOG_WRITES
 	  This device-mapper target takes two devices, one device to use
 	  normally, one to log all write operations done to the first device.
 	  This is for use by file system developers wishing to verify that
-	  their fs is writing a consitent file system at all times by allowing
+	  their fs is writing a consistent file system at all times by allowing
 	  them to replay the log in a variety of ways and to check the
 	  contents.
 
-- 
1.9.1
