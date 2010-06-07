From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 03/16] md: don't allow arrays to contain devices with bad
	blocks.
Date: Mon, 07 Jun 2010 10:07:54 +1000
Message-ID: <20100607000753.13302.11121.stgit@notabene.brown>
References: <20100606235833.13302.60932.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606235833.13302.60932.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As no personality understand bad block lists yet, we must
reject any device that is known to contain bad blocks.
As the personalities get taught, these tests can be removed.

This only applies to raid1/raid5/raid10.
For linear/raid0/multipath/faulty the whole concept of bad blocks
doesn't mean anything so there is no point adding the checks.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c  |    7 +++++++
 drivers/md/raid10.c |    8 ++++++++
 drivers/md/raid5.c  |    7 +++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a948da8..82440a7 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1153,6 +1153,9 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = mddev->raid_disks - 1;
 
+	if (rdev->badblocks.count)
+		return -EINVAL;
+
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
@@ -2117,6 +2120,10 @@ static int run(mddev_t *mddev)
 			blk_queue_segment_boundary(mddev->queue,
 						   PAGE_CACHE_SIZE - 1);
 		}
+		if (rdev->badblocks.count) {
+			printk(KERN_ERR "md/raid1: Cannot handle bad blocks yet\n");
+			return -EINVAL;
+		}
 	}
 
 	mddev->degraded = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0372499..20da258 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1129,6 +1129,9 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
+	if (rdev->badblocks.count)
+		return -EINVAL;
+
 	if (mddev->recovery_cp < MaxSector)
 		/* only hot-add to in-sync arrays, as recovery is
 		 * very different from resync
@@ -2296,6 +2299,11 @@ static int run(mddev_t *mddev)
 				 (conf->raid_disks / conf->near_copies));
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
+
+		if (rdev->badblocks.count) {
+			printk(KERN_ERR "md/raid10: cannot handle bad blocks yet\n");
+			goto out_free_conf;
+		}
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= conf->raid_disks
 		    || disk_idx < 0)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8ac122d..5ec9792 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5002,6 +5002,10 @@ static int run(mddev_t *mddev)
 	 * 0 for a fully functional array, 1 or 2 for a degraded array.
 	 */
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (rdev->badblocks.count) {
+			printk(KERN_ERR "md/raid5: cannot handle bad blocks yet\n");
+			goto abort;
+		}
 		if (rdev->raid_disk < 0)
 			continue;
 		if (test_bit(In_sync, &rdev->flags))
@@ -5310,6 +5314,9 @@ static int raid5_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	int first = 0;
 	int last = conf->raid_disks - 1;
 
+	if (rdev->badblocks.count)
+		return -EINVAL;
+
 	if (mddev->degraded > conf->max_degraded)
 		/* no point adding a device */
 		return -EINVAL;


