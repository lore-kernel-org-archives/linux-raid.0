From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH] MD RAID10: Fix oops when creating RAID10 arrays via
 dm-raid.c
Date: Thu, 25 Oct 2012 01:17:50 -0500
Message-ID: <1351145870.20327.2.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, jbrassow@redhat.com
List-Id: linux-raid.ids

Commit 2863b9eb didn't take into account the changes to add TRIM support to
RAID10 (commit 532a2a3fb).  That is, when using dm-raid.c to create the
RAID10 arrays, there is no mddev->gendisk or mddev->queue.  The code added
to support TRIM simply assumes that mddev->queue is available without
checking.  The result is an oops any time dm-raid.c attempts to create a
RAID10 device.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-upstream/drivers/md/raid10.c
===================================================================
--- linux-upstream.orig/drivers/md/raid10.c
+++ linux-upstream/drivers/md/raid10.c
@@ -1783,7 +1783,7 @@ static int raid10_add_disk(struct mddev
 		clear_bit(Unmerged, &rdev->flags);
 	}
 	md_integrity_add_rdev(rdev, mddev);
-	if (blk_queue_discard(bdev_get_queue(rdev->bdev)))
+	if (mddev->queue && blk_queue_discard(bdev_get_queue(rdev->bdev)))
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
 
 	print_conf(conf);
@@ -3613,11 +3613,14 @@ static int run(struct mddev *mddev)
 			discard_supported = true;
 	}
 
-	if (discard_supported)
-		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
-	else
-		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
-
+	if (mddev->queue) {
+		if (discard_supported)
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
+						mddev->queue);
+		else
+			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD,
+						  mddev->queue);
+	}
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
 		printk(KERN_ERR "md/raid10:%s: not enough operational mirrors.\n",


