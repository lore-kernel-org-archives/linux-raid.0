From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 05/12] raid5-ppl: Partial Parity Log implementation
Date: Mon,  5 Dec 2016 16:31:06 +0100
Message-ID: <20161205153113.7268-6-artur.paszkiewicz@intel.com>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This implements the write logging functionality, using the policy logic
introduced in previous patches.

PPL is a distributed log - data is stored on all RAID member drives in
the metadata area. PPL is written to the parity disk of a particular
stripe. Distributed log is implemented by using one r5l_log instance per
each array member. They are grouped in child_logs array in struct
ppl_conf, which is assigned to a common parent log. This parent log
serves as a proxy and is used in raid5 personality code - it is assigned
as _the_ log in r5conf->log. The child logs are where all the real work
is done.

The PPL consists of a 4KB header (struct ppl_header), and at least 128KB
for partial parity data. It is stored right after the array data (for
IMSM) or in the bitmap area (super 1.1 and 1.2) and can be overwritten
even at each array write request.

Attach a page for holding the partial parity data to each stripe_head.
Allocate it only if mddev has the MD_HAS_PPL flag set.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-cache.c |  12 +-
 drivers/md/raid5-cache.h |   6 +
 drivers/md/raid5-ppl.c   | 594 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/raid5.c       |  15 +-
 drivers/md/raid5.h       |   1 +
 5 files changed, 620 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index fa82b9a..be534d8 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -119,8 +119,8 @@ static bool r5l_has_free_space(struct r5l_log *log, sector_t size)
 	return log->device_size > used_size + size;
 }
 
-static void __r5l_set_io_unit_state(struct r5l_io_unit *io,
-				    enum r5l_io_unit_state state)
+void __r5l_set_io_unit_state(struct r5l_io_unit *io,
+			     enum r5l_io_unit_state state)
 {
 	if (WARN_ON(io->state >= state))
 		return;
@@ -340,7 +340,7 @@ static void r5c_finish_cache_stripe(struct stripe_head *sh)
 	}
 }
 
-static void r5l_io_run_stripes(struct r5l_io_unit *io)
+void r5l_io_run_stripes(struct r5l_io_unit *io)
 {
 	struct stripe_head *sh, *next;
 
@@ -935,7 +935,7 @@ static sector_t r5l_reclaimable_space(struct r5l_log *log)
 				 r5c_calculate_new_cp(conf));
 }
 
-static void r5l_run_no_mem_stripe(struct r5l_log *log)
+void r5l_run_no_mem_stripe(struct r5l_log *log)
 {
 	struct stripe_head *sh;
 
@@ -1039,7 +1039,7 @@ static void r5l_log_flush_endio(struct bio *bio)
  * only write stripes of an io_unit to raid disks till the io_unit is the first
  * one whose data/parity is in log.
  */
-static void __r5l_flush_stripe_to_raid(struct r5l_log *log)
+void __r5l_flush_stripe_to_raid(struct r5l_log *log)
 {
 	bool do_flush;
 
@@ -1359,7 +1359,7 @@ bool r5l_log_disk_error(struct r5conf *conf)
 	if (!log)
 		ret = test_bit(MD_HAS_JOURNAL, &conf->mddev->flags);
 	else
-		ret = test_bit(Faulty, &log->rdev->flags);
+		ret = log->rdev && test_bit(Faulty, &log->rdev->flags);
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/drivers/md/raid5-cache.h b/drivers/md/raid5-cache.h
index 4ba11d3..0446100 100644
--- a/drivers/md/raid5-cache.h
+++ b/drivers/md/raid5-cache.h
@@ -157,4 +157,10 @@ extern int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio);
 extern void r5l_quiesce(struct r5l_log *log, int state);
 extern bool r5l_log_disk_error(struct r5conf *conf);
 
+extern void __r5l_set_io_unit_state(struct r5l_io_unit *io,
+				    enum r5l_io_unit_state state);
+extern void r5l_io_run_stripes(struct r5l_io_unit *io);
+extern void r5l_run_no_mem_stripe(struct r5l_log *log);
+extern void __r5l_flush_stripe_to_raid(struct r5l_log *log);
+
 #endif /* _RAID5_CACHE_H */
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 263fad7..2d4c90f 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -14,7 +14,599 @@
 
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/crc32c.h>
+#include <linux/module.h>
+#include <linux/raid/md_p.h>
+#include "md.h"
 #include "raid5.h"
 #include "raid5-cache.h"
 
-struct r5l_policy r5l_ppl;
+static bool ppl_debug;
+module_param(ppl_debug, bool, 0644);
+MODULE_PARM_DESC(ppl_debug, "Debug mode for md raid5 PPL");
+
+#define dbg(format, args...)						\
+do {									\
+	if (ppl_debug)							\
+		printk(KERN_DEBUG"[%d] %s() "format,			\
+			current->pid, __func__, ##args);		\
+} while (0)
+
+struct ppl_conf {
+	int count;
+	struct r5l_log **child_logs;
+};
+
+struct ppl_header_entry {
+	__le64 data_sector;	/* Raid sector of the new data */
+	__le32 pp_size;		/* Length of partial parity */
+	__le32 data_size;	/* Length of data */
+	__u8 parity_disk;	/* Member disk containing parity */
+	__le32 checksum;	/* Checksum of this entry */
+} __packed;
+
+#define PPL_HEADER_SIZE PAGE_SIZE
+#define PPL_HDR_RESERVED 512
+#define PPL_HDR_ENTRY_SPACE \
+	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 3 * sizeof(u32) - sizeof(u64))
+#define PPL_HDR_MAX_ENTRIES \
+	(PPL_HDR_ENTRY_SPACE / sizeof(struct ppl_header_entry))
+#define PPL_ENTRY_SPACE_IMSM (128 * 1024)
+
+struct ppl_header {
+	__u8 reserved[PPL_HDR_RESERVED];/* Reserved space */
+	__le32 signature;		/* Signature (family number of volume) */
+	__le64 generation;		/* Generation number of PP Header */
+	__le32 entries_count;		/* Number of entries in entry array */
+	__le32 checksum;		/* Checksum of PP Header */
+	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
+} __packed;
+
+static void ppl_log_endio(struct bio *bio)
+{
+	struct r5l_io_unit *io = bio->bi_private;
+	struct r5l_log *log = io->log;
+	unsigned long flags;
+
+	dbg("io %p seq: %llu\n", io, io->seq);
+
+	if (bio->bi_error)
+		md_error(log->rdev->mddev, log->rdev);
+
+	bio_put(bio);
+	mempool_free(io->meta_page, log->meta_pool);
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	__r5l_set_io_unit_state(io, IO_UNIT_IO_END);
+	if (log->need_cache_flush) {
+		list_move_tail(&io->log_sibling, &log->io_end_ios);
+	} else {
+		list_move_tail(&io->log_sibling, &log->finished_ios);
+		r5l_io_run_stripes(io);
+	}
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+
+	if (log->need_cache_flush)
+		md_wakeup_thread(log->rdev->mddev->thread);
+}
+
+static struct r5l_io_unit *ppl_new_iounit(struct r5l_log *log,
+					  struct stripe_head *sh)
+{
+	struct r5l_io_unit *io;
+	struct ppl_header *pplhdr;
+	struct r5conf *conf = log->rdev->mddev->private;
+	struct r5l_log *parent_log = conf->log;
+
+	io = mempool_alloc(log->io_pool, GFP_ATOMIC);
+	if (!io)
+		return NULL;
+
+	memset(io, 0, sizeof(*io));
+	io->log = log;
+	INIT_LIST_HEAD(&io->log_sibling);
+	INIT_LIST_HEAD(&io->stripe_list);
+	io->state = IO_UNIT_RUNNING;
+
+	io->meta_page = mempool_alloc(log->meta_pool, GFP_NOIO);
+	pplhdr = page_address(io->meta_page);
+	clear_page(pplhdr);
+	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
+	pplhdr->signature = cpu_to_le32(log->uuid_checksum);
+
+	io->current_bio = bio_alloc_bioset(GFP_NOIO, BIO_MAX_PAGES, log->bs);
+	bio_set_op_attrs(io->current_bio, REQ_OP_WRITE, 0);
+
+	io->current_bio->bi_bdev = log->rdev->bdev;
+	io->current_bio->bi_iter.bi_sector = log->rdev->ppl.sector;
+	io->current_bio->bi_end_io = ppl_log_endio;
+	io->current_bio->bi_private = io;
+	bio_add_page(io->current_bio, io->meta_page, PAGE_SIZE, 0);
+
+	spin_lock(&parent_log->io_list_lock);
+	io->seq = parent_log->seq++;
+	spin_unlock(&parent_log->io_list_lock);
+	pplhdr->generation = cpu_to_le64(io->seq);
+
+	return io;
+}
+
+static int ppl_log_stripe(struct r5l_log *log, struct stripe_head *sh)
+{
+	struct r5l_io_unit *io;
+	struct ppl_header *pplhdr;
+	struct ppl_header_entry *pplhdr_entry = NULL;
+	int i;
+	sector_t data_sector;
+	unsigned long flags;
+	int data_disks = 0;
+	unsigned int entry_space = (log->rdev->ppl.size << 9) - PPL_HEADER_SIZE;
+	struct r5conf *conf = log->rdev->mddev->private;
+
+	dbg("<%llu>\n", (unsigned long long)sh->sector);
+
+	io = log->current_io;
+	if (!io) {
+		io = ppl_new_iounit(log, sh);
+		if (!io)
+			return -ENOMEM;
+		spin_lock_irqsave(&log->io_list_lock, flags);
+		list_add_tail(&io->log_sibling, &log->running_ios);
+		spin_unlock_irqrestore(&log->io_list_lock, flags);
+	} else {
+		pplhdr = page_address(io->meta_page);
+		if (io->meta_offset >= entry_space ||
+		    pplhdr->entries_count == PPL_HDR_MAX_ENTRIES) {
+			/*
+			 * this io_unit is full - set meta_offset to -1 to
+			 * indicate that other units are waiting for this one
+			 */
+			io->meta_offset = -1;
+
+			dbg("add blocked io_unit by %p seq: %llu\n",
+			    io, io->seq);
+
+			io = ppl_new_iounit(log, sh);
+			if (!io) {
+				log->current_io->meta_offset = entry_space;
+				return -ENOMEM;
+			}
+			/*
+			 * reuse need_split_bio to mark that this io_unit is
+			 * blocked by an other
+			 */
+			io->need_split_bio = true;
+
+			spin_lock_irqsave(&log->io_list_lock, flags);
+			list_add_tail(&io->log_sibling, &log->running_ios);
+			spin_unlock_irqrestore(&log->io_list_lock, flags);
+		}
+	}
+
+	log->current_io = io;
+	io->meta_offset += PAGE_SIZE;
+
+	for (i = 0; i < sh->disks; i++) {
+		struct r5dev *dev = &sh->dev[i];
+		if (i != sh->pd_idx && test_bit(R5_LOCKED, &dev->flags)) {
+			if (!data_disks)
+				data_sector = dev->sector;
+			data_disks++;
+		}
+	}
+	BUG_ON(!data_disks);
+
+	dbg("io: %p seq: %llu data_sector: %llu data_disks: %d\n",
+	    io, io->seq, (unsigned long long)data_sector, data_disks);
+	pplhdr = page_address(io->meta_page);
+
+	if (pplhdr->entries_count > 0) {
+		/* check if we can merge with the previous entry */
+		struct ppl_header_entry *prev;
+		prev = &pplhdr->entries[pplhdr->entries_count-1];
+
+		if ((prev->data_sector + (prev->pp_size >> 9) == data_sector) &&
+		    (prev->data_size == prev->pp_size * data_disks) &&
+		    (data_sector >> ilog2(sh->raid_conf->chunk_sectors) ==
+		     prev->data_sector >> ilog2(sh->raid_conf->chunk_sectors)))
+			pplhdr_entry = prev;
+	}
+
+	if (pplhdr_entry) {
+		pplhdr_entry->data_size += PAGE_SIZE * data_disks;
+		pplhdr_entry->pp_size += PAGE_SIZE;
+	} else {
+		pplhdr_entry = &pplhdr->entries[pplhdr->entries_count++];
+		pplhdr_entry->data_sector = data_sector;
+		pplhdr_entry->data_size = PAGE_SIZE * data_disks;
+		pplhdr_entry->pp_size = PAGE_SIZE;
+		pplhdr_entry->parity_disk = sh->pd_idx;
+	}
+
+	/* don't write any PP if full stripe write */
+	if (pplhdr_entry->pp_size >> 9 == conf->chunk_sectors &&
+	    pplhdr_entry->data_size == pplhdr_entry->pp_size *
+	      (conf->raid_disks - conf->max_degraded)) {
+		io->meta_offset -= pplhdr_entry->pp_size;
+		pplhdr_entry->pp_size = 0;
+	}
+
+	list_add_tail(&sh->log_list, &io->stripe_list);
+	atomic_inc(&io->pending_stripe);
+	sh->log_io = io;
+
+	return 0;
+}
+
+static int ppl_write_stripe(struct r5l_log *log, struct stripe_head *sh)
+{
+	struct r5l_io_unit *io = sh->log_io;
+
+	if (io || !test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
+	    test_bit(STRIPE_SYNCING, &sh->state) || !log || !log->rdev ||
+	    test_bit(Faulty, &log->rdev->flags)) {
+		clear_bit(STRIPE_LOG_TRAPPED, &sh->state);
+		return -EAGAIN;
+	}
+
+	set_bit(STRIPE_LOG_TRAPPED, &sh->state);
+	clear_bit(STRIPE_DELAYED, &sh->state);
+	atomic_inc(&sh->count);
+
+	mutex_lock(&log->io_mutex);
+	if (ppl_log_stripe(log, sh)) {
+		spin_lock_irq(&log->io_list_lock);
+		list_add_tail(&sh->log_list, &log->no_mem_stripes);
+		spin_unlock_irq(&log->io_list_lock);
+	}
+	mutex_unlock(&log->io_mutex);
+
+	return 0;
+}
+
+static void ppl_submit_iounit(struct r5l_io_unit *io)
+{
+	struct mddev *mddev = io->log->rdev->mddev;
+	struct r5conf *conf = mddev->private;
+	int block_size = queue_logical_block_size(mddev->queue);
+	struct ppl_header *pplhdr = page_address(io->meta_page);
+	struct bio *bio = io->current_bio;
+	struct stripe_head *sh;
+	int i;
+	struct bio_list bios = BIO_EMPTY_LIST;
+
+	dbg("io %p seq: %llu\n", io, io->seq);
+
+	sh = list_first_entry(&io->stripe_list, struct stripe_head, log_list);
+	bio_list_add(&bios, io->current_bio);
+
+	for (i = 0; i < pplhdr->entries_count; i++) {
+		struct ppl_header_entry *e = &pplhdr->entries[i];
+		u32 pp_size = e->pp_size;
+		u32 crc = ~0;
+
+		if (pp_size == 0) {
+			pp_size = conf->chunk_sectors << 9;
+			while (pp_size) {
+				pp_size -= PAGE_SIZE;
+				sh = list_next_entry(sh, log_list);
+			}
+		}
+
+		while (pp_size) {
+			struct page *pp_page;
+
+			if (test_bit(STRIPE_FULL_WRITE, &sh->state))
+				pp_page = ZERO_PAGE(0);
+			else
+				pp_page = sh->ppl_page;
+
+			crc = crc32c_le(crc, page_address(pp_page), PAGE_SIZE);
+
+			if (!bio_add_page(bio, pp_page, PAGE_SIZE, 0)) {
+				struct bio *bio2;
+				bio2 = bio_alloc_bioset(GFP_NOIO,
+							BIO_MAX_PAGES,
+							io->log->bs);
+				bio_set_op_attrs(bio2, REQ_OP_WRITE, 0);
+				bio2->bi_bdev = bio->bi_bdev;
+				bio2->bi_iter.bi_sector =
+						bio->bi_iter.bi_sector +
+						bio_sectors(bio);
+				bio_add_page(bio2, pp_page, PAGE_SIZE, 0);
+				bio_chain(bio2, io->current_bio);
+				bio_list_add(&bios, bio2);
+				bio = bio2;
+			}
+
+			pp_size -= PAGE_SIZE;
+			sh = list_next_entry(sh, log_list);
+		}
+
+		dbg("entry: %d, data sector: %llu, PPL size: %u, data size %u\n",
+		    i, e->data_sector, e->pp_size, e->data_size);
+
+		e->data_sector = cpu_to_le64(e->data_sector >>
+				 ilog2(block_size >> 9));
+		e->pp_size = cpu_to_le32(e->pp_size);
+		e->data_size = cpu_to_le32(e->data_size);
+		e->checksum = cpu_to_le32(~crc);
+	}
+	pplhdr->entries_count = cpu_to_le32(pplhdr->entries_count);
+	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PAGE_SIZE));
+
+	while ((bio = bio_list_pop(&bios))) {
+		dbg("submit_bio() size: %u sector: %llu dev: %s\n",
+		    bio->bi_iter.bi_size,
+		    (unsigned long long)bio->bi_iter.bi_sector,
+		    bio->bi_bdev->bd_disk->disk_name);
+		submit_bio(bio);
+	}
+}
+
+static void ppl_submit_current_io(struct r5l_log *log)
+{
+	struct r5l_io_unit *io, *io_submit = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	list_for_each_entry(io, &log->running_ios, log_sibling) {
+		if (io->state >= IO_UNIT_IO_START)
+			break;
+
+		if (io->state == IO_UNIT_RUNNING && !io->need_split_bio) {
+			__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
+
+			if (io == log->current_io) {
+				BUG_ON(io->meta_offset < 0);
+				log->current_io = NULL;
+			}
+
+			io_submit = io;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+
+	if (io_submit)
+		ppl_submit_iounit(io_submit);
+}
+
+static void ppl_write_stripe_run(struct r5l_log *log)
+{
+	mutex_lock(&log->io_mutex);
+	ppl_submit_current_io(log);
+	mutex_unlock(&log->io_mutex);
+}
+
+static void __ppl_stripe_write_finished(struct r5l_io_unit *io)
+{
+	struct r5l_log *log = io->log;
+	unsigned long flags;
+
+	dbg("io %p seq: %llu\n", io, io->seq);
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+
+	if (io->meta_offset < 0) {
+		struct r5l_io_unit *io_next = list_first_entry(&log->running_ios,
+				struct r5l_io_unit, log_sibling);
+		BUG_ON(!io_next->need_split_bio);
+		io_next->need_split_bio = false;
+	}
+
+	list_del(&io->log_sibling);
+	mempool_free(io, log->io_pool);
+	r5l_run_no_mem_stripe(log);
+
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+}
+
+static void ppl_exit_log_child(struct r5l_log *log)
+{
+	clear_bit(JournalPpl, &log->rdev->flags);
+	kfree(log);
+}
+
+static void __ppl_exit_log(struct r5l_log *log)
+{
+	struct ppl_conf *ppl_conf = log->private;
+
+	if (ppl_conf->child_logs) {
+		struct r5l_log *log_child;
+		int i;
+
+		for (i = 0; i < ppl_conf->count; i++) {
+			log_child = ppl_conf->child_logs[i];
+			if (!log_child)
+				continue;
+
+			clear_bit(MD_HAS_PPL, &log_child->rdev->mddev->flags);
+			ppl_exit_log_child(log_child);
+		}
+		kfree(ppl_conf->child_logs);
+	}
+	kfree(ppl_conf);
+
+	mempool_destroy(log->meta_pool);
+	if (log->bs)
+		bioset_free(log->bs);
+	mempool_destroy(log->io_pool);
+	kmem_cache_destroy(log->io_kc);
+}
+
+static int ppl_init_log_child(struct r5l_log *log_parent,
+			      struct md_rdev *rdev, struct r5l_log **log_child)
+{
+	struct r5l_log *log;
+	struct request_queue *q;
+
+	log = kzalloc(sizeof(struct r5l_log), GFP_KERNEL);
+	if (!log)
+		return -ENOMEM;
+
+	*log_child = log;
+	log->rdev = rdev;
+
+	mutex_init(&log->io_mutex);
+	spin_lock_init(&log->io_list_lock);
+	INIT_LIST_HEAD(&log->running_ios);
+	INIT_LIST_HEAD(&log->io_end_ios);
+	INIT_LIST_HEAD(&log->flushing_ios);
+	INIT_LIST_HEAD(&log->finished_ios);
+	INIT_LIST_HEAD(&log->no_mem_stripes);
+	bio_init(&log->flush_bio);
+
+	log->io_kc = log_parent->io_kc;
+	log->io_pool = log_parent->io_pool;
+	log->bs = log_parent->bs;
+	log->meta_pool = log_parent->meta_pool;
+	log->uuid_checksum = log_parent->uuid_checksum;
+
+	if (rdev->mddev->external) {
+		log->rdev->ppl.sector = log->rdev->data_offset +
+					log->rdev->sectors;
+		log->rdev->ppl.size = (PPL_HEADER_SIZE +
+				       PPL_ENTRY_SPACE_IMSM) >> 9;
+	} else {
+		log->rdev->ppl.sector = log->rdev->sb_start +
+					log->rdev->ppl.offset;
+	}
+	log->policy = log_parent->policy;
+	q = bdev_get_queue(log->rdev->bdev);
+	log->need_cache_flush = test_bit(QUEUE_FLAG_WC, &q->queue_flags) != 0;
+
+	set_bit(JournalPpl, &rdev->flags);
+
+	return 0;
+}
+
+static int __ppl_init_log(struct r5l_log *log, struct r5conf *conf)
+{
+	struct ppl_conf *ppl_conf;
+	struct mddev *mddev = conf->mddev;
+	int ret;
+	int i;
+
+	if (PAGE_SIZE != 4096)
+		return -EINVAL;
+
+	ppl_conf = kzalloc(sizeof(struct ppl_conf), GFP_KERNEL);
+	if (!ppl_conf)
+		return -ENOMEM;
+	log->private = ppl_conf;
+
+	if (!mddev->external)
+		log->uuid_checksum = crc32c_le(~0, mddev->uuid,
+					       sizeof(mddev->uuid));
+
+	if (mddev->bitmap) {
+		pr_err("PPL is not compatible with bitmap\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	spin_lock_init(&log->io_list_lock);
+
+	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
+	if (!log->io_kc) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	log->io_pool = mempool_create_slab_pool(conf->raid_disks, log->io_kc);
+	if (!log->io_pool) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	log->bs = bioset_create(conf->raid_disks, 0);
+	if (!log->bs) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	log->meta_pool = mempool_create_page_pool(conf->raid_disks, 0);
+	if (!log->meta_pool) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	log->need_cache_flush = true;
+
+	ppl_conf->count = conf->raid_disks;
+	ppl_conf->child_logs = kzalloc(sizeof(struct r5l_log *) * ppl_conf->count,
+				       GFP_KERNEL);
+	if (!ppl_conf->child_logs) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	for (i = 0; i < ppl_conf->count; i++) {
+		struct r5l_log *log_child;
+		struct md_rdev *rdev = conf->disks[i].rdev;
+
+		if (!rdev)
+			continue;
+
+		ret = ppl_init_log_child(log, rdev, &log_child);
+		if (ret)
+			goto err;
+
+		ppl_conf->child_logs[i] = log_child;
+	}
+
+	rcu_assign_pointer(conf->log, log);
+	set_bit(MD_HAS_PPL, &mddev->flags);
+
+	return 0;
+err:
+	__ppl_exit_log(log);
+	return ret;
+}
+
+static int __ppl_write_stripe(struct r5l_log *log, struct stripe_head *sh)
+{
+	struct ppl_conf *ppl_conf = log->private;
+	struct r5l_log *log_child = ppl_conf->child_logs[sh->pd_idx];
+
+	return ppl_write_stripe(log_child, sh);
+}
+
+static void __ppl_write_stripe_run(struct r5l_log *log)
+{
+	struct ppl_conf *ppl_conf = log->private;
+	struct r5l_log *log_child;
+	int i;
+
+	for (i = 0; i < ppl_conf->count; i++) {
+		log_child = ppl_conf->child_logs[i];
+		if (log_child)
+			ppl_write_stripe_run(log_child);
+	}
+}
+
+static void __ppl_flush_stripe_to_raid(struct r5l_log *log)
+{
+	struct ppl_conf *ppl_conf = log->private;
+	struct r5l_log *log_child;
+	int i;
+
+	for (i = 0; i < ppl_conf->count; i++) {
+		log_child = ppl_conf->child_logs[i];
+		if (log_child)
+			__r5l_flush_stripe_to_raid(log_child);
+	}
+}
+
+struct r5l_policy r5l_ppl = {
+	.init_log = __ppl_init_log,
+	.exit_log = __ppl_exit_log,
+	.write_stripe = __ppl_write_stripe,
+	.write_stripe_run = __ppl_write_stripe_run,
+	.flush_stripe_to_raid = __ppl_flush_stripe_to_raid,
+	.stripe_write_finished = __ppl_stripe_write_finished,
+	.handle_flush_request = NULL,
+	.quiesce = NULL,
+};
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a7e993a..77a503d3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -464,6 +464,11 @@ static void shrink_buffers(struct stripe_head *sh)
 		sh->dev[i].page = NULL;
 		put_page(p);
 	}
+
+	if (sh->ppl_page) {
+		put_page(sh->ppl_page);
+		sh->ppl_page = NULL;
+	}
 }
 
 static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
@@ -480,6 +485,13 @@ static int grow_buffers(struct stripe_head *sh, gfp_t gfp)
 		sh->dev[i].page = page;
 		sh->dev[i].orig_page = page;
 	}
+
+	if (test_bit(MD_HAS_PPL, &sh->raid_conf->mddev->flags)) {
+		sh->ppl_page = alloc_page(gfp);
+		if (!sh->ppl_page)
+			return 1;
+	}
+
 	return 0;
 }
 
@@ -875,7 +887,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
-	if (!test_bit(STRIPE_R5C_CACHING, &sh->state)) {
+	if (!test_bit(STRIPE_R5C_CACHING, &sh->state) ||
+	    test_bit(MD_HAS_PPL, &conf->mddev->flags)) {
 		/* writing out phase */
 		if (s->waiting_extra_page)
 			return;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 315d6ea..4a0d7b3 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -228,6 +228,7 @@ struct stripe_head {
 	struct list_head	log_list;
 	sector_t		log_start; /* first meta block on the journal */
 	struct list_head	r5c; /* for r5c_cache->stripe_in_journal */
+	struct page		*ppl_page;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
-- 
2.10.1

