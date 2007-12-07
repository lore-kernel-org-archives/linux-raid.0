From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH] (2nd try) force parallel resync
Date: Fri, 7 Dec 2007 13:38:44 +0100
Message-ID: <200712071338.45190.bs@q-leap.de>
References: <200712062006.15406.bs@q-leap.de> <18264.43933.856112.52203@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18264.43933.856112.52203@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On Friday 07 December 2007 03:10:37 Neil Brown wrote:
> On Thursday December 6, bs@q-leap.de wrote:
> > Hello,
> >
> > here is the second version of the patch. With this version also on
> > setting /sys/block/*/md/sync_force_parallel the sync_thread is woken up.
> > Though, I still don't understand why md_wakeup_thread() is not working.
>
> Could give a little more detail on why you want this?  When do you
> want multiple arrays on the same device to sync at the same time?
> What exactly is the hardware like?

I did describe it in my first mail, I guess you just missed this one. So I'm 
pasting this part here:

On Monday 03 December 2007 14:37:03 Bernd Schubert wrote:
> Hello Neil,
>
>
> on doing software-raid over some Infortrend hardware raid boxes, we can
> easily bring a single cpu to 100%, while the hardware-raid boxes are still
> only utilized for 50% or less.
> So we are using *several* software raids instead of only one. However, for
> us it then also doesn't make sense to have a resync for only one of the
> md-raids. Below is a patch to force parallel resync for specified md-sets
> via sysfs.
> This still leaves a problem, though. If a resync starts before settings
> this parameter, I don't know how to wake up the sleeping resync-thread. Any
> ideas?
>


>
> md threads generally run for a little while to perform some task, then
> stop and wait to be needed again.  md_wakeup_thread says "you are
> needed again".
>
> The resync/recovery thread is a bit different.  It just run md_do_sync
> once.  md_wakeup_thread is not really meaningful in that context.
>
> What you want is:
> 		wake_up(&resync_wait);
>
> that will get any thread that is waiting for some other array to
> resync to wake up and see if something needs to be done.

Ah thanks a lot! Now I understand. What about this?


Signed-off-by: Bernd Schubert <bs@q-leap.de>


Index: linux-2.6.22/drivers/md/md.c
===================================================================
--- linux-2.6.22.orig/drivers/md/md.c	2007-12-06 19:51:55.000000000 +0100
+++ linux-2.6.22/drivers/md/md.c	2007-12-07 12:07:47.000000000 +0100
@@ -74,6 +74,8 @@ static DEFINE_SPINLOCK(pers_lock);
 
 static void md_print_devices(void);
 
+static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
+
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, 
__LINE__); md_print_devices(); }
 
 /*
@@ -2843,6 +2845,34 @@ __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, 
 
 
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
@@ -2980,6 +3010,7 @@ static struct attribute *md_redundancy_a
 	&md_sync_min.attr,
 	&md_sync_max.attr,
 	&md_sync_speed.attr,
+	&md_sync_force_parallel.attr,
 	&md_sync_completed.attr,
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
@@ -5199,8 +5230,6 @@ void md_allow_write(mddev_t *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
-static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 void md_do_sync(mddev_t *mddev)
@@ -5264,8 +5293,9 @@ void md_do_sync(mddev_t *mddev)
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
--- linux-2.6.22.orig/include/linux/raid/md_k.h	2007-12-06 19:51:55.000000000 
+0100
+++ linux-2.6.22/include/linux/raid/md_k.h	2007-12-06 19:52:33.000000000 +0100
@@ -170,6 +170,9 @@ struct mddev_s
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
