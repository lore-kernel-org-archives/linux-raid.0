From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 09/26] md/linear: remove rcu protections in favour of
 suspend/resume
Date: Wed, 04 Feb 2015 08:42:29 +1100
Message-ID: <20150203214229.3448.80550.stgit@notabene.brown>
References: <20150203213948.3448.80258.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150203213948.3448.80258.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The use of 'rcu' to protect accesses to ->private_data so that
the ->private_data could be updated predates the introduction
of mddev_suspend/mddev_resume.
These are a cleaner mechanism for providing stability while
swapping in a new ->private data - it is used by level_store()
to support changing of raid levels.

So get rid of the RCU stuff and just use mddev_suspend, mddev_resume.

As these function call ->quiesce(), we add an empty function for
linear just like for raid0.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/linear.c |   44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 4c2a92ce2b0b..b3e717adbc9b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -34,7 +34,7 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
 
 	lo = 0;
 	hi = mddev->raid_disks - 1;
-	conf = rcu_dereference(mddev->private);
+	conf = mddev->private;
 
 	/*
 	 * Binary Search
@@ -70,7 +70,6 @@ static int linear_mergeable_bvec(struct mddev *mddev,
 	int maxbytes = biovec->bv_len;
 	struct request_queue *subq;
 
-	rcu_read_lock();
 	dev0 = which_dev(mddev, sector);
 	maxsectors = dev0->end_sector - sector;
 	subq = bdev_get_queue(dev0->rdev->bdev);
@@ -80,7 +79,6 @@ static int linear_mergeable_bvec(struct mddev *mddev,
 		maxbytes = min(maxbytes, subq->merge_bvec_fn(subq, bvm,
 							     biovec));
 	}
-	rcu_read_unlock();
 
 	if (maxsectors < bio_sectors)
 		maxsectors = 0;
@@ -101,15 +99,13 @@ static int linear_congested(struct mddev *mddev, int bits)
 	struct linear_conf *conf;
 	int i, ret = 0;
 
-	rcu_read_lock();
-	conf = rcu_dereference(mddev->private);
+	conf = mddev->private;
 
 	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
 		struct request_queue *q = bdev_get_queue(conf->disks[i].rdev->bdev);
 		ret |= bdi_congested(&q->backing_dev_info, bits);
 	}
 
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -118,12 +114,10 @@ static sector_t linear_size(struct mddev *mddev, sector_t sectors, int raid_disk
 	struct linear_conf *conf;
 	sector_t array_sectors;
 
-	rcu_read_lock();
-	conf = rcu_dereference(mddev->private);
+	conf = mddev->private;
 	WARN_ONCE(sectors || raid_disks,
 		  "%s does not support generic reshape\n", __func__);
 	array_sectors = conf->array_sectors;
-	rcu_read_unlock();
 
 	return array_sectors;
 }
@@ -243,33 +237,22 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	if (!newconf)
 		return -ENOMEM;
 
-	oldconf = rcu_dereference_protected(mddev->private,
-					    lockdep_is_held(
-						    &mddev->reconfig_mutex));
+	mddev_suspend(mddev);
+	oldconf = mddev->private;
 	mddev->raid_disks++;
-	rcu_assign_pointer(mddev->private, newconf);
+	mddev->private = newconf;
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 	set_capacity(mddev->gendisk, mddev->array_sectors);
+	mddev_resume(mddev);
 	revalidate_disk(mddev->gendisk);
-	kfree_rcu(oldconf, rcu);
+	kfree(oldconf);
 	return 0;
 }
 
 static int linear_stop (struct mddev *mddev)
 {
-	struct linear_conf *conf =
-		rcu_dereference_protected(mddev->private,
-					  lockdep_is_held(
-						  &mddev->reconfig_mutex));
+	struct linear_conf *conf = mddev->private;
 
-	/*
-	 * We do not require rcu protection here since
-	 * we hold reconfig_mutex for both linear_add and
-	 * linear_stop, so they cannot race.
-	 * We should make sure any old 'conf's are properly
-	 * freed though.
-	 */
-	rcu_barrier();
 	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 	kfree(conf);
 	mddev->private = NULL;
@@ -290,16 +273,12 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 	}
 
 	do {
-		rcu_read_lock();
-
 		tmp_dev = which_dev(mddev, bio->bi_iter.bi_sector);
 		start_sector = tmp_dev->end_sector - tmp_dev->rdev->sectors;
 		end_sector = tmp_dev->end_sector;
 		data_offset = tmp_dev->rdev->data_offset;
 		bio->bi_bdev = tmp_dev->rdev->bdev;
 
-		rcu_read_unlock();
-
 		if (unlikely(bio->bi_iter.bi_sector >= end_sector ||
 			     bio->bi_iter.bi_sector < start_sector))
 			goto out_of_bounds;
@@ -346,6 +325,10 @@ static void linear_status (struct seq_file *seq, struct mddev *mddev)
 	seq_printf(seq, " %dk rounding", mddev->chunk_sectors / 2);
 }
 
+static void linear_quiesce(struct mddev *mddev, int state)
+{
+}
+
 static struct md_personality linear_personality =
 {
 	.name		= "linear",
@@ -357,6 +340,7 @@ static struct md_personality linear_personality =
 	.status		= linear_status,
 	.hot_add_disk	= linear_add,
 	.size		= linear_size,
+	.quiesce	= linear_quiesce,
 	.congested	= linear_congested,
 	.mergeable_bvec	= linear_mergeable_bvec,
 };


