From: Denis ChengRq <crquan@gmail.com>
Subject: [PATCH] md: switch to use pr_debug from <linux/kernel.h>
Date: Fri,  1 Aug 2008 14:55:48 +0800
Message-ID: <1217573748-26886-1-git-send-email-crquan@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

the local defined macro dprintk should not be used,

and some of the orignal dprintk use KERN_INFO prefix, but they were actually
debug messages, should use KERN_DEBUG prefix instead, which is pr_debug will do.

Notice: pr_info from kernel.h will always call printk, not according to DEBUG macro,
so cannot be used here, only pr_debug is adaptive to DEBUG.

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/md/md.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c2ff77c..c1299fb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -61,10 +61,6 @@
 /* 63 partitions with the alternate major number (mdp) */
 #define MdpMinorShift 6
 
-#define DEBUG 0
-#define dprintk(x...) ((void)(DEBUG && printk(x)))
-
-
 #ifndef MODULE
 static void autostart_arrays (int part);
 #endif
@@ -1792,31 +1788,30 @@ repeat:
 	sync_sbs(mddev, nospares);
 	spin_unlock_irq(&mddev->write_lock);
 
-	dprintk(KERN_INFO 
-		"md: updating %s RAID superblock on device (in sync %d)\n",
+	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
 		mdname(mddev),mddev->in_sync);
 
 	bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, tmp, mddev) {
 		char b[BDEVNAME_SIZE];
-		dprintk(KERN_INFO "md: ");
+		pr_debug("md: ");
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
 		if (test_bit(Faulty, &rdev->flags))
-			dprintk("(skipping faulty ");
+			pr_debug("(skipping faulty ");
 
-		dprintk("%s ", bdevname(rdev->bdev,b));
+		pr_debug("%s ", bdevname(rdev->bdev,b));
 		if (!test_bit(Faulty, &rdev->flags)) {
 			md_super_write(mddev,rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
-			dprintk(KERN_INFO "(write) %s's sb offset: %llu\n",
+			pr_debug("(write) %s's sb offset: %llu\n",
 				bdevname(rdev->bdev,b),
 				(unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
 
 		} else
-			dprintk(")\n");
+			pr_debug(")\n");
 		if (mddev->level == LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
 			break;
@@ -5108,7 +5103,7 @@ static int md_thread(void * arg)
 void md_wakeup_thread(mdk_thread_t *thread)
 {
 	if (thread) {
-		dprintk("md: waking up MD thread %s.\n", thread->tsk->comm);
+		pr_debug("md: waking up MD thread %s.\n", thread->tsk->comm);
 		set_bit(THREAD_WAKEUP, &thread->flags);
 		wake_up(&thread->wqueue);
 	}
@@ -5138,7 +5133,7 @@ mdk_thread_t *md_register_thread(void (*run) (mddev_t *), mddev_t *mddev,
 
 void md_unregister_thread(mdk_thread_t *thread)
 {
-	dprintk("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
+	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 
 	kthread_stop(thread->tsk);
 	kfree(thread);
@@ -5157,7 +5152,7 @@ void md_error(mddev_t *mddev, mdk_rdev_t *rdev)
 	if (mddev->external)
 		set_bit(Blocked, &rdev->flags);
 /*
-	dprintk("md_error dev:%s, rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
+	pr_debug("md_error dev:%s, rdev:(%d:%d), (caller: %p,%p,%p,%p).\n",
 		mdname(mddev),
 		MAJOR(rdev->bdev->bd_dev), MINOR(rdev->bdev->bd_dev),
 		__builtin_return_address(0),__builtin_return_address(1),
@@ -6250,7 +6245,7 @@ static struct notifier_block md_notifier = {
 
 static void md_geninit(void)
 {
-	dprintk("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
+	pr_debug("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
 	proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
 }
-- 
1.5.6.4

