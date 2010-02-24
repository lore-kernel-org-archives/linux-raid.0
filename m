From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 6/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:43:54 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65BE@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From 4655d0b51ae7351d04c71e20527416a1842f02eb Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:27:15 +0100
Subject: [PATCH] OLCE: Changes to raid5 required by raid0

Changes to be committed:
	modified:   raid5.c

Changes to raid5 required by takeovered raid0 array to be reshaped

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/raid5.c |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c7a3ca6..724798e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5188,11 +5188,43 @@ static void print_raid5_conf (raid5_conf_t *conf)
 	}
 }
 
+/**********************************************************
+ for external meta
+ get missing drives and if mddev->degraded value
+ is less than missing drives, update it
+	 parameters:
+		mddev
+	returns:
+		counted degraded drives
+**********************************************************/
+static int raid5_get_degraded_drives(mddev_t *mddev)
+{
+	int retVal = 0;
+	raid5_conf_t *conf = mddev->private;
+	int i;
+	struct disk_info *tmp;
+
+	/* count not existing drives */
+	for (i = 0; i < conf->raid_disks; i++) {
+		tmp = conf->disks + i;
+		if (tmp->rdev)
+			retVal++;
+	}
+	/* count degraded based on non existing drives */
+	retVal = mddev->raid_disks - retVal;
+
+	printk(KERN_INFO "raid5: Counted %i absent/degraded disks.\n", retVal);
+
+	return retVal;
+}
+
 static int raid5_spare_active(mddev_t *mddev)
 {
 	int i;
 	raid5_conf_t *conf = mddev->private;
 	struct disk_info *tmp;
+	int degraded = 0;
+	unsigned long flags;
 
 	for (i = 0; i < conf->raid_disks; i++) {
 		tmp = conf->disks + i;
@@ -5205,6 +5237,18 @@ static int raid5_spare_active(mddev_t *mddev)
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 		}
 	}
+	/* check degraded disks - needed by Raid0 OLCE
+	 * count degraded based on non existing drives
+	 */
+	degraded = raid5_get_degraded_drives(mddev);
+	/* this cannot be more than degraded disks */
+	if (mddev->degraded < degraded) {
+		/* so, fix degraded disk number in system */
+		printk(KERN_INFO "Fixing DEGRADED to %i\n", degraded);
+		spin_lock_irqsave(&conf->device_lock, flags);
+		mddev->degraded = degraded;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
 	print_raid5_conf(conf);
 	return 0;
 }
@@ -5291,6 +5335,24 @@ static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
+		int degraded = 0;
+		unsigned long flags;
+		/* propably OLCE reconfiguration - use it
+		 * check degraded disks - needed by Raid0 OLCE
+		 * count degraded based on non existing drives
+		 */
+		degraded = raid5_get_degraded_drives(mddev);
+		/* this cannot be more than degraded disks */
+		if (mddev->degraded > degraded) {
+			/* so, fix degraded disk number in system */
+			spin_lock_irqsave(&conf->device_lock, flags);
+			mddev->degraded = degraded;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		}
+	}
+
 	print_raid5_conf(conf);
 	return err;
 }
@@ -5944,6 +6006,8 @@ static int raid5_wait_reshape(mddev_t *mddev, unsigned int useTimeout)
 					!test_bit(Faulty, &rdev->flags))
 					spares++;
 
+			degraded = raid5_get_degraded_drives(mddev);
+
 			 /* OLCE new condition */
 			if ((conf->raid_disks - mddev->raid_disks > conf->max_degraded) ||
 			    (mddev->degraded > conf->max_degraded) ||
-- 
1.6.0.2

