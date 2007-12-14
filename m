From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 7] md: Allow a maximum extent to be set for resyncing.
Date: Fri, 14 Dec 2007 17:26:22 +1100
Message-ID: <1071214062622.1852@suse.de>
References: <20071214171950.1308.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This allows userspace to control resync/reshape progress and
synchronise it with other activities, such as shared access in a SAN,
or backing up critical sections during a tricky reshape.

Writing a number of sectors (which must be a multiple of the chunk
size if such is meaningful) causes a resync to pause when it
gets to that point.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt      |   10 +++++
 ./drivers/md/md.c           |   75 ++++++++++++++++++++++++++++++++++++++------
 ./drivers/md/raid1.c        |    2 +
 ./drivers/md/raid10.c       |    3 +
 ./drivers/md/raid5.c        |   25 ++++++++++++++
 ./include/linux/raid/md_k.h |    2 +
 6 files changed, 107 insertions(+), 10 deletions(-)

diff .prev/Documentation/md.txt ./Documentation/md.txt
--- .prev/Documentation/md.txt	2007-12-14 16:07:50.000000000 +1100
+++ ./Documentation/md.txt	2007-12-14 16:08:57.000000000 +1100
@@ -416,6 +416,16 @@ also have
      sectors in total that could need to be processed.  The two
      numbers are separated by a '/'  thus effectively showing one
      value, a fraction of the process that is complete.
+     A 'select' on this attribute will return when resync completes,
+     when it reaches the current sync_max (below) and possibly at
+     other times.
+
+   sync_max
+     This is a number of sectors at which point a resync/recovery
+     process will pause.  When a resync is active, the value can
+     only ever be increased, never decreased.  The value of 'max'
+     effectively disables the limit.
+
 
    sync_speed
      This shows the current actual speed, in K/sec, of the current

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-12-14 16:08:52.000000000 +1100
+++ ./drivers/md/md.c	2007-12-14 16:08:57.000000000 +1100
@@ -275,6 +275,7 @@ static mddev_t * mddev_find(dev_t unit)
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
 	new->reshape_position = MaxSector;
+	new->resync_max = MaxSector;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -2926,6 +2927,43 @@ sync_completed_show(mddev_t *mddev, char
 static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
 
 static ssize_t
+max_sync_show(mddev_t *mddev, char *page)
+{
+	if (mddev->resync_max == MaxSector)
+		return sprintf(page, "max\n");
+	else
+		return sprintf(page, "%llu\n",
+			       (unsigned long long)mddev->resync_max);
+}
+static ssize_t
+max_sync_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	if (strncmp(buf, "max", 3) == 0)
+		mddev->resync_max = MaxSector;
+	else {
+		char *ep;
+		unsigned long long max = simple_strtoull(buf, &ep, 10);
+		if (ep == buf || (*ep != 0 && *ep != '\n'))
+			return -EINVAL;
+		if (max < mddev->resync_max &&
+		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+			return -EBUSY;
+
+		/* Must be a multiple of chunk_size */
+		if (mddev->chunk_size) {
+			if (max & (sector_t)((mddev->chunk_size>>9)-1))
+				return -EINVAL;
+		}
+		mddev->resync_max = max;
+	}
+	wake_up(&mddev->recovery_wait);
+	return len;
+}
+
+static struct md_sysfs_entry md_max_sync =
+__ATTR(sync_max, S_IRUGO|S_IWUSR, max_sync_show, max_sync_store);
+
+static ssize_t
 suspend_lo_show(mddev_t *mddev, char *page)
 {
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->suspend_lo);
@@ -3035,6 +3073,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
 	&md_sync_completed.attr,
+	&md_max_sync.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
@@ -3582,6 +3621,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->size = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
+		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
 
@@ -5445,8 +5485,16 @@ void md_do_sync(mddev_t *mddev)
 		sector_t sectors;
 
 		skipped = 0;
+		if (j >= mddev->resync_max) {
+			sysfs_notify(&mddev->kobj, NULL, "sync_completed");
+			wait_event(mddev->recovery_wait,
+				   mddev->resync_max > j
+				   || kthread_should_stop());
+		}
+		if (kthread_should_stop())
+			goto interrupted;
 		sectors = mddev->pers->sync_request(mddev, j, &skipped,
-					    currspeed < speed_min(mddev));
+						  currspeed < speed_min(mddev));
 		if (sectors == 0) {
 			set_bit(MD_RECOVERY_ERR, &mddev->recovery);
 			goto out;
@@ -5488,15 +5536,9 @@ void md_do_sync(mddev_t *mddev)
 		}
 
 
-		if (kthread_should_stop()) {
-			/*
-			 * got a signal, exit.
-			 */
-			printk(KERN_INFO 
-				"md: md_do_sync() got signal ... exiting\n");
-			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			goto out;
-		}
+		if (kthread_should_stop())
+			goto interrupted;
+
 
 		/*
 		 * this loop exits only if either when we are slower than
@@ -5560,9 +5602,22 @@ void md_do_sync(mddev_t *mddev)
 
  skip:
 	mddev->curr_resync = 0;
+	mddev->resync_max = MaxSector;
+	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
+	return;
+
+ interrupted:
+	/*
+	 * got a signal, exit.
+	 */
+	printk(KERN_INFO
+	       "md: md_do_sync() got signal ... exiting\n");
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+	goto out;
+
 }
 EXPORT_SYMBOL_GPL(md_do_sync);
 

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2007-12-14 16:07:50.000000000 +1100
+++ ./drivers/md/raid10.c	2007-12-14 16:08:57.000000000 +1100
@@ -1657,6 +1657,9 @@ static sector_t sync_request(mddev_t *md
 		return (max_sector - sector_nr) + sectors_skipped;
 	}
 
+	if (max_sector > mddev->resync_max)
+		max_sector = mddev->resync_max; /* Don't do IO beyond here */
+
 	/* make sure whole request will fit in a chunk - if chunks
 	 * are meaningful
 	 */

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-12-14 16:07:50.000000000 +1100
+++ ./drivers/md/raid1.c	2007-12-14 16:08:57.000000000 +1100
@@ -1784,6 +1784,8 @@ static sector_t sync_request(mddev_t *md
 		return rv;
 	}
 
+	if (max_sector > mddev->resync_max)
+		max_sector = mddev->resync_max; /* Don't do IO beyond here */
 	nr_sectors = 0;
 	sync_blocks = 0;
 	do {

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-12-14 16:07:50.000000000 +1100
+++ ./drivers/md/raid5.c	2007-12-14 16:08:57.000000000 +1100
@@ -4277,6 +4277,25 @@ static sector_t reshape_request(mddev_t 
 		release_queue(sq);
 		first_sector += STRIPE_SECTORS;
 	}
+	/* If this takes us to the resync_max point where we have to pause,
+	 * then we need to write out the superblock.
+	 */
+	sector_nr += conf->chunk_size>>9;
+	if (sector_nr >= mddev->resync_max) {
+		/* Cannot proceed until we've updated the superblock... */
+		wait_event(conf->wait_for_overlap,
+			   atomic_read(&conf->reshape_stripes) == 0);
+		mddev->reshape_position = conf->expand_progress;
+		set_bit(MD_CHANGE_DEVS, &mddev->flags);
+		md_wakeup_thread(mddev->thread);
+		wait_event(mddev->sb_wait,
+			   !test_bit(MD_CHANGE_DEVS, &mddev->flags)
+			   || kthread_should_stop());
+		spin_lock_irq(&conf->device_lock);
+		conf->expand_lo = mddev->reshape_position;
+		spin_unlock_irq(&conf->device_lock);
+		wake_up(&conf->wait_for_overlap);
+	}
 	return conf->chunk_size>>9;
 }
 
@@ -4314,6 +4333,12 @@ static inline sector_t sync_request(mdde
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return reshape_request(mddev, sector_nr, skipped);
 
+	/* No need to check resync_max as we never do more than one
+	 * stripe, and as resync_max will always be on a chunk boundary,
+	 * if the check in md_do_sync didn't fire, there is no chance
+	 * of overstepping resync_max here
+	 */
+
 	/* if there is too many failed drives and we are trying
 	 * to resync, then assert that we are finished, because there is
 	 * nothing we can do.

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2007-12-14 16:07:54.000000000 +1100
+++ ./include/linux/raid/md_k.h	2007-12-14 16:08:57.000000000 +1100
@@ -219,6 +219,8 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
+	sector_t			resync_max;	/* resync should pause
+							 * when it gets here */
 
 	spinlock_t			write_lock;
 	wait_queue_head_t		sb_wait;	/* for waiting on superblock updates */
