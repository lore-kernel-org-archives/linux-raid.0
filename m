From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 7/7] md: add bcache personality
Date: Fri, 11 May 2012 12:46:47 -0700
Message-ID: <20120511194647.25770.88687.stgit@dwillia2-linux.jf.intel.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Expose bcache as a md personality.  Since bcache already depends on
userpsace assembly, allow it to borrow all the discovery and assembly
mechanisms that have grown up around mdadm.  Userpace requests
raid-level "bcache", or "11" (0xb), when starting an array.  "Backing
device" vs "cache device" is determined by slot number whereby the
backing device slot is the highest number index.

This attempts to be a minimal conversion, but reconciling the gendisk
and kobject relationships with md contributed to the bulk of the thrash.
The removal of the balance of the duplicated functionality comes later.
Also note that functionality like flash-only volume creation and
flash-only resize are temporarily removed until they can be
re-implemented via the upper layer (md or dm).  Another todo item is
detaching devices from cache sets via md hot disk add/remove.

The sysfs topology is easier to navigate now.  The bcache attributes no
longer pop up up under individual block devices.  Instead bcache
membership of an individual block device can be determined the same as
raid membership, i.e. by following:

  /sys/block/<blockdev>/holders/<mddev>

From there the layout is:

  /sys/block/<mddev>/md/bcache : cache set attributes
  /sys/block/<mddev>/md/rd[0..N-1]/bcache : cache device device attributes
  /sys/block/<mddev>/md/rdN/bcache : backing device attributes

Global listing of all bcache volumes available via /proc/mdstat or
/sys/block/*/md/bcache (rather than /sys/fs/bcache).

Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/md/Kconfig          |   12 +
 drivers/md/bcache/Kconfig   |    2 
 drivers/md/bcache/Makefile  |    2 
 drivers/md/bcache/bcache.h  |   39 ++++
 drivers/md/bcache/md.c      |  374 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/bcache/request.c |   24 +--
 drivers/md/bcache/super.c   |  359 +++++++++--------------------------------
 drivers/md/bcache/sysfs.c   |   49 ------
 8 files changed, 511 insertions(+), 350 deletions(-)
 create mode 100644 drivers/md/bcache/md.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 110c1b7..e1ad581 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -185,6 +185,18 @@ config MD_FAULTY
 
 	  In unsure, say N.
 
+config MD_BCACHE
+	tristate "Caching mode for MD"
+	depends on BLK_DEV_MD
+	select BCACHE
+	help
+	  The "md_bcache" module allows for an md device that
+	  establishes a cache hierarchy of high iops and/or bandwidth
+	  block device(s) to a slower block device.  Assembly of arrays
+	  of this personality require userspace assistance, i.e. arrays
+	  with this format are treated as "external" metadata, see
+	  MDADM(8)
+
 source "drivers/md/bcache/Kconfig"
 
 config BLK_DEV_DM
diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 9acd870..c4f404c 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -1,6 +1,6 @@
 
 config BCACHE
-	tristate "Block device as cache"
+	tristate
 	select CLOSURES
 	---help---
 	Allows a block device to be used as cache for other devices; uses
diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index 84302f9..5a0c445 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -1,8 +1,10 @@
 
 ccflags-y		+= -std=gnu99
 obj-$(CONFIG_BCACHE)	+= bcache.o
+obj-$(CONFIG_MD_BCACHE) += md_bcache.o
 
 bcache-y		:= alloc.o btree.o bset.o io.o journal.o\
 	writeback.o request.o super.o debug.o util.o trace.o stats.o
+md_bcache-y		:= md.o
 
 CFLAGS_request.o	+= -Iblock
diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aad9c48..1bdae7b 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1,5 +1,7 @@
 
+#ifndef pr_fmt
 #define pr_fmt(fmt) "bcache: %s() " fmt "\n", __func__
+#endif
 
 #include <linux/bio.h>
 #include <linux/blktrace_api.h>
@@ -297,6 +299,7 @@ struct cached_dev {
 	unsigned		writeback_rate_d_term;
 	unsigned		writeback_rate_p_term_inverse;
 	unsigned		writeback_rate_d_smooth;
+	void			(*release)(struct cached_dev *);
 };
 
 struct cache {
@@ -375,6 +378,7 @@ struct cache {
 	atomic_long_t		meta_sectors_written;
 	atomic_long_t		btree_sectors_written;
 	atomic_long_t		sectors_written;
+	void			(*release)(struct cache *);
 };
 
 struct gc_stat {
@@ -387,6 +391,26 @@ struct gc_stat {
 	unsigned		in_use; /* percent */
 };
 
+struct uuid_entry {
+	union {
+		struct {
+			uint8_t		uuid[16];
+			uint8_t		label[32];
+			uint32_t	first_reg;
+			uint32_t	last_reg;
+			uint32_t	invalidated;
+
+			uint32_t	flags;
+			/* Size of flash only volumes */
+			uint64_t	sectors;
+		};
+
+		uint8_t	pad[128];
+	};
+};
+
+BITMASK(UUID_FLASH_ONLY,	struct uuid_entry, flags, 0, 1);
+
 struct cache_set {
 	struct closure		cl;
 
@@ -837,3 +861,18 @@ void bcache_request_exit(void);
 int bcache_request_init(void);
 void bcache_btree_exit(void);
 int bcache_btree_init(void);
+
+int bcache_flash_dev_run(struct cache_set *, struct uuid_entry *, struct bcache_device *);
+const char *bcache_register_cache(struct cache_sb *, struct page *, struct block_device *,
+				  struct kobject *, struct cache *, struct kobject *);
+const char *bcache_register_bdev(struct cache_sb *, struct page *, struct block_device *,
+				 struct kobject *, struct cached_dev *);
+const char *bcache_read_super(struct cache_sb *, struct block_device *, struct page **);
+void bcache_cached_dev_make_request(struct bcache_device *d, struct bio *bio);
+void bcache_flash_dev_make_request(struct bcache_device *d, struct bio *bio);
+int bcache_cached_dev_attach(struct cached_dev *d, struct cache_set *c);
+int bcache_cached_dev_congested(void *data, int bits);
+int bcache_flash_dev_congested(void *data, int bits);
+void bcache_cached_dev_run(struct cached_dev *);
+void bcache_device_stop(struct bcache_device *);
+void bcache_cache_set_stop(struct cache_set *);
diff --git a/drivers/md/bcache/md.c b/drivers/md/bcache/md.c
new file mode 100644
index 0000000..58e2e04
--- /dev/null
+++ b/drivers/md/bcache/md.c
@@ -0,0 +1,374 @@
+/*
+ * md/bcache
+ * Copyright(c) 2012 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ */
+#define pr_fmt(fmt) "md/bcache: " fmt
+
+#include <linux/blkdev.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include "bcache.h"
+#include "../md.h"
+
+struct md_backing_dev {
+	struct md_rdev *rdev;
+	struct cached_dev d;
+};
+
+struct md_cache_dev {
+	struct list_head node;
+	struct md_rdev *rdev;
+	struct cache c;
+};
+
+struct md_bcache_conf {
+	void (*make_request)(struct bcache_device *d, struct bio *bio);
+	struct bcache_device *bcache;
+	struct mddev *mddev;
+	spinlock_t lock;
+	struct list_head cache_devs;
+	struct bcache_device *fdev; /* "flash-only" mode */
+	struct md_backing_dev *bdev;
+	wait_queue_head_t wait;
+};
+
+static void md_bcache_free_conf(struct md_bcache_conf *conf)
+{
+	if (!conf)
+		return;
+
+	if (conf->fdev)
+		bcache_cache_set_stop(conf->fdev->c);
+	else {
+		struct cache_set *c = conf->bdev ? conf->bdev->d.disk.c : NULL;
+
+		if (c)
+			bcache_cache_set_stop(c);
+		else if (conf->bdev)
+			bcache_device_stop(&conf->bdev->d.disk);
+	}
+
+	wait_event_timeout(conf->wait,
+			   !conf->bdev && list_empty(&conf->cache_devs),
+			   5 * HZ);
+
+	conf->mddev->private = NULL;
+	conf->bcache = NULL;
+	kfree(conf->fdev);
+	conf->fdev = NULL;
+	kfree(conf);
+}
+
+struct md_rdev *rdev_from_flash(struct md_bcache_conf *conf)
+{
+	struct md_cache_dev *md_cdev;
+
+	md_cdev = list_entry(conf->cache_devs.next, typeof(*md_cdev), node);
+	return conf->fdev ? md_cdev->rdev : NULL;
+}
+
+static sector_t md_bcache_size(struct mddev *mddev, sector_t sectors, int raid_disks)
+{
+	struct md_bcache_conf *conf = mddev->private;
+	struct md_rdev *rdev;
+
+	if (conf->fdev)
+		rdev = rdev_from_flash(conf);
+	else
+		rdev = conf->bdev->rdev;
+
+	WARN_ONCE(sectors || raid_disks,
+		  "%s does not support generic reshape\n", __func__);
+
+	if (!rdev)
+		return 0;
+	return rdev->sectors;
+}
+
+static void md_cached_dev_release(struct cached_dev *d)
+{
+	struct md_backing_dev *bdev = container_of(d, typeof(*bdev), d);
+	struct mddev *mddev = bdev->rdev->mddev;
+	struct md_bcache_conf *conf = mddev->private;
+
+	kfree(bdev);
+	conf->bdev = NULL;
+	wake_up(&conf->wait);
+}
+
+static void md_cache_release(struct cache *c)
+{
+	struct md_cache_dev *cdev = container_of(c, typeof(*cdev), c);
+	struct mddev *mddev = cdev->rdev->mddev;
+	struct md_bcache_conf *conf = mddev->private;
+
+	spin_lock(&conf->lock);
+	list_del(&cdev->node);
+	spin_unlock(&conf->lock);
+
+	kfree(cdev);
+	wake_up(&conf->wait);
+}
+
+static int md_bcache_register_disk(struct md_bcache_conf *conf, struct md_rdev *rdev,
+				   struct cache_set **cs)
+{
+	struct cache_sb *sb = kmalloc(sizeof(*sb), GFP_KERNEL);
+	struct block_device *bdev = rdev->bdev;
+	struct mddev *mddev = conf->mddev;
+	struct page *sb_page;
+	int rc = -ENOMEM;
+	const char *err;
+
+	if (!sb)
+		return rc;
+
+	err = bcache_read_super(sb, bdev, &sb_page);
+	if (err) {
+		pr_err("failed to read bcache superblock: \'%s\'\n", err);
+		goto out;
+	}
+
+	if (sb->version == CACHE_BACKING_DEV) {
+		struct md_backing_dev *md_bdev = kzalloc(sizeof(*md_bdev), GFP_KERNEL);
+
+		md_bdev->rdev = rdev;
+		conf->bdev = md_bdev;
+		md_bdev->d.disk.disk = mddev->gendisk;
+		md_bdev->d.release = md_cached_dev_release;
+
+		err = bcache_register_bdev(sb, sb_page, bdev, &rdev->kobj,
+					   &md_bdev->d);
+		if (err)
+			md_cached_dev_release(&md_bdev->d);
+	} else {
+		struct md_cache_dev *md_cdev = kzalloc(sizeof(*md_cdev), GFP_KERNEL);
+
+		md_cdev->rdev = rdev;
+		spin_lock(&conf->lock);
+		list_add(&md_cdev->node, &conf->cache_devs);
+		spin_unlock(&conf->lock);
+		md_cdev->c.release = md_cache_release;
+
+		err = bcache_register_cache(sb, sb_page, bdev, &rdev->kobj,
+					    &md_cdev->c, &mddev->kobj);
+
+		if (err)
+			md_cache_release(&md_cdev->c);
+		else if (*cs && md_cdev->c.set != *cs) {
+			err = "tried to register more than one cache set";
+			md_cache_release(&md_cdev->c);
+		} else
+			*cs = md_cdev->c.set;
+	}
+
+	if (err) {
+		char buf[BDEVNAME_SIZE];
+
+		/* bcache_register_(bdev|cache) will only return
+		 * an error if they didn't get far enough to
+		 * create the kobject - if they did, the kobject
+		 * destructor will do this cleanup.
+		 */
+		pr_err("%s device %s registration error: '%s'\n",
+		       mddev->gendisk->disk_name, bdevname(bdev, buf), err);
+		put_page(sb_page);
+	} else {
+		disk_stack_limits(mddev->gendisk, bdev, rdev->data_offset << 9);
+		rc = 0;
+	}
+ out:
+	kfree(sb);
+	return rc;
+}
+
+static struct uuid_entry *flash_uuid(struct cache_set *c)
+{
+	struct uuid_entry *u, *r = NULL;
+
+	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
+		if (UUID_FLASH_ONLY(u)) {
+			if (r) {
+				pr_debug("cache set with multiple flash only devices?\n");
+				r = NULL;
+				break;
+			} else {
+				r = u;
+			}
+		}
+
+	return r;
+}
+
+static bool is_flash_only(struct md_bcache_conf *conf, struct cache_set *c)
+{
+	bool f;
+
+	spin_lock(&conf->lock);
+	f = !conf->bdev && !list_empty(&conf->cache_devs) &&
+	    list_is_last(conf->cache_devs.next, &conf->cache_devs);
+	spin_unlock(&conf->lock);
+
+	return f && c && flash_uuid(c);
+}
+
+static struct md_bcache_conf *md_bcache_alloc_conf(struct mddev *mddev)
+{
+	struct md_bcache_conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	struct backing_dev_info	*bdi = &mddev->queue->backing_dev_info;
+	struct cache_set *cs = NULL;
+	struct md_rdev *rdev;
+	int rc = -ENOMEM;
+
+	if (!conf)
+		goto abort;
+
+	conf->mddev = mddev;
+	mddev->private = conf;
+	spin_lock_init(&conf->lock);
+	init_waitqueue_head(&conf->wait);
+	INIT_LIST_HEAD(&conf->cache_devs);
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		rc = md_bcache_register_disk(conf, rdev, &cs);
+		if (rc != 0)
+			goto abort;
+	}
+
+	if (is_flash_only(conf, cs)) {
+		conf->fdev = kzalloc(sizeof(struct bcache_device), GFP_KERNEL);
+		if (!conf->fdev) {
+			rc = -ENOMEM;
+			goto abort;
+		}
+
+		conf->bcache = conf->fdev;
+		conf->fdev->disk = mddev->gendisk;
+		conf->make_request = bcache_flash_dev_make_request;
+
+		bdi->congested_fn = bcache_flash_dev_congested;
+		bdi->congested_data = conf->bcache;
+
+		rc = bcache_flash_dev_run(cs, flash_uuid(cs), conf->fdev);
+	} else if (conf->bdev) {
+		struct cached_dev *d = &conf->bdev->d;
+
+		conf->bcache = &d->disk;
+		conf->make_request = bcache_cached_dev_make_request;
+
+		bdi->congested_fn = bcache_cached_dev_congested;
+		bdi->congested_data = conf->bcache;
+
+		if (cs)
+			rc = bcache_cached_dev_attach(d, cs);
+		else if (BDEV_STATE(&d->sb) == BDEV_STATE_NONE ||
+			 BDEV_STATE(&d->sb) == BDEV_STATE_STALE) {
+			bcache_cached_dev_run(d);
+			rc = 0;
+		} else
+			rc = -ENODEV;
+	} else
+		rc = -ENODEV;
+
+	if (rc == 0)
+		return conf;
+ abort:
+	md_bcache_free_conf(conf);
+	return ERR_PTR(rc);
+}
+
+static int md_bcache_run(struct mddev *mddev)
+{
+	struct md_bcache_conf *conf;
+
+	if (md_check_no_bitmap(mddev))
+		return -EINVAL;
+
+	conf = md_bcache_alloc_conf(mddev);
+	if (IS_ERR(conf))
+		return PTR_ERR(conf);
+
+	/* calculate array device size */
+	md_set_array_sectors(mddev, md_bcache_size(mddev, 0, 0));
+
+	pr_info("%s: size is %llu sectors.\n", mdname(mddev),
+		(unsigned long long)mddev->array_sectors);
+
+	return md_integrity_register(mddev);
+}
+
+static int md_bcache_stop(struct mddev *mddev)
+{
+	struct md_bcache_conf *conf = mddev->private;
+
+	blk_sync_queue(mddev->queue);
+	md_bcache_free_conf(conf);
+
+	return 0;
+}
+
+static void md_bcache_make_request(struct mddev *mddev, struct bio *bio)
+{
+	struct md_bcache_conf *conf = mddev->private;
+
+	conf->make_request(conf->bcache, bio);
+}
+
+static void md_bcache_status(struct seq_file *seq, struct mddev *mddev)
+{
+	struct md_bcache_conf *conf = mddev->private;
+	struct md_rdev *rdev;
+
+	if (conf->fdev)
+		rdev = rdev_from_flash(conf);
+	else
+		rdev = conf->bdev->rdev;
+
+	seq_printf(seq, " %lluk cache-blocks",
+		   (unsigned long long) rdev->sectors / 2);
+}
+
+static struct md_personality md_bcache_personality = {
+	.name		= "bcache",
+	.level		= 0xb,
+	.owner		= THIS_MODULE,
+	.make_request	= md_bcache_make_request,
+	.run		= md_bcache_run,
+	.stop		= md_bcache_stop,
+	.status		= md_bcache_status,
+	.size		= md_bcache_size,
+};
+
+static int __init md_bcache_init(void)
+{
+	return register_md_personality(&md_bcache_personality);
+}
+
+static void md_bcache_exit(void)
+{
+	unregister_md_personality(&md_bcache_personality);
+}
+
+module_init(md_bcache_init);
+module_exit(md_bcache_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("block device caching personality for md");
+MODULE_ALIAS("md-bcache");
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 691fe8d..2d0d7ee 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1228,11 +1228,10 @@ skip:
 	s->skip = true;
 }
 
-static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
+void bcache_cached_dev_make_request(struct bcache_device *d, struct bio *bio)
 {
-	struct search *s;
-	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+	struct search *s;
 
 	bio->bi_bdev = dc->bdev;
 	bio->bi_sector += 16;
@@ -1247,6 +1246,7 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
 	} else
 		bio_passthrough(dc, bio);
 }
+EXPORT_SYMBOL_GPL(bcache_cached_dev_make_request);
 
 static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
 			    unsigned int cmd, unsigned long arg)
@@ -1255,7 +1255,7 @@ static int cached_dev_ioctl(struct bcache_device *d, fmode_t mode,
 	return __blkdev_driver_ioctl(dc->bdev, mode, cmd, arg);
 }
 
-static int cached_dev_congested(void *data, int bits)
+int bcache_cached_dev_congested(void *data, int bits)
 {
 	struct bcache_device *d = data;
 	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
@@ -1278,13 +1278,10 @@ static int cached_dev_congested(void *data, int bits)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(bcache_cached_dev_congested);
 
 void cached_dev_request_init(struct cached_dev *d)
 {
-	struct gendisk *g = d->disk.disk;
-
-	g->queue->make_request_fn		= cached_dev_make_request;
-	g->queue->backing_dev_info.congested_fn = cached_dev_congested;
 	d->disk.cache_miss			= cached_dev_cache_miss;
 	d->disk.ioctl				= cached_dev_ioctl;
 }
@@ -1398,10 +1395,9 @@ static void flash_dev_req_nodata(struct search *s)
 	continue_at(&s->cl, flash_dev_bio_complete, NULL);
 }
 
-static void flash_dev_make_request(struct request_queue *q, struct bio *bio)
+void bcache_flash_dev_make_request(struct bcache_device *d, struct bio *bio)
 {
 	struct search *s;
-	struct bcache_device *d = bio->bi_bdev->bd_disk->private_data;
 
 	s = do_bio_hook(bio, d);
 	trace_bcache_request_start(&s->op, bio);
@@ -1410,6 +1406,7 @@ static void flash_dev_make_request(struct request_queue *q, struct bio *bio)
 	 bio->bi_rw & REQ_WRITE ? flash_dev_write :
 				  flash_dev_read)(s);
 }
+EXPORT_SYMBOL_GPL(bcache_flash_dev_make_request);
 
 static int flash_dev_ioctl(struct bcache_device *d, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
@@ -1417,7 +1414,7 @@ static int flash_dev_ioctl(struct bcache_device *d, fmode_t mode,
 	return -ENOTTY;
 }
 
-static int flash_dev_congested(void *data, int bits)
+int bcache_flash_dev_congested(void *data, int bits)
 {
 	struct bcache_device *d = data;
 	struct request_queue *q;
@@ -1431,13 +1428,10 @@ static int flash_dev_congested(void *data, int bits)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(bcache_flash_dev_congested);
 
 void flash_dev_request_init(struct bcache_device *d)
 {
-	struct gendisk *g = d->disk;
-
-	g->queue->make_request_fn		= flash_dev_make_request;
-	g->queue->backing_dev_info.congested_fn = flash_dev_congested;
 	d->cache_miss				= flash_dev_cache_miss;
 	d->ioctl				= flash_dev_ioctl;
 }
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c1fe44d..c1e0e98 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -53,26 +53,6 @@ struct uuid_entry_v0 {
 	uint32_t	pad;
 };
 
-struct uuid_entry {
-	union {
-		struct {
-			uint8_t		uuid[16];
-			uint8_t		label[32];
-			uint32_t	first_reg;
-			uint32_t	last_reg;
-			uint32_t	invalidated;
-
-			uint32_t	flags;
-			/* Size of flash only volumes */
-			uint64_t	sectors;
-		};
-
-		uint8_t	pad[128];
-	};
-};
-
-BITMASK(UUID_FLASH_ONLY,	struct uuid_entry, flags, 0, 1);
-
 /* We keep absolute totals of various statistics, and addionally a set of three
  * rolling averages.
  *
@@ -102,29 +82,22 @@ static const unsigned accounting_weight		= 32;
 static const char * const accounting_types[]	= {
 	"total", "five_minute", "hour", "day" };
 
-static struct kobject *bcache_kobj;
 static struct mutex register_lock;
 static LIST_HEAD(uncached_devices);
 static LIST_HEAD(cache_sets);
-static int bcache_major, bcache_minor;
 static wait_queue_head_t unregister_wait;
 
 struct workqueue_struct *bcache_wq;
 
 static int uuid_write(struct cache_set *);
-static void bcache_device_stop(struct bcache_device *);
 
 static void __cached_dev_free(struct kobject *);
-static void cached_dev_run(struct cached_dev *);
-static int cached_dev_attach(struct cached_dev *, struct cache_set *);
 static void cached_dev_detach(struct cached_dev *);
 
 static void __flash_dev_free(struct kobject *);
-static int flash_dev_create(struct cache_set *c, uint64_t size);
 
 static void __cache_set_free(struct kobject *);
 static void cache_set_unregister(struct cache_set *);
-static void cache_set_stop(struct cache_set *);
 static void bcache_write_super(struct cache_set *);
 
 static void cache_free(struct kobject *);
@@ -135,7 +108,7 @@ static void cache_free(struct kobject *);
 
 /* Superblock */
 
-static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
+const char *bcache_read_super(struct cache_sb *sb, struct block_device *bdev,
 			      struct page **res)
 {
 	const char *err;
@@ -250,6 +223,7 @@ err:
 	put_bh(bh);
 	return err;
 }
+EXPORT_SYMBOL_GPL(bcache_read_super);
 
 static void write_bdev_super_endio(struct bio *bio, int error)
 {
@@ -695,42 +669,12 @@ static int prio_read(struct cache *c, uint64_t bucket)
 
 /* Bcache device */
 
-static int open_dev(struct block_device *b, fmode_t mode)
-{
-	struct bcache_device *d = b->bd_disk->private_data;
-	if (atomic_read(&d->closing))
-		return -ENXIO;
-
-	closure_get(&d->cl);
-	return 0;
-}
-
-static int release_dev(struct gendisk *b, fmode_t mode)
-{
-	struct bcache_device *d = b->private_data;
-	closure_put(&d->cl);
-	return 0;
-}
-
-static int ioctl_dev(struct block_device *b, fmode_t mode,
-		     unsigned int cmd, unsigned long arg)
-{
-	struct bcache_device *d = b->bd_disk->private_data;
-	return d->ioctl(d, mode, cmd, arg);
-}
-
-static const struct block_device_operations bcache_ops = {
-	.open		= open_dev,
-	.release	= release_dev,
-	.ioctl		= ioctl_dev,
-	.owner		= THIS_MODULE,
-};
-
-static void bcache_device_stop(struct bcache_device *d)
+void bcache_device_stop(struct bcache_device *d)
 {
 	if (!atomic_xchg(&d->closing, 1))
 		closure_queue(&d->cl);
 }
+EXPORT_SYMBOL_GPL(bcache_device_stop);
 
 static void bcache_device_detach(struct bcache_device *d)
 {
@@ -784,13 +728,6 @@ static void bcache_device_free(struct bcache_device *d)
 	if (d->c)
 		bcache_device_detach(d);
 
-	if (d->disk)
-		del_gendisk(d->disk);
-	if (d->disk && d->disk->queue)
-		blk_cleanup_queue(d->disk->queue);
-	if (d->disk)
-		put_disk(d->disk);
-
 	if (d->unaligned_bvec)
 		mempool_destroy(d->unaligned_bvec);
 	if (d->bio_split)
@@ -801,43 +738,10 @@ static void bcache_device_free(struct bcache_device *d)
 
 static int bcache_device_init(struct bcache_device *d, unsigned block_size)
 {
-	struct request_queue *q;
-
 	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
 	    !(d->unaligned_bvec = mempool_create_kmalloc_pool(1,
 				sizeof(struct bio_vec) * BIO_MAX_PAGES)))
 		return -ENOMEM;
-
-	d->disk = alloc_disk(1);
-	if (!d->disk)
-		return -ENOMEM;
-
-	snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", bcache_minor);
-
-	d->disk->major		= bcache_major;
-	d->disk->first_minor	= bcache_minor++;
-	d->disk->fops		= &bcache_ops;
-	d->disk->private_data	= d;
-
-	q = blk_alloc_queue(GFP_KERNEL);
-	if (!q)
-		return -ENOMEM;
-
-	blk_queue_make_request(q, NULL);
-	d->disk->queue			= q;
-	q->queuedata			= d;
-	q->backing_dev_info.congested_data = d;
-	q->limits.max_hw_sectors	= UINT_MAX;
-	q->limits.max_sectors		= UINT_MAX;
-	q->limits.max_segment_size	= UINT_MAX;
-	q->limits.max_segments		= BIO_MAX_PAGES;
-	q->limits.max_discard_sectors	= UINT_MAX;
-	q->limits.io_min		= block_size;
-	q->limits.logical_block_size	= block_size;
-	q->limits.physical_block_size	= block_size;
-	set_bit(QUEUE_FLAG_NONROT,	&d->disk->queue->queue_flags);
-	set_bit(QUEUE_FLAG_DISCARD,	&d->disk->queue->queue_flags);
-
 	return 0;
 }
 
@@ -854,7 +758,7 @@ static void calc_cached_dev_sectors(struct cache_set *c)
 	c->cached_dev_sectors = sectors;
 }
 
-static void cached_dev_run(struct cached_dev *dc)
+void bcache_cached_dev_run(struct cached_dev *dc)
 {
 	struct bcache_device *d = &dc->disk;
 
@@ -871,7 +775,6 @@ static void cached_dev_run(struct cached_dev *dc)
 		closure_sync(&cl);
 	}
 
-	add_disk(d->disk);
 #if 0
 	char *env[] = { "SYMLINK=label" , NULL };
 	kobject_uevent_env(&disk_to_dev(d->disk)->kobj, KOBJ_CHANGE, env);
@@ -880,6 +783,7 @@ static void cached_dev_run(struct cached_dev *dc)
 	    sysfs_create_link(&disk_to_dev(d->disk)->kobj, &d->kobj, "bcache"))
 		pr_debug("error creating sysfs link");
 }
+EXPORT_SYMBOL_GPL(bcache_cached_dev_run);
 
 static void cached_dev_detach_finish(struct work_struct *w)
 {
@@ -919,7 +823,7 @@ static void cached_dev_detach(struct cached_dev *d)
 	cached_dev_put(d);
 }
 
-static int cached_dev_attach(struct cached_dev *d, struct cache_set *c)
+static int __cached_dev_attach(struct cached_dev *d, struct cache_set *c)
 {
 	uint32_t rtime = cpu_to_le32(get_seconds());
 	struct uuid_entry *u;
@@ -1000,7 +904,7 @@ static int cached_dev_attach(struct cached_dev *d, struct cache_set *c)
 		bcache_writeback_queue(d);
 	}
 
-	cached_dev_run(d);
+	bcache_cached_dev_run(d);
 
 	printk(KERN_INFO "bcache: Caching %s as %s on set %pU\n",
 	       bdevname(d->bdev, buf), d->disk.disk->disk_name,
@@ -1008,11 +912,23 @@ static int cached_dev_attach(struct cached_dev *d, struct cache_set *c)
 	return 0;
 }
 
+int bcache_cached_dev_attach(struct cached_dev *d, struct cache_set *c)
+{
+	int err;
+
+	mutex_lock(&register_lock);
+	err =__cached_dev_attach(d, c);
+	mutex_unlock(&register_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(bcache_cached_dev_attach);
+
 static void __cached_dev_free(struct kobject *kobj)
 {
 	struct cached_dev *d = container_of(kobj, struct cached_dev, disk.kobj);
-	kfree(d);
-	module_put(THIS_MODULE);
+
+	d->release(d);
 }
 
 static void cached_dev_free(struct closure *cl)
@@ -1034,11 +950,6 @@ static void cached_dev_free(struct closure *cl)
 	if (d->bio_passthrough)
 		mempool_destroy(d->bio_passthrough);
 
-	if (!IS_ERR_OR_NULL(d->bdev)) {
-		blk_sync_queue(bdev_get_queue(d->bdev));
-		blkdev_put(d->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-	}
-
 	wake_up(&unregister_wait);
 
 	kobject_put(&d->disk.kobj);
@@ -1064,7 +975,6 @@ static int cached_dev_init(struct cached_dev *d, unsigned block_size)
 	closure_init(&d->disk.cl, NULL);
 	set_closure_fn(&d->disk.cl, cached_dev_flush, system_wq);
 
-	__module_get(THIS_MODULE);
 	INIT_LIST_HEAD(&d->list);
 	cached_dev_kobject_init(d);
 	init_cache_accounting(&d->accounting, &d->disk.cl);
@@ -1104,13 +1014,12 @@ err:
 
 /* Cached device - bcache superblock */
 
-static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
-				 struct block_device *bdev, struct cached_dev *d)
+static const char *__register_bdev(struct cache_sb *sb, struct page *sb_page,
+				   struct block_device *bdev, struct kobject *parent,
+				   struct cached_dev *d)
 {
 	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
-	struct gendisk *g;
-	struct cache_set *c;
 
 	if (!d || cached_dev_init(d, sb->block_size << 9) != 0)
 		return err;
@@ -1118,29 +1027,15 @@ static const char *register_bdev(struct cache_sb *sb, struct page *sb_page,
 	memcpy(&d->sb, sb, sizeof(struct cache_sb));
 	d->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	d->bdev = bdev;
-	d->bdev->bd_holder = d;
-
-	g = d->disk.disk;
-
-	set_capacity(g, d->bdev->bd_part->nr_sects - 16);
 
 	cached_dev_request_init(d);
 
 	err = "error creating kobject";
-	if (kobject_add(&d->disk.kobj, &part_to_dev(bdev->bd_part)->kobj,
-			"bcache"))
+	if (kobject_add(&d->disk.kobj, parent, "bcache"))
 		goto err;
 	if (add_cache_accounting_kobjs(&d->accounting, &d->disk.kobj))
 		goto err;
 
-	list_add(&d->list, &uncached_devices);
-	list_for_each_entry(c, &cache_sets, list)
-		cached_dev_attach(d, c);
-
-	if (BDEV_STATE(&d->sb) == BDEV_STATE_NONE ||
-	    BDEV_STATE(&d->sb) == BDEV_STATE_STALE)
-		cached_dev_run(d);
-
 	return NULL;
 err:
 	kobject_put(&d->disk.kobj);
@@ -1153,6 +1048,20 @@ err:
 	return NULL;
 }
 
+const char *bcache_register_bdev(struct cache_sb *sb, struct page *sb_page,
+				 struct block_device *bdev, struct kobject *parent,
+				 struct cached_dev *d)
+{
+	const char *err;
+
+	mutex_lock(&register_lock);
+	err = __register_bdev(sb, sb_page, bdev, parent, d);
+	mutex_unlock(&register_lock);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(bcache_register_bdev);
+
 /* Flash only volumes */
 
 static void __flash_dev_free(struct kobject *kobj)
@@ -1179,27 +1088,22 @@ static void flash_dev_flush(struct closure *cl)
 	continue_at(cl, flash_dev_free, system_wq);
 }
 
-static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
+static int __flash_dev_run(struct cache_set *c, struct uuid_entry *u, struct bcache_device *d)
 {
-	struct bcache_device *d = kzalloc(sizeof(struct bcache_device),
-					  GFP_KERNEL);
-	if (!d)
-		return -ENOMEM;
-
 	closure_init(&d->cl, NULL);
 	set_closure_fn(&d->cl, flash_dev_flush, system_wq);
 
+	/* uplevel this init to the caller */
 	flash_dev_kobject_init(d);
 
 	if (bcache_device_init(d, block_bytes(c)))
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-	set_capacity(d->disk, u->sectors);
 	flash_dev_request_init(d);
-	add_disk(d->disk);
 
-	if (kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache"))
+	/* messy requires caller to pre-init ->parent */
+	if (kobject_add(&d->kobj, d->kobj.parent, "bcache"))
 		goto err;
 
 	bcache_device_link(d, c, "volume");
@@ -1210,43 +1114,17 @@ err:
 	return -ENOMEM;
 }
 
-static int flash_devs_run(struct cache_set *c)
-{
-	int ret = 0;
-
-	for (struct uuid_entry *u = c->uuids;
-	     u < c->uuids + c->nr_uuids && !ret;
-	     u++)
-		if (UUID_FLASH_ONLY(u))
-			ret = flash_dev_run(c, u);
-
-	return ret;
-}
-
-static int flash_dev_create(struct cache_set *c, uint64_t size)
+int bcache_flash_dev_run(struct cache_set *c, struct uuid_entry *u, struct bcache_device *d)
 {
-	struct uuid_entry *u;
-
-	if (atomic_read(&c->closing))
-		return -EINTR;
-
-	u = uuid_find_empty(c);
-	if (!u) {
-		err_printk("Can't create volume, no room for UUID\n");
-		return -EINVAL;
-	}
-
-	get_random_bytes(u->uuid, 16);
-	memset(u->label, 0, 32);
-	u->first_reg = u->last_reg = cpu_to_le32(get_seconds());
-
-	SET_UUID_FLASH_ONLY(u, 1);
-	u->sectors = size >> 9;
+	int err;
 
-	uuid_write(c);
+	mutex_lock(&register_lock);
+	err = __flash_dev_run(c, u, d);
+	mutex_unlock(&register_lock);
 
-	return flash_dev_run(c, u);
+	return err;
 }
+EXPORT_SYMBOL_GPL(bcache_flash_dev_run);
 
 /* Cache set */
 
@@ -1277,7 +1155,6 @@ static void __cache_set_free(struct kobject *kobj)
 {
 	struct cache_set *c = container_of(kobj, struct cache_set, kobj);
 	kfree(c);
-	module_put(THIS_MODULE);
 }
 
 static void cache_set_free(struct closure *cl)
@@ -1358,16 +1235,17 @@ static void __cache_set_unregister(struct closure *cl)
 	continue_at(cl, cache_set_flush, system_wq);
 }
 
-static void cache_set_stop(struct cache_set *c)
+void bcache_cache_set_stop(struct cache_set *c)
 {
 	if (!atomic_xchg(&c->closing, 1))
 		closure_queue(&c->caching);
 }
+EXPORT_SYMBOL_GPL(bcache_cache_set_stop);
 
 static void cache_set_unregister(struct cache_set *c)
 {
 	atomic_set(&c->unregistering, 1);
-	cache_set_stop(c);
+	bcache_cache_set_stop(c);
 }
 
 #define alloc_bucket_pages(gfp, c)			\
@@ -1380,7 +1258,6 @@ struct cache_set *cache_set_alloc(struct cache_sb *sb)
 	if (!c)
 		return NULL;
 
-	__module_get(THIS_MODULE);
 	closure_init(&c->cl, NULL);
 	set_closure_fn(&c->cl, cache_set_free, system_wq);
 
@@ -1458,7 +1335,6 @@ err:
 static void run_cache_set(struct cache_set *c)
 {
 	const char *err = "cannot allocate memory";
-	struct cached_dev *d, *t;
 	struct cache *ca;
 
 	struct btree_op op;
@@ -1601,11 +1477,6 @@ static void run_cache_set(struct cache_set *c)
 	c->sb.last_mount = get_seconds();
 	bcache_write_super(c);
 
-	list_for_each_entry_safe(d, t, &uncached_devices, list)
-		cached_dev_attach(d, c);
-
-	flash_devs_run(c);
-
 	return;
 err_unlock_gc:
 	closure_set_stopped(&c->gc.cl);
@@ -1623,7 +1494,7 @@ static bool can_attach_cache(struct cache *ca, struct cache_set *c)
 		ca->sb.nr_in_set	== c->sb.nr_in_set;
 }
 
-static const char *register_cache_set(struct cache *ca)
+static const char *register_cache_set(struct cache *ca, struct kobject *parent)
 {
 	char buf[12];
 	const char *err = "cannot allocate memory";
@@ -1648,7 +1519,7 @@ static const char *register_cache_set(struct cache *ca)
 		return err;
 
 	err = "error creating kobject";
-	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->sb.set_uuid) ||
+	if (kobject_add(&c->kobj, parent, "bcache") ||
 	    kobject_add(&c->internal, &c->kobj, "internal"))
 		goto err;
 
@@ -1717,16 +1588,10 @@ static void cache_free(struct kobject *kobj)
 	if (c->sb_bio.bi_inline_vecs[0].bv_page)
 		put_page(c->sb_bio.bi_io_vec[0].bv_page);
 
-	if (!IS_ERR_OR_NULL(c->bdev)) {
-		blk_sync_queue(bdev_get_queue(c->bdev));
-		blkdev_put(c->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-	}
-
-	kfree(c);
-	module_put(THIS_MODULE);
+	c->release(c);
 }
 
-static int cache_alloc(struct cache_sb *sb, struct cache *c)
+static int cache_init(struct cache_sb *sb, struct cache *c)
 {
 	size_t free;
 	struct bucket *b;
@@ -1734,7 +1599,6 @@ static int cache_alloc(struct cache_sb *sb, struct cache *c)
 	if (!c)
 		return -ENOMEM;
 
-	__module_get(THIS_MODULE);
 	cache_kobject_init(c);
 
 	memcpy(&c->sb, sb, sizeof(struct cache_sb));
@@ -1782,13 +1646,14 @@ err:
 	return -ENOMEM;
 }
 
-static const char *register_cache(struct cache_sb *sb, struct page *sb_page,
-				  struct block_device *bdev, struct cache *c)
+static const char *__register_cache(struct cache_sb *sb, struct page *sb_page,
+				    struct block_device *bdev, struct kobject *parent,
+				    struct cache *c, struct kobject *set_parent)
 {
 	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
 
-	if (cache_alloc(sb, c) != 0)
+	if (cache_init(sb, c) != 0)
 		return err;
 
 	c->sb_bio.bi_io_vec[0].bv_page = sb_page;
@@ -1799,10 +1664,10 @@ static const char *register_cache(struct cache_sb *sb, struct page *sb_page,
 		c->discard = CACHE_DISCARD(&c->sb);
 
 	err = "error creating kobject";
-	if (kobject_add(&c->kobj, &disk_to_dev(bdev->bd_disk)->kobj, "bcache"))
+	if (kobject_add(&c->kobj, parent, "bcache"))
 		goto err;
 
-	err = register_cache_set(c);
+	err = register_cache_set(c, set_parent);
 	if (err)
 		goto err;
 
@@ -1822,79 +1687,19 @@ err:
 	return NULL;
 }
 
-/* Global interfaces/init */
-
-static ssize_t register_bcache(struct kobject *, struct kobj_attribute *,
-			       const char *, size_t);
-
-kobj_attribute_write(register,		register_bcache);
-kobj_attribute_write(register_quiet,	register_bcache);
-
-static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
-			       const char *buffer, size_t size)
+const char *bcache_register_cache(struct cache_sb *sb, struct page *sb_page,
+				  struct block_device *bdev, struct kobject *parent,
+				  struct cache *c, struct kobject *set_parent)
 {
-	ssize_t ret = size;
-	const char *err = "cannot allocate memory";
-	char *path = NULL;
-	struct cache_sb *sb = NULL;
-	struct block_device *bdev = NULL;
-	struct page *sb_page = NULL;
-
-	if (!try_module_get(THIS_MODULE))
-		return -EBUSY;
+	const char *err;
 
 	mutex_lock(&register_lock);
-
-	if (!(path = kstrndup(buffer, size, GFP_KERNEL)) ||
-	    !(sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL)))
-		goto err;
-
-	err = "failed to open device";
-	bdev = blkdev_get_by_path(strim(path),
-				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
-				  sb);
-	if (bdev == ERR_PTR(-EBUSY))
-		err = "device busy";
-
-	if (IS_ERR(bdev) ||
-	    set_blocksize(bdev, 4096))
-		goto err;
-
-	err = read_super(sb, bdev, &sb_page);
-	if (err)
-		goto err_close;
-
-	if (sb->version == CACHE_BACKING_DEV) {
-		struct cached_dev *d = kzalloc(sizeof(*d), GFP_KERNEL);
-
-		err = register_bdev(sb, sb_page, bdev, d);
-	} else {
-		struct cache *c = kzalloc(sizeof(*c), GFP_KERNEL);
-
-		err = register_cache(sb, sb_page, bdev, c);
-	}
-
-	if (err) {
-		/* register_(bdev|cache) will only return an error if they
-		 * didn't get far enough to create the kobject - if they did,
-		 * the kobject destructor will do this cleanup.
-		 */
-		put_page(sb_page);
-err_close:
-		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
-err:
-		if (attr != &ksysfs_register_quiet)
-			printk(KERN_DEBUG "bcache: error opening %s: %s\n",
-			       path, err);
-		ret = -EINVAL;
-	}
-
-	kfree(sb);
-	kfree(path);
+	err = __register_cache(sb, sb_page, bdev, parent, c, set_parent);
 	mutex_unlock(&register_lock);
-	module_put(THIS_MODULE);
-	return ret;
+
+	return err;
 }
+EXPORT_SYMBOL_GPL(bcache_register_cache);
 
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 {
@@ -1916,7 +1721,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		printk(KERN_INFO "bcache: Stopping all devices:\n");
 
 		list_for_each_entry_safe(c, tc, &cache_sets, list)
-			cache_set_stop(c);
+			bcache_cache_set_stop(c);
 
 		list_for_each_entry_safe(dc, tdc, &uncached_devices, list)
 			bcache_device_stop(&dc->disk);
@@ -1962,37 +1767,21 @@ static void bcache_exit(void)
 	bcache_writeback_exit();
 	bcache_request_exit();
 	bcache_btree_exit();
-	if (bcache_kobj)
-		kobject_put(bcache_kobj);
 	if (bcache_wq)
 		destroy_workqueue(bcache_wq);
-	unregister_blkdev(bcache_major, "bcache");
 	unregister_reboot_notifier(&reboot);
 }
 
 static int __init bcache_init(void)
 {
-	static const struct attribute *files[] = {
-		&ksysfs_register.attr,
-		&ksysfs_register_quiet.attr,
-		NULL
-	};
-
 	mutex_init(&register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
 
-	bcache_major = register_blkdev(0, "bcache");
-	if (bcache_major < 0)
-		return bcache_major;
-
 	if (!(bcache_wq = create_workqueue("bcache")) ||
-	    !(bcache_kobj = kobject_create_and_add("bcache", fs_kobj)) ||
-	    sysfs_create_files(bcache_kobj, files) ||
 	    bcache_btree_init() ||
 	    bcache_request_init() ||
-	    bcache_writeback_init() ||
-	    bcache_debug_init(bcache_kobj))
+	    bcache_writeback_init())
 		goto err;
 
 	return 0;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 3ead3ba..f075ce5 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1,11 +1,7 @@
-write_attribute(attach);
-write_attribute(detach);
 write_attribute(unregister);
-write_attribute(stop);
 write_attribute(clear_stats);
 write_attribute(trigger_gc);
 write_attribute(prune_cache);
-write_attribute(flash_vol_create);
 
 read_attribute(bucket_size);
 read_attribute(block_size);
@@ -61,7 +57,6 @@ read_attribute(writeback_rate_debug);
 rw_attribute(synchronous);
 rw_attribute(journal_delay_ms);
 rw_attribute(discard);
-rw_attribute(running);
 rw_attribute(label);
 rw_attribute(readahead);
 rw_attribute(io_error_limit);
@@ -129,7 +124,6 @@ SHOW(__cached_dev)
 	var_hprint(sequential_cutoff);
 	var_hprint(readahead);
 
-	sysfs_print(running,		atomic_read(&d->running));
 	sysfs_print(state,		states[BDEV_STATE(&d->sb)]);
 
 	if (attr == &sysfs_label) {
@@ -147,8 +141,6 @@ SHOW_LOCKED(cached_dev)
 STORE(__cached_dev)
 {
 	struct cached_dev *d = container_of(kobj, struct cached_dev, disk.kobj);
-	unsigned v = size;
-	struct cache_set *c;
 
 #define d_strtoul(var)		sysfs_strtoul(var, d->var)
 #define d_strtoi_h(var)		sysfs_hatoi(var, d->var)
@@ -175,10 +167,6 @@ STORE(__cached_dev)
 	if (attr == &sysfs_clear_stats)
 		clear_stats(&d->accounting);
 
-	if (attr == &sysfs_running &&
-	    strtoul_or_return(buf))
-		cached_dev_run(d);
-
 	if (attr == &sysfs_cache_mode) {
 		ssize_t v = read_string_list(buf, bcache_cache_modes + 1);
 
@@ -201,24 +189,6 @@ STORE(__cached_dev)
 		}
 	}
 
-	if (attr == &sysfs_attach) {
-		if (parse_uuid(buf, d->sb.set_uuid) < 16)
-			return -EINVAL;
-
-		list_for_each_entry(c, &cache_sets, list) {
-			v = cached_dev_attach(d, c);
-			if (!v)
-				return size;
-		}
-		size = v;
-	}
-
-	if (attr == &sysfs_detach && d->disk.c)
-		cached_dev_detach(d);
-
-	if (attr == &sysfs_stop)
-		bcache_device_stop(&d->disk);
-
 	return size;
 }
 
@@ -244,9 +214,6 @@ STORE(cached_dev)
 static void cached_dev_kobject_init(struct cached_dev *dc)
 {
 	static struct attribute *cached_dev_files[] = {
-		&sysfs_attach,
-		&sysfs_detach,
-		&sysfs_stop,
 #if 0
 		&sysfs_data_csum,
 #endif
@@ -265,7 +232,6 @@ static void cached_dev_kobject_init(struct cached_dev *dc)
 		&sysfs_sequential_cutoff,
 		&sysfs_sequential_merge,
 		&sysfs_clear_stats,
-		&sysfs_running,
 		&sysfs_state,
 		&sysfs_label,
 		&sysfs_readahead,
@@ -479,9 +445,6 @@ STORE(__cache_set)
 	if (attr == &sysfs_unregister)
 		cache_set_unregister(c);
 
-	if (attr == &sysfs_stop)
-		cache_set_stop(c);
-
 	if (attr == &sysfs_synchronous) {
 		bool sync = strtoul_or_return(buf);
 
@@ -491,16 +454,6 @@ STORE(__cache_set)
 		}
 	}
 
-	if (attr == &sysfs_flash_vol_create) {
-		int r;
-		uint64_t v;
-		strtoi_h_or_return(buf, v);
-
-		r = flash_dev_create(c, v);
-		if (r)
-			return r;
-	}
-
 	if (attr == &sysfs_clear_stats) {
 		atomic_long_set(&c->writeback_keys_done,	0);
 		atomic_long_set(&c->writeback_keys_failed,	0);
@@ -557,10 +510,8 @@ static void cache_set_kobject_init(struct cache_set *c)
 {
 	static struct attribute *cache_set_files[] = {
 		&sysfs_unregister,
-		&sysfs_stop,
 		&sysfs_synchronous,
 		&sysfs_journal_delay_ms,
-		&sysfs_flash_vol_create,
 
 		&sysfs_bucket_size,
 		&sysfs_block_size,
