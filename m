From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v4 3/7] raid5-ppl: Partial Parity Log write logging implementation
Date: Tue, 21 Feb 2017 20:43:57 +0100
Message-ID: <20170221194401.18733-4-artur.paszkiewicz@intel.com>
References: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170221194401.18733-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

This implements the PPL write logging functionality. The description
of PPL is added to the documentation. More details can be found in the
comments in raid5-ppl.c.

Put the PPL metadata structures to md_p.h because userspace tools
(mdadm) will also need to read/write PPL.

Warn about using PPL with enabled disk volatile write-back cache for
now. It can be removed once disk cache flushing before writing PPL is
implemented.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Documentation/md/raid5-ppl.txt |  44 +++
 drivers/md/Makefile            |   2 +-
 drivers/md/raid5-ppl.c         | 617 +++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |  49 +++-
 drivers/md/raid5.h             |   8 +
 include/uapi/linux/raid/md_p.h |  26 ++
 6 files changed, 738 insertions(+), 8 deletions(-)
 create mode 100644 Documentation/md/raid5-ppl.txt
 create mode 100644 drivers/md/raid5-ppl.c

diff --git a/Documentation/md/raid5-ppl.txt b/Documentation/md/raid5-ppl.txt
new file mode 100644
index 000000000000..127072b09363
--- /dev/null
+++ b/Documentation/md/raid5-ppl.txt
@@ -0,0 +1,44 @@
+Partial Parity Log
+
+Partial Parity Log (PPL) is a feature available for RAID5 arrays. The issue
+addressed by PPL is that after a dirty shutdown, parity of a particular stripe
+may become inconsistent with data on other member disks. If the array is also
+in degraded state, there is no way to recalculate parity, because one of the
+disks is missing. This can lead to silent data corruption when rebuilding the
+array or using it is as degraded - data calculated from parity for array blocks
+that have not been touched by a write request during the unclean shutdown can
+be incorrect. Such condition is known as the RAID5 Write Hole. Because of
+this, md by default does not allow starting a dirty degraded array.
+
+Partial parity for a write operation is the XOR of stripe data chunks not
+modified by this write. It is just enough data needed for recovering from the
+write hole. XORing partial parity with the modified chunks produces parity for
+the stripe, consistent with its state before the write operation, regardless of
+which chunk writes have completed. If one of the not modified data disks of
+this stripe is missing, this updated parity can be used to recover its
+contents. PPL recovery is also performed when starting an array after an
+unclean shutdown and all disks are available, eliminating the need to resync
+the array. Because of this, using write-intent bitmap and PPL together is not
+supported.
+
+When handling a write request PPL writes partial parity before new data and
+parity are dispatched to disks. PPL is a distributed log - it is stored on
+array member drives in the metadata area, on the parity drive of a particular
+stripe.  It does not require a dedicated journaling drive. Write performance is
+reduced by up to 30%-40% but it scales with the number of drives in the array
+and the journaling drive does not become a bottleneck or a single point of
+failure.
+
+Unlike raid5-cache, the other solution in md for closing the write hole, PPL is
+not a true journal. It does not protect from losing in-flight data, only from
+silent data corruption. If a dirty disk of a stripe is lost, no PPL recovery is
+performed for this stripe (parity is not updated). So it is possible to have
+arbitrary data in the written part of a stripe if that disk is lost. In such
+case the behavior is the same as in plain raid5.
+
+PPL is available for md version-1 metadata and external (specifically IMSM)
+metadata arrays. It can be enabled using mdadm option --consistency-policy=ppl.
+
+Currently, volatile write-back cache should be disabled on all member drives
+when using PPL. Otherwise it cannot guarantee consistency in case of power
+failure.
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 3cbda1af87a0..4d48714ccc6b 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -18,7 +18,7 @@ dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-era-y	+= dm-era-target.o
 dm-verity-y	+= dm-verity-target.o
 md-mod-y	+= md.o bitmap.o
-raid456-y	+= raid5.o raid5-cache.o
+raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
new file mode 100644
index 000000000000..a00cabf1adf6
--- /dev/null
+++ b/drivers/md/raid5-ppl.c
@@ -0,0 +1,617 @@
+/*
+ * Partial Parity Log for closing the RAID5 write hole
+ * Copyright (c) 2017, Intel Corporation.
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
+
+#include <linux/kernel.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/crc32c.h>
+#include <linux/raid/md_p.h>
+#include "md.h"
+#include "raid5.h"
+
+/*
+ * PPL consists of a 4KB header (struct ppl_header) and at least 128KB for
+ * partial parity data. The header contains an array of entries
+ * (struct ppl_header_entry) which describe the logged write requests.
+ * Partial parity for the entries comes after the header, written in the same
+ * sequence as the entries:
+ *
+ * Header
+ *   entry0
+ *   ...
+ *   entryN
+ * PP data
+ *   PP for entry0
+ *   ...
+ *   PP for entryN
+ *
+ * Every entry holds a checksum of its partial parity, the header also has a
+ * checksum of the header itself. Entries for full stripes writes contain no
+ * partial parity, they only mark the stripes for which parity should be
+ * recalculated after an unclean shutdown.
+ *
+ * A write request is always logged to the PPL instance stored on the parity
+ * disk of the corresponding stripe. For each member disk there is one ppl_log
+ * used to handle logging for this disk, independently from others. They are
+ * grouped in child_logs array in struct ppl_conf, which is assigned to
+ * r5conf->ppl and used in raid5 core.
+ *
+ * ppl_io_unit represents a full PPL write, header_page contains the ppl_header.
+ * PPL entries for logged stripes are added in ppl_log_stripe(). A stripe can
+ * be appended to the last entry if the chunks to write are the same, otherwise
+ * a new entry is added. Checksums of entries are calculated incrementally as
+ * stripes containing partial parity are being added to entries.
+ * ppl_submit_iounit() calculates the checksum of the header and submits a bio
+ * containing the header page and partial parity pages (sh->ppl_page) for all
+ * stripes of the io_unit. When the PPL write completes, the stripes associated
+ * with the io_unit are released and raid5d starts writing their data and
+ * parity. When all stripes are written, the io_unit is freed and the next can
+ * be submitted.
+ *
+ * An io_unit is used to gather stripes until it is submitted or becomes full
+ * (if the maximum number of entries or size of PPL is reached). Another io_unit
+ * can't be submitted until the previous has completed (PPL and stripe
+ * data+parity is written). The log->io_list tracks all io_units of a log
+ * (for a single member disk). New io_units are added to the end of the list
+ * and the first io_unit is submitted, if it is not submitted already.
+ * The current io_unit accepting new stripes is always at the end of the list.
+ */
+
+struct ppl_conf {
+	struct mddev *mddev;
+
+	/* array of child logs, one for each raid disk */
+	struct ppl_log *child_logs;
+	int count;
+
+	int block_size;		/* the logical block size used for data_sector
+				 * in ppl_header_entry */
+	u32 signature;		/* raid array identifier */
+	atomic64_t seq;		/* current log write sequence number */
+
+	struct kmem_cache *io_kc;
+	mempool_t *io_pool;
+	struct bio_set *bs;
+	mempool_t *meta_pool;
+};
+
+struct ppl_log {
+	struct ppl_conf *ppl_conf;	/* shared between all log instances */
+
+	struct md_rdev *rdev;		/* array member disk associated with
+					 * this log instance */
+	struct mutex io_mutex;
+	struct ppl_io_unit *current_io;	/* current io_unit accepting new data
+					 * always at the end of io_list */
+	spinlock_t io_list_lock;
+	struct list_head io_list;	/* all io_units of this log */
+	struct list_head no_mem_stripes;/* stripes to retry if failed to
+					 * allocate io_unit */
+};
+
+struct ppl_io_unit {
+	struct ppl_log *log;
+
+	struct page *header_page;	/* for ppl_header */
+
+	unsigned int entries_count;	/* number of entries in ppl_header */
+	unsigned int pp_size;		/* total size current of partial parity */
+
+	u64 seq;			/* sequence number of this log write */
+	struct list_head log_sibling;	/* log->io_list */
+
+	struct list_head stripe_list;	/* stripes added to the io_unit */
+	atomic_t pending_stripes;	/* how many stripes not written to raid */
+
+	bool submitted;			/* true if write to log started */
+};
+
+static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
+					  struct stripe_head *sh)
+{
+	struct ppl_conf *ppl_conf = log->ppl_conf;
+	struct ppl_io_unit *io;
+	struct ppl_header *pplhdr;
+
+	io = mempool_alloc(ppl_conf->io_pool, GFP_ATOMIC);
+	if (!io)
+		return NULL;
+
+	memset(io, 0, sizeof(*io));
+	io->log = log;
+	INIT_LIST_HEAD(&io->log_sibling);
+	INIT_LIST_HEAD(&io->stripe_list);
+	atomic_set(&io->pending_stripes, 0);
+
+	io->header_page = mempool_alloc(ppl_conf->meta_pool, GFP_NOIO);
+	pplhdr = page_address(io->header_page);
+	clear_page(pplhdr);
+	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
+	pplhdr->signature = cpu_to_le32(ppl_conf->signature);
+
+	io->seq = atomic64_add_return(1, &ppl_conf->seq);
+	pplhdr->generation = cpu_to_le64(io->seq);
+
+	return io;
+}
+
+static int ppl_log_stripe(struct ppl_log *log, struct stripe_head *sh)
+{
+	struct ppl_io_unit *io = log->current_io;
+	struct ppl_header_entry *e = NULL;
+	struct ppl_header *pplhdr;
+	int i;
+	sector_t data_sector = 0;
+	int data_disks = 0;
+	unsigned int entry_space = (log->rdev->ppl.size << 9) - PPL_HEADER_SIZE;
+	struct r5conf *conf = sh->raid_conf;
+
+	pr_debug("%s: stripe: %llu\n", __func__, (unsigned long long)sh->sector);
+
+	/* check if current io_unit is full */
+	if (io && (io->pp_size == entry_space ||
+		   io->entries_count == PPL_HDR_MAX_ENTRIES)) {
+		pr_debug("%s: add io_unit blocked by seq: %llu\n",
+			 __func__, io->seq);
+		io = NULL;
+	}
+
+	/* add a new unit if there is none or the current is full */
+	if (!io) {
+		io = ppl_new_iounit(log, sh);
+		if (!io)
+			return -ENOMEM;
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&io->log_sibling, &log->io_list);
+		spin_unlock_irq(&log->io_list_lock);
+
+		log->current_io = io;
+	}
+
+	for (i = 0; i < sh->disks; i++) {
+		struct r5dev *dev = &sh->dev[i];
+
+		if (i != sh->pd_idx && test_bit(R5_Wantwrite, &dev->flags)) {
+			if (!data_disks || dev->sector < data_sector)
+				data_sector = dev->sector;
+			data_disks++;
+		}
+	}
+	BUG_ON(!data_disks);
+
+	pr_debug("%s: seq: %llu data_sector: %llu data_disks: %d\n", __func__,
+		 io->seq, (unsigned long long)data_sector, data_disks);
+
+	pplhdr = page_address(io->header_page);
+
+	if (io->entries_count > 0) {
+		struct ppl_header_entry *last =
+				&pplhdr->entries[io->entries_count - 1];
+		u64 data_sector_last = le64_to_cpu(last->data_sector);
+		u32 data_size_last = le32_to_cpu(last->data_size);
+		u32 pp_size_last = le32_to_cpu(last->pp_size);
+
+		/*
+		 * Check if we can merge with the last entry. Must be on
+		 * the same stripe and disks. Use bit shift and logarithm
+		 * to avoid 64-bit division.
+		 */
+		if ((data_sector >> ilog2(conf->chunk_sectors) ==
+		     data_sector_last >> ilog2(conf->chunk_sectors)) &&
+		    ((pp_size_last == 0 &&
+		      test_bit(STRIPE_FULL_WRITE, &sh->state)) ||
+		     ((data_sector_last + (pp_size_last >> 9) == data_sector) &&
+		      (data_size_last == pp_size_last * data_disks))))
+			e = last;
+	}
+
+	if (!e) {
+		e = &pplhdr->entries[io->entries_count++];
+		e->data_sector = cpu_to_le64(data_sector);
+		e->parity_disk = cpu_to_le32(sh->pd_idx);
+		e->checksum = cpu_to_le32(~0);
+	}
+
+	le32_add_cpu(&e->data_size, data_disks << PAGE_SHIFT);
+
+	/* don't write any PP if full stripe write */
+	if (!test_bit(STRIPE_FULL_WRITE, &sh->state)) {
+		le32_add_cpu(&e->pp_size, PAGE_SIZE);
+		io->pp_size += PAGE_SIZE;
+		e->checksum = cpu_to_le32(crc32c_le(le32_to_cpu(e->checksum),
+						    page_address(sh->ppl_page),
+						    PAGE_SIZE));
+	}
+
+	list_add_tail(&sh->log_list, &io->stripe_list);
+	atomic_inc(&io->pending_stripes);
+	sh->ppl_log_io = io;
+
+	return 0;
+}
+
+int ppl_write_stripe(struct ppl_conf *ppl_conf, struct stripe_head *sh)
+{
+	struct ppl_log *log;
+	struct ppl_io_unit *io = sh->ppl_log_io;
+
+	if (io || test_bit(STRIPE_SYNCING, &sh->state) ||
+	    !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
+	    !test_bit(R5_Insync, &sh->dev[sh->pd_idx].flags)) {
+		clear_bit(STRIPE_LOG_TRAPPED, &sh->state);
+		return -EAGAIN;
+	}
+
+	log = &ppl_conf->child_logs[sh->pd_idx];
+
+	mutex_lock(&log->io_mutex);
+
+	if (!log->rdev || test_bit(Faulty, &log->rdev->flags)) {
+		mutex_unlock(&log->io_mutex);
+		return -EAGAIN;
+	}
+
+	set_bit(STRIPE_LOG_TRAPPED, &sh->state);
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	atomic_inc(&sh->count);
+
+	if (ppl_log_stripe(log, sh)) {
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&sh->log_list, &log->no_mem_stripes);
+		spin_unlock_irq(&log->io_list_lock);
+	}
+
+	mutex_unlock(&log->io_mutex);
+
+	return 0;
+}
+
+static void ppl_log_endio(struct bio *bio)
+{
+	struct ppl_io_unit *io = bio->bi_private;
+	struct ppl_log *log = io->log;
+	struct ppl_conf *ppl_conf = log->ppl_conf;
+	struct stripe_head *sh, *next;
+
+	pr_debug("%s: seq: %llu\n", __func__, io->seq);
+
+	if (bio->bi_error)
+		md_error(ppl_conf->mddev, log->rdev);
+
+	bio_put(bio);
+	mempool_free(io->header_page, ppl_conf->meta_pool);
+
+	list_for_each_entry_safe(sh, next, &io->stripe_list, log_list) {
+		list_del_init(&sh->log_list);
+
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+}
+
+static void ppl_submit_iounit(struct ppl_io_unit *io)
+{
+	struct ppl_log *log = io->log;
+	struct ppl_conf *ppl_conf = log->ppl_conf;
+	struct r5conf *conf = ppl_conf->mddev->private;
+	struct ppl_header *pplhdr = page_address(io->header_page);
+	struct bio *bio;
+	struct stripe_head *sh;
+	int i;
+	struct bio_list bios = BIO_EMPTY_LIST;
+	char b[BDEVNAME_SIZE];
+
+	bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, ppl_conf->bs);
+	bio->bi_private = io;
+	bio->bi_end_io = ppl_log_endio;
+	bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
+	bio->bi_bdev = log->rdev->bdev;
+	bio->bi_iter.bi_sector = log->rdev->ppl.sector;
+	bio_add_page(bio, io->header_page, PAGE_SIZE, 0);
+	bio_list_add(&bios, bio);
+
+	sh = list_first_entry(&io->stripe_list, struct stripe_head, log_list);
+
+	for (i = 0; i < io->entries_count; i++) {
+		struct ppl_header_entry *e = &pplhdr->entries[i];
+		u32 pp_size = le32_to_cpu(e->pp_size);
+		u32 data_size = le32_to_cpu(e->data_size);
+		u64 data_sector = le64_to_cpu(e->data_sector);
+		int stripes_count;
+
+		if (pp_size > 0)
+			stripes_count = pp_size >> PAGE_SHIFT;
+		else
+			stripes_count = (data_size /
+					 (conf->raid_disks -
+					  conf->max_degraded)) >> PAGE_SHIFT;
+
+		while (stripes_count--) {
+			/*
+			 * if entry without partial parity just skip its stripes
+			 * without adding pages to bio
+			 */
+			if (pp_size > 0 &&
+			    !bio_add_page(bio, sh->ppl_page, PAGE_SIZE, 0)) {
+				struct bio *prev = bio;
+
+				bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES,
+						       ppl_conf->bs);
+				bio->bi_opf = prev->bi_opf;
+				bio->bi_bdev = prev->bi_bdev;
+				bio->bi_iter.bi_sector = bio_end_sector(prev);
+				bio_add_page(bio, sh->ppl_page, PAGE_SIZE, 0);
+				bio_chain(bio, prev);
+				bio_list_add(&bios, bio);
+			}
+			sh = list_next_entry(sh, log_list);
+		}
+
+		pr_debug("%s: seq: %llu entry: %d data_sector: %llu pp_size: %u data_size: %u\n",
+			 __func__, io->seq, i, data_sector, pp_size, data_size);
+
+		e->data_sector = cpu_to_le64(data_sector >>
+					     ilog2(ppl_conf->block_size >> 9));
+		e->checksum = cpu_to_le32(~le32_to_cpu(e->checksum));
+	}
+
+	pplhdr->entries_count = cpu_to_le32(io->entries_count);
+	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PPL_HEADER_SIZE));
+
+	while ((bio = bio_list_pop(&bios))) {
+		pr_debug("%s: seq: %llu submit_bio() size: %u sector: %llu dev: %s\n",
+			 __func__, io->seq, bio->bi_iter.bi_size,
+			 (unsigned long long)bio->bi_iter.bi_sector,
+			 bdevname(bio->bi_bdev, b));
+		submit_bio(bio);
+	}
+}
+
+static void ppl_submit_current_io(struct ppl_log *log)
+{
+	struct ppl_io_unit *io;
+
+	spin_lock_irq(&log->io_list_lock);
+
+	io = list_first_entry_or_null(&log->io_list, struct ppl_io_unit,
+				      log_sibling);
+	if (io && io->submitted)
+		io = NULL;
+
+	spin_unlock_irq(&log->io_list_lock);
+
+	if (io) {
+		io->submitted = true;
+
+		if (io == log->current_io)
+			log->current_io = NULL;
+
+		ppl_submit_iounit(io);
+	}
+}
+
+void ppl_write_stripe_run(struct ppl_conf *ppl_conf)
+{
+	struct ppl_log *log;
+	int i;
+
+	for (i = 0; i < ppl_conf->count; i++) {
+		log = &ppl_conf->child_logs[i];
+
+		mutex_lock(&log->io_mutex);
+		ppl_submit_current_io(log);
+		mutex_unlock(&log->io_mutex);
+	}
+}
+
+static void ppl_io_unit_finished(struct ppl_io_unit *io)
+{
+	struct ppl_log *log = io->log;
+	unsigned long flags;
+
+	pr_debug("%s: seq: %llu\n", __func__, io->seq);
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+
+	list_del(&io->log_sibling);
+	mempool_free(io, log->ppl_conf->io_pool);
+
+	if (!list_empty(&log->no_mem_stripes)) {
+		struct stripe_head *sh = list_first_entry(&log->no_mem_stripes,
+							  struct stripe_head,
+							  log_list);
+		list_del_init(&sh->log_list);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		raid5_release_stripe(sh);
+	}
+
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+}
+
+void ppl_stripe_write_finished(struct stripe_head *sh)
+{
+	struct ppl_io_unit *io;
+
+	io = sh->ppl_log_io;
+	sh->ppl_log_io = NULL;
+
+	if (io && atomic_dec_and_test(&io->pending_stripes))
+		ppl_io_unit_finished(io);
+}
+
+void ppl_exit_log(struct ppl_conf *ppl_conf)
+{
+	kfree(ppl_conf->child_logs);
+
+	mempool_destroy(ppl_conf->meta_pool);
+	if (ppl_conf->bs)
+		bioset_free(ppl_conf->bs);
+	mempool_destroy(ppl_conf->io_pool);
+	kmem_cache_destroy(ppl_conf->io_kc);
+
+	kfree(ppl_conf);
+}
+
+static int ppl_validate_rdev(struct md_rdev *rdev)
+{
+	char b[BDEVNAME_SIZE];
+	int ppl_data_sectors;
+	int ppl_size_new;
+
+	/*
+	 * The configured PPL size must be enough to store
+	 * the header and (at the very least) partial parity
+	 * for one stripe. Round it down to ensure the data
+	 * space is cleanly divisible by stripe size.
+	 */
+	ppl_data_sectors = rdev->ppl.size - (PPL_HEADER_SIZE >> 9);
+
+	if (ppl_data_sectors > 0)
+		ppl_data_sectors = rounddown(ppl_data_sectors, STRIPE_SECTORS);
+
+	if (ppl_data_sectors <= 0) {
+		pr_warn("md/raid:%s: PPL space too small on %s\n",
+			mdname(rdev->mddev), bdevname(rdev->bdev, b));
+		return -ENOSPC;
+	}
+
+	ppl_size_new = ppl_data_sectors + (PPL_HEADER_SIZE >> 9);
+
+	if ((rdev->ppl.sector < rdev->data_offset &&
+	     rdev->ppl.sector + ppl_size_new > rdev->data_offset) ||
+	    (rdev->ppl.sector >= rdev->data_offset &&
+	     rdev->data_offset + rdev->sectors > rdev->ppl.sector)) {
+		pr_warn("md/raid:%s: PPL space overlaps with data on %s\n",
+			mdname(rdev->mddev), bdevname(rdev->bdev, b));
+		return -EINVAL;
+	}
+
+	if (!rdev->mddev->external &&
+	    ((rdev->ppl.offset > 0 && rdev->ppl.offset < (rdev->sb_size >> 9)) ||
+	     (rdev->ppl.offset <= 0 && rdev->ppl.offset + ppl_size_new > 0))) {
+		pr_warn("md/raid:%s: PPL space overlaps with superblock on %s\n",
+			mdname(rdev->mddev), bdevname(rdev->bdev, b));
+		return -EINVAL;
+	}
+
+	rdev->ppl.size = ppl_size_new;
+
+	return 0;
+}
+
+int ppl_init_log(struct r5conf *conf)
+{
+	struct ppl_conf *ppl_conf;
+	struct mddev *mddev = conf->mddev;
+	int ret = 0;
+	int i;
+	bool need_cache_flush;
+
+	if (PAGE_SIZE != 4096)
+		return -EINVAL;
+
+	if (mddev->bitmap_info.file || mddev->bitmap_info.offset) {
+		pr_warn("md/raid:%s PPL is not compatible with bitmap\n",
+			mdname(mddev));
+		return -EINVAL;
+	}
+
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		pr_warn("md/raid:%s PPL is not compatible with journal\n",
+			mdname(mddev));
+		return -EINVAL;
+	}
+
+	ppl_conf = kzalloc(sizeof(struct ppl_conf), GFP_KERNEL);
+	if (!ppl_conf)
+		return -ENOMEM;
+
+	ppl_conf->io_kc = KMEM_CACHE(ppl_io_unit, 0);
+	if (!ppl_conf->io_kc) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ppl_conf->io_pool = mempool_create_slab_pool(conf->raid_disks, ppl_conf->io_kc);
+	if (!ppl_conf->io_pool) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ppl_conf->bs = bioset_create(conf->raid_disks, 0);
+	if (!ppl_conf->bs) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ppl_conf->meta_pool = mempool_create_page_pool(conf->raid_disks, 0);
+	if (!ppl_conf->meta_pool) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ppl_conf->mddev = mddev;
+	ppl_conf->count = conf->raid_disks;
+	ppl_conf->child_logs = kcalloc(ppl_conf->count, sizeof(struct ppl_log),
+				       GFP_KERNEL);
+	if (!ppl_conf->child_logs) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	atomic64_set(&ppl_conf->seq, 0);
+
+	if (!mddev->external) {
+		ppl_conf->signature = ~crc32c_le(~0, mddev->uuid, sizeof(mddev->uuid));
+		ppl_conf->block_size = 512;
+	} else {
+		ppl_conf->block_size = queue_logical_block_size(mddev->queue);
+	}
+
+	for (i = 0; i < ppl_conf->count; i++) {
+		struct ppl_log *log = &ppl_conf->child_logs[i];
+		struct md_rdev *rdev = conf->disks[i].rdev;
+
+		mutex_init(&log->io_mutex);
+		spin_lock_init(&log->io_list_lock);
+		INIT_LIST_HEAD(&log->io_list);
+		INIT_LIST_HEAD(&log->no_mem_stripes);
+
+		log->ppl_conf = ppl_conf;
+		log->rdev = rdev;
+
+		if (rdev) {
+			struct request_queue *q;
+
+			ret = ppl_validate_rdev(rdev);
+			if (ret)
+				goto err;
+
+			q = bdev_get_queue(rdev->bdev);
+			if (test_bit(QUEUE_FLAG_WC, &q->queue_flags))
+				need_cache_flush = true;
+		}
+	}
+
+	if (need_cache_flush)
+		pr_warn("md/raid:%s: Volatile write-back cache should be disabled on all member drives when using PPL!\n",
+			mdname(mddev));
+
+	conf->ppl = ppl_conf;
+
+	return 0;
+err:
+	ppl_exit_log(ppl_conf);
+	return ret;
+}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 02e02fe5b04e..21440b594878 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -739,7 +739,7 @@ static bool stripe_can_batch(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 
-	if (conf->log)
+	if (conf->log || conf->ppl)
 		return false;
 	return test_bit(STRIPE_BATCH_READY, &sh->state) &&
 		!test_bit(STRIPE_BITMAP_PENDING, &sh->state) &&
@@ -936,6 +936,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		}
 	}
 
+	if (conf->ppl && ppl_write_stripe(conf->ppl, sh) == 0)
+		return;
+
 	for (i = disks; i--; ) {
 		int op, op_flags = 0;
 		int replace_only = 0;
@@ -3308,6 +3311,16 @@ static void stripe_set_idx(sector_t stripe, struct r5conf *conf, int previous,
 			     &dd_idx, sh);
 }
 
+static void log_stripe_write_finished(struct stripe_head *sh)
+{
+	struct r5conf *conf = sh->raid_conf;
+
+	if (conf->log)
+		r5l_stripe_write_finished(sh);
+	else if (conf->ppl)
+		ppl_stripe_write_finished(sh);
+}
+
 static void
 handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 				struct stripe_head_state *s, int disks,
@@ -3347,7 +3360,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		if (bi)
 			bitmap_end = 1;
 
-		r5l_stripe_write_finished(sh);
+		log_stripe_write_finished(sh);
 
 		if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
 			wake_up(&conf->wait_for_overlap);
@@ -3766,7 +3779,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 				discard_pending = 1;
 		}
 
-	r5l_stripe_write_finished(sh);
+	log_stripe_write_finished(sh);
 
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
@@ -4756,7 +4769,7 @@ static void handle_stripe(struct stripe_head *sh)
 
 	if (s.just_cached)
 		r5c_handle_cached_data_endio(conf, sh, disks, &s.return_bi);
-	r5l_stripe_write_finished(sh);
+	log_stripe_write_finished(sh);
 
 	/* Now we might consider reading some blocks, either to check/generate
 	 * parity, or to satisfy requests
@@ -6120,6 +6133,14 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	return handled;
 }
 
+static void log_write_stripe_run(struct r5conf *conf)
+{
+	if (conf->log)
+		r5l_write_stripe_run(conf->log);
+	else if (conf->ppl)
+		ppl_write_stripe_run(conf->ppl);
+}
+
 static int handle_active_stripes(struct r5conf *conf, int group,
 				 struct r5worker *worker,
 				 struct list_head *temp_inactive_list)
@@ -6157,7 +6178,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 
 	for (i = 0; i < batch_size; i++)
 		handle_stripe(batch[i]);
-	r5l_write_stripe_run(conf->log);
+	log_write_stripe_run(conf);
 
 	cond_resched();
 
@@ -6735,6 +6756,8 @@ static void free_conf(struct r5conf *conf)
 
 	if (conf->log)
 		r5l_exit_log(conf->log);
+	if (conf->ppl)
+		ppl_exit_log(conf->ppl);
 	if (conf->shrinker.nr_deferred)
 		unregister_shrinker(&conf->shrinker);
 
@@ -7196,6 +7219,13 @@ static int raid5_run(struct mddev *mddev)
 		BUG_ON(mddev->delta_disks != 0);
 	}
 
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags) &&
+	    test_bit(MD_HAS_PPL, &mddev->flags)) {
+		pr_warn("md/raid:%s: using journal device and PPL not allowed - disabling PPL\n",
+			mdname(mddev));
+		clear_bit(MD_HAS_PPL, &mddev->flags);
+	}
+
 	if (mddev->private == NULL)
 		conf = setup_conf(mddev);
 	else
@@ -7422,6 +7452,11 @@ static int raid5_run(struct mddev *mddev)
 			 mdname(mddev), bdevname(journal_dev->bdev, b));
 		if (r5l_init_log(conf, journal_dev))
 			goto abort;
+	} else if (test_bit(MD_HAS_PPL, &mddev->flags)) {
+		pr_debug("md/raid:%s: enabling distributed Partial Parity Log\n",
+			 mdname(mddev));
+		if (ppl_init_log(conf))
+			goto abort;
 	}
 
 	return 0;
@@ -7690,7 +7725,7 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	sector_t newsize;
 	struct r5conf *conf = mddev->private;
 
-	if (conf->log)
+	if (conf->log || conf->ppl)
 		return -EINVAL;
 	sectors &= ~((sector_t)conf->chunk_sectors - 1);
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
@@ -7743,7 +7778,7 @@ static int check_reshape(struct mddev *mddev)
 {
 	struct r5conf *conf = mddev->private;
 
-	if (conf->log)
+	if (conf->log || conf->ppl)
 		return -EINVAL;
 	if (mddev->delta_disks == 0 &&
 	    mddev->new_layout == mddev->layout &&
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 3cc4cb28f7e6..f915a7a0e752 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -230,6 +230,7 @@ struct stripe_head {
 	struct list_head	r5c; /* for r5c_cache->stripe_in_journal */
 
 	struct page		*ppl_page; /* partial parity of this stripe */
+	struct ppl_io_unit	*ppl_log_io;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -689,6 +690,7 @@ struct r5conf {
 	int			group_cnt;
 	int			worker_cnt_per_group;
 	struct r5l_log		*log;
+	struct ppl_conf		*ppl;
 
 	struct bio_list		pending_bios;
 	spinlock_t		pending_bios_lock;
@@ -798,4 +800,10 @@ extern void r5c_check_cached_full_stripe(struct r5conf *conf);
 extern struct md_sysfs_entry r5c_journal_mode;
 extern void r5c_update_on_rdev_error(struct mddev *mddev);
 extern bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect);
+
+extern int ppl_init_log(struct r5conf *conf);
+extern void ppl_exit_log(struct ppl_conf *log);
+extern int ppl_write_stripe(struct ppl_conf *log, struct stripe_head *sh);
+extern void ppl_write_stripe_run(struct ppl_conf *log);
+extern void ppl_stripe_write_finished(struct stripe_head *sh);
 #endif
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index fe2112810c43..2c28711cc5f1 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -398,4 +398,30 @@ struct r5l_meta_block {
 
 #define R5LOG_VERSION 0x1
 #define R5LOG_MAGIC 0x6433c509
+
+struct ppl_header_entry {
+	__le64 data_sector;	/* Raid sector of the new data */
+	__le32 pp_size;		/* Length of partial parity */
+	__le32 data_size;	/* Length of data */
+	__le32 parity_disk;	/* Member disk containing parity */
+	__le32 checksum;	/* Checksum of this entry */
+} __attribute__ ((__packed__));
+
+#define PPL_HEADER_SIZE 4096
+#define PPL_HDR_RESERVED 512
+#define PPL_HDR_ENTRY_SPACE \
+	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))
+#define PPL_HDR_MAX_ENTRIES \
+	(PPL_HDR_ENTRY_SPACE / sizeof(struct ppl_header_entry))
+
+struct ppl_header {
+	__u8 reserved[PPL_HDR_RESERVED];/* Reserved space */
+	__le32 signature;		/* Signature (family number of volume) */
+	__le32 padding;
+	__le64 generation;		/* Generation number of PP Header */
+	__le32 entries_count;		/* Number of entries in entry array */
+	__le32 checksum;		/* Checksum of PP Header */
+	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
+} __attribute__ ((__packed__));
+
 #endif
-- 
2.11.0

