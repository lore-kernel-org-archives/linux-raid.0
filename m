From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md -  Convert a number or "unsigned long"s to "sector_t"s
Date: Thu, 25 Mar 2004 12:25:08 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1B6JcK-0007Z7-00@notabene>
References: <20040325122138.29050.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, Evan Felix <evan.felix@pnl.gov>
List-Id: linux-raid.ids


This helps raid5 work on at least 1 very large array..

Thanks to  Evan Felix <evan.felix@pnl.gov>

I cannot test this as I don't have the terabytes of storage where it
makes a difference, but it is purely changing "long" or "unsigned
long" to "sector_t", where the number in question is a sector - and
type casting a few "long"s to (sector_t) before multiplication.

NeilBrown



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   15 ++++++++-------
 ./drivers/md/raid5.c        |   16 ++++++++--------
 ./drivers/md/raid6main.c    |   16 ++++++++--------
 ./include/linux/raid/md_k.h |    4 ++--
 4 files changed, 26 insertions(+), 25 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-03-25 12:12:38.000000000 +1100
+++ ./drivers/md/md.c	2004-03-25 12:20:15.000000000 +1100
@@ -3178,13 +3178,14 @@ DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 static void md_do_sync(mddev_t *mddev)
 {
 	mddev_t *mddev2;
-	unsigned int max_sectors, currspeed = 0,
-		j, window;
+	unsigned int currspeed = 0,
+		 window;
+	sector_t max_sectors,j;
 	unsigned long mark[SYNC_MARKS];
-	unsigned long mark_cnt[SYNC_MARKS];
+	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
 	struct list_head *tmp;
-	unsigned long last_check;
+	sector_t last_check;
 
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
@@ -3253,8 +3254,8 @@ static void md_do_sync(mddev_t *mddev)
 	 * Tune reconstruction:
 	 */
 	window = 32*(PAGE_SIZE/512);
-	printk(KERN_INFO "md: using %dk window, over a total of %d blocks.\n",
-		window/2,max_sectors/2);
+	printk(KERN_INFO "md: using %dk window, over a total of %Lu blocks.\n",
+		window/2,(unsigned long long) max_sectors/2);
 
 	atomic_set(&mddev->recovery_active, 0);
 	init_waitqueue_head(&mddev->recovery_wait);
@@ -3322,7 +3323,7 @@ static void md_do_sync(mddev_t *mddev)
 		 */
 		cond_resched();
 
-		currspeed = (j-mddev->resync_mark_cnt)/2/((jiffies-mddev->resync_mark)/HZ +1) +1;
+		currspeed = ((unsigned long)(j-mddev->resync_mark_cnt))/2/((jiffies-mddev->resync_mark)/HZ +1) +1;
 
 		if (currspeed > sysctl_speed_limit_min) {
 			if ((currspeed > sysctl_speed_limit_max) ||

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-03-25 12:12:39.000000000 +1100
+++ ./drivers/md/raid5.c	2004-03-25 12:12:39.000000000 +1100
@@ -181,7 +181,7 @@ static int grow_buffers(struct stripe_he
 
 static void raid5_build_block (struct stripe_head *sh, int i);
 
-static inline void init_stripe(struct stripe_head *sh, unsigned long sector, int pd_idx)
+static inline void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks, i;
@@ -218,7 +218,7 @@ static inline void init_stripe(struct st
 	insert_hash(conf, sh);
 }
 
-static struct stripe_head *__find_stripe(raid5_conf_t *conf, unsigned long sector)
+static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector)
 {
 	struct stripe_head *sh;
 
@@ -231,7 +231,7 @@ static struct stripe_head *__find_stripe
 	return NULL;
 }
 
-static struct stripe_head *get_active_stripe(raid5_conf_t *conf, unsigned long sector, 
+static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector, 
 					     int pd_idx, int noblock) 
 {
 	struct stripe_head *sh;
@@ -495,7 +495,7 @@ static void error(mddev_t *mddev, mdk_rd
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
-static unsigned long raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
+static sector_t raid5_compute_sector(sector_t r_sector, unsigned int raid_disks,
 			unsigned int data_disks, unsigned int * dd_idx,
 			unsigned int * pd_idx, raid5_conf_t *conf)
 {
@@ -556,7 +556,7 @@ static unsigned long raid5_compute_secto
 	/*
 	 * Finally, compute the new sector number
 	 */
-	new_sector = stripe * sectors_per_chunk + chunk_offset;
+	new_sector = (sector_t)stripe * sectors_per_chunk + chunk_offset;
 	return new_sector;
 }
 
@@ -567,7 +567,7 @@ static sector_t compute_blocknr(struct s
 	int raid_disks = conf->raid_disks, data_disks = raid_disks - 1;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
-	long stripe;
+	sector_t stripe;
 	int chunk_offset;
 	int chunk_number, dummy1, dummy2, dd_idx = i;
 	sector_t r_sector;
@@ -1388,7 +1388,7 @@ static int sync_request (mddev_t *mddev,
 	unsigned long stripe;
 	int chunk_offset;
 	int dd_idx, pd_idx;
-	unsigned long first_sector;
+	sector_t first_sector;
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks-1;
 
@@ -1401,7 +1401,7 @@ static int sync_request (mddev_t *mddev,
 	stripe = x;
 	BUG_ON(x != stripe);
 
-	first_sector = raid5_compute_sector(stripe*data_disks*sectors_per_chunk
+	first_sector = raid5_compute_sector((sector_t)stripe*data_disks*sectors_per_chunk
 		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 	sh = get_active_stripe(conf, sector_nr, pd_idx, 1);
 	if (sh == NULL) {

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-03-25 12:16:37.000000000 +1100
+++ ./drivers/md/raid6main.c	2004-03-25 12:18:32.000000000 +1100
@@ -200,7 +200,7 @@ static int grow_buffers(struct stripe_he
 
 static void raid6_build_block (struct stripe_head *sh, int i);
 
-static inline void init_stripe(struct stripe_head *sh, unsigned long sector, int pd_idx)
+static inline void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx)
 {
 	raid6_conf_t *conf = sh->raid_conf;
 	int disks = conf->raid_disks, i;
@@ -237,7 +237,7 @@ static inline void init_stripe(struct st
 	insert_hash(conf, sh);
 }
 
-static struct stripe_head *__find_stripe(raid6_conf_t *conf, unsigned long sector)
+static struct stripe_head *__find_stripe(raid6_conf_t *conf, sector_t sector)
 {
 	struct stripe_head *sh;
 
@@ -250,7 +250,7 @@ static struct stripe_head *__find_stripe
 	return NULL;
 }
 
-static struct stripe_head *get_active_stripe(raid6_conf_t *conf, unsigned long sector,
+static struct stripe_head *get_active_stripe(raid6_conf_t *conf, sector_t sector,
 					     int pd_idx, int noblock)
 {
 	struct stripe_head *sh;
@@ -516,7 +516,7 @@ static void error(mddev_t *mddev, mdk_rd
  * Input: a 'big' sector number,
  * Output: index of the data and parity disk, and the sector # in them.
  */
-static unsigned long raid6_compute_sector(sector_t r_sector, unsigned int raid_disks,
+static sector_t raid6_compute_sector(sector_t r_sector, unsigned int raid_disks,
 			unsigned int data_disks, unsigned int * dd_idx,
 			unsigned int * pd_idx, raid6_conf_t *conf)
 {
@@ -588,7 +588,7 @@ static unsigned long raid6_compute_secto
 	/*
 	 * Finally, compute the new sector number
 	 */
-	new_sector = stripe * sectors_per_chunk + chunk_offset;
+	new_sector = (sector_t) stripe * sectors_per_chunk + chunk_offset;
 	return new_sector;
 }
 
@@ -599,7 +599,7 @@ static sector_t compute_blocknr(struct s
 	int raid_disks = conf->raid_disks, data_disks = raid_disks - 2;
 	sector_t new_sector = sh->sector, check;
 	int sectors_per_chunk = conf->chunk_size >> 9;
-	long stripe;
+	sector_t stripe;
 	int chunk_offset;
 	int chunk_number, dummy1, dummy2, dd_idx = i;
 	sector_t r_sector;
@@ -1550,7 +1550,7 @@ static int sync_request (mddev_t *mddev,
 	unsigned long stripe;
 	int chunk_offset;
 	int dd_idx, pd_idx;
-	unsigned long first_sector;
+	sector_t first_sector;
 	int raid_disks = conf->raid_disks;
 	int data_disks = raid_disks - 2;
 
@@ -1563,7 +1563,7 @@ static int sync_request (mddev_t *mddev,
 	stripe = x;
 	BUG_ON(x != stripe);
 
-	first_sector = raid6_compute_sector(stripe*data_disks*sectors_per_chunk
+	first_sector = raid6_compute_sector((sector_t)stripe*data_disks*sectors_per_chunk
 		+ chunk_offset, raid_disks, data_disks, &dd_idx, &pd_idx, conf);
 	sh = get_active_stripe(conf, sector_nr, pd_idx, 1);
 	if (sh == NULL) {

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-03-25 12:12:39.000000000 +1100
+++ ./include/linux/raid/md_k.h	2004-03-25 12:12:39.000000000 +1100
@@ -212,9 +212,9 @@ struct mddev_s
 
 	struct mdk_thread_s		*thread;	/* management thread */
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
-	unsigned long			curr_resync;	/* blocks scheduled */
+	sector_t			curr_resync;	/* blocks scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
-	unsigned long			resync_mark_cnt;/* blocks written at resync_mark */
+	sector_t			resync_mark_cnt;/* blocks written at resync_mark */
 
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover
