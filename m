From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - md 12 of 22 - Remove "data" from dev_mapping and tidy up
Date: Wed, 19 Jun 2002 10:52:26 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15631.54730.725595.801613@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




The mapping from minor number to mddev structure allows for a
'data' that is never used.  This patch removes that and explicitly
inlines some inline functions that become trivial.
mddev_map also becomes completely local to md.c



 ----------- Diffstat output ------------
 ./drivers/md/md.c           |   52 ++++++--------------------------------------
 ./include/linux/raid/md.h   |    2 -
 ./include/linux/raid/md_k.h |   18 ---------------
 3 files changed, 8 insertions(+), 64 deletions(-)

--- ./drivers/md/md.c	2002/06/18 04:33:08	1.11
+++ ./drivers/md/md.c	2002/06/18 04:37:53	1.12
@@ -130,43 +130,13 @@
  */
 static LIST_HEAD(all_mddevs);
 
-/*
- * The mapping between kdev and mddev is not necessary a simple
- * one! Eg. HSM uses several sub-devices to implement Logical
- * Volumes. All these sub-devices map to the same mddev.
- */
-dev_mapping_t mddev_map[MAX_MD_DEVS];
+static mddev_t *mddev_map[MAX_MD_DEVS];
 
-void add_mddev_mapping(mddev_t * mddev, kdev_t dev, void *data)
+static inline mddev_t * kdev_to_mddev (kdev_t dev)
 {
-	unsigned int minor = minor(dev);
-
-	if (major(dev) != MD_MAJOR) {
-		MD_BUG();
-		return;
-	}
-	if (mddev_map[minor].mddev) {
-		MD_BUG();
-		return;
-	}
-	mddev_map[minor].mddev = mddev;
-	mddev_map[minor].data = data;
-}
-
-void del_mddev_mapping(mddev_t * mddev, kdev_t dev)
-{
-	unsigned int minor = minor(dev);
-
-	if (major(dev) != MD_MAJOR) {
-		MD_BUG();
-		return;
-	}
-	if (mddev_map[minor].mddev != mddev) {
-		MD_BUG();
-		return;
-	}
-	mddev_map[minor].mddev = NULL;
-	mddev_map[minor].data = NULL;
+	if (major(dev) != MD_MAJOR)
+		BUG();
+        return mddev_map[minor(dev)];
 }
 
 static int md_fail_request (request_queue_t *q, struct bio *bio)
@@ -197,12 +167,7 @@
 	INIT_LIST_HEAD(&mddev->all_mddevs);
 	atomic_set(&mddev->active, 0);
 
-	/*
-	 * The 'base' mddev is the one with data NULL.
-	 * personalities can create additional mddevs
-	 * if necessary.
-	 */
-	add_mddev_mapping(mddev, dev, 0);
+	mddev_map[mdidx(mddev)] = mddev;
 	list_add(&mddev->all_mddevs, &all_mddevs);
 
 	MOD_INC_USE_COUNT;
@@ -667,7 +632,7 @@
 	while (atomic_read(&mddev->recovery_sem.count) != 1)
 		schedule();
 
-	del_mddev_mapping(mddev, mk_kdev(MD_MAJOR, mdidx(mddev)));
+ 	mddev_map[mdidx(mddev)] = NULL;
 	list_del(&mddev->all_mddevs);
 	kfree(mddev);
 	MOD_DEC_USE_COUNT;
@@ -3723,7 +3688,7 @@
 		if (!md_setup_args.device_set[minor])
 			continue;
 
-		if (mddev_map[minor].mddev) {
+		if (mddev_map[minor]) {
 			printk(KERN_WARNING
 			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
 			       minor);
@@ -3882,6 +3847,5 @@
 EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(find_rdev_nr);
 EXPORT_SYMBOL(md_interrupt_thread);
-EXPORT_SYMBOL(mddev_map);
 EXPORT_SYMBOL(get_spare);
 MODULE_LICENSE("GPL");
--- ./include/linux/raid/md_k.h	2002/06/18 04:29:32	1.5
+++ ./include/linux/raid/md_k.h	2002/06/18 04:37:53	1.6
@@ -65,24 +65,6 @@
 #define MAX_MD_DEVS  (1<<MINORBITS)	/* Max number of md dev */
 
 /*
- * Maps a kdev to an mddev/subdev. How 'data' is handled is up to
- * the personality. (eg. HSM uses this to identify individual LVs)
- */
-typedef struct dev_mapping_s {
-	mddev_t *mddev;
-	void *data;
-} dev_mapping_t;
-
-extern dev_mapping_t mddev_map [MAX_MD_DEVS];
-
-static inline mddev_t * kdev_to_mddev (kdev_t dev)
-{
-	if (major(dev) != MD_MAJOR)
-		BUG();
-        return mddev_map[minor(dev)].mddev;
-}
-
-/*
  * options passed in raidrun:
  */
 
--- ./include/linux/raid/md.h	2002/06/18 04:29:32	1.2
+++ ./include/linux/raid/md.h	2002/06/18 04:37:53	1.3
@@ -63,8 +63,6 @@
 extern int md_size[MAX_MD_DEVS];
 extern struct hd_struct md_hd_struct[MAX_MD_DEVS];
 
-extern void add_mddev_mapping (mddev_t *mddev, kdev_t dev, void *data);
-extern void del_mddev_mapping (mddev_t *mddev, kdev_t dev);
 extern char * partition_name (kdev_t dev);
 extern inline char * bdev_partition_name (struct block_device *bdev)
 {
