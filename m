From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 8] MD:  raid5 do not set fullsync
Date: Tue, 07 Jun 2011 17:52:43 -0500
Message-ID: <1307487163.31279.18.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Add new flag for struct mdk_rdev_s to indicate when recovery can use bitmap

Device-mapper can tell if a device is in-sync, in need of partial (bitmap aided)
recovery, or in need of complete recovery.  The raid5 code assumes that if a
device is not in-sync, then it must undergo complete recovery - it does not
honor the bitmap.  The flag 'RecoverByBitmap' has been introduced to force raid5
not to set 'conf->fullsync' if the superblock routines have already determined
that only a partial recovery is necessary.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -4858,7 +4858,7 @@ static raid5_conf_t *setup_conf(mddev_t 
 			printk(KERN_INFO "md/raid:%s: device %s operational as raid"
 			       " disk %d\n",
 			       mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
-		} else
+		} else if (!test_bit(RecoverByBitmap, &rdev->flags))
 			/* Cannot rely on bitmap to complete recovery */
 			conf->fullsync = 1;
 	}
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -77,6 +77,8 @@ struct mdk_rdev_s
 #define Blocked		8		/* An error occurred on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
+#define RecoverByBitmap 9               /* Used by device-mapper to ensure this
+					 * device is recovered by the bitmap. */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */


