From: NeilBrown <neilb@suse.de>
Subject: [PATCH 010 of 11] md: make md_print_devices() static
Date: Mon, 1 May 2006 15:31:00 +1000
Message-ID: <1060501053100.23021@suse.de>
References: <20060501152229.18367.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751247AbWEAFb2@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
List-Id: linux-raid.ids


From: Adrian Bunk <bunk@stusta.de>

This patch makes the needlessly global md_print_devices() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c         |    7 +++++--
 ./include/linux/raid/md.h |    4 ----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2006-05-01 15:13:14.000000000 +1000
+++ ./drivers/md/md.c	2006-05-01 15:13:29.000000000 +1000
@@ -72,6 +72,10 @@ static void autostart_arrays (int part);
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
 
+static void md_print_devices(void);
+
+#define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
+
 /*
  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
  * is 1000 KB/sec, so the extra system load does not show up that much.
@@ -1512,7 +1516,7 @@ static void print_rdev(mdk_rdev_t *rdev)
 		printk(KERN_INFO "md: no rdev superblock!\n");
 }
 
-void md_print_devices(void)
+static void md_print_devices(void)
 {
 	struct list_head *tmp, *tmp2;
 	mdk_rdev_t *rdev;
@@ -5310,7 +5314,6 @@ EXPORT_SYMBOL(md_write_end);
 EXPORT_SYMBOL(md_register_thread);
 EXPORT_SYMBOL(md_unregister_thread);
 EXPORT_SYMBOL(md_wakeup_thread);
-EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(md_check_recovery);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md");

diff ./include/linux/raid/md.h~current~ ./include/linux/raid/md.h
--- ./include/linux/raid/md.h~current~	2006-05-01 15:09:20.000000000 +1000
+++ ./include/linux/raid/md.h	2006-05-01 15:13:29.000000000 +1000
@@ -85,8 +85,6 @@ extern void md_done_sync(mddev_t *mddev,
 extern void md_error (mddev_t *mddev, mdk_rdev_t *rdev);
 extern void md_unplug_mddev(mddev_t *mddev);
 
-extern void md_print_devices (void);
-
 extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
 			   sector_t sector, int size, struct page *page);
 extern void md_super_wait(mddev_t *mddev);
@@ -97,7 +95,5 @@ extern void md_new_event(mddev_t *mddev)
 
 extern void md_update_sb(mddev_t * mddev);
 
-#define MD_BUG(x...) { printk("md: bug in file %s, line %d\n", __FILE__, __LINE__); md_print_devices(); }
-
 #endif 
 
