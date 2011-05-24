From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH 9 of 9] MD:  raid5 do not set fullsync
Date: Mon, 23 May 2011 22:07:26 -0500
Message-ID: <201105240307.p4O37Q4J029805@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-raid5-do-not-set-fullsync.patch

Add new flag for struct mdk_rdev_s to indicate when recovery can use bitmap

The version 2 superblock routines (device-mapper) can tell if a device is
in-sync, in need of partial (bitmap aided) recovery, or in need of complete
recovery.  The raid5 code assumes that if a device is not in-sync, then it must
undergo complete recovery - it does not honor the bitmap.  The flag
'RecoverByBitmap' has been introduced to force raid5 not to set
'conf->fullsync' if the superblock routines have already determined that only
a partial recovery is necessary.

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
Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -2009,8 +2009,10 @@ static int super_2_validate(mddev_t *mdd
 	if (test_bit(Faulty, &rdev->flags)) {
 		clear_bit(Faulty, &rdev->flags);
 		clear_bit(In_sync, &rdev->flags);
+		set_bit(RecoverByBitmap, &rdev->flags);
 		rdev->recovery_offset = 0;
-		printk(KERN_INFO "md: %s: Dev #%d previously marked as failed\n",
+		printk(KERN_INFO
+		       "md: %s: Dev #%d recovering from transient failure\n",
 		       mdname(mddev), rdev->raid_disk);
 	}
 
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -79,6 +79,8 @@ struct mdk_rdev_s
 					 * until it is cleared */
 #define FirstUse        9               /* Used by device-mapper interface when
 					 * initializing first-time devices. */
+#define RecoverByBitmap 10              /* Used by device-mapper to ensure
+					 * this device is recovered by bitmap. */
 	wait_queue_head_t blocked_wait;
 
 	int desc_nr;			/* descriptor index in the superblock */
