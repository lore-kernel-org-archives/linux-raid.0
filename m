From: NeilBrown <neilb@suse.de>
Subject: [PATCH 004 of 12] md: Fix resync speed calculation for restarted resyncs.
Date: Tue, 27 Jun 2006 17:05:25 +1000
Message-ID: <1060627070525.25998@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030729AbWF0HIz@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


We introduced 'io_sectors' recently so we could count
the sectors that causes io during resync separate from sectors
which didn't cause IO - there can be a difference if a bitmap
is being used to accelerate resync.

However when a speed is reported, we find the number of sectors
processed recently by subtracting an oldish io_sectors count
from a current 'curr_resync' count.  This is wrong because
curr_resync counts all sectors, not just io sectors.

So, add a field to mddev to store the curren io_sectors separately from
curr_resync, and use that in the calculations.

### Diffstat output
 ./drivers/md/md.c           |   10 ++++++----
 ./drivers/md/raid5.c        |    3 ++-
 ./include/linux/raid/md_k.h |    3 ++-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-06-27 12:17:32.000000000 +1000
+++ ./drivers/md/md.c	2006-06-27 12:17:32.000000000 +1000
@@ -2721,7 +2721,7 @@ static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
 {
 	unsigned long resync, dt, db;
-	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active));
+	resync = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active));
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
 	db = resync - (mddev->resync_mark_cnt);
@@ -4692,12 +4692,13 @@ static void status_resync(struct seq_fil
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
-	db = resync - (mddev->resync_mark_cnt/2);
-	rt = (dt * ((unsigned long)(max_blocks-resync) / (db/100+1)))/100;
+	db = (mddev->curr_mark_cnt - atomic_read(&mddev->recovery_active))
+		- mddev->resync_mark_cnt;
+	rt = (dt * ((unsigned long)(max_blocks-resync) / (db/2/100+1)))/100;
 
 	seq_printf(seq, " finish=%lu.%lumin", rt / 60, (rt % 60)/6);
 
-	seq_printf(seq, " speed=%ldK/sec", db/dt);
+	seq_printf(seq, " speed=%ldK/sec", db/2/dt);
 }
 
 static void *md_seq_start(struct seq_file *seq, loff_t *pos)
@@ -5208,6 +5209,7 @@ void md_do_sync(mddev_t *mddev)
 
 		j += sectors;
 		if (j>1) mddev->curr_resync = j;
+		mddev->curr_mark_cnt = io_sectors;
 		if (last_check == 0)
 			/* this is the earliers that rebuilt will be
 			 * visible in /proc/mdstat

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2006-06-27 12:17:32.000000000 +1000
+++ ./drivers/md/raid5.c	2006-06-27 12:17:32.000000000 +1000
@@ -282,7 +282,8 @@ static struct stripe_head *get_active_st
 			} else {
 				if (!test_bit(STRIPE_HANDLE, &sh->state))
 					atomic_inc(&conf->active_stripes);
-				if (list_empty(&sh->lru))
+				if (list_empty(&sh->lru) &&
+				    !test_bit(STRIPE_EXPANDING, &sh->state))
 					BUG();
 				list_del_init(&sh->lru);
 			}

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2006-06-27 12:15:17.000000000 +1000
+++ ./include/linux/raid/md_k.h	2006-06-27 12:17:32.000000000 +1000
@@ -148,9 +148,10 @@ struct mddev_s
 
 	struct mdk_thread_s		*thread;	/* management thread */
 	struct mdk_thread_s		*sync_thread;	/* doing resync or reconstruct */
-	sector_t			curr_resync;	/* blocks scheduled */
+	sector_t			curr_resync;	/* last block scheduled */
 	unsigned long			resync_mark;	/* a recent timestamp */
 	sector_t			resync_mark_cnt;/* blocks written at resync_mark */
+	sector_t			curr_mark_cnt; /* blocks scheduled now */
 
 	sector_t			resync_max_sectors; /* may be set by personality */
 
