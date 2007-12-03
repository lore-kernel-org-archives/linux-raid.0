From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH] force parallel resync
Date: Mon, 3 Dec 2007 14:37:03 +0100
Message-ID: <200712031437.04211.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Neil,


on doing software-raid over some Infortrend hardware raid boxes, we can easily 
bring a single cpu to 100%, while the hardware-raid boxes are still only 
utilized for 50% or less.
So we are using *several* software raids instead of only one. However, for us 
it then also doesn't make sense to have a resync for only one of the 
md-raids. Below is a patch to force parallel resync for specified md-sets via 
sysfs.
This still leaves a problem, though. If a resync starts before settings this 
parameter, I don't know how to wake up the sleeping resync-thread. Any ideas?


Signed-off-by: Bernd Schubert <bs@q-leap.de>

(The patch is against 2.6.22, but also applies to 2.6.23).

Index: linux-2.6.22/drivers/md/md.c
===================================================================
--- linux-2.6.22.orig/drivers/md/md.c	2007-11-27 15:42:22.000000000 +0100
+++ linux-2.6.22/drivers/md/md.c	2007-12-03 13:39:26.000000000 +0100
@@ -2843,6 +2843,30 @@ __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, 
 
 
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
@@ -2980,6 +3004,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
+	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
@@ -5264,8 +5289,9 @@ void md_do_sync(mddev_t *mddev)
 		ITERATE_MDDEV(mddev2,tmp) {
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
Index: linux-2.6.22/include/linux/raid/md_k.h
===================================================================
--- linux-2.6.22.orig/include/linux/raid/md_k.h	2007-12-03 13:00:10.000000000 
+0100
+++ linux-2.6.22/include/linux/raid/md_k.h	2007-12-03 13:01:40.000000000 +0100
@@ -170,6 +170,9 @@ struct mddev_s
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
