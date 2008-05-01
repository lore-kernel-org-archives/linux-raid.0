From: Bernd Schubert <bs@q-leap.de>
Subject: Re: parallel resync
Date: Thu, 1 May 2008 23:17:13 +0200
Message-ID: <200805012317.14370.bs@q-leap.de>
References: <200804291159.27967.bs@q-leap.de> <18457.22180.38604.335076@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18457.22180.38604.335076@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Thursday 01 May 2008 07:35:32 Neil Brown wrote:
> On Tuesday April 29, bs@q-leap.de wrote:
>
> Sorry for not responding earlier....

No problem, we are all always overly busy ;)

>
> I seem to remember the setting used to be global, but I see in this
> patch it is per-array -- which makes much more sense.
> Though it brings up an interesting question.  If two arrays share a
> device, and exactly one of them is flagged for parallel sync, does
> that make sense?
>
> Maybe it does.  I suspect the reality is that it is individual devices
> that should be flagged for parallel sync or not, and the setting on
> the array is just an "and" of the settings for the devices in the
> array.  So different settings on arrays which share one device can
> make sense...
>
> Note: I'm *not* suggesting that the setting should be moved to the
> component devices - that would be too clumsy.  I'm just musing.
>
> If get 3 errors and 2 warnings from ./scripts/checkpatch.pl.  If you
> fix those I'll take the patch.

Below is a new version of the patch. If kmail should break something, I
also uploaded it here: 
http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/md/parallel_resync.patch


Unfortunately I presently don't have any non-production system I could
easily reboot to test the new version on. 


Thanks,
Bernd


Allow parallel resync of md-devices.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

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
@@ -2979,6 +2981,36 @@ degraded_show(mddev_t *mddev, char *page
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
@@ -3153,6 +3185,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
+	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
 	&md_max_sync.attr,
 	&md_suspend_lo.attr,
@@ -5413,8 +5446,6 @@ void md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
-static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 void md_do_sync(mddev_t *mddev)
@@ -5478,8 +5509,9 @@ void md_do_sync(mddev_t *mddev)
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


-- 
Bernd Schubert
Q-Leap Networks GmbH
