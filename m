From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: [PATCH 1/8] block/genhd.c: Add error handling
Date: Fri, 06 Nov 2015 17:52:08 +0530
Message-ID: <1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-reply-to: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
Sender: linux-mmc-owner@vger.kernel.org
To: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, jmoyer@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, davem@davemloft.net, neilb@suse.com, ulf.hansson@linaro.org, tiwai@suse.de, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, viro@zeniv.linux.org.uk, tj@kernel.org, adrian.hunter@intel.com, jonathanh@nvidia.com, grundler@chromium.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org
Cc: cpgs@samsung.com, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com, Vishnu Pratap Singh <vishnu.ps@samsung.com>
List-Id: linux-raid.ids

This patch adds error handling for blk_register_region(), register_disk(),
add_disk(), disk_alloc_events() & disk_add_events().
add_disk() & register_disk() functions  error handling is very much needed
as this is used mainly by many modules like mmc, zram, mtd, scsi etc.
But there is no error handling and it may cause stability issues also.

Verfied on X86 based ubuntu machine.

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 block/genhd.c         | 89 +++++++++++++++++++++++++++++++++++----------------
 include/linux/genhd.h |  4 +--
 2 files changed, 64 insertions(+), 29 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3213b66..a63ebd6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -39,8 +39,8 @@ static struct device_type disk_type;
 
 static void disk_check_events(struct disk_events *ev,
 			      unsigned int *clearing_ptr);
-static void disk_alloc_events(struct gendisk *disk);
-static void disk_add_events(struct gendisk *disk);
+static int disk_alloc_events(struct gendisk *disk);
+static int disk_add_events(struct gendisk *disk);
 static void disk_del_events(struct gendisk *disk);
 static void disk_release_events(struct gendisk *disk);
 
@@ -473,11 +473,11 @@ static char *bdevt_str(dev_t devt, char *buf)
  * range must be nonzero
  * The hash chain is sorted on range, so that subranges can override.
  */
-void blk_register_region(dev_t devt, unsigned long range, struct module *module,
+int blk_register_region(dev_t devt, unsigned long range, struct module *module,
 			 struct kobject *(*probe)(dev_t, int *, void *),
 			 int (*lock)(dev_t, void *), void *data)
 {
-	kobj_map(bdev_map, devt, range, module, probe, lock, data);
+	return kobj_map(bdev_map, devt, range, module, probe, lock, data);
 }
 
 EXPORT_SYMBOL(blk_register_region);
@@ -505,7 +505,7 @@ static int exact_lock(dev_t devt, void *data)
 	return 0;
 }
 
-static void register_disk(struct gendisk *disk)
+static int register_disk(struct gendisk *disk)
 {
 	struct device *ddev = disk_to_dev(disk);
 	struct block_device *bdev;
@@ -520,14 +520,15 @@ static void register_disk(struct gendisk *disk)
 	/* delay uevents, until we scanned partition table */
 	dev_set_uevent_suppress(ddev, 1);
 
-	if (device_add(ddev))
-		return;
+	err = device_add(ddev);
+	if (err)
+		return err;
 	if (!sysfs_deprecated) {
 		err = sysfs_create_link(block_depr, &ddev->kobj,
 					kobject_name(&ddev->kobj));
 		if (err) {
 			device_del(ddev);
-			return;
+			return err;
 		}
 	}
 
@@ -569,6 +570,7 @@ exit:
 	while ((part = disk_part_iter_next(&piter)))
 		kobject_uevent(&part_to_dev(part)->kobj, KOBJ_ADD);
 	disk_part_iter_exit(&piter);
+	return err;
 }
 
 /**
@@ -577,10 +579,8 @@ exit:
  *
  * This function registers the partitioning information in @disk
  * with the kernel.
- *
- * FIXME: error handling
  */
-void add_disk(struct gendisk *disk)
+int add_disk(struct gendisk *disk)
 {
 	struct backing_dev_info *bdi;
 	dev_t devt;
@@ -598,7 +598,7 @@ void add_disk(struct gendisk *disk)
 	retval = blk_alloc_devt(&disk->part0, &devt);
 	if (retval) {
 		WARN_ON(1);
-		return;
+		return retval;
 	}
 	disk_to_dev(disk)->devt = devt;
 
@@ -608,17 +608,27 @@ void add_disk(struct gendisk *disk)
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
 
-	disk_alloc_events(disk);
-
+	retval = disk_alloc_events(disk);
+	if (retval)
+		goto err_blk_devt;
 	/* Register BDI before referencing it from bdev */
 	bdi = &disk->queue->backing_dev_info;
-	bdi_register_dev(bdi, disk_devt(disk));
+	retval = bdi_register_dev(bdi, disk_devt(disk));
+	if (retval)
+		goto err_alloc_event;
 
-	blk_register_region(disk_devt(disk), disk->minors, NULL,
+	retval = blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
-	register_disk(disk);
-	blk_register_queue(disk);
+	if (retval)
+		goto err_alloc_event;
+
+	retval = register_disk(disk);
+	if (retval)
+		goto err_reg_region;
 
+	retval = blk_register_queue(disk);
+	if (retval)
+		goto err_reg_disk;
 	/*
 	 * Take an extra ref on queue which will be put on disk_release()
 	 * so that it sticks around as long as @disk is there.
@@ -627,9 +637,28 @@ void add_disk(struct gendisk *disk)
 
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
-	WARN_ON(retval);
+	if (retval)
+		goto err_blk_reg_queue;
+
+	retval = disk_add_events(disk);
+	if (retval)
+		goto err_sysfs;
 
-	disk_add_events(disk);
+	return 0;
+
+err_blk_devt:
+	blk_free_devt(devt);
+err_alloc_event:
+	disk_del_events(disk);
+err_reg_region:
+	blk_unregister_region(disk_devt(disk), disk->minors);
+err_reg_disk:
+	del_gendisk(disk);
+err_blk_reg_queue:
+	blk_unregister_queue(disk);
+err_sysfs:
+	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
+	return retval;
 }
 EXPORT_SYMBOL(add_disk);
 
@@ -1782,17 +1811,17 @@ module_param_cb(events_dfl_poll_msecs, &disk_events_dfl_poll_msecs_param_ops,
 /*
  * disk_{alloc|add|del|release}_events - initialize and destroy disk_events.
  */
-static void disk_alloc_events(struct gendisk *disk)
+static int disk_alloc_events(struct gendisk *disk)
 {
 	struct disk_events *ev;
 
 	if (!disk->fops->check_events)
-		return;
+		return 0;
 
 	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
 	if (!ev) {
 		pr_warn("%s: failed to initialize events\n", disk->disk_name);
-		return;
+		return -ENOMEM;
 	}
 
 	INIT_LIST_HEAD(&ev->node);
@@ -1804,17 +1833,22 @@ static void disk_alloc_events(struct gendisk *disk)
 	INIT_DELAYED_WORK(&ev->dwork, disk_events_workfn);
 
 	disk->ev = ev;
+	return 0;
 }
 
-static void disk_add_events(struct gendisk *disk)
+static int disk_add_events(struct gendisk *disk)
 {
+	int ret = 0;
+
 	if (!disk->ev)
-		return;
+		return ret;
 
-	/* FIXME: error handling */
-	if (sysfs_create_files(&disk_to_dev(disk)->kobj, disk_events_attrs) < 0)
+	ret = sysfs_create_files(&disk_to_dev(disk)->kobj, disk_events_attrs);
+	if (ret) {
 		pr_warn("%s: failed to create sysfs files for events\n",
 			disk->disk_name);
+		return ret;
+	}
 
 	mutex_lock(&disk_events_mutex);
 	list_add_tail(&disk->ev->node, &disk_events);
@@ -1825,6 +1859,7 @@ static void disk_add_events(struct gendisk *disk)
 	 * unblock kicks it into action.
 	 */
 	__disk_unblock_events(disk, true);
+	return ret;
 }
 
 static void disk_del_events(struct gendisk *disk)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 2adbfa6..dae3160 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -417,7 +417,7 @@ static inline void free_part_info(struct hd_struct *part)
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* block/genhd.c */
-extern void add_disk(struct gendisk *disk);
+extern int add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
@@ -620,7 +620,7 @@ extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
 extern void put_disk(struct gendisk *disk);
-extern void blk_register_region(dev_t devt, unsigned long range,
+extern int blk_register_region(dev_t devt, unsigned long range,
 			struct module *module,
 			struct kobject *(*probe)(dev_t, int *, void *),
 			int (*lock)(dev_t, void *),
-- 
1.9.1

