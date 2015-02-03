From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/26] md: make ->congested robust against personality
 changes.
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214228.3448.2680.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is currently no locking around calls to the 'congested'
bdi function.  If called at an awkward time while an array is
being converted from one level (or personality) to another, there
is a tiny chance of running code in an unreferenced module etc.

So add a 'congested' function to the md_personality operations
structure, and call it with appropriate locking from a central
'mddev_congested'.

When the array personality is changing the array will be 'suspended'
so no IO is processed.
If mddev_congested detects this, it simply reports that the
array is congested, which is a safe guess.
As mddev_suspend calls synchronize_rcu(), mddev_congested can
avoid races by included the whole call inside an rcu_read_lock()
region.
This require that the congested functions for all subordinate devices
can be run under rcu_lock.  Fortunately this is the case.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-raid.c   |    8 +-------
 drivers/md/linear.c    |    9 ++-------
 drivers/md/md.c        |   22 ++++++++++++++++++++--
 drivers/md/md.h        |    3 +++
 drivers/md/multipath.c |   10 ++--------
 drivers/md/raid0.c     |    9 ++-------
 drivers/md/raid1.c     |   14 ++------------
 drivers/md/raid1.h     |    3 ---
 drivers/md/raid10.c    |   14 ++------------
 drivers/md/raid10.h    |    3 ---
 drivers/md/raid5.c     |   19 ++++---------------
 drivers/md/raid5.h     |    1 -
 12 files changed, 38 insertions(+), 77 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 07c0fa0fa284..777d9ba2acad 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -746,13 +746,7 @@ static int raid_is_congested(struct dm_target_callbacks *cb, int bits)
 {
 	struct raid_set *rs = container_of(cb, struct raid_set, callbacks);
 
-	if (rs->raid_type->level == 1)
-		return md_raid1_congested(&rs->md, bits);
-
-	if (rs->raid_type->level == 10)
-		return md_raid10_congested(&rs->md, bits);
-
-	return md_raid5_congested(&rs->md, bits);
+	return mddev_congested(&rs->md, bits);
 }
 
 /*
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 64713b77df1c..05108510d9cd 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -97,15 +97,11 @@ static int linear_mergeable_bvec(struct request_queue *q,
 		return maxsectors << 9;
 }
 
-static int linear_congested(void *data, int bits)
+static int linear_congested(struct mddev *mddev, int bits)
 {
-	struct mddev *mddev = data;
 	struct linear_conf *conf;
 	int i, ret = 0;
 
-	if (mddev_congested(mddev, bits))
-		return 1;
-
 	rcu_read_lock();
 	conf = rcu_dereference(mddev->private);
 
@@ -218,8 +214,6 @@ static int linear_run (struct mddev *mddev)
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
-	mddev->queue->backing_dev_info.congested_fn = linear_congested;
-	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	ret =  md_integrity_register(mddev);
 	if (ret) {
@@ -366,6 +360,7 @@ static struct md_personality linear_personality =
 	.status		= linear_status,
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
+	.congested	= linear_congested,
 };
 
 static int __init linear_init (void)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 17e7fd776034..d45f52edb314 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -321,9 +321,23 @@ EXPORT_SYMBOL_GPL(mddev_resume);
 
 int mddev_congested(struct mddev *mddev, int bits)
 {
-	return mddev->suspended;
+	struct md_personality *pers = mddev->pers;
+	int ret = 0;
+
+	rcu_read_lock();
+	if (mddev->suspended)
+		ret = 1;
+	else if (pers && pers->congested)
+		ret = pers->congested(mddev, bits);
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mddev_congested);
+static int md_congested(void *data, int bits)
+{
+	struct mddev *mddev = data;
+	return mddev_congested(mddev, bits);
 }
-EXPORT_SYMBOL(mddev_congested);
 
 /*
  * Generic flush handling for md
@@ -4908,6 +4922,10 @@ int md_run(struct mddev *mddev)
 		bitmap_destroy(mddev);
 		return err;
 	}
+	if (mddev->queue) {
+		mddev->queue->backing_dev_info.congested_data = mddev;
+		mddev->queue->backing_dev_info.congested_fn = md_congested;
+	}
 	if (mddev->pers->sync_request) {
 		if (mddev->kobj.sd &&
 		    sysfs_create_group(&mddev->kobj, &md_redundancy_group))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f0d15bdd96d4..f2602280fac1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -496,6 +496,9 @@ struct md_personality
 	 * array.
 	 */
 	void *(*takeover) (struct mddev *mddev);
+	/* congested implements bdi.congested_fn().
+	 * Will not be called while array is 'suspended' */
+	int (*congested)(struct mddev *mddev, int bits);
 };
 
 struct md_sysfs_entry {
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 399272f9c042..fedb1b31877d 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -153,15 +153,11 @@ static void multipath_status (struct seq_file *seq, struct mddev *mddev)
 	seq_printf (seq, "]");
 }
 
-static int multipath_congested(void *data, int bits)
+static int multipath_congested(struct mddev *mddev, int bits)
 {
-	struct mddev *mddev = data;
 	struct mpconf *conf = mddev->private;
 	int i, ret = 0;
 
-	if (mddev_congested(mddev, bits))
-		return 1;
-
 	rcu_read_lock();
 	for (i = 0; i < mddev->raid_disks ; i++) {
 		struct md_rdev *rdev = rcu_dereference(conf->multipaths[i].rdev);
@@ -489,9 +485,6 @@ static int multipath_run (struct mddev *mddev)
 	 */
 	md_set_array_sectors(mddev, multipath_size(mddev, 0, 0));
 
-	mddev->queue->backing_dev_info.congested_fn = multipath_congested;
-	mddev->queue->backing_dev_info.congested_data = mddev;
-
 	if (md_integrity_register(mddev))
 		goto out_free_conf;
 
@@ -533,6 +526,7 @@ static struct md_personality multipath_personality =
 	.hot_add_disk	= multipath_add_disk,
 	.hot_remove_disk= multipath_remove_disk,
 	.size		= multipath_size,
+	.congested	= multipath_congested,
 };
 
 static int __init multipath_init (void)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ba6b85de96d2..4b521eac5b69 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -25,17 +25,13 @@
 #include "raid0.h"
 #include "raid5.h"
 
-static int raid0_congested(void *data, int bits)
+static int raid0_congested(struct mddev *mddev, int bits)
 {
-	struct mddev *mddev = data;
 	struct r0conf *conf = mddev->private;
 	struct md_rdev **devlist = conf->devlist;
 	int raid_disks = conf->strip_zone[0].nb_dev;
 	int i, ret = 0;
 
-	if (mddev_congested(mddev, bits))
-		return 1;
-
 	for (i = 0; i < raid_disks && !ret ; i++) {
 		struct request_queue *q = bdev_get_queue(devlist[i]->bdev);
 
@@ -263,8 +259,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			 mdname(mddev),
 			 (unsigned long long)smallest->sectors);
 	}
-	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
-	mddev->queue->backing_dev_info.congested_data = mddev;
 
 	/*
 	 * now since we have the hard sector sizes, we can make sure
@@ -729,6 +723,7 @@ static struct md_personality raid0_personality=
 	.size		= raid0_size,
 	.takeover	= raid0_takeover,
 	.quiesce	= raid0_quiesce,
+	.congested	= raid0_congested,
 };
 
 static int __init raid0_init (void)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 40b35be34f8d..9ad7ce7091be 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -734,7 +734,7 @@ static int raid1_mergeable_bvec(struct request_queue *q,
 
 }
 
-int md_raid1_congested(struct mddev *mddev, int bits)
+static int raid1_congested(struct mddev *mddev, int bits)
 {
 	struct r1conf *conf = mddev->private;
 	int i, ret = 0;
@@ -763,15 +763,6 @@ int md_raid1_congested(struct mddev *mddev, int bits)
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(md_raid1_congested);
-
-static int raid1_congested(void *data, int bits)
-{
-	struct mddev *mddev = data;
-
-	return mddev_congested(mddev, bits) ||
-		md_raid1_congested(mddev, bits);
-}
 
 static void flush_pending_writes(struct r1conf *conf)
 {
@@ -2955,8 +2946,6 @@ static int run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	if (mddev->queue) {
-		mddev->queue->backing_dev_info.congested_fn = raid1_congested;
-		mddev->queue->backing_dev_info.congested_data = mddev;
 		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
 
 		if (discard_supported)
@@ -3193,6 +3182,7 @@ static struct md_personality raid1_personality =
 	.check_reshape	= raid1_reshape,
 	.quiesce	= raid1_quiesce,
 	.takeover	= raid1_takeover,
+	.congested	= raid1_congested,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index 33bda55ef9f7..14ebb288c1ef 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -170,7 +170,4 @@ struct r1bio {
  */
 #define	R1BIO_MadeGood 7
 #define	R1BIO_WriteError 8
-
-extern int md_raid1_congested(struct mddev *mddev, int bits);
-
 #endif
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 32e282f4c83c..fb6b88674e87 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -910,7 +910,7 @@ retry:
 	return rdev;
 }
 
-int md_raid10_congested(struct mddev *mddev, int bits)
+static int raid10_congested(struct mddev *mddev, int bits)
 {
 	struct r10conf *conf = mddev->private;
 	int i, ret = 0;
@@ -934,15 +934,6 @@ int md_raid10_congested(struct mddev *mddev, int bits)
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(md_raid10_congested);
-
-static int raid10_congested(void *data, int bits)
-{
-	struct mddev *mddev = data;
-
-	return mddev_congested(mddev, bits) ||
-		md_raid10_congested(mddev, bits);
-}
 
 static void flush_pending_writes(struct r10conf *conf)
 {
@@ -3757,8 +3748,6 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		int stripe = conf->geo.raid_disks *
 			((mddev->chunk_sectors << 9) / PAGE_SIZE);
-		mddev->queue->backing_dev_info.congested_fn = raid10_congested;
-		mddev->queue->backing_dev_info.congested_data = mddev;
 
 		/* Calculate max read-ahead size.
 		 * We need to readahead at least twice a whole stripe....
@@ -4727,6 +4716,7 @@ static struct md_personality raid10_personality =
 	.check_reshape	= raid10_check_reshape,
 	.start_reshape	= raid10_start_reshape,
 	.finish_reshape	= raid10_finish_reshape,
+	.congested	= raid10_congested,
 };
 
 static int __init raid_init(void)
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 157d69e83ff4..5ee6473ddc2c 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -150,7 +150,4 @@ enum r10bio_state {
  */
 	R10BIO_Previous,
 };
-
-extern int md_raid10_congested(struct mddev *mddev, int bits);
-
 #endif
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a03cf2d889bf..502a908149c6 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4149,7 +4149,7 @@ static void activate_bit_delay(struct r5conf *conf,
 	}
 }
 
-int md_raid5_congested(struct mddev *mddev, int bits)
+static int raid5_congested(struct mddev *mddev, int bits)
 {
 	struct r5conf *conf = mddev->private;
 
@@ -4166,15 +4166,6 @@ int md_raid5_congested(struct mddev *mddev, int bits)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(md_raid5_congested);
-
-static int raid5_congested(void *data, int bits)
-{
-	struct mddev *mddev = data;
-
-	return mddev_congested(mddev, bits) ||
-		md_raid5_congested(mddev, bits);
-}
 
 /* We want read requests to align with chunks where possible,
  * but write requests don't need to.
@@ -6248,9 +6239,6 @@ static int run(struct mddev *mddev)
 
 		blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
 
-		mddev->queue->backing_dev_info.congested_data = mddev;
-		mddev->queue->backing_dev_info.congested_fn = raid5_congested;
-
 		chunk_size = mddev->chunk_sectors << 9;
 		blk_queue_io_min(mddev->queue, chunk_size);
 		blk_queue_io_opt(mddev->queue, chunk_size *
@@ -6333,8 +6321,6 @@ static int stop(struct mddev *mddev)
 	struct r5conf *conf = mddev->private;
 
 	md_unregister_thread(&mddev->thread);
-	if (mddev->queue)
-		mddev->queue->backing_dev_info.congested_fn = NULL;
 	free_conf(conf);
 	mddev->private = NULL;
 	mddev->to_remove = &raid5_attrs_group;
@@ -7126,6 +7112,7 @@ static struct md_personality raid6_personality =
 	.finish_reshape = raid5_finish_reshape,
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid6_takeover,
+	.congested	= raid5_congested,
 };
 static struct md_personality raid5_personality =
 {
@@ -7148,6 +7135,7 @@ static struct md_personality raid5_personality =
 	.finish_reshape = raid5_finish_reshape,
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid5_takeover,
+	.congested	= raid5_congested,
 };
 
 static struct md_personality raid4_personality =
@@ -7171,6 +7159,7 @@ static struct md_personality raid4_personality =
 	.finish_reshape = raid5_finish_reshape,
 	.quiesce	= raid5_quiesce,
 	.takeover	= raid4_takeover,
+	.congested	= raid5_congested,
 };
 
 static int __init raid5_init(void)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index d59f5ca743cd..983e18a83db1 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -558,7 +558,6 @@ static inline int algorithm_is_DDF(int layout)
 	return layout >= 8 && layout <= 10;
 }
 
-extern int md_raid5_congested(struct mddev *mddev, int bits);
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
 #endif


