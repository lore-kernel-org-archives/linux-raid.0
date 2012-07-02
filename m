From: Shaohua Li <shli@kernel.org>
Subject: [patch 3/3 v3] raid1: prevent merging too large request
Date: Mon, 02 Jul 2012 09:08:43 +0800
Message-ID: <20120702011037.466764171@kernel.org>
References: <20120702010840.197370335@kernel.org>
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

Note: if the raid uses any hard disk, we don't prevent merging. That will make
performace worse.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid1.c |   46 ++++++++++++++++++++++++++++++++++++++--------
 drivers/md/raid1.h |    1 +
 2 files changed, 39 insertions(+), 8 deletions(-)

Index: linux/drivers/md/raid1.c
===================================================================
--- linux.orig/drivers/md/raid1.c	2012-06-29 15:17:09.160691540 +0800
+++ linux/drivers/md/raid1.c	2012-06-29 15:57:54.993943576 +0800
@@ -489,6 +489,7 @@ static int read_balance(struct r1conf *c
 	unsigned int min_pending;
 	struct md_rdev *rdev;
 	int choose_first;
+	int choose_idle;
 
 	rcu_read_lock();
 	/*
@@ -502,6 +503,7 @@ static int read_balance(struct r1conf *c
 	best_dist = MaxSector;
 	min_pending = -1;
 	best_good_sectors = 0;
+	choose_idle = 0;
 
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync))
@@ -580,16 +582,35 @@ static int read_balance(struct r1conf *c
 		nonrot = blk_queue_nonrot(bdev_get_queue(rdev->bdev));
 		pending = atomic_read(&rdev->nr_pending);
 		dist = abs(this_sector - conf->mirrors[disk].head_position);
-		if (choose_first
-		    /* Don't change to another disk for sequential reads */
-		    || conf->mirrors[disk].next_seq_sect == this_sector
-		    || dist == 0
-		    /* If device is idle, use it */
-		    || pending == 0) {
-			best_disk = disk;
-			break;
+		if (choose_first)
+			goto done;
+		/* Don't change to another disk for sequential reads */
+		if (conf->mirrors[disk].next_seq_sect == this_sector
+		    || dist == 0) {
+			int opt_iosize = bdev_io_opt(rdev->bdev) >> 9;
+			struct mirror_info *mirror = &conf->mirrors[disk];
+
+			/*
+			 * If buffered sequential IO size exceeds optimal
+			 * iosize and there is idle disk, choose idle disk
+			 */
+			if (nonrot && opt_iosize > 0 && choose_idle == 0 &&
+			    mirror->seq_start != MaxSector &&
+			    mirror->next_seq_sect > opt_iosize &&
+			    mirror->next_seq_sect - opt_iosize >=
+			    mirror->seq_start) {
+				choose_idle = 1;
+				best_disk = disk;
+				continue;
+			}
+			goto done;
 		}
+		/* If device is idle, use it */
+		if (pending == 0 && (!choose_idle || nonrot))
+			goto done;
 
+		if (choose_idle)
+			continue;
 		/*
 		 * If all disks are rotational, choose the closest disk. If any
 		 * disk is non-rotational, choose the disk with less pending
@@ -606,6 +627,10 @@ static int read_balance(struct r1conf *c
 			best_dist = dist;
 			best_disk = disk;
 		}
+		continue;
+done:
+		best_disk = disk;
+		break;
 	}
 
 	if (best_disk >= 0) {
@@ -621,6 +646,10 @@ static int read_balance(struct r1conf *c
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
@@ -2582,6 +2611,7 @@ static struct r1conf *setup_conf(struct
 			mddev->merge_check_needed = 1;
 
 		disk->head_position = 0;
+		disk->seq_start = MaxSector;
 	}
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
Index: linux/drivers/md/raid1.h
===================================================================
--- linux.orig/drivers/md/raid1.h	2012-06-29 15:17:09.152691892 +0800
+++ linux/drivers/md/raid1.h	2012-06-29 15:17:09.172691231 +0800
@@ -9,6 +9,7 @@ struct mirror_info {
 	 * we try to keep sequential reads one the same device
 	 */
 	sector_t	next_seq_sect;
+	sector_t	seq_start;
 };
 
 /*

