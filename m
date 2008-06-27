From: NeilBrown <neilb@suse.de>
Subject: [PATCH 007 of 29] md: Allow setting start point for requested check/repair
Date: Fri, 27 Jun 2008 16:50:03 +1000
Message-ID: <1080627065003.10401@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This makes it possible to just resync a small part of an array.
e.g. if a drive reports that it has questionable sectors,
a 'repair' of just the region covering those sectors will 
cause them to be read and, if there is an error, re-written
with correct data.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   47 +++++++++++++++++++++++++++++++++++++++-----
 ./include/linux/raid/md_k.h |    2 +
 2 files changed, 44 insertions(+), 5 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:31:08.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:31:27.000000000 +1000
@@ -278,6 +278,7 @@ static mddev_t * mddev_find(dev_t unit)
 	init_waitqueue_head(&new->sb_wait);
 	init_waitqueue_head(&new->recovery_wait);
 	new->reshape_position = MaxSector;
+	new->resync_min = 0;
 	new->resync_max = MaxSector;
 	new->level = LEVEL_NONE;
 
@@ -3075,6 +3076,36 @@ sync_completed_show(mddev_t *mddev, char
 static struct md_sysfs_entry md_sync_completed = __ATTR_RO(sync_completed);
 
 static ssize_t
+min_sync_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n",
+		       (unsigned long long)mddev->resync_min);
+}
+static ssize_t
+min_sync_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	unsigned long long min;
+	if (strict_strtoull(buf, 10, &min))
+		return -EINVAL;
+	if (min > mddev->resync_max)
+		return -EINVAL;
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return -EBUSY;
+
+	/* Must be a multiple of chunk_size */
+	if (mddev->chunk_size) {
+		if (min & (sector_t)((mddev->chunk_size>>9)-1))
+			return -EINVAL;
+	}
+	mddev->resync_min = min;
+
+	return len;
+}
+
+static struct md_sysfs_entry md_min_sync =
+__ATTR(sync_min, S_IRUGO|S_IWUSR, min_sync_show, min_sync_store);
+
+static ssize_t
 max_sync_show(mddev_t *mddev, char *page)
 {
 	if (mddev->resync_max == MaxSector)
@@ -3089,9 +3120,10 @@ max_sync_store(mddev_t *mddev, const cha
 	if (strncmp(buf, "max", 3) == 0)
 		mddev->resync_max = MaxSector;
 	else {
-		char *ep;
-		unsigned long long max = simple_strtoull(buf, &ep, 10);
-		if (ep == buf || (*ep != 0 && *ep != '\n'))
+		unsigned long long max;
+		if (strict_strtoull(buf, 10, &max))
+			return -EINVAL;
+		if (max < mddev->resync_min)
 			return -EINVAL;
 		if (max < mddev->resync_max &&
 		    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
@@ -3222,6 +3254,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_speed.attr,
 	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
+	&md_min_sync.attr,
 	&md_max_sync.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
@@ -3777,6 +3810,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->size = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
+		mddev->resync_min = 0;
 		mddev->resync_max = MaxSector;
 		mddev->reshape_position = MaxSector;
 		mddev->external = 0;
@@ -5625,9 +5659,11 @@ void md_do_sync(mddev_t *mddev)
 		max_sectors = mddev->resync_max_sectors;
 		mddev->resync_mismatches = 0;
 		/* we don't use the checkpoint if there's a bitmap */
-		if (!mddev->bitmap &&
-		    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
+			j = mddev->resync_min;
+		else if (!mddev->bitmap)
 			j = mddev->recovery_cp;
+
 	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		max_sectors = mddev->size << 1;
 	else {
@@ -5796,6 +5832,7 @@ void md_do_sync(mddev_t *mddev)
 
  skip:
 	mddev->curr_resync = 0;
+	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-06-27 15:14:04.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-06-27 15:31:27.000000000 +1000
@@ -227,6 +227,8 @@ struct mddev_s
 	atomic_t			recovery_active; /* blocks scheduled, but not written */
 	wait_queue_head_t		recovery_wait;
 	sector_t			recovery_cp;
+	sector_t			resync_min;	/* user requested sync
+							 * starts here */
 	sector_t			resync_max;	/* resync should pause
 							 * when it gets here */
 
