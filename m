From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [md PATCH 5/8] Enable OLCE for external IMSM metadata
Date: Wed, 24 Feb 2010 07:43:42 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D1016F65BD@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From ace2e51b3e08fac68f4c62446aba456f82a6af6d Mon Sep 17 00:00:00 2001
From: Adam Kwolek <adam.kwolek@intel.com>
Date: Thu, 18 Feb 2010 11:26:43 +0100
Subject: [PATCH] OLCE: new_dev and raid_disks changes

Changes to be committed:
	modified:   md.c
	modified:   raid5.c

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---
 drivers/md/md.c    |   25 +++++++++++++++++++++----
 drivers/md/raid5.c |    8 ++++++--
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c7d32c9..5e31b36 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3250,7 +3250,7 @@ new_dev_store(mddev_t *mddev, const char *buf, size_t len)
 	int minor;
 	dev_t dev;
 	mdk_rdev_t *rdev;
-	int err;
+	int err = 0;
 
 	if (!*buf || *e != ':' || !e[1] || e[1] == '\n')
 		return -EINVAL;
@@ -5296,11 +5296,28 @@ static int update_raid_disks(mddev_t *mddev, int raid_disks)
 	if (mddev->pers->check_reshape == NULL)
 		return -EINVAL;
 	if (raid_disks <= 0 ||
-	    raid_disks >= mddev->max_disks)
-		return -EINVAL;
+	    raid_disks >= mddev->max_disks) {
+		if (mddev->external &&
+		    (mddev->max_disks == 0)) {
+			printk(KERN_WARNING "OLCE: in update_raid_disks() variable mddev->max_disks is set to MD_SB_DISKS\n");
+			mddev->max_disks = MD_SB_DISKS;
+		} else {
+			return -EINVAL;
+		}
+	}
+
 	if (mddev->sync_thread || mddev->reshape_position != MaxSector)
 		return -EBUSY;
-	mddev->delta_disks = raid_disks - mddev->raid_disks;
+
+	 /* OLCE for external meta */
+	if (mddev->external) {
+		/* increase raid_disks for external meta only */
+		if (raid_disks - mddev->raid_disks >= 0)
+			mddev->delta_disks = raid_disks - mddev->raid_disks;
+		else
+			return -EINVAL;
+	} else
+		mddev->delta_disks = raid_disks - mddev->raid_disks;
 
 	rv = mddev->pers->check_reshape(mddev);
 	return rv;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 1c6022d..c7a3ca6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5260,9 +5260,13 @@ static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
-	if (mddev->degraded > conf->max_degraded)
+	if (mddev->degraded > conf->max_degraded) {
 		/* no point adding a device */
-		return -EINVAL;
+		if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+			return -EINVAL;
+
+		/* OLCE reconfiguration - add device */
+	}
 
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
-- 
1.6.0.2

