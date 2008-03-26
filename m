From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/8] md: Simplify restart_array().
Date: Wed, 26 Mar 2008 01:25:24 +0100
Message-ID: <S1754107AbYGHQdk/20080708163340Z+62@vger.kernel.org>
References: <20080708155541.GS23944@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080708155541.GS23944@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   46 ++++++++++++++++------------------------------
 1 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index bf1499c..90b6d1d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3610,38 +3610,24 @@ static int do_md_run(mddev_t * mddev)
 static int restart_array(mddev_t *mddev)
 {
 	struct gendisk *disk = mddev->gendisk;
-	int err;
 
-	/*
-	 * Complain if it has no devices
-	 */
-	err = -ENXIO;
+	/* Complain if it has no devices */
 	if (list_empty(&mddev->disks))
-		goto out;
-
-	if (mddev->pers) {
-		err = -EBUSY;
-		if (!mddev->ro)
-			goto out;
-
-		mddev->safemode = 0;
-		mddev->ro = 0;
-		set_disk_ro(disk, 0);
-
-		printk(KERN_INFO "md: %s switched to read-write mode.\n",
-			mdname(mddev));
-		/*
-		 * Kick recovery or resync if necessary
-		 */
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		md_wakeup_thread(mddev->thread);
-		md_wakeup_thread(mddev->sync_thread);
-		err = 0;
-	} else
-		err = -EINVAL;
-
-out:
-	return err;
+		return -ENXIO;
+	if (!mddev->pers)
+		return -EINVAL;
+	if (!mddev->ro)
+		return -EBUSY;
+	mddev->safemode = 0;
+	mddev->ro = 0;
+	set_disk_ro(disk, 0);
+	printk(KERN_INFO "md: %s switched to read-write mode.\n",
+		mdname(mddev));
+	/* Kick recovery or resync if necessary */
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread);
+	return 0;
 }
 
 /* similar to deny_write_access, but accounts for our holding a reference
-- 
1.5.3.8

