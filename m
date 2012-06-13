From: Shaohua Li <shli@kernel.org>
Subject: [patch 4/4 v2] raid1: split large request for SSD
Date: Wed, 13 Jun 2012 17:09:26 +0800
Message-ID: <20120613091051.897211465@kernel.org>
References: <20120613090922.971820942@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=raid1-ssd-split-large-read.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

For SSD, if request size exceeds specific value (optimal io size), request size
isn't important for bandwidth. In such condition, if making request size bigger
will cause some disks idle, the total throughput will actually drop. A good
example is doing a readahead in a two-disk raid1 setup.

So when we should split big request? We absolutly don't want to split big
request to very small requests. Even in SSD, big request transfer is more
efficient. Below patch only consider request with size above optimal io size.

If all disks are busy, is it worthy to do split? Say optimal io size is 16k,
two requests 32k and two disks. We can let each disk run one 32k request, or
split the requests to 4 16k requests and each disk runs two. It's hard to say
which case is better, depending on hardware.

So only consider case where there are idle disks. For readahead, split is
always better in this case. And in my test, below patch can improve > 30%
thoughput. Hmm, not 100%, because disk isn't 100% busy.

Such case can happen not just in readahead, for example, in directio. But I
suppose directio usually will have bigger IO depth and make all disks busy, so
I ignored it.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   44 +++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid1.h |    2 ++
 2 files changed, 39 insertions(+), 7 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-06-13 16:16:53.235287825 +0800
+++ linux/drivers/md/raid1.c	2012-06-13 16:16:56.315249040 +0800
@@ -464,31 +464,49 @@ static void raid1_end_write_request(stru
 }
 
 static int read_balance_measure_ssd(struct r1conf *conf, struct r1bio *r1_bio,
-	int disk, int *best_disk, unsigned int *min_pending)
+	int disk, int *best_disk, unsigned int *min_pending, int *choose_idle)
 {
 	const sector_t this_sector = r1_bio->sector;
 	struct md_rdev *rdev;
 	unsigned int pending;
+	struct mirror_info *mirror = &conf->mirrors[disk];
+	int ret = 0;
 
-	rdev = rcu_dereference(conf->mirrors[disk].rdev);
+	rdev = rcu_dereference(mirror->rdev);
 	pending = atomic_read(&rdev->nr_pending);
 
 	/* big request IO helps SSD too, allow sequential IO merge */
-	if (conf->mirrors[disk].next_seq_sect == this_sector) {
+	if (mirror->next_seq_sect == this_sector && *choose_idle == 0) {
 		sector_t dist;
-		dist = abs(this_sector - conf->mirrors[disk].head_position);
+		dist = abs(this_sector - mirror->head_position);
 		/*
 		 * head_position is for finished request, such reqeust can't be
 		 * merged with current request, so it means nothing for SSD
 		 */
-		if (dist != 0)
+		if (dist != 0) {
+			/*
+			 * If buffered sequential IO size exceeds optimal
+			 * iosize and there is idle disk, choose idle disk
+			 */
+			if (mirror->seq_start != MaxSector
+			    && conf->opt_iosize > 0
+			    && mirror->next_seq_sect > conf->opt_iosize
+			    && mirror->next_seq_sect - conf->opt_iosize >=
+			       mirror->seq_start) {
+				*choose_idle = 1;
+				ret = 1;
+			}
 			goto done;
+		}
 	}
 
 	/* If device is idle, use it */
 	if (pending == 0)
 		goto done;
 
+	if (*choose_idle == 1)
+		return 1;
+
 	/* find device with less requests pending */
 	if (*min_pending > pending) {
 		*min_pending = pending;
@@ -497,7 +515,7 @@ static int read_balance_measure_ssd(stru
 	return 1;
 done:
 	*best_disk = disk;
-	return 0;
+	return ret;
 }
 
 static int read_balance_measure_distance(struct r1conf *conf,
@@ -551,6 +569,7 @@ static int read_balance(struct r1conf *c
 	unsigned int min_pending;
 	struct md_rdev *rdev;
 	int choose_first;
+	int choose_idle;
 
 	rcu_read_lock();
 	/*
@@ -564,6 +583,7 @@ static int read_balance(struct r1conf *c
 	best_dist = MaxSector;
 	min_pending = -1;
 	best_good_sectors = 0;
+	choose_idle = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync))
@@ -647,7 +667,7 @@ static int read_balance(struct r1conf *c
 				break;
 		} else {
 			if (!read_balance_measure_ssd(conf, r1_bio, disk,
-			    &best_disk, &min_pending))
+			    &best_disk, &min_pending, &choose_idle))
 				break;
 		}
 	}
@@ -665,6 +685,10 @@ static int read_balance(struct r1conf *c
 			goto retry;
 		}
 		sectors = best_good_sectors;
+
+		if (conf->mirrors[best_disk].next_seq_sect != this_sector)
+			conf->mirrors[best_disk].seq_start = this_sector;
+
 		conf->mirrors[best_disk].next_seq_sect = this_sector + sectors;
 	}
 	rcu_read_unlock();
@@ -2579,6 +2603,7 @@ static struct r1conf *setup_conf(struct
 	struct md_rdev *rdev;
 	int err = -ENOMEM;
 	bool nonrotational = true;
+	int opt_iosize = 0;
 
 	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
 	if (!conf)
@@ -2629,8 +2654,13 @@ static struct r1conf *setup_conf(struct
 		disk->head_position = 0;
 		if (!blk_queue_nonrot(bdev_get_queue(rdev->bdev)))
 			nonrotational = false;
+		else
+			opt_iosize = max(opt_iosize, bdev_io_opt(rdev->bdev));
+		disk->seq_start = MaxSector;
 	}
 	conf->nonrotational = nonrotational;
+	if (nonrotational)
+		conf->opt_iosize = opt_iosize >> 9;
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
 	INIT_LIST_HEAD(&conf->retry_list);
Index: linux/drivers/md/raid1.h
===================================================================
--- linux.orig/drivers/md/raid1.h	2012-06-13 16:16:53.235287825 +0800
+++ linux/drivers/md/raid1.h	2012-06-13 16:16:56.315249040 +0800
@@ -9,6 +9,7 @@ struct mirror_info {
 	 * we try to keep sequential reads one the same device
 	 */
 	sector_t	next_seq_sect;
+	sector_t	seq_start;
 };
 
 /*
@@ -66,6 +67,7 @@ struct r1conf {
 	int			barrier;
 
 	int			nonrotational;
+	sector_t		opt_iosize;
 
 	/* Set to 1 if a full sync is needed, (fresh device added).
 	 * Cleared when a sync completes.

