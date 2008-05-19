From: NeilBrown <neilb@suse.de>
Subject: [PATCH 009 of 10] md: Allow parallel resync of md-devices.
Date: Mon, 19 May 2008 11:11:04 +1000
Message-ID: <1080519011104.7767@suse.de>
References: <20080519110910.7473.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Bernd Schubert <bs@q-leap.de>
List-Id: linux-raid.ids


From: Bernd Schubert <bs@q-leap.de>

In some configurations, a raid6 resync can be limited by CPU speed
(Calculating P and Q and moving data) rather than by device speed.
In these cases there is nothing to be gained byt serialising resync
of arrays that share a device, and doing the resync in parallel can
provide benefit.
So add a sysfs tunable to flag an array as being allowed to
resync in parallel with other arrays that use (a different part of)
the same device.


Signed-off-by: Bernd Schubert <bs@q-leap.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c           |   40 ++++++++++++++++++++++++++++++++++++----
 ./include/linux/raid/md_k.h |    3 +++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:03:47.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 11:04:07.000000000 +1000
@@ -74,6 +74,8 @@ static DEFINE_SPINLOCK(pers_lock);
 
 static void md_print_devices(void);
 
+static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
 
 /*
@@ -3013,6 +3015,36 @@ degraded_show(mddev_t *mddev, char *page
 static struct md_sysfs_entry md_degraded = __ATTR_RO(degraded);
 
 static ssize_t
+sync_force_parallel_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d\n", mddev->parallel_resync);
+}
+
+static ssize_t
+sync_force_parallel_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	long n;
+
+	if (strict_strtol(buf, 10, &n))
+		return -EINVAL;
+
+	if (n != 0 && n != 1)
+		return -EINVAL;
+
+	mddev->parallel_resync = n;
+
+	if (mddev->sync_thread)
+		wake_up(&resync_wait);
+
+	return len;
+}
+
+/* force parallel resync, even with shared block devices */
+static struct md_sysfs_entry md_sync_force_parallel =
+__ATTR(sync_force_parallel, S_IRUGO|S_IWUSR,
+       sync_force_parallel_show, sync_force_parallel_store);
+
+static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
 {
 	unsigned long resync, dt, db;
@@ -3187,6 +3219,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
+	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
 	&md_max_sync.attr,
 	&md_suspend_lo.attr,
@@ -5487,8 +5520,6 @@ void md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
-static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 void md_do_sync(mddev_t *mddev)
@@ -5552,8 +5583,9 @@ void md_do_sync(mddev_t *mddev)
 		for_each_mddev(mddev2, tmp) {
 			if (mddev2 == mddev)
 				continue;
-			if (mddev2->curr_resync && 
-			    match_mddev_units(mddev,mddev2)) {
+			if (!mddev->parallel_resync
+			&&  mddev2->curr_resync
+			&&  match_mddev_units(mddev, mddev2)) {
 				DEFINE_WAIT(wq);
 				if (mddev < mddev2 && mddev->curr_resync == 2) {
 					/* arbitrarily yield */

diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
--- .prev/include/linux/raid/md_k.h	2008-05-19 11:02:06.000000000 +1000
+++ ./include/linux/raid/md_k.h	2008-05-19 11:04:07.000000000 +1000
@@ -180,6 +180,9 @@ struct mddev_s
 	int				sync_speed_min;
 	int				sync_speed_max;
 
+	/* resync even though the same disks are shared among md-devices */
+	int				parallel_resync;
+
 	int				ok_start_degraded;
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover
