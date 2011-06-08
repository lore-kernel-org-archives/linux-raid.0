From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD:  use is_power_of_2 macro
Date: Wed, 08 Jun 2011 13:01:10 -0500
Message-ID: <1307556070.9555.11.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Make use of is_power_of_2 macro.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -651,7 +651,7 @@ static int bitmap_read_sb(struct bitmap 
 		reason = "unrecognized superblock version";
 	else if (chunksize < 512)
 		reason = "bitmap chunksize too small";
-	else if ((1 << ffz(~chunksize)) != chunksize)
+	else if (!is_power_of_2(chunksize))
 		reason = "bitmap chunksize not a power of 2";
 	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT)
 		reason = "daemon sleep period out of range";


