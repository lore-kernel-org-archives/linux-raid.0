From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/3 v4]raid1: prevent merging too large request
Date: Thu, 5 Jul 2012 17:21:24 +0800
Message-ID: <20120705092124.GC27956@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
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

Note: if the raid uses any hard disk, we don't prevent merging. That will make
performace worse.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/md/raid1.h |    1 
 2 files changed, 50 insertions(+), 7 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-07-05 16:12:13.954489517 +0800
+++ linux/drivers/md/raid1.c	2012-07-05 17:15:38.750657755 +0800
@@ -490,6 +490,7 @@ static int read_balance(struct r1conf *c
 	unsigned int min_pending;
 	struct md_rdev *rdev;
 	int choose_first;
+	int choose_next_idle;
 
 	rcu_read_lock();
 	/*
@@ -506,6 +507,7 @@ static int read_balance(struct r1conf *c
 	min_pending = UINT_MAX;
 	best_good_sectors = 0;
 	has_nonrot_disk = 0;
+	choose_next_idle = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync))
@@ -518,6 +520,7 @@ static int read_balance(struct r1conf *c
 		sector_t first_bad;
 		int bad_sectors;
 		unsigned int pending;
+		bool nonrot;
 
 		int disk = i;
 		if (disk >= conf->raid_disks * 2)
@@ -580,18 +583,52 @@ static int read_balance(struct r1conf *c
 		} else
 			best_good_sectors = sectors;
 
-		has_nonrot_disk |= blk_queue_nonrot(bdev_get_queue(rdev->bdev));
+		nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
+		has_nonrot_disk |= nonrot;
 		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(this_sector - conf->mirrors[disk].head_position);
-		if (choose_first
-		    /* Don't change to another disk for sequential reads */
-		    || conf->mirrors[disk].next_seq_sect == this_sector
-		    || dist == 0
-		    /* If device is idle, use it */
-		    || pending == 0) {
+		if (choose_first) {
 			best_disk = disk;
 			break;
 		}
+		/* Don't change to another disk for sequential reads */
+		if (conf->mirrors[disk].next_seq_sect == this_sector
+		    || dist == 0) {
+			int opt_iosize = bdev_io_opt(rdev->bdev) >> 9;
+			struct mirror_info *mirror = &conf->mirrors[disk];
+
+			best_disk = disk;
+			/*
+			 * If buffered sequential IO size exceeds optimal
+			 * iosize, check if there is idle disk. If yes, choose
+			 * the idle disk. read_balance could already choose an
+			 * idle disk before noticing it's a sequential IO in
+			 * this disk. This doesn't matter because this disk
+			 * will idle, next time it will be utilized after the
+			 * first disk has IO size exceeds optimal iosize. In
+			 * this way, iosize of the first disk will be optimal
+			 * iosize at least. iosize of the second disk might be
+			 * small, but not a big deal since when the second disk
+			 * starts IO, the first disk is likely still busy.
+			 */
+			if (nonrot && opt_iosize > 0 &&
+			    mirror->seq_start != MaxSector &&
+			    mirror->next_seq_sect > opt_iosize &&
+			    mirror->next_seq_sect - opt_iosize >=
+			    mirror->seq_start) {
+				choose_next_idle = 1;
+				continue;
+			}
+			break;
+		}
+		/* If device is idle, use it */
+		if (pending == 0) {
+			best_disk = disk;
+			break;
+		}
+
+		if (choose_next_idle)
+			continue;
 
 		if (min_pending > pending) {
 			min_pending = pending;
@@ -630,6 +667,10 @@ static int read_balance(struct r1conf *c
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
@@ -2588,6 +2629,7 @@ static struct r1conf *setup_conf(struct
 			mddev->merge_check_needed = 1;
 
 		disk->head_position = 0;
+		disk->seq_start = MaxSector;
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
Index: linux/drivers/md/raid1.h
===================================================================
--- linux.orig/drivers/md/raid1.h	2012-07-05 16:12:13.946489619 +0800
+++ linux/drivers/md/raid1.h	2012-07-05 16:12:13.970489316 +0800
@@ -9,6 +9,7 @@ struct mirror_info {
 	 * we try to keep sequential reads one the same device
 	 */
 	sector_t	next_seq_sect;
+	sector_t	seq_start;
 };
 
 /*
