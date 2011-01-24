From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] Add raid1->raid0 takeover support
Date: Mon, 24 Jan 2011 15:16:34 +0100
Message-ID: <20110124141632.16380.20483.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

This patch introduces raid 1 to raid0 takeover operation
in kernel space.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 drivers/md/raid0.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a39f4c3..c534651 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -179,6 +179,14 @@ static int create_strip_zones(mddev_t *mddev, raid0_conf_t **private_conf)
 			rdev1->new_raid_disk = j;
 		}
 
+		if (mddev->level == 1) {
+			/* taiking over a raid1 array-
+			 * we have only one active disk
+			 */
+			j = 0;
+			rdev1->new_raid_disk = 0;
+		}
+
 		if (j < 0 || j >= mddev->raid_disks) {
 			printk(KERN_ERR "md/raid0:%s: bad disk number %d - "
 			       "aborting!\n", mdname(mddev), j);
@@ -644,12 +652,41 @@ static void *raid0_takeover_raid10(mddev_t *mddev)
 	return priv_conf;
 }
 
+static void *raid0_takeover_raid1(mddev_t *mddev)
+{
+	raid0_conf_t *priv_conf;
+
+	/* Check layout:
+	 *  - (N - 1) mirror drives must be already faulty
+	 */
+	if ((mddev->raid_disks - 1) != mddev->degraded) {
+		printk(KERN_ERR "md/raid0:%s: (N - 1) mirrors drives must be already faulty!\n",
+		       mdname(mddev));
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* Set new parameters */
+	mddev->new_level = 0;
+	mddev->new_layout = 0;
+	mddev->chunk_sectors = 128; /* by default set chunk size to 64k */
+	mddev->new_chunk_sectors = mddev->chunk_sectors;
+	mddev->delta_disks = -1;
+	mddev->raid_disks = 1;
+	mddev->degraded = 0;
+	/* make sure it will be not marked as dirty */
+	mddev->recovery_cp = MaxSector;
+
+	create_strip_zones(mddev, &priv_conf);
+	return priv_conf;
+}
+
 static void *raid0_takeover(mddev_t *mddev)
 {
 	/* raid0 can take over:
 	 *  raid4 - if all data disks are active.
 	 *  raid5 - providing it is Raid4 layout and one disk is faulty
 	 *  raid10 - assuming we have all necessary active disks
+	 *  raid1 - with (N -1) mirror drives faulty
 	 */
 	if (mddev->level == 4)
 		return raid0_takeover_raid45(mddev);
@@ -665,6 +702,12 @@ static void *raid0_takeover(mddev_t *mddev)
 	if (mddev->level == 10)
 		return raid0_takeover_raid10(mddev);
 
+	if (mddev->level == 1)
+		return raid0_takeover_raid1(mddev);
+
+	printk(KERN_ERR "Takeover from raid%i to raid0 not supported\n",
+		mddev->level);
+
 	return ERR_PTR(-EINVAL);
 }
 

