From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 6 of 9] Improve the interface to sync_request
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <E1D1wCK-0000XS-Hm@notabene.cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


1/ change the return value (which is number-of-sectors synced)
 from 'int' to 'sector_t'.
 The number of sectors is usually easily small enough to fit 
 in an int, but if resync needs to abort, it may want to return
 the total number of remaining sectors, which could be large.
 Also errors cannot be returned as negative numbers now, so use
 0 instead
2/ Add a 'skipped' return parameter to allow the array to report
 that it skipped the sectors.  This allows md to take this into account
 in the speed calculations.
 Currently there is no important skipping, but the bitmap-based-resync
 that is coming will use this.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c           |   39 ++++++++++++++++++++++++---------------
 ./drivers/md/raid1.c        |    8 ++++----
 ./drivers/md/raid10.c       |   19 ++++++++++++-------
 ./drivers/md/raid5.c        |    6 +++---
 ./drivers/md/raid6main.c    |    6 +++---
 ./include/linux/raid/md_k.h |    2 +-
 6 files changed, 47 insertions(+), 33 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/md.c	2005-02-18 11:11:26.000000000 +1100
@@ -3361,12 +3361,13 @@ static void md_do_sync(mddev_t *mddev)
 	mddev_t *mddev2;
 	unsigned int currspeed = 0,
 		 window;
-	sector_t max_sectors,j;
+	sector_t max_sectors,j, io_sectors;
 	unsigned long mark[SYNC_MARKS];
 	sector_t mark_cnt[SYNC_MARKS];
 	int last_mark,m;
 	struct list_head *tmp;
 	sector_t last_check;
+	int skipped = 0;
 
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery))
@@ -3432,7 +3433,7 @@ static void md_do_sync(mddev_t *mddev)
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
 		/* resync follows the size requested by the personality,
-		 * which default to physical size, but can be virtual size
+		 * which defaults to physical size, but can be virtual size
 		 */
 		max_sectors = mddev->resync_max_sectors;
 	else
@@ -3451,9 +3452,10 @@ static void md_do_sync(mddev_t *mddev)
 		j = mddev->recovery_cp;
 	else
 		j = 0;
+	io_sectors = 0;
 	for (m = 0; m < SYNC_MARKS; m++) {
 		mark[m] = jiffies;
-		mark_cnt[m] = j;
+		mark_cnt[m] = io_sectors;
 	}
 	last_mark = 0;
 	mddev->resync_mark = mark[last_mark];
@@ -3478,26 +3480,32 @@ static void md_do_sync(mddev_t *mddev)
 	}
 
 	while (j < max_sectors) {
-		int sectors;
-
-		sectors = mddev->pers->sync_request(mddev, j, currspeed < sysctl_speed_limit_min);
-		if (sectors < 0) {
+		sector_t sectors;
+		skipped = 0;
+		sectors = mddev->pers->sync_request(mddev, j, &skipped,
+						    currspeed < sysctl_speed_limit_min);
+		if (sectors == 0) {
 			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 			goto out;
 		}
-		atomic_add(sectors, &mddev->recovery_active);
+		if (!skipped) { /* actual IO requested */
+			io_sectors += sectors;
+			atomic_add(sectors, &mddev->recovery_active);
+		}
+
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
+
+		if (last_check + window > io_sectors || j == max_sectors)
+			continue;
+
 		if (last_check==0)
 			/* This is the earliest that rebuild will be visible
 			 * in /proc/mdstat
 			 */
 			md_new_event();
 
-		if (last_check + window > j || j == max_sectors)
-			continue;
-
-		last_check = j;
+		last_check = io_sectors;
 
 		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery) ||
 		    test_bit(MD_RECOVERY_ERR, &mddev->recovery))
@@ -3511,7 +3519,7 @@ static void md_do_sync(mddev_t *mddev)
 			mddev->resync_mark = mark[next];
 			mddev->resync_mark_cnt = mark_cnt[next];
 			mark[next] = jiffies;
-			mark_cnt[next] = j - atomic_read(&mddev->recovery_active);
+			mark_cnt[next] = io_sectors - atomic_read(&mddev->recovery_active);
 			last_mark = next;
 		}
 
@@ -3538,7 +3546,8 @@ static void md_do_sync(mddev_t *mddev)
 		mddev->queue->unplug_fn(mddev->queue);
 		cond_resched();
 
-		currspeed = ((unsigned long)(j-mddev->resync_mark_cnt))/2/((jiffies-mddev->resync_mark)/HZ +1) +1;
+		currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
+			/((jiffies-mddev->resync_mark)/HZ +1) +1;
 
 		if (currspeed > sysctl_speed_limit_min) {
 			if ((currspeed > sysctl_speed_limit_max) ||
@@ -3558,7 +3567,7 @@ static void md_do_sync(mddev_t *mddev)
 	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
 
 	/* tell personality that we are finished */
-	mddev->pers->sync_request(mddev, max_sectors, 1);
+	mddev->pers->sync_request(mddev, max_sectors, &skipped, 1);
 
 	if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
 	    mddev->curr_resync > 2 &&

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/raid1.c	2005-02-18 11:11:26.000000000 +1100
@@ -1010,7 +1010,7 @@ static int init_resync(conf_t *conf)
  * that can be installed to exclude normal IO requests.
  */
 
-static int sync_request(mddev_t *mddev, sector_t sector_nr, int go_faster)
+static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	mirror_info_t *mirror;
@@ -1023,7 +1023,7 @@ static int sync_request(mddev_t *mddev, 
 
 	if (!conf->r1buf_pool)
 		if (init_resync(conf))
-			return -ENOMEM;
+			return 0;
 
 	max_sector = mddev->size << 1;
 	if (sector_nr >= max_sector) {
@@ -1107,8 +1107,8 @@ static int sync_request(mddev_t *mddev, 
 		/* There is nowhere to write, so all non-sync
 		 * drives must be failed - so we are finished
 		 */
-		int rv = max_sector - sector_nr;
-		md_done_sync(mddev, rv, 1);
+		sector_t rv = max_sector - sector_nr;
+		*skipped = 1;
 		put_buf(r1_bio);
 		rdev_dec_pending(conf->mirrors[disk].rdev, mddev);
 		return rv;

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-02-18 11:11:25.000000000 +1100
+++ ./drivers/md/raid10.c	2005-02-18 11:11:26.000000000 +1100
@@ -1321,7 +1321,7 @@ static int init_resync(conf_t *conf)
  *
  */
 
-static int sync_request(mddev_t *mddev, sector_t sector_nr, int go_faster)
+static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
 	conf_t *conf = mddev_to_conf(mddev);
 	r10bio_t *r10_bio;
@@ -1335,7 +1335,7 @@ static int sync_request(mddev_t *mddev, 
 
 	if (!conf->r10buf_pool)
 		if (init_resync(conf))
-			return -ENOMEM;
+			return 0;
 
  skipped:
 	max_sector = mddev->size << 1;
@@ -1343,15 +1343,15 @@ static int sync_request(mddev_t *mddev, 
 		max_sector = mddev->resync_max_sectors;
 	if (sector_nr >= max_sector) {
 		close_sync(conf);
+		*skipped = 1;
 		return sectors_skipped;
 	}
 	if (chunks_skipped >= conf->raid_disks) {
 		/* if there has been nothing to do on any drive,
 		 * then there is nothing to do at all..
 		 */
-		sector_t sec = max_sector - sector_nr;
-		md_done_sync(mddev, sec, 1);
-		return sec + sectors_skipped;
+		*skipped = 1;
+		return (max_sector - sector_nr) + sectors_skipped;
 	}
 
 	/* make sure whole request will fit in a chunk - if chunks
@@ -1565,17 +1565,22 @@ static int sync_request(mddev_t *mddev, 
 		}
 	}
 
+	if (sectors_skipped)
+		/* pretend they weren't skipped, it makes
+		 * no important difference in this case
+		 */
+		md_done_sync(mddev, sectors_skipped, 1);
+
 	return sectors_skipped + nr_sectors;
  giveup:
 	/* There is nowhere to write, so all non-sync
 	 * drives must be failed, so try the next chunk...
 	 */
 	{
-	int sec = max_sector - sector_nr;
+	sector_t sec = max_sector - sector_nr;
 	sectors_skipped += sec;
 	chunks_skipped ++;
 	sector_nr = max_sector;
-	md_done_sync(mddev, sec, 1);
 	goto skipped;
 	}
 }

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-18 11:11:26.000000000 +1100
@@ -1475,7 +1475,7 @@ static int make_request (request_queue_t
 }
 
 /* FIXME go_faster isn't used */
-static int sync_request (mddev_t *mddev, sector_t sector_nr, int go_faster)
+static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
 	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
 	struct stripe_head *sh;
@@ -1498,8 +1498,8 @@ static int sync_request (mddev_t *mddev,
 	 * nothing we can do.
 	 */
 	if (mddev->degraded >= 1 && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		int rv = (mddev->size << 1) - sector_nr;
-		md_done_sync(mddev, rv, 1);
+		sector_t rv = (mddev->size << 1) - sector_nr;
+		*skipped = 1;
 		return rv;
 	}
 

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./drivers/md/raid6main.c	2005-02-18 11:11:26.000000000 +1100
@@ -1634,7 +1634,7 @@ static int make_request (request_queue_t
 }
 
 /* FIXME go_faster isn't used */
-static int sync_request (mddev_t *mddev, sector_t sector_nr, int go_faster)
+static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
 	raid6_conf_t *conf = (raid6_conf_t *) mddev->private;
 	struct stripe_head *sh;
@@ -1657,8 +1657,8 @@ static int sync_request (mddev_t *mddev,
 	 * nothing we can do.
 	 */
 	if (mddev->degraded >= 2 && test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		int rv = (mddev->size << 1) - sector_nr;
-		md_done_sync(mddev, rv, 1);
+		sector_t rv = (mddev->size << 1) - sector_nr;
+		*skipped = 1;
 		return rv;
 	}
 

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2005-02-18 11:11:26.000000000 +1100
+++ ./include/linux/raid/md_k.h	2005-02-18 11:11:26.000000000 +1100
@@ -298,7 +298,7 @@ struct mdk_personality_s
 	int (*hot_add_disk) (mddev_t *mddev, mdk_rdev_t *rdev);
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
 	int (*spare_active) (mddev_t *mddev);
-	int (*sync_request)(mddev_t *mddev, sector_t sector_nr, int go_faster);
+	sector_t (*sync_request)(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster);
 	int (*resize) (mddev_t *mddev, sector_t sectors);
 	int (*reshape) (mddev_t *mddev, int raid_disks);
 	int (*reconfig) (mddev_t *mddev, int layout, int chunk_size);
