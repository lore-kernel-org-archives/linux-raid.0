From: Shaohua Li <shli@kernel.org>
Subject: [patch 1/3 v3] MD: add a specific workqueue to do dispatch
Date: Wed, 13 Jun 2012 17:11:44 +0800
Message-ID: <20120613091231.470357766@kernel.org>
References: <20120613091143.508417333@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-workqueue.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

Add a specific workqueue to do dispatch. Later patches will use it to do
per-cpu request queue dispatch.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/md.c |   14 ++++++++++++++
 drivers/md/md.h |    1 +
 2 files changed, 15 insertions(+)

Index: linux/drivers/md/md.c
===================================================================
--- linux.orig/drivers/md/md.c	2012-05-24 15:42:56.892251685 +0800
+++ linux/drivers/md/md.c	2012-05-24 15:44:55.618759412 +0800
@@ -71,6 +71,7 @@ static void md_print_devices(void);
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 static struct workqueue_struct *md_wq;
 static struct workqueue_struct *md_misc_wq;
+static struct workqueue_struct *md_run_wq;
 
 #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
 
@@ -8446,6 +8447,12 @@ static void md_geninit(void)
 	proc_create("mdstat", S_IRUGO, NULL, &md_seq_fops);
 }
 
+int md_schedule_work_on(int cpu, struct work_struct *work)
+{
+	return queue_work_on(cpu, md_run_wq, work);
+}
+EXPORT_SYMBOL(md_schedule_work_on);
+
 static int __init md_init(void)
 {
 	int ret = -ENOMEM;
@@ -8458,6 +8465,10 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
+	md_run_wq = alloc_workqueue("md_run", WQ_MEM_RECLAIM, 0);
+	if (!md_run_wq)
+		goto err_run_wq;
+
 	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
 		goto err_md;
 
@@ -8479,6 +8490,8 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
+	destroy_workqueue(md_run_wq);
+err_run_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	destroy_workqueue(md_wq);
@@ -8571,6 +8584,7 @@ static __exit void md_exit(void)
 		export_array(mddev);
 		mddev->hold_active = 0;
 	}
+	destroy_workqueue(md_run_wq);
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
 }
Index: linux/drivers/md/md.h
===================================================================
--- linux.orig/drivers/md/md.h	2012-05-24 15:42:56.896251635 +0800
+++ linux/drivers/md/md.h	2012-05-24 15:44:55.622759274 +0800
@@ -616,6 +616,7 @@ extern int md_integrity_register(struct
 extern void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 extern void restore_bitmap_write_access(struct file *file);
+extern int md_schedule_work_on(int cpu, struct work_struct *work);
 
 extern void mddev_init(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);

