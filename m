Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AF126B94E;
	Tue,  8 Apr 2025 12:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116485; cv=none; b=cwzZBeWZgjYlBaq6HrtJ/pztnQt8wSgNutvx1sDDoJnfitFRl11otpxZXLwkt60dX69R36uJFBjqio2QTx/867XFzZfa+w6iE/62lQkp8vtfDf0sYl4pBv92Yj4mJB6SfLTafev2p1E3WCp1sLDnKcD9xhM9B9wLhJGOyD/FfFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116485; c=relaxed/simple;
	bh=o06LsqKt9ZKFc+X/eB16U1/EpTtNW8vDw63l6tKzT70=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mWxi1cmW7++E1Q08guppWW8HsCyeNsUdHjC3VFzNMY6/+QuqZF+WNVm2TAbenHQyQdo8cKIR1S8hc8WwdRV5bQWydVufiZjjjmPaHP0wVR0UVd99Vf/KsHpY4/NVtBDMwyK2JiYNPI8m3EJadZGcA0kp1He3TgRtJYyzv6ZkSYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZX5T63gp9z4f3jkw;
	Tue,  8 Apr 2025 20:47:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7DBE71A1478;
	Tue,  8 Apr 2025 20:47:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2D6GvVnWMCDIw--.65008S4;
	Tue, 08 Apr 2025 20:47:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	xni@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC] md: fix is_mddev_idle()
Date: Tue,  8 Apr 2025 20:41:25 +0800
Message-Id: <20250408124125.2535488-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2D6GvVnWMCDIw--.65008S4
X-Coremail-Antispam: 1UD129KBjvAXoW3ur4UXFW5Wr13KrW3Jw18Krg_yoW8JF47uo
	Z3JFnxuw1rJrWrury7tr1rtFZxW398Cws5Aw15AFs5AFZrXw45tFnrG3yfXa4aqF1SgFWr
	Xr9Fqw4SqFsrAw1fn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYg7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

If sync_speed is above speed_min, then is_mddev_idle() will be called
for each sync IO to check if the array is idle, and inflihgt sync_io
will be limited to one if the array is not idle.

However, while mkfs.ext4 for a large raid5 array while recovery is in
progress, it's found that sync_speed is already above speed_min while
lots of stripes are used for sync IO, causing long delay for mkfs.ext4.

Root cause is the following checking from is_mddev_idle():

t1: submit sync IO: events1 = completed IO - issued sync IO
t2: submit next sync IO: events2  = completed IO - issued sync IO
if (events2 - events1 > 64)

For consequence, the more sync IO issued, the less likely checking will
pass. And when completed normal IO is more than issued sync IO, the
condition will finally pass and is_mddev_idle() will return false,
however, last_events will be updated hence is_mddev_idle() can only
return false once in a while.

Fix this problem by changing the checking as following:

1) mddev doesn't have normal IO completed;
2) mddev doesn't have normal IO inflight;
3) if any member disks is partition, and all other partitions doesn't
   have IO completed.

Noted in order to prevent sync speed to drop conspicuously, the inflight
sync IO above speed_min is also increased from 1 to 8.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk.h            |  1 -
 block/genhd.c          |  1 +
 drivers/md/md.c        | 97 +++++++++++++++++++++++++-----------------
 drivers/md/md.h        | 12 +-----
 drivers/md/raid1.c     |  3 --
 drivers/md/raid10.c    |  9 ----
 drivers/md/raid5.c     |  8 ----
 include/linux/blkdev.h |  2 +-
 8 files changed, 60 insertions(+), 73 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 90fa5f28ccab..a78f9df72a83 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -413,7 +413,6 @@ void blk_apply_bdi_limits(struct backing_dev_info *bdi,
 int blk_dev_init(void);
 
 void update_io_ticks(struct block_device *part, unsigned long now, bool end);
-unsigned int part_in_flight(struct block_device *part);
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
 {
diff --git a/block/genhd.c b/block/genhd.c
index e9375e20d866..0ce35bc88196 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -139,6 +139,7 @@ unsigned int part_in_flight(struct block_device *part)
 
 	return inflight;
 }
+EXPORT_SYMBOL_GPL(part_in_flight);
 
 static void part_in_flight_rw(struct block_device *part,
 		unsigned int inflight[2])
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cefa9cba711b..c65483a33d7a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8585,50 +8585,51 @@ void md_cluster_stop(struct mddev *mddev)
 	put_cluster_ops(mddev);
 }
 
-static int is_mddev_idle(struct mddev *mddev, int init)
+static bool is_rdev_idle(struct md_rdev *rdev, bool init)
 {
-	struct md_rdev *rdev;
-	int idle;
-	int curr_events;
+	int last_events = rdev->last_events;
 
-	idle = 1;
-	rcu_read_lock();
-	rdev_for_each_rcu(rdev, mddev) {
-		struct gendisk *disk = rdev->bdev->bd_disk;
+	if (!bdev_is_partition(rdev->bdev))
+		return true;
 
-		if (!init && !blk_queue_io_stat(disk->queue))
-			continue;
+	rdev->last_events = (int)part_stat_read_accum(rdev->bdev->bd_disk->part0, sectors) -
+			    (int)part_stat_read_accum(rdev->bdev, sectors);
 
-		curr_events = (int)part_stat_read_accum(disk->part0, sectors) -
-			      atomic_read(&disk->sync_io);
-		/* sync IO will cause sync_io to increase before the disk_stats
-		 * as sync_io is counted when a request starts, and
-		 * disk_stats is counted when it completes.
-		 * So resync activity will cause curr_events to be smaller than
-		 * when there was no such activity.
-		 * non-sync IO will cause disk_stat to increase without
-		 * increasing sync_io so curr_events will (eventually)
-		 * be larger than it was before.  Once it becomes
-		 * substantially larger, the test below will cause
-		 * the array to appear non-idle, and resync will slow
-		 * down.
-		 * If there is a lot of outstanding resync activity when
-		 * we set last_event to curr_events, then all that activity
-		 * completing might cause the array to appear non-idle
-		 * and resync will be slowed down even though there might
-		 * not have been non-resync activity.  This will only
-		 * happen once though.  'last_events' will soon reflect
-		 * the state where there is little or no outstanding
-		 * resync requests, and further resync activity will
-		 * always make curr_events less than last_events.
-		 *
-		 */
-		if (init || curr_events - rdev->last_events > 64) {
-			rdev->last_events = curr_events;
-			idle = 0;
-		}
+	if (!init && rdev->last_events > last_events)
+		return false;
+
+	return true;
+}
+
+/*
+ * mddev is idle if following conditions are match since last check:
+ * 1) mddev doesn't have normal IO completed;
+ * 2) mddev doesn't have inflight normal IO;
+ * 3) if any member disk is partition, and other partitions doesn't have IO
+ *    completed;
+ *
+ * Noted this checking rely on IO accounting is enabled.
+ */
+static bool is_mddev_idle(struct mddev *mddev, bool init)
+{
+	struct md_rdev *rdev;
+	bool idle = true;
+
+	if (!mddev_is_dm(mddev)) {
+		int last_events = mddev->last_events;
+
+		mddev->last_events = (int)part_stat_read_accum(mddev->gendisk->part0, sectors);
+		if (!init && (mddev->last_events > last_events ||
+			      part_in_flight(mddev->gendisk->part0)))
+			idle = false;
 	}
+
+	rcu_read_lock();
+	rdev_for_each_rcu(rdev, mddev)
+		if (!is_rdev_idle(rdev, init))
+			idle = false;
 	rcu_read_unlock();
+
 	return idle;
 }
 
@@ -8940,6 +8941,21 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 	}
 }
 
+/*
+ * For raid 456, sync IO is stripe(4k) per IO, for other levels, it's
+ * RESYNC_PAGES(64k) per IO, we limit inflight sync IO for no more than
+ * 8 if sync_speed is above speed_min.
+ */
+static int get_active_threshold(struct mddev *mddev)
+{
+	int max_active = 128 * 8;
+
+	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
+		max_active = 8 * 8;
+
+	return max_active;
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -8953,6 +8969,7 @@ void md_do_sync(struct md_thread *thread)
 	unsigned long update_time;
 	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
+	int active_threshold = get_active_threshold(mddev);
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
@@ -9208,14 +9225,14 @@ void md_do_sync(struct md_thread *thread)
 				msleep(500);
 				goto repeat;
 			}
-			if (!is_mddev_idle(mddev, 0)) {
+			if (atomic_read(&mddev->recovery_active) >= active_threshold &&
+			    !is_mddev_idle(mddev, 0))
 				/*
 				 * Give other IO more of a chance.
 				 * The faster the devices, the less we wait.
 				 */
 				wait_event(mddev->recovery_wait,
 					   !atomic_read(&mddev->recovery_active));
-			}
 		}
 	}
 	pr_info("md: %s: %s %s.\n",mdname(mddev), desc,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index dd6a28f5d8e6..6890aa4ac8b4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -518,6 +518,7 @@ struct mddev {
 							 * adding a spare
 							 */
 
+	int last_events;		/* IO event timestamp */
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
@@ -714,17 +715,6 @@ static inline int mddev_trylock(struct mddev *mddev)
 }
 extern void mddev_unlock(struct mddev *mddev);
 
-static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
-{
-	if (blk_queue_io_stat(bdev->bd_disk->queue))
-		atomic_add(nr_sectors, &bdev->bd_disk->sync_io);
-}
-
-static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
-{
-	md_sync_acct(bio->bi_bdev, nr_sectors);
-}
-
 struct md_personality
 {
 	struct md_submodule_head head;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e366d0bba792..d422bab77580 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2376,7 +2376,6 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
 
 		submit_bio_noacct(wbio);
 	}
@@ -3049,7 +3048,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio = r1_bio->bios[i];
 			if (bio->bi_end_io == end_sync_read) {
 				read_targets--;
-				md_sync_acct_bio(bio, nr_sectors);
 				if (read_targets == 1)
 					bio->bi_opf &= ~MD_FAILFAST;
 				submit_bio_noacct(bio);
@@ -3058,7 +3056,6 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	} else {
 		atomic_set(&r1_bio->remaining, 1);
 		bio = r1_bio->bios[r1_bio->read_disk];
-		md_sync_acct_bio(bio, nr_sectors);
 		if (read_targets == 1)
 			bio->bi_opf &= ~MD_FAILFAST;
 		submit_bio_noacct(bio);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6ef65b4d1093..12fb01987ff3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2426,7 +2426,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
 		if (test_bit(FailFast, &conf->mirrors[d].rdev->flags))
 			tbio->bi_opf |= MD_FAILFAST;
@@ -2448,8 +2447,6 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			bio_copy_data(tbio, fbio);
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     bio_sectors(tbio));
 		submit_bio_noacct(tbio);
 	}
 
@@ -2583,13 +2580,10 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	d = r10_bio->devs[1].devnum;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
 		submit_bio_noacct(wbio);
 	}
 	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
-		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     bio_sectors(wbio2));
 		submit_bio_noacct(wbio2);
 	}
 }
@@ -3757,7 +3751,6 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		r10_bio->sectors = nr_sectors;
 
 		if (bio->bi_end_io == end_sync_read) {
-			md_sync_acct_bio(bio, nr_sectors);
 			bio->bi_status = 0;
 			submit_bio_noacct(bio);
 		}
@@ -4882,7 +4875,6 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	r10_bio->sectors = nr_sectors;
 
 	/* Now submit the read */
-	md_sync_acct_bio(read_bio, r10_bio->sectors);
 	atomic_inc(&r10_bio->remaining);
 	read_bio->bi_next = NULL;
 	submit_bio_noacct(read_bio);
@@ -4942,7 +4934,6 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			continue;
 
 		atomic_inc(&rdev->nr_pending);
-		md_sync_acct_bio(b, r10_bio->sectors);
 		atomic_inc(&r10_bio->remaining);
 		b->bi_next = NULL;
 		submit_bio_noacct(b);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6389383166c0..ca5b0e8ba707 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1240,10 +1240,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 
 		if (rdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
-				md_sync_acct(rdev->bdev, RAID5_STRIPE_SECTORS(conf));
-
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bio_init(bi, rdev->bdev, &dev->vec, 1, op | op_flags);
@@ -1300,10 +1296,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 				submit_bio_noacct(bi);
 		}
 		if (rrdev) {
-			if (s->syncing || s->expanding || s->expanded
-			    || s->replacing)
-				md_sync_acct(rrdev->bdev, RAID5_STRIPE_SECTORS(conf));
-
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
 			bio_init(rbi, rrdev->bdev, &dev->rvec, 1, op | op_flags);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 248416ecd01c..da1a161627ba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -182,7 +182,6 @@ struct gendisk {
 	struct list_head slave_bdevs;
 #endif
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
 
 #ifdef CONFIG_BLK_DEV_ZONED
@@ -1117,6 +1116,7 @@ static inline long nr_blockdev_pages(void)
 
 extern void blk_io_schedule(void);
 
+unsigned int part_in_flight(struct block_device *part);
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask);
 int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-- 
2.39.2

