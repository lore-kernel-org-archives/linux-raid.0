From: Jonathan Brassow <jbrassow@f14.redhat.com>
Subject: [PATCH] MD:  raid1 changes to allow use by device mapper
Date: Tue, 24 May 2011 16:01:05 -0500
Message-ID: <201105242101.p4OL15aO012537@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patch name: md-raid1-changes-to-allow-use-by-device-mapper.patch

MD RAID1: Changes to allow RAID1 to be used by device-mapper (dm-raid.c)

Added the necessary congestion function and conditionalize calls requiring an
array 'queue' or 'gendisk'.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/raid1.c
+++ linux-2.6/drivers/md/raid1.c
@@ -497,21 +497,19 @@ static int read_balance(conf_t *conf, r1
 	return best_disk;
 }
 
-static int raid1_congested(void *data, int bits)
+int md_raid1_congested(mddev_t *mddev, int bits)
 {
-	mddev_t *mddev = data;
 	conf_t *conf = mddev->private;
 	int i, ret = 0;
 
-	if (mddev_congested(mddev, bits))
-		return 1;
-
 	rcu_read_lock();
 	for (i = 0; i < mddev->raid_disks; i++) {
 		mdk_rdev_t *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev && !test_bit(Faulty, &rdev->flags)) {
 			struct request_queue *q = bdev_get_queue(rdev->bdev);
 
+			BUG_ON(!q);
+
 			/* Note the '|| 1' - when read_balance prefers
 			 * non-congested targets, it can be removed
 			 */
@@ -524,7 +522,15 @@ static int raid1_congested(void *data, i
 	rcu_read_unlock();
 	return ret;
 }
+EXPORT_SYMBOL_GPL(md_raid1_congested);
 
+static int raid1_congested(void *data, int bits)
+{
+	mddev_t *mddev = data;
+
+	return mddev_congested(mddev, bits) ||
+		md_raid1_congested(mddev, bits);
+}
 
 static void flush_pending_writes(conf_t *conf)
 {
@@ -1972,6 +1978,8 @@ static int run(mddev_t *mddev)
 		return PTR_ERR(conf);
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (!mddev->gendisk)
+			continue;
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
@@ -2013,8 +2021,10 @@ static int run(mddev_t *mddev)
 
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
-	mddev->queue->backing_dev_info.congested_fn = raid1_congested;
-	mddev->queue->backing_dev_info.congested_data = mddev;
+	if (mddev->queue) {
+		mddev->queue->backing_dev_info.congested_fn = raid1_congested;
+		mddev->queue->backing_dev_info.congested_data = mddev;
+	}
 	return md_integrity_register(mddev);
 }
 
Index: linux-2.6/drivers/md/raid1.h
===================================================================
--- linux-2.6.orig/drivers/md/raid1.h
+++ linux-2.6/drivers/md/raid1.h
@@ -126,4 +126,6 @@ struct r1bio_s {
  */
 #define	R1BIO_Returned 6
 
+extern int md_raid1_congested(mddev_t *mddev, int bits);
+
 #endif
