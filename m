From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 1/3] md/isrt: base infrastructure and metadata loading
Date: Wed, 23 Apr 2014 23:18:49 -0700
Message-ID: <20140424061849.3187.48229.stgit@viggo.jf.intel.com>
References: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424061756.3187.2633.stgit@viggo.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, jes.sorensen@redhat.com, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Dave Jiang <dave.jiang@intel.com>
List-Id: linux-raid.ids

Initial md / block boilerplate for the Intel (R) Smart Response
Technology compatibility driver.  Supports reading the packed  metadata
and parsing it into a cache lookup tree.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/Kconfig  |   18 ++
 drivers/md/Makefile |    1 
 drivers/md/isrt.c   |  524 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/isrt.h   |  290 ++++++++++++++++++++++++++++
 4 files changed, 833 insertions(+), 0 deletions(-)
 create mode 100644 drivers/md/isrt.c
 create mode 100644 drivers/md/isrt.h

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 5bdedf6df153..3cb0d80f551e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -174,6 +174,24 @@ config MD_FAULTY
 
 	  In unsure, say N.
 
+config MD_INTEL_SRT
+	tristate "Intel (R) Smart Response Technology support"
+	depends on BLK_DEV_MD
+	help
+	  Basic compatibility support for Intel(R) Smart Response
+	  Technology arrays.  These arrays include a HDD fronted by an SSD.
+	  This driver enables basic compatibility for parsing the metadata and
+	  directing reads to the most up-to-date version of the data (if it is
+	  cached on the SSD).  For writes the driver simply writes the data back
+	  to the HDD (if it is dirty in the SSD) and then invalidates the blocks
+	  in the metadata.  It never inserts new dirty data into the cache.
+
+	  Note, component members of an isrt volume are imsm raid volumes, you
+	  should enable at least MD_RAID0 before mdadm will be able to assemble
+	  an isrt volume.
+
+	  If unsure, say N.
+
 source "drivers/md/bcache/Kconfig"
 
 config BLK_DEV_DM_BUILTIN
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a2da532b1c2b..7d407d6921f9 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_MD_RAID10)		+= raid10.o
 obj-$(CONFIG_MD_RAID456)	+= raid456.o
 obj-$(CONFIG_MD_MULTIPATH)	+= multipath.o
 obj-$(CONFIG_MD_FAULTY)		+= faulty.o
+obj-$(CONFIG_MD_INTEL_SRT)	+= isrt.o
 obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
diff --git a/drivers/md/isrt.c b/drivers/md/isrt.c
new file mode 100644
index 000000000000..8dad8fada52c
--- /dev/null
+++ b/drivers/md/isrt.c
@@ -0,0 +1,524 @@
+/*
+ * Intel (R) Smart Response Technology
+ * Copyright(c) 2011-2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#define pr_fmt(fmt) "md/isrt: " fmt
+
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+#include "md.h"
+#include "isrt.h"
+
+static void mpb_read_endio(struct bio *bio, int error)
+{
+	struct mddev *mddev = bio->bi_private;
+	struct isrt_conf *conf = mddev->private;
+
+	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+		pr_err("%s: %s error: %d uptodate: %d\n",
+		       __func__, mdname(mddev), error,
+		       test_bit(BIO_UPTODATE, &bio->bi_flags));
+		WARN_ON(test_bit(BIO_UPTODATE, &bio->bi_flags));
+		set_bit(ISRT_ERROR, &conf->state);
+	}
+
+	if (atomic_dec_and_test(&conf->count))
+		wake_up(&conf->eventq);
+	bio_put(bio);
+}
+
+static int isrt_mpb_read(struct mddev *mddev, struct page *page)
+{
+	struct isrt_conf *conf = mddev->private;
+	struct md_rdev *rdev = conf->dev[ISRT_DEV_IDX];
+	struct bio *bio = bio_alloc_mddev(GFP_KERNEL, 1, mddev);
+	int size = ALIGN(sizeof(struct nv_cache_control_data), 512);
+
+	bio->bi_iter.bi_sector = 0;
+	bio->bi_private = mddev;
+	bio->bi_bdev = rdev->bdev;
+	bio->bi_end_io = mpb_read_endio;
+	bio_add_page(bio, page, size, 0);
+
+	atomic_inc(&conf->count);
+	submit_bio(0, bio);
+	wait_event(conf->eventq, atomic_read(&conf->count) == 0);
+	return test_bit(ISRT_ERROR, &conf->state) ? -EIO : 0;
+}
+
+static int isrt_read_packed_md(struct mddev *mddev)
+{
+	struct isrt_conf *conf = mddev->private;
+	struct md_rdev *rdev = conf->dev[ISRT_DEV_IDX];
+	int i;
+
+	for (i = 0; i < conf->vmeta_size; i += PAGE_SIZE) {
+		int idx = i/sizeof(struct nv_cache_packed_md);
+		struct page *page = vmalloc_to_page(&conf->vmeta[idx]);
+		struct bio *bio = bio_alloc_mddev(GFP_KERNEL, 1, mddev);
+
+		if (!bio)
+			break;
+		if (!page) {
+			bio_put(bio);
+			break;
+		}
+
+		bio->bi_iter.bi_sector = conf->packed_md_lba + (i >> 9);
+		bio->bi_private = mddev;
+		bio->bi_bdev = rdev->bdev;
+		bio->bi_end_io = mpb_read_endio;
+		bio_add_page(bio, page, PAGE_SIZE, 0);
+
+		atomic_inc(&conf->count);
+		submit_bio(0, bio);
+	}
+
+	wait_event(conf->eventq, atomic_read(&conf->count) == 0);
+	if (i < conf->vmeta_size || test_bit(ISRT_ERROR, &conf->state))
+		return -EIO;
+
+	return 0;
+}
+
+static bool isrt_insert_page(struct isrt_conf *conf, struct isrt_page *new)
+{
+	struct rb_node **link = &conf->root.rb_node, *parent = NULL;
+	struct isrt_page *p;
+	u32 key = new->seg_page;
+
+	while (*link) {
+		parent = *link;
+		p = to_cache_page(parent);
+
+		if (p->seg_page > key)
+			link = &(*link)->rb_left;
+		else if (p->seg_page < key)
+			link = &(*link)->rb_right;
+		else {
+			WARN_ONCE(1, pr_fmt("duplicate insert: %d\n"), key);
+			return false;
+		}
+	}
+
+	rb_link_node(&new->rb, parent, link);
+	rb_insert_color(&new->rb, &conf->root);
+	return true;
+}
+
+static struct isrt_page *isrt_lookup_page(struct isrt_conf *conf, sector_t lba)
+{
+	u32 key = to_key(lba);
+	struct rb_node *r = conf->root.rb_node;
+
+	while (r) {
+		struct isrt_page *p = to_cache_page(r);
+
+		if (p->seg_page > key)
+			r = r->rb_left;
+		else if (p->seg_page < key)
+			r = r->rb_right;
+		else
+			return p;
+	}
+
+	return NULL;
+}
+
+static struct isrt_page *isrt_new_page(struct isrt_conf *conf, sector_t lba)
+{
+	struct isrt_page *p = kmalloc(sizeof(*p), GFP_KERNEL);
+	int i;
+
+	if (!p)
+		return NULL;
+
+	p->seg_page = to_key(lba);
+	RB_CLEAR_NODE(&p->rb);
+	for (i = 0; i < ARRAY_SIZE(p->frame); i++)
+		p->frame[i] = -1;
+
+	spin_lock(&conf->lock);
+	if (!isrt_insert_page(conf, p)) {
+		kfree(p);
+		p = NULL;
+	}
+	spin_unlock(&conf->lock);
+
+	return p;
+}
+
+static bool isrt_insert_frame(struct isrt_conf *conf, struct isrt_page *p, int frame_idx)
+{
+	struct nv_cache_packed_md *frame = &conf->vmeta[frame_idx];
+	int page_idx = to_page_idx(le32_to_cpu(frame->seg_num));
+
+	if (p->frame[page_idx] == -1)
+		p->frame[page_idx] = frame_idx;
+	else
+		return false;
+
+	return true;
+}
+
+static struct nv_cache_packed_md *isrt_lookup_frame(struct isrt_conf *conf,
+							struct isrt_page *p,
+							sector_t lba)
+{
+	int page_idx = to_page_idx(to_seg_num(lba));
+	int frame_idx = p ? p->frame[page_idx] : -1;
+
+	if (frame_idx == -1)
+		return NULL;
+	else
+		return &conf->vmeta[frame_idx];
+}
+
+static int isrt_init_conf(struct mddev *mddev, struct isrt_conf *conf)
+{
+	struct page *page = alloc_page(GFP_KERNEL);
+	int err, num_frames, packed_set, i;
+	struct nv_cache_control_data *ctrl;
+	size_t size;
+
+	mddev->private = conf;
+	conf->mddev = mddev;
+	spin_lock_init(&conf->lock);
+	conf->root = RB_ROOT;
+	init_waitqueue_head(&conf->eventq);
+	atomic_set(&conf->count, 0);
+
+	if (!page)
+		return -ENOMEM;
+
+	err = isrt_mpb_read(mddev, page);
+	if (err)
+		goto out;
+
+	/* validate superblock */
+	ctrl = page_address(page);
+	err = 0;
+	if (strncmp(NV_CACHE_CONFIG_SIG, ctrl->hdr.signature, NVC_SIG_LEN) != 0)
+		err = -ENODEV;
+	num_frames = le32_to_cpu(ctrl->mpb.num_cache_frames);
+	if (num_frames > MAX_NVC_FRAMES)
+		err = -ENODEV;
+	if (err) {
+		pr_err("%s: invalid superblock\n", mdname(mddev));
+		pr_debug("signature '%.32s\n' num_cache_frames: %d\n",
+			 ctrl->hdr.signature, num_frames);
+		goto out;
+	}
+
+	size = sizeof(struct nv_cache_packed_md) * num_frames;
+	size = ALIGN(size, PAGE_SIZE);
+	pr_debug("allocating %zd KB for %d packed metadata entries\n",
+		 size >> 10, num_frames);
+	conf->vmeta = vmalloc(size);
+	if (!conf->vmeta) {
+		err = -ENOMEM;
+		goto out;
+	}
+	conf->vmeta_size = size;
+
+	packed_set = le32_to_cpu(ctrl->mpb.md_base_for_delta_log) ^ 1;
+	if (packed_set == 0)
+		conf->packed_md_lba = le32_to_cpu(ctrl->mpb.packed_md0_nba);
+	else if (packed_set == 1)
+		conf->packed_md_lba = le32_to_cpu(ctrl->mpb.packed_md1_nba);
+	else {
+		err = -ENODEV;
+		goto out;
+	}
+
+	conf->cache_frame0_lba = le32_to_cpu(ctrl->mpb.cache_frame0_nba);
+
+	err = isrt_read_packed_md(mddev);
+	if (err)
+		goto out;
+
+	for (i = 0; i < num_frames; i++) {
+		struct isrt_page *p;
+		struct nv_cache_packed_md *frame = &conf->vmeta[i];
+		u16 valid = le16_to_cpu(frame->per_sector_validity);
+		sector_t seg_lba = le32_to_cpu(frame->seg_num) << FRAME_SHIFT;
+
+		if (valid == (u16) ~0) {
+			/* all sectors invalid, skip */
+			continue;
+		}
+
+		spin_lock(&conf->lock);
+		p = isrt_lookup_page(conf, seg_lba);
+		spin_unlock(&conf->lock);
+		if (!p) {
+			p = isrt_new_page(conf, seg_lba);
+			conf->num_pages++;
+		}
+
+		if (!p || !isrt_insert_frame(conf, p, i)) {
+			int j;
+
+			pr_debug("%s: failed to insert frame: `%d seg_page: %d seg_num: %d page_idx: %d\n",
+				 __func__, i, to_key(seg_lba), frame->seg_num,
+				 to_page_idx(frame->seg_num));
+			for (j = 0; j < ARRAY_SIZE(p->frame); j++)
+				pr_debug("\tframe[%d]: %d\n", j, p->frame[j]);
+			break;
+		}
+
+		if (frame->flags & NVC_PACKED_DIRTY)
+			conf->num_dirty++;
+		conf->num_frames++;
+	}
+	pr_info("%s: init: %s pages: %d frames: %d dirty: %d\n", mdname(mddev),
+		i < num_frames ? "fail" : "success", conf->num_pages,
+		conf->num_frames, conf->num_dirty);
+
+	if (i < num_frames)
+		err = -ENODEV;
+	else
+		err = 0;
+
+ out:
+	put_page(page);
+	return err;
+}
+
+static void isrt_free_conf(struct isrt_conf *conf)
+{
+	struct rb_node *r;
+
+	if (!conf)
+		return;
+
+	spin_lock(&conf->lock);
+	for (r = rb_first(&conf->root); r; ) {
+		struct isrt_page *p = to_cache_page(r);
+		struct rb_node *next = rb_next(r);
+
+		rb_erase(r, &conf->root);
+		kfree(p);
+		r = next;
+	}
+	spin_unlock(&conf->lock);
+
+	conf->mddev->private = NULL;
+	vfree(conf->vmeta);
+	kfree(conf);
+}
+
+static int isrt_congested(void *data, int bits)
+{
+	struct mddev *mddev = data;
+	struct md_rdev *rdev;
+	int ret = 0;
+
+	if (mddev_congested(mddev, bits))
+		return 1;
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		struct request_queue *q = bdev_get_queue(rdev->bdev);
+
+		ret |= bdi_congested(&q->backing_dev_info, bits);
+	}
+
+	return ret;
+}
+
+static sector_t isrt_size(struct mddev *mddev, sector_t sectors, int raid_disks)
+{
+	struct md_rdev *rdev;
+
+	WARN_ONCE(sectors || raid_disks,
+		  "%s does not support generic reshape\n", __func__);
+
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk == ISRT_TARGET_DEV_IDX)
+			break;
+	if (&rdev->same_set != &mddev->disks)
+		return rdev->sectors;
+	else
+		return 0;
+}
+
+static int isrt_mergeable_bvec(struct request_queue *q,
+				   struct bvec_merge_data *bvm,
+				   struct bio_vec *biovec)
+{
+	unsigned int bio_sectors = bvm->bi_size >> 9;
+	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
+	int frame_offset = sector & (ISRT_FRAME_SIZE-1);
+	int max;
+
+	max = (ISRT_FRAME_SIZE - (frame_offset + bio_sectors)) << 9;
+	if (max < 0)
+		max = 0; /* bio_add cannot handle a negative return */
+	if (max <= biovec->bv_len && bio_sectors == 0)
+		return biovec->bv_len;
+	else
+		return max;
+}
+
+static struct isrt_conf *isrt_setup_conf(struct mddev *mddev)
+{
+	struct isrt_conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	struct request_queue *targetq;
+	int err = -EINVAL, ra_pages;
+	struct md_rdev *rdev;
+
+	if (!conf)
+		goto abort;
+
+	if (mddev->raid_disks != 2) {
+		pr_err("%s: only supports 1:1 caching\n", mdname(mddev));
+		goto abort;
+	}
+
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		int d = rdev->raid_disk;
+
+		if (d < mddev->raid_disks && (d == 0 || d == 1))
+			conf->dev[d] = rdev;
+		else {
+			pr_err("%s: bad disk number %d aborting!\n",
+			       mdname(mddev), d);
+			goto abort;
+		}
+
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset << 9);
+
+	}
+
+	/* skip the need to honor the merge constraints of underlying devices,
+	 * and ensure that requests are always bio_split() capable
+	 */
+	blk_queue_max_segments(mddev->queue, 1);
+	blk_queue_segment_boundary(mddev->queue, PAGE_CACHE_SIZE - 1);
+
+	err = isrt_init_conf(mddev, conf);
+	if (err)
+		goto abort;
+
+	/* set the read ahead to the max supported by the cache target */
+	err = -ENODEV;
+	rdev = conf->dev[ISRT_TARGET_DEV_IDX];
+	targetq = bdev_get_queue(rdev->bdev);
+	if (!targetq)
+		goto abort;
+	ra_pages = targetq->backing_dev_info.ra_pages;
+	if (mddev->queue->backing_dev_info.ra_pages < ra_pages)
+		mddev->queue->backing_dev_info.ra_pages = ra_pages;
+
+	mddev->queue->backing_dev_info.congested_fn = isrt_congested;
+	mddev->queue->backing_dev_info.congested_data = mddev;
+
+	return conf;
+ abort:
+	isrt_free_conf(conf);
+	return ERR_PTR(err);
+}
+
+static int isrt_run(struct mddev *mddev)
+{
+	struct isrt_conf *conf;
+
+	if (md_check_no_bitmap(mddev))
+		return -EINVAL;
+
+	conf = isrt_setup_conf(mddev);
+	if (IS_ERR(conf))
+		return PTR_ERR(conf);
+
+	/* calculate array device size */
+	md_set_array_sectors(mddev, isrt_size(mddev, 0, 0));
+
+	pr_info("%s: size is %llu sectors.\n", mdname(mddev),
+		(unsigned long long)mddev->array_sectors);
+
+	blk_queue_max_hw_sectors(mddev->queue, NVC_FRAME_SIZE >> 9);
+	blk_queue_merge_bvec(mddev->queue, isrt_mergeable_bvec);
+	return md_integrity_register(mddev);
+}
+
+static int isrt_stop(struct mddev *mddev)
+{
+	struct isrt_conf *conf = mddev->private;
+
+	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+	isrt_free_conf(conf);
+	mddev->private = NULL;
+
+	return 0;
+}
+
+static void isrt_make_request(struct mddev *mddev, struct bio *bio)
+{
+	struct isrt_conf *conf = mddev->private;
+	struct nv_cache_packed_md *frame;
+	struct isrt_page *p;
+
+	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+		md_flush_request(mddev, bio);
+		return;
+	}
+
+	spin_lock(&conf->lock);
+	p = isrt_lookup_page(conf, bio->bi_iter.bi_sector);
+	frame = isrt_lookup_frame(conf, p, bio->bi_iter.bi_sector);
+	spin_unlock(&conf->lock);
+
+	pr_debug("%s: sector: %llu cache: %s\n",
+		 __func__, (unsigned long long) bio->bi_iter.bi_sector,
+		 frame ? "hit" : "miss");
+	bio_endio(bio, -EOPNOTSUPP);
+}
+
+static void isrt_status(struct seq_file *seq, struct mddev *mddev)
+{
+	struct isrt_conf *conf = mddev->private;
+	struct md_rdev *rdev = conf->dev[ISRT_DEV_IDX];
+
+	seq_printf(seq, " %lluk cache-blocks",
+		   (unsigned long long) rdev->sectors / 2);
+}
+
+static struct md_personality isrt_personality = {
+	.name		= "isrt",
+	.level		= 8,
+	.owner		= THIS_MODULE,
+	.make_request	= isrt_make_request,
+	.run		= isrt_run,
+	.stop		= isrt_stop,
+	.status		= isrt_status,
+	.size		= isrt_size,
+};
+
+static int __init isrt_init(void)
+{
+	return register_md_personality(&isrt_personality);
+}
+
+static void isrt_exit(void)
+{
+	unregister_md_personality(&isrt_personality);
+}
+
+module_init(isrt_init);
+module_exit(isrt_exit);
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Intel(R) Smart Response Technology base compatibility");
+MODULE_ALIAS("md-isrt");
diff --git a/drivers/md/isrt.h b/drivers/md/isrt.h
new file mode 100644
index 000000000000..31e354039eae
--- /dev/null
+++ b/drivers/md/isrt.h
@@ -0,0 +1,290 @@
+/*
+ * imsm cache support via md
+ * Copyright (c) 2011-2014, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/rbtree.h>
+#include "md.h"
+
+enum {
+	/* for a given cache device how many volumes can be associated */
+	MAX_NV_CACHE_VOLS = 1,
+	/* likely should be dynamically configurable when this driver is
+	 * made more generic
+	 */
+	ISRT_FRAME_SIZE = 8192,
+	VOL_CONFIG_RESERVED = 32,
+	MD_HEADER_RESERVED = 32,
+	MAX_RAID_SERIAL_LEN = 16,
+	NVC_SIG_LEN = 32,
+	ISRT_DEV_IDX = 0,
+	ISRT_TARGET_DEV_IDX = 1,
+};
+
+struct segment_index_pair {
+	__le32 segment;
+	__le32 index;
+};
+
+#define NV_CACHE_CONFIG_SIG "Intel IMSM NV Cache Cfg. Sig.   "
+#define MAX_NVC_SIZE_GB            128UL      /* Max NvCache we can support is 128GB */
+#define NVC_FRAME_SIZE             8192UL
+#define NVC_FRAME_SIZE_IN_KB       (NVC_FRAME_SIZE / 1024UL)                  /* 8 */
+#define NVC_FRAMES_PER_GB          (1024UL * (1024UL / NVC_FRAME_SIZE_IN_KB))   /* 128k */
+#define MAX_NVC_FRAMES             (MAX_NVC_SIZE_GB * NVC_FRAMES_PER_GB)    /* 16m */
+#define SEGIDX_PAIRS_PER_NVC_FRAME (NVC_FRAME_SIZE / sizeof(struct segment_index_pair)) /* 1k */
+#define SEGHEAP_SEGS_PER_NVC_FRAME (NVC_FRAME_SIZE / sizeof(__le32)) /* 2k */
+#define FRAMES_PER_SEGHEAP_FRAME   (SEGIDX_PAIRS_PER_NVC_FRAME \
+				    * SEGHEAP_SEGS_PER_NVC_FRAME) /* 2m */
+#define MAX_SEGHEAP_NVC_FRAMES     (MAX_NVC_FRAMES/FRAMES_PER_SEGHEAP_FRAME)  /* 8 */
+#define MAX_SEGHEAP_TOC_ENTRIES    (MAX_SEGHEAP_NVC_FRAMES + 1)
+
+
+/* XXX: size of enum guarantees? */
+enum nvc_shutdown_state {
+	ShutdownStateNormal,
+	ShutdownStateS4CrashDmpStart,
+	ShutdownStateS4CrashDmpEnd,
+	ShutdownStateS4CrashDmpFailed
+};
+
+struct isrt_mpb {
+	/*
+	 * Metadata array (packed_md0_nba or packed_md1_nba).  is the base for
+	 * the Metadata Delta Log changes.  The current contents of the Metadata
+	 * Delta Log applied to this packed metadata base becomes the working
+	 * packed metadata upon recovery from a power failure.  The alternate
+	 * packed metadata array, indicated by (md_base_for_delta_log ^1) is
+	 * where the next complete write of packed metadata from DRAM will be
+	 * written. On a clean shutdown, packed metadata will also be written to
+	 * the alternate array.
+	 */
+	__le32 packed_md0_nba; /* Start of primary packed metadata array */
+	__le32 packed_md1_nba; /* Start of secondary packed metadata array */
+	__le32 md_base_for_delta_log; /* 0 or 1. Indicates which packed */
+	__le32 packed_md_size; /* Size of packed metadata array in bytes */
+	__le32 aux_packed_md_nba; /* Start of array of extra metadata for driver use */
+	__le32 aux_packed_md_size; /* Size of array of extra metadata for driver use */
+	__le32 cache_frame0_nba; /* Start of actual cache frames */
+	__le32 seg_num_index_nba; /* Start of the Seg_num_index array */
+	__le32 seg_num_heap_nba; /* Start of the Seg_num_heap */
+	__le32 seg_num_heap_size; /* Size of the Seg_num Heap in bytes (always a */
+	/*
+	 * Multiple of NVM_PAGE_SIZE bytes. The Seg_nums in the tail of the last
+	 * page are all set to 0xFFFFFFFF
+	 */
+	__le32 seg_heap_toc[MAX_SEGHEAP_TOC_ENTRIES];
+	__le32 md_delta_log_nba; /* Start of the Metadata Delta Log region */
+	/*  The Delta Log is a circular buffer */
+	__le32 md_delta_log_max_size; /* Size of the Metadata Delta Log region in bytes */
+	__le32 orom_frames_to_sync_nba; /* Start of the orom_frames_to_sync record */
+	__le32 num_cache_frames; /* Total number of cache frames */
+	__le32 cache_frame_size; /* Size of each cache frame in bytes */
+	__le32 lba_alignment; /* Offset to add to host I/O request LBA before
+			       * shifting to form the segment number
+			       */
+	__le32 valid_frame_gen_num; /* Valid cache frame generation number */
+	/*
+	 * If the cache frame metadata contains a smaller generation number,
+	 * that frame's contents are considered invalid.
+	 */
+	__le32 packed_md_frame_gen_num; /* Packed metadata frame generation number */
+	/*
+	 * This is the frame generation number associated with all frames in the
+	 * packed metadata array. If this is < valid_frame_gen_num, then all
+	 * frames in packed metadata are considered invalid.
+	 */
+	__le32 curr_clean_batch_num; /* Initialized to 0, incremented whenever
+				      * the cache goes clean. If this value is
+				      * greater than the Nv_cache_metadata
+				      * dirty_batch_num in the atomic metadata
+				      * of the cache frame, the frame is
+				      * considered clean.
+				      */
+	__le32 total_used_sectors; /* Total number of NVM sectors of size
+				    * NVM_SECTOR_SIZE used by cache frames and
+				    * metadata.
+				    */
+	/* OROM I/O Log fields */
+	__le32 orom_log_nba; /* OROM I/O Log area for next boot */
+	__le32 orom_log_size; /* OROM I/O Log size in 512-byte blocks */
+
+	/* Hibernate/Crashdump Extent_log */
+	__le32 s4_crash_dmp_extent_log_nba; /* I/O Extent Log area created by the */
+					   /* hibernate/crashdump driver for OROM */
+	/* Driver shutdown state utilized by the OROM */
+	enum nvc_shutdown_state driver_shutdown_state;
+
+	__le32 validity_bits;
+	__le64 nvc_hdr_array_in_dram;
+
+	/* The following fields are used in managing the Metadata Delta Log. */
+
+	/*
+	 * Every delta record in the Metadata Delta Log  has a copy of the value
+	 * of this field at the time the record was written. This gen num is
+	 * incremented by 1 every time the log fills up, and allows powerfail
+	 * recovery to easily find the end of the log (it's the first record
+	 * whose gen num field is < curr_delta_log_gen_num.)
+	 */
+	__le32 curr_delta_log_gen_num;
+	/*
+	 * This is the Nba to the start of the current generation of delta
+	 * records in the log.  Since the log is circular, the currentlog
+	 * extends from md_delta_log_first up to and including
+	 * (md_delta_log_first +max_records-2) % max_records) NOTE: when reading
+	 * the delta log, the actual end of the log is indicated by the first
+	 * record whose gen num field is <curr_delta_log_gen_num, so the
+	 * 'max_records-2' guarantees we'll have at least one delta record whose
+	 * gen num field will qualify to mark the end of the log.
+	 */
+	__le32 md_delta_log_first;
+	/*
+	 * How many free frames are used in the Metadata Delta Log. After every
+	 * write of a delta log record that contains at least one
+	 * Md_delta_log_entry, there must always be exactly
+	 */
+
+	__le32 md_delta_log_num_free_frames;
+	__le32 num_dirty_frames; /* Number of dirty frames in cache when this
+				  * isrt_mpb was written.
+				  */
+	__le32 num_dirty_frames_at_mode_trans; /* Number of dirty frames from
+						* the start of the most recent
+						* transition out of Performance
+						* mode (Perf_to_safe/Perf_to_off)
+						*/
+} __packed;
+
+
+struct nv_cache_vol_config_md {
+	__le32 acc_vol_orig_family_num; /* Unique Volume Id of the accelerated
+					 * volume caching to the NVC Volume
+					 */
+	__le16 acc_vol_dev_id; /* (original family + dev_id ) if there is no
+				* volume associated with Nv_cache, both of these
+				* fields are 0.
+				*/
+	__le16 nv_cache_mode; /* NV Cache mode of this volume */
+	/*
+	 * The serial_no of the accelerated volume associated with Nv_cache.  If
+	 * there is no volume associated with Nv_cache, acc_vol_name[0] = 0
+	 */
+	char acc_vol_name[MAX_RAID_SERIAL_LEN];
+	__le32 flags;
+	__le32 power_cycle_count; /* Power Cycle Count of the underlying disk or
+				   * volume from the last device enumeration.
+				   */
+	/* Used to determine separation case. */
+	__le32  expansion_space[VOL_CONFIG_RESERVED];
+} __packed;
+
+struct nv_cache_config_md_header {
+	char signature[NVC_SIG_LEN]; /* "Intel IMSM NV Cache Cfg. Sig.   " */
+	__le16  version_number; /* NV_CACHE_CFG_MD_VERSION */
+	__le16  header_length; /* Length by bytes */
+	__le32  total_length; /* Length of the entire Config Metadata including
+			       * header and volume(s) in bytes
+			       */
+	/* Elements above here will never change even in new versions */
+	__le16  num_volumes; /* Number of volumes that have config metadata. in
+			      * 9.0 it's either 0 or 1
+			      */
+	__le32 expansion_space[MD_HEADER_RESERVED];
+	struct nv_cache_vol_config_md vol_config_md[MAX_NV_CACHE_VOLS]; /* Array of Volume */
+	/* Config Metadata entries. Contains "num_volumes" */
+	/* entries. In 9.0 'MAX_NV_CACHE_VOLS' = 1. */
+} __packed;
+
+struct nv_cache_control_data {
+	struct nv_cache_config_md_header hdr;
+	struct isrt_mpb mpb;
+} __packed;
+
+/* One or more sectors in NAND page are bad */
+#define NVC_PACKED_SECTORS_BAD (1 << 0)
+#define NVC_PACKED_DIRTY (1 << 1)
+#define NVC_PACKED_FRAME_TYPE_SHIFT (2)
+/* If set, frame is in clean area of LRU list */
+#define NVC_PACKED_IN_CLEAN_AREA (1 << 5)
+/*
+ * This frame was TRIMMed (OROM shouldn't expect the delta log rebuild to match
+ * the packed metadata stored on a clean shutdown.
+ */
+#define NVC_PACKED_TRIMMED (1 << 6)
+
+struct nv_cache_packed_md {
+	__le32 seg_num; /* Disk Segment currently assigned to frame */
+	__le16 per_sector_validity; /* Per sector validity */
+	u8 flags;
+	union {
+		u8 pad;
+		/* repurpose padding for driver state */
+		u8 locked;
+	};
+} __packed;
+
+#define SEGMENTS_PER_PAGE_SHIFT 6
+#define SEGMENTS_PER_PAGE (1 << SEGMENTS_PER_PAGE_SHIFT)
+#define SEGMENTS_PER_PAGE_MASK (SEGMENTS_PER_PAGE-1)
+#define FRAME_SHIFT 4
+#define SECTORS_PER_FRAME (1 << FRAME_SHIFT)
+#define FRAME_MASK (SECTORS_PER_FRAME-1)
+struct isrt_page {
+	struct rb_node rb;
+	u32 seg_page;
+	int frame[SEGMENTS_PER_PAGE];
+};
+
+static inline struct isrt_page *to_cache_page(struct rb_node *rb)
+{
+	return rb_entry(rb, struct isrt_page, rb);
+}
+
+struct isrt_conf {
+	struct mddev *mddev;
+	struct md_rdev *dev[2];
+	sector_t packed_md_lba;
+	sector_t cache_frame0_lba;
+	int num_pages;
+	int num_frames;
+	int num_dirty;
+	/* in memory copy of the packed metadata array */
+	struct nv_cache_packed_md *vmeta;
+	size_t vmeta_size;
+	struct rb_root root;
+	spinlock_t lock;
+	#define ISRT_META_IO 0
+	#define ISRT_ERROR 1
+	unsigned long state;
+	atomic_t count;
+	wait_queue_head_t eventq;
+};
+
+static inline u32 to_seg_num(sector_t lba)
+{
+	return lba >> FRAME_SHIFT;
+}
+
+static inline int to_page_idx(u32 seg_num)
+{
+	return seg_num & SEGMENTS_PER_PAGE_MASK;
+}
+
+static inline int to_frame_idx(struct isrt_conf *conf, struct nv_cache_packed_md *f)
+{
+	return f - conf->vmeta;
+}
+
+static inline u32 to_key(sector_t lba)
+{
+	return lba >> (FRAME_SHIFT + SEGMENTS_PER_PAGE_SHIFT);
+}

