From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject:[PATCH 012:013]: raid0.c, wrap reshape code in ifdefs
Date: Wed, 17 Jun 2009 01:00:06 +0300
Message-ID: <1245189606.3478.117.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

have reshape wrapped in ifdefs
 raid0.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Signed-off-by: razb <raziebe@gmail.com>
---
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 0b2c2e5..ee6db5c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -23,6 +23,8 @@
 #include "md.h"
 #include "raid0.h"
 
+#ifdef CONFIG_MD_RAID0_RESHAPE
+
 #define RAID0_RESHAPE_START	0x01
 #define RAID0_RESHAPE_END	0x02
 
@@ -64,6 +66,8 @@ static int start_raid0d(mddev_t *mddev)
 	md_wakeup_thread(mddev->thread);
 	return 0;
 }
+#endif
+
 static void raid0_unplug(struct request_queue *q)
 {
 	mddev_t *mddev = q->queuedata;
@@ -413,6 +417,8 @@ static int raid0_run(mddev_t *mddev)
 	if (!conf)
 		goto abort;
 	mddev->private = conf;
+
+#ifdef CONFIG_MD_RAID0_RESHAPE
 	/*
 	 *  I am doing it only to eliminate the
 	 *  resync=PENDING in mdstats with sb ver= 1.
@@ -425,6 +431,7 @@ static int raid0_run(mddev_t *mddev)
 			"recovery. ended at=%lld\n", mdname(mddev),
 			(unsigned long long)mddev->recovery_cp);
 	}
+#endif
 	if (create_strip_zones(conf, &mddev->disks,
 			mddev->chunk_sectors,  mddev->raid_disks))
 		goto abort;
@@ -446,12 +453,14 @@ static int raid0_run(mddev_t *mddev)
 	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	print_conf(mddev->private, mddev->raid_disks, mdname(mddev));
 	list_splice(&new_disks, &mddev->disks);
+#ifdef CONFIG_MD_RAID0_RESHAPE
 	mutex_init(&conf->reshape_lock);
 	if (mddev->reshape_position != MaxSector) {
 		if (reshape_init(mddev))
 			goto abort;
 		start_raid0d(mddev);
 	}
+#endif
 	return 0;
 abort:
 	{
@@ -468,6 +477,7 @@ static int raid0_stop(mddev_t *mddev)
 {
 	raid0_conf_t *conf = mddev->private;
 
+#ifdef CONFIG_MD_RAID0_RESHAPE
 	if (mddev->thread) {
 		md_unregister_thread(mddev->thread);
 		mddev->thread = 0;
@@ -482,6 +492,7 @@ static int raid0_stop(mddev_t *mddev)
 		kfree(reshape->conf);
 		kfree(reshape);
 	}
+#endif
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
@@ -648,6 +659,8 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
+
+#ifdef CONFIG_MD_RAID0_RESHAPE
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
 		unsigned long flags;
 		/*
@@ -659,6 +672,8 @@ static int raid0_make_request(struct request_queue *q, struct bio *bio)
 		spin_unlock_irqrestore(&reshape->lock, flags);
 		return 0;
 	}
+#endif
+
 	return make_request(q, mddev->private,
 				mddev->raid_disks,
 				mddev->chunk_sectors, bio);
@@ -697,6 +712,8 @@ static void raid0_status(struct seq_file *seq, mddev_t *mddev)
 }
 

+#ifdef CONFIG_MD_RAID0_RESHAPE
+
 /*
  * end read from source device. move io to write list.
  * incase of an error just notify an error and leave
@@ -1342,6 +1359,7 @@ int raid0_start_reshape(mddev_t *mddev)
 {
 	return -1;
 }
+#endif
 
 static struct mdk_personality raid0_personality=
 {
@@ -1353,12 +1371,14 @@ static struct mdk_personality raid0_personality=
 	.stop		= raid0_stop,
 	.status		= raid0_status,
 	.size		= raid0_size,
+#ifdef CONFIG_MD_RAID0_RESHAPE
 	.hot_add_disk	= raid0_add_disk,
 	.hot_remove_disk = raid0_remove_disk,
 	.check_reshape	= raid0_check_reshape,
 	.spare_active	= raid0_spare_active,
 	.sync_request   = raid0_sync,
 	.start_reshape = raid0_start_reshape,
+#endif
 };
 
 static int __init raid0_init (void)



