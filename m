From: Bernd Schubert <bs@q-leap.de>
Subject: parallel resync
Date: Tue, 29 Apr 2008 11:59:26 +0200
Message-ID: <200804291159.27967.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hello Neil,

I think in about December I already asked if you could include our parallel 
resync patch. We need this patch, since we are doing software raid over 
fast hardware raid devices and with these hardware raid system the cpu is 
the bottleneck and not disk i/o.

Here is the previous thread: http://www.issociate.de/board/post/470063/[PATCH]_(2nd_try)_force_parallel_resync.html

Is there any chance you could add this patch as well, or if the patch is 
not suitable yet, could you please tell me what needs to be done?


Index: linus/drivers/md/md.c
===================================================================
--- linus.orig/drivers/md/md.c
+++ linus/drivers/md/md.c
@@ -74,6 +74,8 @@ static DEFINE_SPINLOCK(pers_lock);
 
 static void md_print_devices(void);
 
+static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
 
 /*
@@ -2979,6 +2981,34 @@ degraded_show(mddev_t *mddev, char *page
 static struct md_sysfs_entry md_degraded = __ATTR_RO(degraded);
 
 static ssize_t
+sync_force_parallel_show(mddev_t *mddev, char *page)
+{
+        return sprintf(page, "%d\n", mddev->parallel_resync);
+}
+
+static ssize_t
+sync_force_parallel_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long n = simple_strtoul(buf, &e, 10);
+
+	if (!*buf || (*e && *e != '\n') || (n != 0 && n != 1))
+		return -EINVAL;
+
+	mddev->parallel_resync = n;
+
+	if (mddev->sync_thread) {
+		wake_up(&resync_wait);
+	}
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
@@ -3153,6 +3183,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
+	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
 	&md_max_sync.attr,
 	&md_suspend_lo.attr,
@@ -5413,8 +5444,6 @@ void md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
-static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 void md_do_sync(mddev_t *mddev)
@@ -5478,8 +5507,9 @@ void md_do_sync(mddev_t *mddev)
 		for_each_mddev(mddev2, tmp) {
 			if (mddev2 == mddev)
 				continue;
-			if (mddev2->curr_resync && 
-			    match_mddev_units(mddev,mddev2)) {
+			if (!mddev->parallel_resync
+			&&  mddev2->curr_resync
+			&&  match_mddev_units(mddev,mddev2)) {
 				DEFINE_WAIT(wq);
 				if (mddev < mddev2 && mddev->curr_resync == 2) {
 					/* arbitrarily yield */
Index: linus/include/linux/raid/md_k.h
===================================================================
--- linus.orig/include/linux/raid/md_k.h
+++ linus/include/linux/raid/md_k.h
@@ -176,6 +176,9 @@ struct mddev_s
 	int				sync_speed_min;
 	int				sync_speed_max;
 
+	/* resync even though the same disks are shared among md-devices */
+	int				parallel_resync;
+
 	int				ok_start_degraded;
 	/* recovery/resync flags 
 	 * NEEDED:   we might need to start a resync/recover



Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
