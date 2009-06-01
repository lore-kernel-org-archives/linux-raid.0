From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject : PATCH [001:001]: raid0 devices size should be aligned to
	chunk size
Date: Mon, 01 Jun 2009 21:55:54 +0300
Message-ID: <1243882554.6331.7.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

raid devices should be aligned to a chunk size 
(when this feature will be enabled)  because zones 
will become un-aligned to chunks and we will traverse
between zones in a single IO access. 

 raid0.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)
Signed-off-by: raziebe@gmail.com
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0fcd9b5..987a926 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -302,6 +302,26 @@ static sector_t raid0_size(mddev_t *mddev, sector_t sectors, int raid_disks)
 	return array_sectors;
 }
 
+/*
+ *	Align devices to a chunk size, else zones will not be aligned
+*/
+static void align_devices_to_chunk_size(struct list_head *disks,
+					int chunk_sects)
+{
+	sector_t sectors;
+	mdk_rdev_t *rdev;
+
+	list_for_each_entry(rdev, disks, same_set) {
+		sectors = rdev->sectors;
+		sector_div(sectors, chunk_sects);
+		sectors = sectors * chunk_sects;
+		printk(KERN_INFO "raid0: reduce device size: %lld --> %lld\n",
+				(unsigned long long)rdev->sectors,
+				(unsigned long long)sectors);
+		rdev->sectors = sectors;
+	}
+}
+
 static int raid0_run(mddev_t *mddev)
 {
 	int ret;
@@ -313,7 +333,7 @@ static int raid0_run(mddev_t *mddev)
 	}
 	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
-
+	align_devices_to_chunk_size(&mddev->disks, mddev->chunk_sectors);
 	ret = create_strip_zones(mddev);
 	if (ret < 0)
 		return ret;


