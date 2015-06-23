From: Shaohua Li <shli@fb.com>
Subject: [PATCH V4 03/13] raid5: cache log handling
Date: Tue, 23 Jun 2015 14:37:53 -0700
Message-ID: <bb5d31352bc261d313eddf264ef40628030b0309.1435094582.git.shli@fb.com>
References: <cover.1435094582.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1435094582.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

This is the log handling part of raid5 cache. I divided cache into two
parts. One is log, which handles IO to cache disk and isn't aware how we
track cache data. The other is cache, which handles data tracking and
in-memory caching, it delegates IO store to log. The structures and
functions with r5l_ are for log, and those with r5c_ are for cache, but
there might be some exceptions we can't restrictly destinguish.

The cache disk will be organized as a simple ring buffer log. Logically
it looks like this:
|super|meta data|data|...|meta data|parity data|...|flush_start|...|flush_end|

super/meta data/flush_start/flush_end always use a single block. Block
size could be 512 to 4k.

super records raid array charactics to make sure raid array and cache
disk match. It also records some other parameters like log tail and
block size.

For IO data, meta data is a tuple of (raid_sector, io length, checksum),
which will be appended to the log, data follows; for raid 5/6 parity,
meta data is a tuple of (stripe_sector, parity length, checksum), which
will be appended to the log, parity data follows. meta data is stored in
a meta data block(r5l_meta_block).

meta data block is essentially a tuple (sequence, metadata length). The
sequence number is monotonously increased and can be used for integrity
checking and ordering track. A meta data block can have a mix of data
meta data tuple and parity meta data tuple. How many tuples will be
stored in meta data block depends on the inflight data/parity should be
dispatched. meta data block might only store one tuple.

We don't have in-disk index for the data appended to the log. So either
we can rebuild an in-memory index at startup with scanning the whole
log, or we can flush all data from cache disk to raid disks at shutdown
so cache disk has no valid data. Current code chooses the second option,
but this can be easily changed.

flush_start/flush_end block look like meta data block, but are to track
reclaim stream. Data stored there is stripe sector which starts/ends
flush to raid disks. More details are in reclaim and recover patches.

Crash recovery or startup will scan the log to read the metadata and
rebuild in-memory index. If metadata is broken at the head of the log,
even metadata afterward is ok, the scanning will not work well. So we
take some steps to mitigate the issue:
-A flush request is sent to cache disk every second to relieve the issue
(this isn't a must-have but a worst case defence, since reclaim will
always flush disk cache)
-FLUSH/FUA request is carefully handled. FLUSH/FUA will only be
dispatched after all previous requests finish.

To maintain the ordering, all IO are added into a list, flush/fua IO can
only be dispatched when they are the first entry of the list. Other IO
don't have such limitation. More details can be found in the comments of
r5l_io_unit.

r5l_task is the bridge between log part and cache part. Cache part
dispatches a task to log for IO. After task is finished, task returns
corresponding data/metadata position and sequence number where the task
data is stored in log.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid5-cache.c       | 1317 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/raid/md_p.h |   76 +++
 2 files changed, 1393 insertions(+)
 create mode 100644 drivers/md/raid5-cache.c

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
new file mode 100644
index 0000000..d6b7c64
--- /dev/null
+++ b/drivers/md/raid5-cache.c
@@ -0,0 +1,1317 @@
+/*
+ * A caching layer for raid 4/5/6
+ *
+ * Copyright (C) 2015 Shaohua Li <shli@fb.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/raid/md_p.h>
+#include <linux/crc32.h>
+#include <linux/list_sort.h>
+#include "md.h"
+#include "raid5.h"
+
+/* the log disk cache will be flushed forcely every second */
+#define LOG_FLUSH_TIME HZ
+#define LOG_SUPER_WRITE_TIME (5 * HZ)
+
+typedef u64 r5blk_t; /* log blocks, could be 512B - 4k */
+
+/*
+ * cache disk is treated as a log. data structures and routinues with r5l_ are
+ * for log. log is just for data storing in cache disk. It's not aware of how
+ * the data is tracked in memory
+ * */
+struct r5l_log {
+	struct md_rdev *rdev;
+
+	struct page *super_page;
+	u8 uuid[16];
+	u32 uuid_checksum_data;
+	u32 uuid_checksum_meta;
+
+	unsigned int block_size; /* bytes */
+	unsigned int block_sector_shift;
+	unsigned int page_block_shift; /* page to block */
+	unsigned int stripe_data_size; /* chunk_size * data_disks, sector */
+	unsigned int chunk_size; /* sector */
+	unsigned int stripe_size; /* chunk_size * all_disks, sector */
+	unsigned int parity_disks; /* parity disks of a stripe */
+
+	r5blk_t total_blocks;
+	r5blk_t first_block;
+	r5blk_t last_block;
+
+	/* background reclaim starts if free log space hits the watermark */
+	r5blk_t low_watermark;
+	/* background reclaim stops if free log space hits the watermark */
+	r5blk_t high_watermark;
+
+	r5blk_t last_checkpoint; /* log tail */
+	/* last_checkpoint to last_freepoint is freed but not discard yet */
+	r5blk_t last_freepoint;
+	r5blk_t super_point; /* checkpoint recorded in super block */
+	u64 last_cp_seq; /* log tail sequence */
+	u64 last_freeseq; /* sequence in last_freepoint */
+	unsigned long last_cp_time;
+	struct work_struct discard_work;
+
+	int do_discard; /* if do discard */
+
+	u64 seq; /* current sequence */
+	r5blk_t log_start; /* current log position */
+
+	u8 data_checksum_type;
+	u8 meta_checksum_type;
+
+	unsigned int reserved_blocks;
+	wait_queue_head_t space_waitq;
+
+	struct mutex io_mutex;
+	struct r5l_io_unit *current_io;
+
+	spinlock_t io_list_lock;
+	struct list_head running_ios; /* running io_unit list */
+
+	struct list_head task_list; /* pending bio task list */
+	struct list_head parity_task_list; /* pending parity task list */
+	spinlock_t task_lock;
+
+	struct kmem_cache *io_kc;
+	mempool_t *io_pool;
+	struct bio_set *bio_set;
+
+	unsigned long next_flush_time; /* force disk flush time */
+	struct work_struct flush_work;
+};
+
+/*
+ * r5l_task is an abstract of IO r5c_cache dispatched undearneath. It could be
+ * a bio or several parity pages. In either case, we append the bio or parity
+ * pages into log with appropriate metadata and return where we store it. The
+ * IO handling is transparent to r5c_cache
+ *
+ * If the task is for a bio, the bio is cloned. This is to simplify io error
+ * handling. The bio dispatched to cache disk can fail. IO error handling will
+ * resend it to raid disks for retry
+ * */
+struct r5l_task;
+/* end function must free task */
+typedef void (r5l_task_end_fn)(struct r5l_task *task, int error);
+struct r5l_task {
+	struct list_head list;
+	int type;
+	struct bio *bio;
+	union {
+		struct bio *orig_bio;
+		struct {
+			sector_t stripe_sector;
+			struct page *page_p;
+			struct page *page_q;
+		};
+	};
+	/* tasks in a single r5l_io_unit will have the same seq and meta_start */
+	sector_t meta_start;
+	sector_t data_start;
+	u64 seq;
+	r5l_task_end_fn *fn;
+	void *private;
+	unsigned int reserved_blocks;
+	u32 checksum[];
+};
+
+/*
+ * r5l_io_unit is a combination of a meta page (r5l_meta_block or
+ * r5l_flush_block) and several r5l_tasks. the meta page will record meta data
+ * of the r5l_tasks. Log can be thought of a set of r5l_io_units. Each
+ * r5l_io_unit is treated as a whole in IO handling. Each io_unit has a sequence
+ * number in ascend order too, tasks in the io_unit will have the same sequence
+ * number. r5c_cache will use the sequence number to sort io ranges and track
+ * log tail. Recovery uses the sequence number to determine log integrity.
+ *
+ * Data and metadata in log is written with normal IO write. A power failure
+ * can cause data loss. To relieve the issue, log disk cache will be flushed
+ * forcely every second.
+ *
+ * Note IO is finished out of order. If metadata corrupts in the middle,
+ * recovery can't work well even metadata/data at the tail is good. IO in log
+ * tail could finish earlier than IO ahead, so we must be very careful to
+ * handle FLUSH/FUA bio.
+ *
+ * FLUSH bio: the bio will be dispatched after all previous IO finish. FLUSH
+ * syntax doesn't require pending IO finish, but pending IO might be a metadata
+ * in the middle of log, we must force this order.
+ *
+ * FUA bio: same like FLUSH bio, previous meta IO must be finished before
+ * dispatching this bio. To simplify implementation, we wait all previous IO.
+ * And we must add a FLUSH to make sure previous IO hit disk media. metadata
+ * of the bio and the bio itself must be written with FUA.
+ *
+ * The r5l_io_unit is added to r5l_log running_ios list in submiting order.
+ * FLUSH/FUA io_unit isn't allowed to be executed ahead of other io_units, so
+ * above ordering is guaranteed.
+ **/
+struct r5l_io_unit {
+	struct r5l_log *log;
+	struct list_head log_sibling; /* link to log->running_ios */
+
+	struct page *meta_page;
+	sector_t meta_sector;
+	int meta_offset; /* current offset in meta_page */
+	u64 seq;
+	struct bio *meta_bio;
+
+	struct list_head tasks;
+	struct bio *current_bio; /* current_bio accepting pages */
+	atomic_t refcnt;
+
+	unsigned int has_flush:1; /* include flush request */
+	unsigned int has_fua:1; /* include fua request */
+	unsigned int has_null_flush:1; /* include empty flush request */
+	/*
+	 * io isn't sent yet, flush/fua request can only be submitted till it's
+	 * the first IO in running_ios list
+	 * */
+	unsigned int io_deferred:1;
+	int error;
+};
+
+/* reclaim reason */
+enum {
+	RECLAIM_MEM = 0, /* work hard to reclaim memory */
+	RECLAIM_MEM_BACKGROUND = 1, /* try to reclaim memory */
+	RECLAIM_MEM_FULL = 2, /* only reclaim full stripe */
+	RECLAIM_DISK = 8, /* work hard to reclaim disk */
+	RECLAIM_DISK_BACKGROUND = 9, /* try to reclaim disk */
+	RECLAIM_FLUSH_ALL = 16, /* flush all data to raid */
+};
+
+#define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
+
+static inline struct r5c_cache *r5l_cache(struct r5l_log *log)
+{
+	return container_of(log, struct r5c_cache, log);
+}
+
+static inline struct block_device *r5l_bdev(struct r5l_log *log)
+{
+	return log->rdev->bdev;
+}
+
+static inline sector_t r5l_block_to_sector(struct r5l_log *log, r5blk_t block)
+{
+	return block << log->block_sector_shift;
+}
+
+static inline r5blk_t r5l_sector_to_block(struct r5l_log *log, sector_t s)
+{
+	return s >> log->block_sector_shift;
+}
+
+static inline int r5l_page_blocks(struct r5l_log *log, int pages)
+{
+	return pages << log->page_block_shift;
+}
+
+static u32 r5l_calculate_checksum(struct r5l_log *log, u32 crc,
+	void *buf, size_t size, bool data)
+{
+
+	/*
+	 * We currently only support CRC32, other checksum algorithm might be
+	 * added later
+	 * */
+	if (log->data_checksum_type != R5LOG_CHECKSUM_CRC32)
+		BUG();
+	if (log->meta_checksum_type != R5LOG_CHECKSUM_CRC32)
+		BUG();
+	return crc32_le(crc, buf, size);
+}
+
+static r5blk_t r5l_ring_add(struct r5l_log *log, r5blk_t block, int inc)
+{
+	block += inc;
+	if (block >= log->last_block)
+		block = block - log->total_blocks;
+	return block;
+}
+
+static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason);
+static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason);
+
+static r5blk_t r5l_free_space(struct r5l_log *log)
+{
+	r5blk_t used_size;
+
+	if (log->log_start >= log->last_checkpoint)
+		used_size = log->log_start - log->last_checkpoint;
+	else
+		used_size = log->log_start + log->total_blocks -
+			log->last_checkpoint;
+
+	if (log->total_blocks > used_size + log->reserved_blocks)
+		return log->total_blocks - used_size - log->reserved_blocks;
+	return 0;
+}
+
+/* Make sure we have enough free space in log device */
+static void r5l_get_reserve(struct r5l_log *log, unsigned int size)
+{
+	r5blk_t free;
+
+	mutex_lock(&log->io_mutex);
+
+	free = r5l_free_space(log);
+	if (free >= size) {
+		log->reserved_blocks += size;
+
+		if (free - size < log->low_watermark)
+			r5c_wake_reclaimer(r5l_cache(log),
+				RECLAIM_DISK_BACKGROUND);
+		mutex_unlock(&log->io_mutex);
+		return;
+	}
+
+	log->reserved_blocks += size;
+	mutex_unlock(&log->io_mutex);
+
+	schedule_work(&log->discard_work);
+	r5c_wake_reclaimer(r5l_cache(log), RECLAIM_DISK);
+
+	mutex_lock(&log->io_mutex);
+	wait_event_cmd(log->space_waitq, r5l_free_space(log) > 0,
+		mutex_unlock(&log->io_mutex), mutex_lock(&log->io_mutex));
+	mutex_unlock(&log->io_mutex);
+}
+
+static void __r5l_put_reserve(struct r5l_log *log, unsigned int reserved_blocks)
+{
+	BUG_ON(!mutex_is_locked(&log->io_mutex));
+
+	log->reserved_blocks -= reserved_blocks;
+	if (r5l_free_space(log) > 0)
+		wake_up(&log->space_waitq);
+}
+
+static void r5l_put_reserve(struct r5l_log *log, unsigned int reserved_blocks)
+{
+	mutex_lock(&log->io_mutex);
+	__r5l_put_reserve(log, reserved_blocks);
+	mutex_unlock(&log->io_mutex);
+}
+
+#define LOG_POOL_SIZE 8
+static void *__io_pool_alloc(gfp_t gfp, void *pool_data)
+{
+	struct r5l_log *log = pool_data;
+	struct r5l_io_unit *io;
+
+	io = kmem_cache_alloc(log->io_kc, gfp);
+	if (!io)
+		return NULL;
+	io->meta_page = alloc_page(gfp);
+	if (!io->meta_page) {
+		kmem_cache_free(log->io_kc, io);
+		return NULL;
+	}
+	return io;
+}
+
+static void __io_pool_free(void *e, void *pool_data)
+{
+	struct r5l_log *log = pool_data;
+	struct r5l_io_unit *io = e;
+
+	__free_page(io->meta_page);
+	kmem_cache_free(log->io_kc, io);
+}
+
+static struct r5l_io_unit *r5l_alloc_io_unit(struct r5l_log *log)
+{
+	struct r5l_io_unit *io;
+	struct page *page;
+
+	io = mempool_alloc(log->io_pool, GFP_NOIO);
+	page = io->meta_page;
+	memset(io, 0, sizeof(*io));
+	io->meta_page = page;
+
+	io->log = log;
+	INIT_LIST_HEAD(&io->tasks);
+	atomic_set(&io->refcnt, 1);
+	clear_highpage(io->meta_page);
+	return io;
+}
+
+static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	mempool_free(io, log->io_pool);
+}
+
+static void r5l_submit_bio(struct r5l_log *log, int rw, struct bio *bio)
+{
+	/* all IO must start from rdev->data_offset */
+	struct bio *split;
+
+	if (bio_end_sector(bio) > (r5l_block_to_sector(log,
+				   log->last_block))) {
+		split = bio_split(bio, r5l_block_to_sector(log,
+			log->last_block) - bio->bi_iter.bi_sector,
+			GFP_NOIO, log->bio_set);
+		bio_chain(split, bio);
+		bio->bi_iter.bi_sector = r5l_block_to_sector(log,
+					log->first_block);
+		split->bi_iter.bi_sector += log->rdev->data_offset;
+		submit_bio(rw, split);
+	}
+
+	bio->bi_iter.bi_sector += log->rdev->data_offset;
+	submit_bio(rw, bio);
+}
+
+static void r5l_put_io_unit(struct r5l_io_unit *io, int error)
+{
+	struct r5l_log *log = io->log;
+	struct r5l_io_unit *io_deferred;
+	unsigned long flags;
+	struct r5l_task *task;
+
+	if (error)
+		io->error = error;
+
+	if (!atomic_dec_and_test(&io->refcnt))
+		return;
+
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	list_del(&io->log_sibling);
+	if (!list_empty(&log->running_ios)) {
+		/*
+		 * FLUSH/FUA io_unit is deferred because of ordering, now we
+		 * can dispatch it
+		 * */
+		io_deferred = list_first_entry(&log->running_ios,
+			struct r5l_io_unit, log_sibling);
+		if (io_deferred->io_deferred)
+			schedule_work(&log->flush_work);
+	}
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+
+	while (!list_empty(&io->tasks)) {
+		task = list_first_entry(&io->tasks, struct r5l_task,
+			list);
+		list_del(&task->list);
+		task->fn(task, io->error);
+	}
+	r5l_free_io_unit(log, io);
+}
+
+static void r5l_log_endio(struct bio *bio, int error)
+{
+	struct r5l_io_unit *io = bio->bi_private;
+
+	bio_put(bio);
+	r5l_put_io_unit(io, error);
+}
+
+static void r5l_do_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	struct r5l_task *task;
+	int rw = WRITE;
+
+	if (io->has_null_flush) {
+		log->next_flush_time = jiffies + LOG_FLUSH_TIME;
+		task = list_first_entry(&io->tasks, struct r5l_task, list);
+		submit_bio(WRITE_FLUSH, task->bio);
+		r5l_put_io_unit(io, 0);
+		return;
+	}
+
+	if (io->has_flush)
+		rw |= REQ_FLUSH;
+	if (io->has_fua)
+		rw |= REQ_FUA | REQ_FLUSH;
+	if (time_before(log->next_flush_time, jiffies))
+		rw |= REQ_FLUSH;
+	if (rw & REQ_FLUSH)
+		log->next_flush_time = jiffies + LOG_FLUSH_TIME;
+
+	r5l_submit_bio(log, rw, io->meta_bio);
+
+	list_for_each_entry(task, &io->tasks, list) {
+		if (task->bio)
+			r5l_submit_bio(log, task->bio->bi_rw, task->bio);
+	}
+	r5l_put_io_unit(io, 0);
+}
+
+/*
+ * submit IO for a r5l_io_unit. For flush/fua, ordering is important. We don't
+ * submit such io_unit till all previous io_units finish. If io_unit isn't
+ * dispatched right now, it's marked as deferred
+ **/
+static void r5l_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
+{
+	unsigned long flags;
+	bool do_io = true;
+
+	if (io->has_flush || io->has_fua) {
+		spin_lock_irqsave(&log->io_list_lock, flags);
+		if (io !=  list_first_entry(&log->running_ios,
+		    struct r5l_io_unit, log_sibling)) {
+			io->io_deferred = 1;
+			do_io = false;
+		}
+		spin_unlock_irqrestore(&log->io_list_lock, flags);
+		if (!do_io)
+			return;
+	}
+
+	r5l_do_submit_io(log, io);
+}
+
+static void r5l_submit_current_io(struct r5l_log *log)
+{
+	struct r5l_io_unit *io = log->current_io;
+	struct r5l_meta_header *header;
+	u32 crc;
+
+	if (!io)
+		return;
+
+	header = page_address(io->meta_page);
+	header->meta_size = cpu_to_le32(io->meta_offset);
+	crc = r5l_calculate_checksum(log, log->uuid_checksum_meta,
+		header, log->block_size, false);
+	header->checksum = cpu_to_le32(crc);
+
+	log->current_io = NULL;
+
+	r5l_submit_io(log, io);
+}
+
+/* deferred io_unit will be dispatched here */
+static void r5l_submit_io_async(struct work_struct *work)
+{
+	struct r5l_log *log = container_of(work, struct r5l_log, flush_work);
+	struct r5l_io_unit *io = NULL;
+
+	spin_lock_irq(&log->io_list_lock);
+	if (!list_empty(&log->running_ios)) {
+		io = list_first_entry(&log->running_ios, struct r5l_io_unit,
+				log_sibling);
+		if (!io->io_deferred)
+			io = NULL;
+		else
+			io->io_deferred = 0;
+	}
+	spin_unlock_irq(&log->io_list_lock);
+	if (!io)
+		return;
+	r5l_do_submit_io(log, io);
+}
+
+static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
+{
+	struct r5l_io_unit *io;
+
+	io = r5l_alloc_io_unit(log);
+
+	io->meta_sector = r5l_block_to_sector(log, log->log_start);
+	io->meta_offset = sizeof(struct r5l_meta_header);
+	io->seq = log->seq;
+
+	io->meta_bio = bio_alloc_bioset(GFP_NOIO,
+		bio_get_nr_vecs(r5l_bdev(log)), log->bio_set);
+	io->meta_bio->bi_bdev = r5l_bdev(log);
+	io->meta_bio->bi_iter.bi_sector = io->meta_sector;
+	bio_add_page(io->meta_bio, io->meta_page, log->block_size, 0);
+	io->meta_bio->bi_end_io = r5l_log_endio;
+	io->meta_bio->bi_private = io;
+
+	atomic_inc(&io->refcnt);
+
+	log->seq++;
+	log->log_start = r5l_ring_add(log, log->log_start, 1);
+	io->current_bio = io->meta_bio;
+
+	spin_lock_irq(&log->io_list_lock);
+	list_add_tail(&io->log_sibling, &log->running_ios);
+	spin_unlock_irq(&log->io_list_lock);
+
+	return io;
+}
+
+static int r5l_get_meta(struct r5l_log *log, unsigned int pages, bool is_bio)
+{
+	struct r5l_io_unit *io;
+	struct r5l_meta_header *header;
+	unsigned int meta_size;
+
+	meta_size = sizeof(struct r5l_meta_payload) +
+		sizeof(u32) * pages;
+	io = log->current_io;
+	if (io && io->meta_offset + meta_size > log->block_size)
+		r5l_submit_current_io(log);
+	io = log->current_io;
+	if (io) {
+		/* If task has bio, we can't use previous bio to add data */
+		if (is_bio)
+			io->current_bio = NULL;
+		return 0;
+	}
+
+	io = r5l_new_meta(log);
+	log->current_io = io;
+
+	if (is_bio)
+		io->current_bio = NULL;
+
+	header = page_address(io->meta_page);
+	header->magic = cpu_to_le32(R5LOG_MAGIC);
+	header->type = cpu_to_le32(R5LOG_TYPE_META);
+	header->seq = cpu_to_le64(log->seq - 1);
+	if (log->log_start == log->first_block)
+		header->position = cpu_to_le64(log->last_block - 1);
+	else
+		header->position = cpu_to_le64(log->log_start - 1);
+
+	return 0;
+}
+
+/* must hold io_mutex */
+static int r5l_run_data_task(struct r5l_log *log, struct r5l_task *task)
+{
+	unsigned int pages;
+	struct r5l_io_unit *io;
+	unsigned int reserved_blocks = task->reserved_blocks;
+	struct r5l_meta_payload *payload;
+	struct bio *bio = task->bio;
+	void *meta;
+	int i;
+
+	pages = bio_sectors(bio) >> PAGE_SECTOR_SHIFT;
+
+	r5l_get_meta(log, pages, true);
+
+	io = log->current_io;
+
+	if (bio->bi_rw & REQ_FLUSH)
+		io->has_flush = 1;
+	if (bio->bi_rw & REQ_FUA)
+		io->has_fua = 1;
+
+	meta = page_address(io->meta_page);
+	payload = meta + io->meta_offset;
+	payload->payload_type = cpu_to_le16(task->type);
+	payload->blocks = cpu_to_le32(r5l_page_blocks(log, pages));
+	payload->location = cpu_to_le64(bio->bi_iter.bi_sector);
+	for (i = 0; i < pages; i++)
+		payload->data_checksum[i] = cpu_to_le32(task->checksum[i]);
+
+	io->meta_offset += sizeof(struct r5l_meta_payload) +
+		sizeof(u32) * pages;
+	task->seq = io->seq;
+	task->meta_start = io->meta_sector;
+	task->data_start = r5l_block_to_sector(log, log->log_start);
+
+	/* submiting will split the bio if it hits log end */
+	bio->bi_iter.bi_sector = task->data_start;
+	bio->bi_end_io = r5l_log_endio;
+	bio->bi_private = io;
+	bio->bi_bdev = r5l_bdev(log);
+	atomic_inc(&io->refcnt);
+
+	log->log_start = r5l_ring_add(log, log->log_start,
+		r5l_page_blocks(log, pages));
+
+	list_add_tail(&task->list, &io->tasks);
+
+	__r5l_put_reserve(log, reserved_blocks);
+	return 0;
+}
+
+/*
+ * We probably can directly add the parity pages into previous bio of io_unit
+ * (the meta data bio or bio for previous parity pages. If that isn't possible,
+ * we allocate a new bio
+ * */
+static int r5l_task_add_parity_pages(struct r5l_log *log,
+	struct r5l_task *task)
+{
+	struct r5l_io_unit *io = log->current_io;
+	struct bio *bio;
+	struct page *pages[] = {task->page_p, task->page_q};
+	r5blk_t pos = log->log_start;
+	r5blk_t bio_pos = 0;
+	int i;
+
+	bio = io->current_bio;
+
+alloc_bio:
+	if (!bio) {
+		/* bio can only contain one page ? */
+		BUG_ON(task->bio);
+		bio = bio_alloc_bioset(GFP_NOIO,
+			bio_get_nr_vecs(r5l_bdev(log)), log->bio_set);
+		bio->bi_rw = WRITE;
+		bio->bi_bdev = r5l_bdev(log);
+		/*
+		 * Set sector to 0, so bio_add_page doesn't fail if we are the
+		 * blkdev tail. Later we will set the bi_sector again and split
+		 * bio if required
+		 * */
+		bio->bi_iter.bi_sector = 0;
+		bio_pos = pos;
+		task->bio = bio;
+		io->current_bio = bio;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pages); i++) {
+		if (!pages[i])
+			continue;
+		if (!bio_add_page(bio, pages[i], PAGE_SIZE, 0)) {
+			bio = NULL;
+			goto alloc_bio;
+		}
+		pages[i] = NULL;
+		pos = r5l_ring_add(log, pos, r5l_page_blocks(log, 1));
+	}
+	if (bio_pos != 0)
+		bio->bi_iter.bi_sector = r5l_block_to_sector(log, bio_pos);
+	return 0;
+}
+
+/* must hold io_mutex. parity task doesn't have a bio */
+static int r5l_run_parity_task(struct r5l_log *log, struct r5l_task *task)
+{
+	unsigned int pages;
+	struct r5l_io_unit *io;
+	struct r5l_meta_payload *payload;
+	struct bio *bio;
+	void *meta;
+	int i;
+
+	pages = !!task->page_p + !!task->page_q;
+
+	r5l_get_meta(log, pages, false);
+
+	io = log->current_io;
+
+	meta = page_address(io->meta_page);
+	payload = meta + io->meta_offset;
+	payload->payload_type = cpu_to_le16(task->type);
+	payload->blocks = cpu_to_le32(r5l_page_blocks(log, pages));
+	payload->location = cpu_to_le64(task->stripe_sector);
+
+	for (i = 0; i < pages; i++)
+		payload->data_checksum[i] = cpu_to_le32(task->checksum[i]);
+
+	io->meta_offset += sizeof(struct r5l_meta_payload) +
+		sizeof(u32) * pages;
+	task->seq = io->seq;
+	task->meta_start = io->meta_sector;
+	task->data_start = r5l_block_to_sector(log, log->log_start);
+
+	r5l_task_add_parity_pages(log, task);
+
+	/* this should only happen r5l_task_add_parity_pages allocates a bio */
+	if (task->bio) {
+		bio = task->bio;
+		bio->bi_end_io = r5l_log_endio;
+		bio->bi_private = io;
+		atomic_inc(&io->refcnt);
+	}
+
+	log->log_start = r5l_ring_add(log, log->log_start,
+		r5l_page_blocks(log, pages));
+
+	list_add_tail(&task->list, &io->tasks);
+
+	return 0;
+}
+
+/*
+ * We reserve space for parity, so reclaim doesn't deadlock because of no space
+ * to write parity. To make this work, reclaim (and conrresponding raid5 threads)
+ * should not run data tasks
+ **/
+static void r5l_run_tasks(struct r5l_log *log, bool parity)
+{
+	struct r5l_task *task;
+	LIST_HEAD(tasks);
+
+	spin_lock(&log->task_lock);
+	list_splice_init(&log->parity_task_list, &tasks);
+	if (!parity)
+		list_splice_tail_init(&log->task_list, &tasks);
+	spin_unlock(&log->task_lock);
+
+	if (list_empty(&tasks))
+		return;
+
+	mutex_lock(&log->io_mutex);
+	while (!list_empty(&tasks)) {
+		task = list_first_entry(&tasks, struct r5l_task, list);
+		list_del_init(&task->list);
+
+		if (task->type == R5LOG_PAYLOAD_PARITY)
+			r5l_run_parity_task(log, task);
+		else
+			r5l_run_data_task(log, task);
+	}
+	r5l_submit_current_io(log);
+	mutex_unlock(&log->io_mutex);
+}
+
+static void r5l_queue_task(struct r5l_log *log, struct r5l_task *task)
+{
+	spin_lock(&log->task_lock);
+	if (task->type == R5LOG_PAYLOAD_DATA)
+		list_add_tail(&task->list, &log->task_list);
+	else
+		list_add_tail(&task->list, &log->parity_task_list);
+	spin_unlock(&log->task_lock);
+}
+
+/*
+ * empty bio hasn't any payload, but our FLUSH bio ordering requirement holds
+ * here too. To simplify implementation, we fake io_unit/task, so such bio can
+ * be handled like normal bios
+ * */
+static int r5l_queue_empty_flush_bio(struct r5l_log *log, struct bio *bio,
+	r5l_task_end_fn fn, void *private)
+{
+	struct r5l_io_unit *io;
+	struct r5l_task *task;
+
+	task = kmalloc(sizeof(*task), GFP_NOIO);
+	if (!task)
+		return -ENOMEM;
+	task->type = R5LOG_PAYLOAD_DATA;
+	task->bio = bio_clone(bio, GFP_NOIO);
+	if (!task->bio) {
+		kfree(task);
+		return -ENOMEM;
+	}
+	task->orig_bio = bio;
+	task->fn = fn;
+	task->private = private;
+	task->reserved_blocks = 0;
+
+	io = r5l_alloc_io_unit(log);
+
+	task->bio->bi_bdev = r5l_bdev(log);
+	task->bio->bi_end_io = r5l_log_endio;
+	task->bio->bi_private = io;
+
+	io->has_flush = 1;
+	io->has_null_flush = 1;
+
+	mutex_lock(&log->io_mutex);
+	r5l_submit_current_io(log);
+
+	atomic_inc(&io->refcnt);
+	list_add_tail(&task->list, &io->tasks);
+
+	spin_lock_irq(&log->io_list_lock);
+	list_add_tail(&io->log_sibling, &log->running_ios);
+	spin_unlock_irq(&log->io_list_lock);
+
+	r5l_submit_io(log, io);
+
+	mutex_unlock(&log->io_mutex);
+	return 0;
+}
+
+static int r5l_queue_bio(struct r5l_log *log, struct bio *bio,
+	r5l_task_end_fn fn, void *private, unsigned int reserved_blocks)
+{
+	struct r5l_task *task;
+	int pages = bio_sectors(bio) >> PAGE_SECTOR_SHIFT;
+	u32 *checksum;
+	struct bio *src = bio;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	void *src_p;
+	unsigned int page_index = 0, page_offset = 0;
+	unsigned int bytes;
+
+	task = kmalloc(sizeof(*task) + sizeof(u32) * pages, GFP_NOIO);
+	if (!task)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&task->list);
+	task->type = R5LOG_PAYLOAD_DATA;
+	task->bio = bio_clone(bio, GFP_NOIO);
+	if (!task->bio) {
+		kfree(task);
+		return -ENOMEM;
+	}
+	task->orig_bio = bio;
+	task->fn = fn;
+	task->private = private;
+	task->reserved_blocks = reserved_blocks;
+
+	checksum = (u32 *)(task + 1);
+
+	iter = src->bi_iter;
+
+	checksum[0] = log->uuid_checksum_data;
+	while (1) {
+		if (!iter.bi_size) {
+			src = src->bi_next;
+			if (!src)
+				break;
+
+			iter = src->bi_iter;
+		}
+
+		if (page_offset == PAGE_SIZE) {
+			page_index++;
+			page_offset = 0;
+			checksum[page_index] = log->uuid_checksum_data;
+		}
+
+		bv = bio_iter_iovec(src, iter);
+
+		bytes = min_t(unsigned int, bv.bv_len, PAGE_SIZE - page_offset);
+
+		src_p = kmap_atomic(bv.bv_page);
+
+		checksum[page_index] = r5l_calculate_checksum(log,
+			checksum[page_index], src_p + bv.bv_offset,
+			bytes, true);
+
+		kunmap_atomic(src_p);
+
+		bio_advance_iter(src, &iter, bytes);
+		page_offset += bytes;
+	}
+	r5l_queue_task(log, task);
+	return 0;
+}
+
+static int r5l_queue_parity(struct r5l_log *log,
+	sector_t stripe_sector, struct page *page_p,
+	struct page *page_q, r5l_task_end_fn fn, void *private)
+{
+	struct r5l_task *task;
+	void *addr;
+	u32 *checksum;
+
+	task = kmalloc(sizeof(*task) + sizeof(u32) * 2, GFP_NOIO);
+	if (!task)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&task->list);
+	task->type = R5LOG_PAYLOAD_PARITY;
+	task->bio = NULL;
+	task->stripe_sector = stripe_sector;
+	task->page_p = page_p;
+	task->page_q = page_q;
+	task->fn = fn;
+	task->private = private;
+	task->reserved_blocks = 0;
+
+	checksum = (u32 *)(task + 1);
+	addr = kmap_atomic(page_p);
+	checksum[0] = r5l_calculate_checksum(log,
+		log->uuid_checksum_data, addr, PAGE_SIZE, true);
+	kunmap_atomic(addr);
+
+	if (page_q) {
+		addr = kmap_atomic(page_q);
+		checksum[1] = r5l_calculate_checksum(log,
+			log->uuid_checksum_data, addr, PAGE_SIZE, true);
+		kunmap_atomic(addr);
+	} else
+		checksum[1] = 0;
+
+	r5l_queue_task(log, task);
+	return 0;
+}
+
+static void r5l_fb_end(struct r5l_task *task, int error)
+{
+	struct completion *comp = task->private;
+	complete(comp);
+}
+
+/*
+ * ordering requirement holds here. To simplify implementation, we fake
+ * io_unit/task, so flush block can be handled like other meta data
+ * */
+static int r5l_flush_block(struct r5l_log *log, int type, __le64 *stripes,
+	size_t size, u64 *next_seq, sector_t *next_sec)
+{
+	struct r5l_io_unit *io;
+	struct r5l_flush_block *fb;
+	struct r5l_task task;
+	DECLARE_COMPLETION_ONSTACK(fb_complete);
+	u32 crc;
+
+	mutex_lock(&log->io_mutex);
+
+	r5l_submit_current_io(log);
+
+	io = r5l_new_meta(log);
+	task.fn = r5l_fb_end;
+	task.private = &fb_complete;
+	task.reserved_blocks = 0;
+	task.type = R5LOG_PAYLOAD_PARITY;
+	task.bio = NULL;
+
+	fb = page_address(io->meta_page);
+	fb->header.magic = cpu_to_le32(R5LOG_MAGIC);
+	fb->header.type = cpu_to_le32(type);
+	fb->header.seq = cpu_to_le64(log->seq - 1);
+	if (log->log_start == log->first_block)
+		fb->header.position = cpu_to_le64(log->last_block - 1);
+	else
+		fb->header.position = cpu_to_le64(log->log_start - 1);
+	fb->header.meta_size = cpu_to_le32(sizeof(struct r5l_flush_block)
+					+ size);
+	memcpy(fb->flush_stripes, stripes, size);
+	crc = r5l_calculate_checksum(log, log->uuid_checksum_meta, fb,
+			log->block_size, false);
+	fb->header.checksum = cpu_to_le32(crc);
+
+	list_add_tail(&task.list, &io->tasks);
+
+	io->has_flush = 1;
+	io->has_fua = 1;
+	r5l_submit_io(log, io);
+
+	*next_seq = log->seq;
+	*next_sec = r5l_block_to_sector(log, log->log_start);
+
+	mutex_unlock(&log->io_mutex);
+
+	wait_for_completion_io(&fb_complete);
+	return 0;
+}
+
+static void r5l_discard_blocks(struct r5l_log *log, r5blk_t start, r5blk_t end)
+{
+	if (!log->do_discard)
+		return;
+	if (start < end) {
+		blkdev_issue_discard(r5l_bdev(log),
+		    r5l_block_to_sector(log, start) + log->rdev->data_offset,
+		    r5l_block_to_sector(log, end - start), GFP_NOIO, 0);
+	} else {
+		blkdev_issue_discard(r5l_bdev(log),
+		    r5l_block_to_sector(log, start) + log->rdev->data_offset,
+		    r5l_block_to_sector(log, log->last_block - start),
+		    GFP_NOIO, 0);
+		blkdev_issue_discard(r5l_bdev(log),
+		    r5l_block_to_sector(log, log->first_block) +
+		    log->rdev->data_offset,
+		    r5l_block_to_sector(log, end - log->first_block),
+		    GFP_NOIO, 0);
+	}
+}
+
+static int r5l_do_write_super(struct r5l_log *log, u64 seq, r5blk_t cp)
+{
+	struct r5l_super_block *sb_blk;
+	struct timespec now = current_kernel_time();
+	u32 crc;
+
+	log->last_cp_time = jiffies + LOG_SUPER_WRITE_TIME;
+
+	if (log->super_point == cp)
+		return 0;
+	sb_blk = page_address(log->super_page);
+	sb_blk->header.seq = cpu_to_le64(seq);
+	sb_blk->last_checkpoint = cpu_to_le64(cp);
+	sb_blk->update_time_sec = cpu_to_le64(now.tv_sec);
+	sb_blk->update_time_nsec = cpu_to_le64(now.tv_nsec);
+	sb_blk->header.checksum = 0;
+	crc = r5l_calculate_checksum(log, log->uuid_checksum_meta,
+		sb_blk, log->block_size, false);
+	sb_blk->header.checksum = cpu_to_le32(crc);
+
+	if (!sync_page_io(log->rdev, 0, log->block_size, log->super_page,
+	     WRITE_FUA, false))
+		return -EIO;
+	log->super_point = cp;
+	return 0;
+}
+
+static void r5l_discard_work(struct work_struct *work)
+{
+	struct r5l_log *log = container_of(work, struct r5l_log,
+		discard_work);
+	struct r5c_cache *cache = r5l_cache(log);
+	r5blk_t free;
+
+	mutex_lock(&log->io_mutex);
+	r5l_do_write_super(log, log->last_freeseq, log->last_freepoint);
+
+	if (log->do_discard && log->last_checkpoint !=
+	    log->last_freepoint)
+		r5l_discard_blocks(log, log->last_checkpoint,
+			log->last_freepoint);
+
+	log->last_cp_seq = log->last_freeseq;
+	log->last_checkpoint = log->last_freepoint;
+
+	free = r5l_free_space(log);
+	if (free > 0) {
+		clear_bit(RECLAIM_DISK, &cache->reclaim_reason);
+		wake_up(&log->space_waitq);
+	}
+	if (free > log->high_watermark)
+		clear_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason);
+
+	mutex_unlock(&log->io_mutex);
+}
+
+static void r5l_schedule_discard(struct r5l_log *log)
+{
+	r5blk_t size;
+
+	if (log->last_freepoint >= log->last_checkpoint)
+		size = log->last_freepoint - log->last_checkpoint;
+	else
+		size = log->last_freepoint + log->total_blocks -
+			log->last_checkpoint;
+
+	if (size * 10 >= log->total_blocks)
+		schedule_work(&log->discard_work);
+}
+
+static int r5l_write_super(struct r5l_log *log, u64 seq, sector_t cp)
+{
+	struct r5c_cache *cache = r5l_cache(log);
+	r5blk_t free;
+
+	r5l_schedule_discard(log);
+
+	mutex_lock(&log->io_mutex);
+	log->last_freepoint = r5l_sector_to_block(log, cp);
+	log->last_freeseq = seq;
+
+	/*
+	 * skiping superblock update doesn't impact the correctness since
+	 * recover can handle it. So we try to defer superblock write for
+	 * performance
+	 * */
+	if (seq == log->last_cp_seq || time_after(log->last_cp_time,
+	    jiffies)) {
+		mutex_unlock(&log->io_mutex);
+		return 0;
+	}
+
+	r5l_do_write_super(log, seq, r5l_sector_to_block(log, cp));
+
+	if (!log->do_discard) {
+		log->last_cp_seq = seq;
+		log->last_checkpoint = log->last_freepoint;
+	}
+
+	free = r5l_free_space(log);
+	if (free > 0) {
+		clear_bit(RECLAIM_DISK, &cache->reclaim_reason);
+		wake_up(&log->space_waitq);
+	}
+	if (free > log->high_watermark)
+		clear_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason);
+
+	mutex_unlock(&log->io_mutex);
+
+	return 0;
+}
+
+static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
+{
+}
+
+static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason)
+{
+}
+
+static int r5l_load_log(struct r5l_log *log)
+{
+	return 0;
+}
+
+static int r5l_read_super(struct r5l_log *log)
+{
+	struct md_rdev *rdev = log->rdev;
+	struct r5l_super_block *sb_blk;
+	struct page *page = log->super_page;
+	u32 crc, stored_crc;
+
+	if (!sync_page_io(rdev, 0, PAGE_SIZE, page, READ, false))
+		return -EIO;
+
+	sb_blk = page_address(page);
+
+	if (le32_to_cpu(sb_blk->version) != R5LOG_VERSION ||
+	    le32_to_cpu(sb_blk->header.magic) != R5LOG_MAGIC ||
+	    le32_to_cpu(sb_blk->header.type) != R5LOG_TYPE_SUPER ||
+	    le64_to_cpu(sb_blk->header.position) != 0 ||
+	    le32_to_cpu(sb_blk->header.meta_size) !=
+	     sizeof(struct r5l_super_block))
+		goto error;
+
+	log->last_cp_seq = le64_to_cpu(sb_blk->header.seq);
+
+	log->block_size = le32_to_cpu(sb_blk->block_size);
+	log->block_sector_shift = ilog2(log->block_size >> 9);
+	log->page_block_shift = PAGE_SHIFT - ilog2(log->block_size);
+
+	/* Only support this stripe size right now */
+	if (le32_to_cpu(sb_blk->stripe_cache_size) != PAGE_SIZE)
+		goto error;
+
+	if (log->block_size > PAGE_SIZE)
+		goto error;
+
+	log->stripe_data_size = le32_to_cpu(sb_blk->stripe_data_size) >> 9;
+	log->chunk_size = le32_to_cpu(sb_blk->chunk_size) >> 9;
+	log->stripe_size = le32_to_cpu(sb_blk->stripe_size) >> 9;
+	log->parity_disks = le32_to_cpu(sb_blk->parity_disks);
+
+	if (sb_blk->meta_checksum_type >= R5LOG_CHECKSUM_NR ||
+	    sb_blk->data_checksum_type >= R5LOG_CHECKSUM_NR)
+		goto error;
+	log->meta_checksum_type = sb_blk->meta_checksum_type;
+	log->data_checksum_type = sb_blk->data_checksum_type;
+
+	stored_crc = le32_to_cpu(sb_blk->header.checksum);
+	sb_blk->header.checksum = 0;
+	crc = r5l_calculate_checksum(log, ~0,
+		sb_blk->uuid, sizeof(sb_blk->uuid), false);
+	crc = r5l_calculate_checksum(log, crc,
+		sb_blk, log->block_size, false);
+	if (crc != stored_crc)
+		goto error;
+
+	if (memcmp(log->uuid, sb_blk->uuid, sizeof(log->uuid)))
+		goto error;
+
+	log->first_block = le64_to_cpu(sb_blk->first_block);
+	if (log->first_block != 1)
+		goto error;
+
+	log->total_blocks = le64_to_cpu(sb_blk->total_blocks);
+	log->last_block = log->first_block + log->total_blocks;
+	log->last_checkpoint = le64_to_cpu(sb_blk->last_checkpoint);
+	log->last_freepoint = log->last_checkpoint;
+	log->super_point = log->last_checkpoint;
+
+	return 0;
+error:
+	return -EINVAL;
+}
+
+static int r5l_init_log(struct r5c_cache *cache)
+{
+	struct r5l_log *log;
+	r5blk_t blocks;
+
+	log = &cache->log;
+
+	log->rdev = cache->rdev;
+
+	log->do_discard = blk_queue_discard(bdev_get_queue(r5l_bdev(log)));
+
+	log->super_page = alloc_page(GFP_KERNEL);
+	if (!log->super_page)
+		return -ENOMEM;
+	memcpy(log->uuid, cache->mddev->uuid, sizeof(log->uuid));
+
+	init_waitqueue_head(&log->space_waitq);
+	mutex_init(&log->io_mutex);
+
+	spin_lock_init(&log->io_list_lock);
+	INIT_LIST_HEAD(&log->running_ios);
+
+	INIT_LIST_HEAD(&log->task_list);
+	INIT_LIST_HEAD(&log->parity_task_list);
+	spin_lock_init(&log->task_lock);
+
+	INIT_WORK(&log->flush_work, r5l_submit_io_async);
+	INIT_WORK(&log->discard_work, r5l_discard_work);
+
+	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
+	if (!log->io_kc)
+		goto io_kc;
+	log->io_pool = mempool_create(LOG_POOL_SIZE, __io_pool_alloc,
+		__io_pool_free, log);
+	if (!log->io_pool)
+		goto io_pool;
+	log->bio_set = bioset_create(LOG_POOL_SIZE * 2, 0);
+	if (!log->bio_set)
+		goto bio_set;
+
+	if (r5l_read_super(log))
+		goto error;
+
+	log->uuid_checksum_data = r5l_calculate_checksum(log, ~0, log->uuid,
+		sizeof(log->uuid), true);
+	log->uuid_checksum_meta = r5l_calculate_checksum(log, ~0, log->uuid,
+		sizeof(log->uuid), false);
+
+	log->reserved_blocks = r5l_sector_to_block(log,
+		cache->reserved_space) + 1;
+
+	if (log->stripe_data_size != cache->stripe_data_size ||
+	    log->chunk_size != cache->chunk_size ||
+	    log->stripe_size != cache->stripe_size ||
+	    log->parity_disks != cache->parity_disks)
+		goto error;
+
+	r5l_load_log(log);
+
+	blocks = log->total_blocks;
+	do_div(blocks, 10);
+	if (blocks * log->block_size < 1024 * 1024 * 1024)
+		log->low_watermark = blocks;
+	else
+		log->low_watermark = (1024 * 1024 * 1024 / log->block_size);
+	log->high_watermark = (log->low_watermark * 3) >> 1;
+
+	r5l_discard_blocks(log, log->first_block, log->last_block);
+
+	return 0;
+error:
+	bioset_free(log->bio_set);
+bio_set:
+	mempool_destroy(log->io_pool);
+io_pool:
+	kmem_cache_destroy(log->io_kc);
+io_kc:
+	__free_page(log->super_page);
+	return -EINVAL;
+}
+
+static void r5l_exit_log(struct r5l_log *log)
+{
+	blkdev_issue_flush(r5l_bdev(log), GFP_NOIO, NULL);
+	schedule_work(&log->discard_work);
+	flush_work(&log->discard_work);
+
+	bioset_free(log->bio_set);
+	mempool_destroy(log->io_pool);
+	kmem_cache_destroy(log->io_kc);
+	__free_page(log->super_page);
+}
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 8c8e12c..bc0f3c0 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -315,4 +315,80 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_WRITE_CACHE		\
 					)
 
+/* all disk position of below struct start from rdev->start_offset */
+struct r5l_meta_header {
+	__le32 magic;
+	__le32 type;
+	__le32 checksum; /* checksum(metadata block + uuid) */
+	__le32 meta_size;
+	__le64 seq;
+	__le64 position; /* block number the meta is written */
+} __attribute__ ((__packed__));
+
+#define R5LOG_VERSION 0x1
+#define R5LOG_MAGIC 0x6433c509
+
+enum {
+	R5LOG_TYPE_META = 0,
+	R5LOG_TYPE_SUPER = 1,
+	R5LOG_TYPE_FLUSH_START = 2,
+	R5LOG_TYPE_FLUSH_END = 3,
+};
+
+struct r5l_super_block {
+	struct r5l_meta_header header;
+	__le32 version;
+	__le32 stripe_cache_size; /* in kernel stripe unit size, bytes */
+	__le32 block_size; /* log block size, bytes */
+	__le32 stripe_data_size; /* chunk_size * data_disks, bytes */
+	__le32 chunk_size; /* bytes */
+	__le32 stripe_size; /* chunk_size * all_raid_disks, bytes */
+	__le32 parity_disks; /* parity disks in each stripe */
+	__le32 zero_padding;
+	__le64 total_blocks; /* block */
+	__le64 first_block; /* block */
+	__le64 last_checkpoint; /* block */
+	__le64 update_time_sec;
+	__le64 update_time_nsec;
+	__u8 meta_checksum_type;
+	__u8 data_checksum_type;
+	__u8 uuid[16];
+	/* must fill with 0 below */
+} __attribute__ ((__packed__));
+
+enum {
+	R5LOG_CHECKSUM_CRC32 = 0,
+	R5LOG_CHECKSUM_NR = 1,
+};
+
+struct r5l_meta_payload {
+	__le16 payload_type;
+	__le16 payload_flags;
+	__le32 blocks; /* block. For parity, should be 1 or 2 pages */
+	__le64 location; /* sector. For data, it's raid sector.
+			    For parity, it's stripe sector */
+	__le32 data_checksum[]; /* checksum(data + uuid) */
+} __attribute__ ((__packed__));
+
+/* payload type */
+enum {
+	R5LOG_PAYLOAD_DATA = 0,
+	R5LOG_PAYLOAD_PARITY = 1,
+};
+
+/* payload flags */
+enum {
+	R5LOG_PAYLOAD_DISCARD = 1,
+};
+
+struct r5l_meta_block {
+	struct r5l_meta_header header;
+	struct r5l_meta_payload payloads[];
+} __attribute__ ((__packed__));
+
+struct r5l_flush_block {
+	struct r5l_meta_header header;
+	__le64 flush_stripes[]; /* stripe sector */
+} __attribute__ ((__packed__));
+
 #endif
-- 
1.8.1

