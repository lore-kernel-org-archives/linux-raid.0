From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 1/3] md:Add support for Raid0->Raid5 takeover
Date: Fri, 29 Jan 2010 14:54:03 +0000
Message-ID: <F2A46F4A087B8547923AD59C289DC90E01D16226@irsmsx002.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hello Neil, I'm sending patches with new takeover transitions proposal:
0->5(4), 5(4)->0, 10->0, 0->10.

Regards,
Maciek


Signed-off-by: Maciej Trela <maciej.trela@intel.com>
---
 drivers/md/raid5.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e84204e..0fe78ea 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5614,6 +5614,39 @@ static void raid5_quiesce(mddev_t *mddev, int state)
 }
 
 
+static void *raid5_takeover_raid0(mddev_t *mddev)
+{
+	int chunksect;
+	
+	if (mddev->degraded > 0) {
+	    printk(KERN_ERR "ERROR: Raid0 with degraded disks!: %d\n", mddev->degraded);
+		return ERR_PTR(-EINVAL);
+	}
+	
+	chunksect = 64*2; /* 64K by default */
+
+	/* The array must be an exact multiple of chunksize */
+	while (chunksect && (mddev->array_sectors & (chunksect-1)))
+		chunksect >>= 1;
+
+	if ((chunksect<<9) < STRIPE_SIZE) {
+		/* array size does not allow a suitable chunk size */
+		return ERR_PTR(-EINVAL);
+	}
+	
+	mddev->new_level = 5;
+	mddev->new_layout = ALGORITHM_PARITY_N;
+	mddev->new_chunk_sectors = chunksect;
+	mddev->degraded++;
+	mddev->raid_disks++;
+	mddev->delta_disks++;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	return setup_conf(mddev);
+}
+
+
 static void *raid5_takeover_raid1(mddev_t *mddev)
 {
 	int chunksect;
@@ -5737,12 +5770,29 @@ static int raid6_check_reshape(mddev_t *mddev)
 
 static void *raid5_takeover(mddev_t *mddev)
 {
+	mdk_rdev_t *rdev;
+	sector_t sectors, dev_sectors;
+
 	/* raid5 can take over:
 	 *  raid0 - if all devices are the same - make it a raid4 layout
 	 *  raid1 - if there are two drives.  We need to know the chunk size
 	 *  raid4 - trivial - just use a raid4 layout.
 	 *  raid6 - Providing it is a *_6 layout
 	 */
+	if (mddev->level == 0) {
+		/* make sure all devices are the same (only one zone is supported) */
+		sectors = mddev->dev_sectors;
+		sector_div(sectors, mddev->chunk_sectors);
+		list_for_each_entry(rdev, &mddev->disks, same_set) {
+			dev_sectors = rdev->sectors;
+			sector_div(dev_sectors, mddev->chunk_sectors);
+			if (dev_sectors != sectors) {
+				printk("error: cannot takeover raid 0 with different dev sizes.\n");
+				return ERR_PTR(-EINVAL);
+			}
+		}
+		return raid5_takeover_raid0(mddev);
+	}
 
 	if (mddev->level == 1)
 		return raid5_takeover_raid1(mddev);
-- 
1.6.3.3


