From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 6 of 22 - Discard "param" from mddev structure
Date: Wed, 19 Jun 2002 10:50:49 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54633.365115.258383@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




It isn't needed.  Only the chunksize is used, and it 
can be found in the superblock.



 ----------- Diffstat output ------------
 ./drivers/md/linear.c       |    2 +-
 ./drivers/md/md.c           |   10 ----------
 ./drivers/md/raid0.c        |    4 ++--
 ./include/linux/raid/md_k.h |    1 -
 4 files changed, 3 insertions(+), 14 deletions(-)

--- ./drivers/md/md.c	2002/06/18 03:33:36	1.5
+++ ./drivers/md/md.c	2002/06/18 03:34:17	1.6
@@ -1626,9 +1626,6 @@
 	chunk_size = mddev->sb->chunk_size;
 	pnum = level_to_pers(mddev->sb->level);
 
-	mddev->param.chunk_size = chunk_size;
-	mddev->param.personality = pnum;
-
 	if ((pnum != MULTIPATH) && (pnum != RAID1)) {
 		if (!chunk_size) {
 			/*
@@ -2828,13 +2825,6 @@
 
 		case RUN_ARRAY:
 		{
-/* The data is never used....
-			mdu_param_t param;
-			err = copy_from_user(&param, (mdu_param_t *)arg,
-							 sizeof(param));
-			if (err)
-				goto abort_unlock;
-*/
 			err = do_md_run (mddev);
 			/*
 			 * we have to clean up the mess if
--- ./drivers/md/linear.c	2002/06/18 03:33:55	1.1
+++ ./drivers/md/linear.c	2002/06/18 03:34:17	1.2
@@ -186,7 +186,7 @@
 	}
 	sz += sprintf(page+sz, "\n");
 #endif
-	sz += sprintf(page+sz, " %dk rounding", mddev->param.chunk_size/1024);
+	sz += sprintf(page+sz, " %dk rounding", mddev->sb->chunk_size/1024);
 	return sz;
 }
 
--- ./drivers/md/raid0.c	2002/06/18 03:33:55	1.1
+++ ./drivers/md/raid0.c	2002/06/18 03:34:17	1.2
@@ -233,7 +233,7 @@
 	mdk_rdev_t *tmp_dev;
 	unsigned long chunk, block, rsect;
 
-	chunk_size = mddev->param.chunk_size >> 10;
+	chunk_size = mddev->sb->chunk_size >> 10;
 	chunksize_bits = ffz(~chunk_size);
 	block = bio->bi_sector >> 1;
 	hash = conf->hash_table + block / conf->smallest->size;
@@ -322,7 +322,7 @@
 				conf->strip_zone[j].size);
 	}
 #endif
-	sz += sprintf(page + sz, " %dk chunks", mddev->param.chunk_size/1024);
+	sz += sprintf(page + sz, " %dk chunks", mddev->sb->chunk_size/1024);
 	return sz;
 }
 
--- ./include/linux/raid/md_k.h	2002/06/18 03:26:36	1.2
+++ ./include/linux/raid/md_k.h	2002/06/18 03:34:18	1.3
@@ -199,7 +199,6 @@
 	int				nb_dev;
 	struct list_head 		disks;
 	int				sb_dirty;
-	mdu_param_t			param;
 	int				ro;
 	unsigned long			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
