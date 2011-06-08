From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 8 - v2] MD:  raid5 do not set fullsync
Date: Wed, 08 Jun 2011 13:00:28 -0500
Message-ID: <1307556028.9555.10.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil, thanks for the insight on 'saved_raid_disk' - this is indeed better.

 brassow
==========

Add check to determine if a device needs full resync or if partial resync will do

RAID 5 was assuming that if a device was not In_sync, it must undergo a full
resync.  We add a check to see if 'saved_raid_disk' is the same as 'raid_disk'.
If it is, we can safely skip the full resync and rely on the bitmap for
partial recovery instead.  This is the legitimate purpose of 'saved_raid_disk',
from md.h:
int saved_raid_disk;            /* role that device used to have in the
                                 * array and could again if we did a partial
                                 * resync from the bitmap
                                 */

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -4858,7 +4858,7 @@ static raid5_conf_t *setup_conf(mddev_t 
 			printk(KERN_INFO "md/raid:%s: device %s operational as raid"
 			       " disk %d\n",
 			       mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
-		} else
+		} else if (rdev->saved_raid_disk != raid_disk)
 			/* Cannot rely on bitmap to complete recovery */
 			conf->fullsync = 1;
 	}


