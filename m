From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 3] MD RAID10: Prep for DM RAID10 device replacement
 capability
Date: Fri, 24 Aug 2012 13:18:35 -0500
Message-ID: <1345832315.25206.16.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

MD RAID10:  Fix a couple potential kernel panics if RAID10 is used by dm-raid

When device-mapper uses the RAID10 personality through dm-raid.c, there is no
'gendisk' structure in mddev and some sysfs information is also not populated.

This patch avoids touching those non-existent structures.

Signed-off-by: Jonathan Brassow <jbrassow@rehdat.com>

Index: linux-upstream/drivers/md/md.c
===================================================================
--- linux-upstream.orig/drivers/md/md.c
+++ linux-upstream/drivers/md/md.c
@@ -2056,8 +2056,14 @@ EXPORT_SYMBOL(md_integrity_register);
 /* Disable data integrity if non-capable/non-matching disk is being added */
 void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
-	struct blk_integrity *bi_rdev = bdev_get_integrity(rdev->bdev);
-	struct blk_integrity *bi_mddev = blk_get_integrity(mddev->gendisk);
+	struct blk_integrity *bi_rdev;
+	struct blk_integrity *bi_mddev;
+
+	if (!mddev->gendisk)
+		return;
+
+	bi_rdev = bdev_get_integrity(rdev->bdev);
+	bi_mddev = blk_get_integrity(mddev->gendisk);
 
 	if (!bi_mddev) /* nothing to do */
 		return;
Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -1632,7 +1632,7 @@ static int raid10_spare_active(struct md
 			   && !test_bit(Faulty, &tmp->rdev->flags)
 			   && !test_and_set_bit(In_sync, &tmp->rdev->flags)) {
 			count++;
-			sysfs_notify_dirent(tmp->rdev->sysfs_state);
+			sysfs_notify_dirent_safe(tmp->rdev->sysfs_state);
 		}
 	}
 	spin_lock_irqsave(&conf->device_lock, flags);


