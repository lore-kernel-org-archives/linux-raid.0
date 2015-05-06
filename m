From: Shaohua Li <shli@fb.com>
Subject: [PATCH 3/5] A caching layer for RAID5/6
Date: Wed, 6 May 2015 16:57:13 -0700
Message-ID: <e41752e8440e1b73e12240b86609b1bee73d7443.1430954848.git.shli@fb.com>
References: <cover.1430954848.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1430954848.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Main goal of the caching layer is to aggregate IO write to hopefully
make full stripe IO write and fix write hole issue. This might speed up
read too, but it's not optimized for read, eg, we don't proactively
cache data for read. The aggregation makes a lot of sense for workloads
which sequentially write to several files with/without fsync. Such
workloads are popular in today's datacenter.

Write IO data will write to a cache disk (SSD) first, then later the
data will be flushed to raid disks.

The cache disk will be organized as a simple ring buffer log. For IO
data, a tuple (raid_sector, io length, checksum, data) will be appended
to the log; for raid 5/6 parity, a tuple (stripe_sector, parity length,
checksum, parity data) will be appended to the log. We don't have
on-disk index for the data appended to the log. So either we can rebuild
an in-memory index at startup with scanning the whole log, or we can
flush all data from cache disk to raid disks at shutdown so cache disk
has no valid data. Current code chooses the second option, but this can
be easily changed.

We have a simple meta data for above tuples. It's essentially a
tuple (sequence, metadata length). Crash recovery or startup will scan
the log to read the metadata and rebuild in-memory index. If metadata is
broken at the head of the log, even metadata afterward is ok, the
scanning will not work well. So we take some steps to mitigate the
issue:
-meta data is written with WRITE_FUA. write IO return only happens after both
data and metadata IO finish
-IO return happens in the order they are added in the log.
These will make sure write IO return happens after its meta and all
previous meta IO finish, eg all related meta are persistent.

The in-memory index is a simple list of io_range (sequence, metadata
sector, data sector, length). The list is orded by sequence. The first
io_range entry's metadata sector is the tail of the log. There is also a
struct to track io ranges within a stripe. All stripes will be organized
as a radix tree.

All IO data will be copied to a memory pool for caching too until the
data is flushed to raid disks. This is just to simplify the
implementation, it's not mandated. In the future flush can do a data
copy from cache disk to raid disks, so the memory pool can be discarded.
If a stripe is flushed to raid disks, memory of the stripe can be
reused.

We have two limited resources here, memory pool and cache disk space. If
resource is tight, we will do reclaim. In either case, we will flush
some data from cache disk to raid disks. However, we implement different
strategies. For memory reclaim, we prefer reclaiming full stripe. For
cache disk space reclaim, we prefer reclaiming io_range entry at the
head of index list.

If cache disk has IO error, since all data are in memory pool, we will
flush all data to raid disks and fallback to no-cache-disk mode. IO
error of cache disk doesn't corrupt any data. After some time, we will
try to use cache disk again if the disk is ok. The retry will stop after
several rounds of failure.

We always do reclaim in stripe unit. Reclaim could create holes in the
log, eg, some io_range in the middle is reclaimed, but io_range at the
head remains. So the index list entries don't always have continuous
sequence. But this doesn't matter, the first io_range is always the log
tail. Superblock has a field pointing to the position of log tail. The
hole can waste a lot of disk space though. In the future, we can
implement a garbage collection to mitigate the issue, eg, copy data
from the index tail to head.

In the process reclaim flush data to raid disk, stripe parity will be
append to cache log. Parity is always appended after its corresponding
data. After parity is in cache disk, a flush_start block is appended to
log, which indicates stripe is flushing to raid disks. Data writing to
raid disks only happens after all data and parity are already in cache
disk. This will fix the write whole issue. After a stripe is flushed to
raid disks, a flush_end block is appended to log, which indicates a
stripe is settled down in raid disks.

Recovery relies on the flush_start and flush_end block. If recovery
finds data and parity of a stripe, the flush start/end block will be
used to determine which stage the stripe is in flush. If the stripe is
listed in flush end block, the stripe is in raid disks, all data and
parity of the stripe can be discarded. If the stripe isn't listed in
flush start block, the stripe hasn't started flush to raid yet, its
parity can be ignored. Otherwise, the stripe is in the middle of
flushing to raid disks.  Since we have both data and parity, the
recovery just rewrite them to raid disks.

IO write code path:
1. copy bio data to stripe memory pages
2. append metadata and data to cache log
3. IO write endio

reclaim code path:
1. select stripe to reclaim
2. write all stripe data to raid disk
3. in raid5 ops_run_io, append metadata and parity data to cache log.
    ops_run_io doesn't write data/parity to raid disks at this time
4. flush cache disk and write flush_start block
5. ops_run_io continues. data/parity will be written to raid disks
6. flush all raid disks cache
7. write flush_end block
8. delete in-memory index of the stripe, and advance superblock log checkpoint

Recovery:
Crash in IO write code path doesn't need recovery. If data and checksum
don't match, the data will be ignored so read will return old data. In
reclaim code path, crash before step 4 doesn't need recovery as
data/parity don't touch raid disk yet. Parity can be ignored too. crash
after 7 doesn't need recovery too, as the stripe is fully flushed to
raid disks. Crash between 4 and 7 need recovery. Data and parity in the
log will be written to raid disks.

The performance issue will mainly in two areas. The FUA write to log
device and reclaim performance. The FUA write isn't fast, especially
SATA disables FUA support by default. But since SSD is fast enough, this
might not a big issue. On the other hand, the FUA isn't a must-have. As
long as we flush log disk cache for any FUA or FLUSH bio from upper
layer, we don't need to use FUA write for log device. This might lose
data but matches the behavior of hard disk. We can fix this later if the
issue is a bottleneck.

The performance of the raid will largely be determined by reclaim speed
at run time. Several stages of the reclaim process involves IO wait or
disk cache flush, which significantly impact the raid disk utilization
and performance. The flush_start and flush_end block make running
multiple reclaim possible. Each reclaim only records stripes in the
flush start/end block which it is reclaiming.  Recovery can use the
information to correctly determine stripe's flush stage. An example of 2
reclaimer:

xxx1 belongs to stripe1 and the same for stripe2

reclaim 1:  |data1|...|parity1|...|flush_start1|...|flush_end1|
reclaim 2:      |data2|..|parity2|...............|flush_start2|...|flush_end2|

the reclaims only record its own stripes in flush block. If, for
exmaple, recovery finds flush_start1, it knows stripe1 is flushing to
raid disk. Recovery will ignore stripe2, since stripe2 isn't in
flush_start1.

Multiple reclaim will efficiently solve the performance issue. Current
code hasn't add multiple reclaim yet, but certainly will be added soon.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/Makefile            |    2 +-
 drivers/md/raid5-cache.c       | 3007 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |   69 +-
 drivers/md/raid5.h             |   15 +-
 include/uapi/linux/raid/md_p.h |   72 +
 5 files changed, 3153 insertions(+), 12 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index dba4db5..aeb4330 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -16,7 +16,7 @@ dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-era-y	+= dm-era-target.o
 md-mod-y	+= md.o bitmap.o
-raid456-y	+= raid5.o
+raid456-y	+= raid5.o raid5-cache.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
new file mode 100644
index 0000000..355a450
--- /dev/null
+++ b/drivers/md/raid5-cache.c
@@ -0,0 +1,3007 @@
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
+#define MAX_MEM (256 * 1024 * 1024)
+#define RECLAIM_BATCH 16
+#define CHECKPOINT_TIMEOUT (5 * HZ)
+
+#define MAX_RETRY 10
+#define IOERR_RETRY_TIME (5 * 60 * HZ)
+#define MEMERR_RETRY_TIME (60 * HZ)
+
+typedef u64 r5blk_t; /* log blocks */
+
+struct r5l_log {
+	struct r5c_cache *cache;
+	struct block_device *bdev;
+	struct md_rdev *rdev;
+
+	struct page *super_page;
+	u8 uuid[16];
+	u32 uuid_checksum_data;
+	u32 uuid_checksum_meta;
+
+	unsigned int block_size; /* bytes */
+	unsigned int block_sector_shift;
+	unsigned int page_block_shift;
+	unsigned int stripe_data_size; /* sector */
+	unsigned int chunk_size; /* sector */
+	unsigned int stripe_size; /* sector */
+	unsigned int parity_disks;
+
+	r5blk_t total_blocks;
+	r5blk_t first_block;
+	r5blk_t last_block;
+
+	r5blk_t low_watermark; /* For disk space */
+	r5blk_t high_watermark;
+
+	r5blk_t last_checkpoint;
+	u64 last_cp_seq;
+
+	int do_discard;
+
+	u64 seq; /* get after read log */
+	r5blk_t log_start; /* get after read log */
+
+	u8 data_checksum_type;
+	u8 meta_checksum_type;
+
+	unsigned int reserved_blocks;
+	wait_queue_head_t space_waitq;
+
+	struct mutex io_mutex;
+	struct r5l_ioctl *current_io;
+
+	spinlock_t io_list_lock;
+	struct list_head running_ios; /* order is important */
+	wait_queue_head_t io_waitq;
+
+	struct list_head task_list;
+	struct list_head parity_task_list;
+	spinlock_t task_lock;
+
+	struct kmem_cache *io_kc;
+	mempool_t *io_pool;
+	struct bio_set *bio_set;
+};
+
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
+	/* tasks in a single r5l_ioctl will have the same seq and meta_start */
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
+ * meta page should write with FUA, and meta page should return IO in order,
+ * otherwise recovery will have trouble. The reason is we are using a simple
+ * log. If metadata corrupts in the middle, recovery can't work even metadata
+ * at the end is good.
+ */
+struct r5l_ioctl {
+	struct r5l_log *log;
+	struct list_head log_sibling;
+
+	struct page *meta_page;
+	sector_t meta_sector;
+	int meta_offset;
+	u64 seq;
+	struct bio *meta_bio;
+
+	struct list_head tasks;
+	struct bio *current_bio;
+	atomic_t refcnt;
+
+	int error;
+};
+
+struct r5c_io_range {
+	struct list_head log_sibling;
+	struct list_head stripe_sibling;
+
+	u64 seq;
+
+	sector_t meta_start; /* cache position */
+	sector_t data_start; /* cache position */
+	sector_t raid_start;
+	unsigned int data_sectors;
+
+	struct r5c_stripe *stripe;
+	union {
+		struct bio *bio;
+		u32 *checksum; /* only for recovery */
+	};
+};
+
+struct r5c_stripe {
+	u64 raid_index;
+	struct r5c_cache *cache;
+	atomic_t ref;
+	int state;
+	int recovery_state; /* just for recovery */
+
+	struct list_head io_ranges; /* order list */
+	union {
+		struct list_head stripes;
+		struct list_head parity_list; /* just for recovery */
+	};
+
+	struct list_head lru;
+
+	int existing_pages;
+	atomic_t dirty_stripes;
+	atomic_t pending_bios;
+	struct page **parity_pages; /* just for recovery */
+	struct page *data_pages[];
+};
+
+enum {
+	STRIPE_RUNNING = 0,
+	STRIPE_FROZEN = 1, /* Doesn't accept new IO */
+	STRIPE_PARITY_DONE = 2,
+	STRIPE_INRAID = 3,
+	STRIPE_DEAD = 4,
+
+	RECOVERY_NO_FLUSH = 0,
+	RECOVERY_FLUSH_START = 1, /* stripe in a start flush block */
+	RECOVERY_FLUSH_END = 2,
+};
+
+#define STRIPE_LOCK_BITS 8
+struct r5c_cache {
+	struct mddev *mddev;
+	struct md_rdev *rdev;
+
+	struct r5l_log log;
+
+	spinlock_t tree_lock; /* protect stripe_tree, log_list, full_stripes */
+	struct radix_tree_root stripe_tree;
+	struct list_head log_list; /* sorted list of io_range */
+	struct list_head full_stripes;
+	int full_stripe_cnt;
+
+	struct list_head page_pool;
+	spinlock_t pool_lock;
+	u64 free_pages;
+	u64 total_pages;
+	u64 max_pages;
+	u64 low_watermark; /* for memory, pages */
+	u64 high_watermark;
+
+	unsigned int stripe_data_size; /* stripe size excluding parity, sector */
+	unsigned int chunk_size; /* one disk chunk size including parity, sector */
+	unsigned int stripe_size; /* stripe size including parity, sector */
+	unsigned int parity_disks;
+
+	unsigned int reclaim_batch;
+
+	unsigned int reserved_space; /* log reserved size, sector */
+
+	unsigned long reclaim_reason;
+	wait_queue_head_t reclaim_wait;
+	struct md_thread *reclaim_thread;
+	__le64 *stripe_flush_data;
+	int quiesce_state;
+
+	int in_recovery;
+
+	struct work_struct pending_io_work;
+
+	spinlock_t stripe_locks[1 << STRIPE_LOCK_BITS];
+	wait_queue_head_t stripe_waitq[1 << STRIPE_LOCK_BITS];
+
+	int error_state;
+	int error_type;
+	int retry_cnt;
+	unsigned long next_retry_time;
+	struct bio_list retry_bio_list;
+	wait_queue_head_t error_wait;
+
+	struct kmem_cache *io_range_kc;
+	struct kmem_cache *stripe_kc;
+	struct bio_set *bio_set;
+};
+
+enum {
+	RECLAIM_MEM = 0, /* work hard to reclaim memory */
+	RECLAIM_MEM_BACKGROUND = 1, /* try to reclaim memory */
+	RECLAIM_MEM_FULL = 2, /* only reclaim full stripe */
+	RECLAIM_DISK = 8, /* work hard to reclaim disk */
+	RECLAIM_DISK_BACKGROUND = 9, /* try to reclaim disk */
+	RECLAIM_FLUSH_ALL = 16, /* flush all data to raid */
+
+	QUIESCE_NONE = 0,
+	QUIESCE_START = 1,
+	QUIESCE_END = 2,
+
+	ERROR_NOERROR = 0,
+	ERROR_PREPARE = 1, /* Had an error, flushing cache to raid */
+	ERROR_FINISH = 2, /* Had an error, cache has no data */
+};
+
+#define STRIPE_INDEX_OFFSET(c, sect, index, offset) \
+({ \
+	sector_t tmp = sect; \
+	offset = sector_div(tmp, (c)->stripe_data_size); \
+	index = tmp; \
+})
+
+#define STRIPE_RAID_SECTOR(cache, stripe) \
+	((stripe)->raid_index * (cache)->stripe_data_size)
+
+#define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
+
+#define STRIPE_DATA_PAGES(c) ((c)->stripe_data_size >> PAGE_SECTOR_SHIFT)
+#define STRIPE_PARITY_PAGES(c) \
+	(((c)->stripe_size - (c)->stripe_data_size) >> PAGE_SECTOR_SHIFT)
+#define BLOCK_SECTOR(log, b) ((b) << (log)->block_sector_shift)
+#define SECTOR_BLOCK(log, s) ((s) >> (log)->block_sector_shift)
+#define PAGE_BLOCKS(log, p) ((p) << (log)->page_block_shift)
+
+#define UUID_CHECKSUM(log, data) \
+	(data ? log->uuid_checksum_data : log->uuid_checksum_meta)
+#define MAX_FLUSH_STRIPES(log) \
+	(((log)->block_size - sizeof(struct r5l_flush_block)) / sizeof(__le64))
+
+static u32 r5l_calculate_checksum(struct r5l_log *log, u32 crc,
+	void *buf, size_t size, bool data)
+{
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
+		block = block - log->last_block + log->first_block;
+	return block;
+}
+
+static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason);
+static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason);
+
+static r5blk_t r5l_free_space(struct r5l_log *log)
+{
+	r5blk_t used_size = (log->total_blocks + log->log_start -
+		log->last_checkpoint) % log->total_blocks;
+
+	if (log->total_blocks > used_size + log->reserved_blocks)
+		return log->total_blocks - used_size - log->reserved_blocks;
+	return 0;
+}
+
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
+			r5c_wake_reclaimer(log->cache,
+				RECLAIM_DISK_BACKGROUND);
+		mutex_unlock(&log->io_mutex);
+		return;
+	}
+
+	log->reserved_blocks += size;
+	mutex_unlock(&log->io_mutex);
+
+	r5c_wake_reclaimer(log->cache, RECLAIM_DISK);
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
+		wake_up_all(&log->space_waitq);
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
+	struct r5l_ioctl *io;
+
+	io = kmem_cache_alloc(log->io_kc, gfp);
+	if (!io)
+		return NULL;
+	io->meta_page = alloc_page(gfp | __GFP_ZERO);
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
+	struct r5l_ioctl *io = e;
+
+	__free_page(io->meta_page);
+	kmem_cache_free(log->io_kc, io);
+}
+
+static void r5l_submit_bio(struct r5l_log *log, int rw, struct bio *bio)
+{
+	/* all IO must start from rdev->data_offset */
+	struct bio *next = bio->bi_next;
+
+	/* queue_task split bio into bio->bi_next */
+	if (next) {
+		next->bi_iter.bi_sector += log->rdev->data_offset;
+		submit_bio(rw, next);
+		bio->bi_next = NULL;
+	}
+
+	bio->bi_iter.bi_sector += log->rdev->data_offset;
+	submit_bio(rw, bio);
+}
+
+static void r5l_put_ioctl(struct r5l_ioctl *io, int error)
+{
+	struct r5l_log *log = io->log;
+	LIST_HEAD(finished_io);
+	unsigned long flags;
+	bool do_wakeup;
+
+	if (error)
+		io->error = error;
+
+	if (!atomic_dec_and_test(&io->refcnt))
+		return;
+
+	/*
+	 * finish IO in order. Note this guarantees later task runs ->fn after
+	 * previous task's IO and this task's IO are finished, but doesn't mean
+	 * previous task already runs its ->fn
+	 */
+	spin_lock_irqsave(&log->io_list_lock, flags);
+	while (!list_empty(&log->running_ios)) {
+		io = list_first_entry(&log->running_ios, struct r5l_ioctl,
+			log_sibling);
+		if (atomic_read(&io->refcnt))
+			break;
+		list_move_tail(&io->log_sibling, &finished_io);
+
+	}
+	do_wakeup = list_empty(&log->running_ios);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
+
+	while (!list_empty(&finished_io)) {
+		struct r5l_task *task;
+
+		io = list_first_entry(&finished_io, struct r5l_ioctl,
+			log_sibling);
+		list_del(&io->log_sibling);
+
+		while (!list_empty(&io->tasks)) {
+			task = list_first_entry(&io->tasks, struct r5l_task,
+				list);
+			list_del(&task->list);
+			task->fn(task, io->error);
+		}
+		mempool_free(io, log->io_pool);
+	}
+	if (do_wakeup)
+		wake_up(&log->io_waitq);
+}
+
+static void r5l_log_endio(struct bio *bio, int error)
+{
+	struct r5l_ioctl *io = bio->bi_private;
+
+	bio_put(bio);
+	r5l_put_ioctl(io, error);
+}
+
+static void r5l_submit_io(struct r5l_log *log)
+{
+	struct r5l_ioctl *io = log->current_io;
+	struct r5l_task *task;
+	struct r5l_meta_header *header;
+	u32 crc;
+
+	header = kmap_atomic(io->meta_page);
+	header->meta_size = cpu_to_le32(io->meta_offset);
+	crc = r5l_calculate_checksum(log, UUID_CHECKSUM(log, false),
+		header, log->block_size, false);
+	header->checksum = cpu_to_le32(crc);
+	kunmap_atomic(header);
+
+	r5l_submit_bio(log, WRITE_FUA, io->meta_bio);
+
+	list_for_each_entry(task, &io->tasks, list) {
+		if (task->bio)
+			r5l_submit_bio(log, task->bio->bi_rw, task->bio);
+	}
+	log->current_io = NULL;
+	r5l_put_ioctl(io, 0);
+}
+
+static struct r5l_ioctl *r5l_new_meta(struct r5l_log *log)
+{
+	struct r5l_ioctl *io;
+
+	io = mempool_alloc(log->io_pool, GFP_NOIO);
+	io->log = log;
+
+	io->meta_sector = BLOCK_SECTOR(log, log->log_start);
+	io->meta_offset = sizeof(struct r5l_meta_header);
+	atomic_set(&io->refcnt, 1);
+	INIT_LIST_HEAD(&io->tasks);
+	io->seq = log->seq;
+	io->error = 0;
+
+	io->meta_bio = bio_alloc_bioset(GFP_NOIO,
+		bio_get_nr_vecs(log->bdev), log->bio_set);
+	io->meta_bio->bi_bdev = log->bdev;
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
+	struct r5l_ioctl *io;
+	struct r5l_meta_header *header;
+	unsigned int meta_size;
+
+	meta_size = sizeof(struct r5l_meta_payload) +
+		sizeof(u32) * pages;
+	io = log->current_io;
+	if (io && io->meta_offset + meta_size > log->block_size)
+		r5l_submit_io(log);
+	io = log->current_io;
+	if (io) {
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
+	header = kmap_atomic(io->meta_page);
+	header->magic = cpu_to_le32(R5LOG_MAGIC);
+	header->type = cpu_to_le32(R5LOG_TYPE_META);
+	header->seq = cpu_to_le64(log->seq - 1);
+	if (log->log_start == log->first_block)
+		header->position = cpu_to_le64(log->last_block - 1);
+	else
+		header->position = cpu_to_le64(log->log_start - 1);
+	kunmap_atomic(header);
+
+	return 0;
+}
+
+static int r5l_log_add_parity_pages(struct r5l_log *log,
+	struct r5l_task *task)
+{
+	struct r5l_ioctl *io = log->current_io;
+	struct bio *bio;
+	struct page *pages[] = {task->page_p, task->page_q};
+	int i;
+
+	bio = io->current_bio;
+
+alloc_bio:
+	if (!bio) {
+		/* bio can only contain one page ? */
+		BUG_ON(task->bio);
+		bio = bio_alloc_bioset(GFP_NOIO,
+			bio_get_nr_vecs(log->bdev), log->bio_set);
+		bio->bi_rw = WRITE;
+		task->bio = bio;
+		io->current_bio = bio;
+		bio->bi_bdev = log->bdev;
+		bio->bi_iter.bi_sector = BLOCK_SECTOR(log, log->log_start);
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
+	}
+	return 0;
+}
+
+/* must hold io_mutex */
+static int r5l_run_task(struct r5l_log *log, struct r5l_task *task)
+{
+	unsigned int pages;
+	struct r5l_ioctl *io;
+	unsigned int reserved_blocks = task->reserved_blocks;
+	struct r5l_meta_payload *payload;
+	struct bio *bio;
+	void *meta;
+	int i;
+
+	if (task->type == R5LOG_PAYLOAD_DATA)
+		pages = bio_sectors(task->bio) >> PAGE_SECTOR_SHIFT;
+	else
+		pages = !!task->page_p + !!task->page_q;
+
+	r5l_get_meta(log, pages, task->type == R5LOG_PAYLOAD_DATA);
+
+	io = log->current_io;
+
+	meta = kmap_atomic(io->meta_page);
+	payload = meta + io->meta_offset;
+	payload->payload_type = cpu_to_le16(task->type);
+	payload->blocks = cpu_to_le32(PAGE_BLOCKS(log, pages));
+	if (task->type == R5LOG_PAYLOAD_DATA) {
+		bio = task->bio;
+		payload->location = cpu_to_le64(bio->bi_iter.bi_sector);
+	} else
+		payload->location = cpu_to_le64(task->stripe_sector);
+	for (i = 0; i < pages; i++)
+		payload->data_checksum[i] = cpu_to_le32(task->checksum[i]);
+	kunmap_atomic(meta);
+
+	io->meta_offset += sizeof(struct r5l_meta_payload) +
+		sizeof(u32) * pages;
+	task->seq = io->seq;
+	task->meta_start = io->meta_sector;
+	task->data_start = BLOCK_SECTOR(log, log->log_start);
+
+	if (task->type == R5LOG_PAYLOAD_PARITY)
+		r5l_log_add_parity_pages(log, task);
+
+	if (task->bio) {
+		bio = task->bio;
+		bio->bi_iter.bi_sector = task->data_start;
+		bio->bi_end_io = r5l_log_endio;
+		bio->bi_private = io;
+		bio->bi_bdev = log->bdev;
+		atomic_inc(&io->refcnt);
+	}
+
+	if (task->type == R5LOG_PAYLOAD_PARITY)
+		bio = io->current_bio;
+	else
+		bio = task->bio;
+
+	if (bio_end_sector(bio) > (BLOCK_SECTOR(log, log->last_block))) {
+		struct bio *split;
+		split = bio_split(bio, BLOCK_SECTOR(log, log->last_block) -
+			bio->bi_iter.bi_sector, GFP_NOIO, log->bio_set);
+		bio->bi_next = split;
+		bio_chain(split, bio);
+		bio->bi_iter.bi_sector = BLOCK_SECTOR(log, log->first_block);
+	}
+
+	log->log_start = r5l_ring_add(log, log->log_start,
+		PAGE_BLOCKS(log, pages));
+
+	list_add_tail(&task->list, &io->tasks);
+
+	__r5l_put_reserve(log, reserved_blocks);
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
+		r5l_run_task(log, task);
+	}
+	if (log->current_io)
+		r5l_submit_io(log);
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
+ * Since we finish IO in order and meta is written with FUA, so meta is always
+ * consistent. For FUA, just make sure both meta and data are written with FUA
+ * and finish IO after both parts are finished. For FLUSH, previous data and
+ * meta are already finished, just need flush the disk. In either case, bio
+ * already has the flag, so just handle them like normal bio
+ */
+static void r5l_flush_endio(struct bio *bio, int error)
+{
+	struct r5l_task *task = bio->bi_private;
+	bio_put(bio);
+
+	task->fn(task, error);
+}
+
+static int r5l_queue_empty_flush_bio(struct r5l_log *log, struct bio *bio,
+	r5l_task_end_fn fn, void *private)
+{
+	struct r5l_task *task;
+
+	task = kmalloc(sizeof(*task), GFP_NOIO);
+	if (!task)
+		return -ENOMEM;
+	task->bio = bio_clone(bio, GFP_NOIO);
+	if (!task->bio) {
+		kfree(task);
+		return -ENOMEM;
+	}
+	task->orig_bio = bio;
+	task->fn = fn;
+	task->private = private;
+	task->bio->bi_bdev = log->bdev;
+	task->bio->bi_end_io = r5l_flush_endio;
+	task->bio->bi_private = task;
+	generic_make_request(task->bio);
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
+	checksum[0] = UUID_CHECKSUM(log, true);
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
+			checksum[page_index] = UUID_CHECKSUM(log, true);
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
+		UUID_CHECKSUM(log, true), addr, PAGE_SIZE, true);
+	kunmap_atomic(addr);
+
+	if (page_q) {
+		addr = kmap_atomic(page_q);
+		checksum[1] = r5l_calculate_checksum(log,
+			UUID_CHECKSUM(log, true), addr, PAGE_SIZE, true);
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
+static int r5l_flush_block(struct r5l_log *log, int type, __le64 *stripes,
+	size_t size, u64 *next_seq, sector_t *next_sec)
+{
+	struct r5l_ioctl *io;
+	struct r5l_flush_block *fb;
+	struct r5l_task task;
+	DECLARE_COMPLETION_ONSTACK(fb_complete);
+	u32 crc;
+
+	mutex_lock(&log->io_mutex);
+
+	if (log->current_io)
+		r5l_submit_io(log);
+
+	/* FIXME: we already wait in reclaim thread, don't need wait again? */
+	spin_lock_irq(&log->io_list_lock);
+	wait_event_lock_irq(log->io_waitq, list_empty(&log->running_ios),
+		log->io_list_lock);
+	spin_unlock_irq(&log->io_list_lock);
+
+	io = r5l_new_meta(log);
+	task.fn = r5l_fb_end;
+	task.private = &fb_complete;
+	/* pretend we are parity */
+	task.type = R5LOG_PAYLOAD_PARITY;
+
+	fb = kmap_atomic(io->meta_page);
+	fb->header.magic = cpu_to_le32(R5LOG_MAGIC);
+	fb->header.type = cpu_to_le32(type);
+	fb->header.seq = cpu_to_le64(log->seq - 1);
+	if (log->log_start == log->first_block)
+		fb->header.position = cpu_to_le64(log->last_block - 1);
+	else
+		fb->header.position = cpu_to_le64(log->log_start - 1);
+	fb->header.meta_size = cpu_to_le32(sizeof(struct r5l_flush_block) + size);
+	memcpy(fb->flush_stripes, stripes, size);
+	crc = r5l_calculate_checksum(log, UUID_CHECKSUM(log, false), fb,
+			log->block_size, false);
+	fb->header.checksum = cpu_to_le32(crc);
+	kunmap_atomic(fb);
+
+	list_add_tail(&task.list, &io->tasks);
+
+	r5l_submit_bio(log, WRITE_FLUSH_FUA, io->meta_bio);
+	r5l_put_ioctl(io, 0);
+
+	*next_seq = log->seq;
+	*next_sec = BLOCK_SECTOR(log, log->log_start);
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
+		blkdev_issue_discard(log->bdev,
+			BLOCK_SECTOR(log, start) + log->rdev->data_offset,
+			BLOCK_SECTOR(log, end - start), GFP_NOIO, 0);
+	} else {
+		blkdev_issue_discard(log->bdev,
+			BLOCK_SECTOR(log, start) + log->rdev->data_offset,
+			BLOCK_SECTOR(log, log->last_block - start),
+			GFP_NOIO, 0);
+		blkdev_issue_discard(log->bdev,
+			BLOCK_SECTOR(log, log->first_block) +
+			log->rdev->data_offset,
+			BLOCK_SECTOR(log, end - log->first_block),
+			GFP_NOIO, 0);
+	}
+}
+
+static int r5l_write_super(struct r5l_log *log, u64 seq, sector_t cp)
+{
+	struct r5c_cache *cache = log->cache;
+	struct r5l_super_block *sb_blk;
+	struct timespec now = current_kernel_time();
+	r5blk_t free;
+	u32 crc;
+
+	if (seq == log->last_cp_seq)
+		return 0;
+
+	mutex_lock(&log->io_mutex);
+	r5l_discard_blocks(log, log->last_checkpoint,
+		SECTOR_BLOCK(log, cp));
+
+	log->last_cp_seq = seq;
+	log->last_checkpoint = SECTOR_BLOCK(log, cp);
+
+	free = r5l_free_space(log);
+	if (free > 0) {
+		clear_bit(RECLAIM_DISK, &cache->reclaim_reason);
+		wake_up_all(&log->space_waitq);
+	}
+	if (free > log->high_watermark)
+		clear_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason);
+
+	mutex_unlock(&log->io_mutex);
+
+	sb_blk = kmap_atomic(log->super_page);
+	sb_blk->header.seq = cpu_to_le64(seq);
+	sb_blk->last_checkpoint = cpu_to_le64(SECTOR_BLOCK(log, cp));
+	sb_blk->update_time_sec = cpu_to_le64(now.tv_sec);
+	sb_blk->update_time_nsec = cpu_to_le64(now.tv_nsec);
+	sb_blk->header.checksum = 0;
+	crc = r5l_calculate_checksum(log, UUID_CHECKSUM(log, false),
+		sb_blk, log->block_size, false);
+	sb_blk->header.checksum = cpu_to_le32(crc);
+	kunmap_atomic(sb_blk);
+
+	if (!sync_page_io(log->rdev, 0, log->block_size, log->super_page,
+	     WRITE_FUA, false))
+		return -EIO;
+
+	return 0;
+}
+
+static void r5c_lock_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	unsigned long *flags)
+{
+	spinlock_t *lock;
+
+	lock = &cache->stripe_locks[hash_ptr(stripe, STRIPE_LOCK_BITS)];
+	spin_lock_irqsave(lock, *flags);
+}
+
+static void r5c_unlock_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	unsigned long *flags)
+{
+	spinlock_t *lock;
+
+	lock = &cache->stripe_locks[hash_ptr(stripe, STRIPE_LOCK_BITS)];
+	spin_unlock_irqrestore(lock, *flags);
+}
+
+static wait_queue_head_t *r5c_stripe_waitq(struct r5c_cache *cache,
+	struct r5c_stripe *stripe)
+{
+	return &cache->stripe_waitq[hash_ptr(stripe, STRIPE_LOCK_BITS)];
+}
+
+static void r5c_stripe_wait_state(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, int state)
+{
+	wait_event(*r5c_stripe_waitq(cache, stripe), stripe->state >= state);
+}
+
+static struct page *r5c_get_page(struct r5c_cache *cache)
+{
+	struct page *page;
+again:
+	spin_lock_irq(&cache->pool_lock);
+	if (!list_empty(&cache->page_pool)) {
+		page = list_first_entry(&cache->page_pool,
+			struct page, lru);
+		list_del_init(&page->lru);
+		cache->free_pages--;
+		if (cache->free_pages < cache->low_watermark)
+			r5c_wake_reclaimer(cache,
+				RECLAIM_MEM_BACKGROUND);
+	}
+	spin_unlock_irq(&cache->pool_lock);
+	if (page)
+		return page;
+	r5c_wake_wait_reclaimer(cache, RECLAIM_MEM);
+	goto again;
+}
+
+static void r5c_put_pages(struct r5c_cache *cache,
+	struct page *pages[], int size)
+{
+	unsigned long flags;
+	int free = 0;
+	int i;
+
+	spin_lock_irqsave(&cache->pool_lock, flags);
+	for (i = 0; i < size; i++) {
+		if (!pages[i])
+			continue;
+		if (cache->total_pages > cache->max_pages) {
+			__free_page(pages[i]);
+			cache->total_pages--;
+		} else {
+			list_add(&pages[i]->lru, &cache->page_pool);
+			free++;
+		}
+	}
+	cache->free_pages += free;
+	if (cache->free_pages >= cache->high_watermark)
+		clear_bit(RECLAIM_MEM_BACKGROUND, &cache->reclaim_reason);
+	clear_bit(RECLAIM_MEM, &cache->reclaim_reason);
+	spin_unlock_irqrestore(&cache->pool_lock, flags);
+
+	wake_up_all(&cache->reclaim_wait);
+}
+
+static struct r5c_stripe *
+r5c_search_stripe(struct r5c_cache *cache, u64 stripe_index)
+{
+	struct r5c_stripe *stripe;
+
+	spin_lock_irq(&cache->tree_lock);
+	stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+	spin_unlock_irq(&cache->tree_lock);
+	return stripe;
+}
+
+static void r5c_put_stripe(struct r5c_stripe *stripe);
+static struct r5c_stripe *
+r5c_get_stripe(struct r5c_cache *cache, u64 stripe_index)
+{
+	struct r5c_stripe *stripe;
+
+again:
+	spin_lock_irq(&cache->tree_lock);
+	stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+	if (stripe)
+		atomic_inc(&stripe->ref);
+	spin_unlock_irq(&cache->tree_lock);
+
+	if (!stripe)
+		return NULL;
+	BUG_ON(stripe->raid_index != stripe_index);
+	/* The stripe is being reclaimed, wait reclaim finish */
+	if (stripe->state >= STRIPE_FROZEN) {
+		r5c_stripe_wait_state(cache, stripe, STRIPE_DEAD);
+		r5c_put_stripe(stripe);
+		goto again;
+	}
+	return stripe;
+}
+
+static struct r5c_stripe *
+r5c_create_get_stripe(struct r5c_cache *cache, u64 stripe_index)
+{
+	struct r5c_stripe *stripe, *new;
+	int error;
+
+again:
+	spin_lock_irq(&cache->tree_lock);
+	stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+	if (stripe)
+		atomic_inc(&stripe->ref);
+	spin_unlock_irq(&cache->tree_lock);
+
+	if (stripe)
+		goto has_stripe;
+
+	new = kmem_cache_zalloc(cache->stripe_kc, GFP_NOIO);
+	if (!new)
+		return NULL;
+
+	new->raid_index = stripe_index;
+	atomic_set(&new->ref, 2);
+	new->state = STRIPE_RUNNING;
+	new->cache = cache;
+	INIT_LIST_HEAD(&new->io_ranges);
+	INIT_LIST_HEAD(&new->stripes);
+	INIT_LIST_HEAD(&new->lru);
+
+	error = radix_tree_preload(GFP_NOIO);
+	if (error) {
+		kmem_cache_free(cache->stripe_kc, new);
+		return NULL;
+	}
+
+	spin_lock_irq(&cache->tree_lock);
+	if (radix_tree_insert(&cache->stripe_tree, stripe_index, new)) {
+		stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+		atomic_inc(&stripe->ref);
+		kmem_cache_free(cache->stripe_kc, new);
+	} else
+		stripe = new;
+	spin_unlock_irq(&cache->tree_lock);
+
+	radix_tree_preload_end();
+
+	BUG_ON(stripe->raid_index != stripe_index);
+has_stripe:
+	/* The stripe is being reclaimed, wait reclaim finish */
+	if (stripe->state >= STRIPE_FROZEN) {
+		r5c_stripe_wait_state(cache, stripe, STRIPE_DEAD);
+		r5c_put_stripe(stripe);
+		goto again;
+	}
+
+	return stripe;
+}
+
+static void r5c_put_stripe(struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *range;
+	unsigned long flags, flags2;
+
+	local_irq_save(flags);
+	if (!atomic_dec_and_lock(&stripe->ref, &cache->tree_lock)) {
+		local_irq_restore(flags);
+		/* the stripe is freezing, might wait for ref */
+		if (atomic_read(&stripe->ref) == 1)
+			wake_up_all(r5c_stripe_waitq(cache, stripe));
+
+		return;
+	}
+
+	BUG_ON(radix_tree_delete(&cache->stripe_tree, stripe->raid_index)
+		!= stripe);
+
+	r5c_lock_stripe(cache, stripe, &flags2);
+	while (!list_empty(&stripe->io_ranges)) {
+		range = list_first_entry(&stripe->io_ranges,
+			struct r5c_io_range, stripe_sibling);
+		list_del(&range->stripe_sibling);
+
+		list_del(&range->log_sibling);
+
+		kmem_cache_free(cache->io_range_kc, range);
+	}
+	r5c_put_pages(cache, stripe->data_pages, STRIPE_DATA_PAGES(cache));
+	BUG_ON(stripe->parity_pages);
+
+	r5c_unlock_stripe(cache, stripe, &flags2);
+
+	spin_unlock_irqrestore(&cache->tree_lock, flags);
+
+	kmem_cache_free(cache->stripe_kc, stripe);
+}
+
+/* must hold cache->tree_lock */
+static bool r5c_freeze_stripe(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, bool blocking)
+{
+	if (atomic_read(&stripe->ref) == 1) {
+		stripe->state = STRIPE_FROZEN;
+		return true;
+	}
+	if (!blocking)
+		return false;
+	/* Make sure no IO running in stripe */
+	wait_event_lock_irq(*r5c_stripe_waitq(cache, stripe),
+			atomic_read(&stripe->ref) == 1 ||
+			stripe->state >= STRIPE_FROZEN, cache->tree_lock);
+	if (stripe->state >= STRIPE_FROZEN)
+		return false;
+	stripe->state = STRIPE_FROZEN;
+	return true;
+}
+
+static bool r5c_check_wait_error_mode(struct r5c_cache *cache)
+{
+	if (cache->error_state)
+		wait_event(cache->error_wait,
+			cache->error_state == ERROR_FINISH);
+	if (cache->next_retry_time &&
+	    time_before(cache->next_retry_time, jiffies))
+		md_wakeup_thread(cache->reclaim_thread);
+	return !!cache->error_state;
+}
+
+static void r5c_enter_error_mode(struct r5c_cache *cache, int error)
+{
+	if (cmpxchg(&cache->error_state, ERROR_NOERROR,
+	    ERROR_PREPARE) == ERROR_NOERROR) {
+		printk(KERN_ERR"md: %s caching has %s, enter bypass mode\n",
+			mdname(cache->mddev),
+			error == -ENOMEM ? "no memory" : "IO error");
+		cache->error_type = error;
+		r5c_wake_reclaimer(cache, RECLAIM_FLUSH_ALL);
+	}
+}
+
+static void r5c_bio_task_end(struct r5l_task *task, int error)
+{
+	struct r5c_io_range *range = task->private;
+	struct r5c_stripe *stripe = range->stripe;
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *tmp;
+	unsigned long flags, flags2;
+	struct bio *orig_bio;
+
+	range->seq = task->seq;
+	range->meta_start = task->meta_start;
+	range->data_start = task->data_start;
+	orig_bio = task->orig_bio;
+	kfree(task);
+
+	spin_lock_irqsave(&cache->tree_lock, flags);
+
+	if (list_empty(&cache->log_list)) {
+		list_add_tail(&range->log_sibling, &cache->log_list);
+		goto out;
+	}
+	/* generally tmp will be the last one */
+	list_for_each_entry_reverse(tmp, &cache->log_list, log_sibling) {
+		/* later range has bigger seq and meta_start than previous range */
+		if (range->seq >= tmp->seq)
+			break;
+	}
+	list_add_tail(&range->log_sibling, &tmp->log_sibling);
+out:
+	r5c_lock_stripe(cache, stripe, &flags2);
+	if (stripe->existing_pages == STRIPE_DATA_PAGES(cache) &&
+	    list_empty(&stripe->lru)) {
+		list_add_tail(&stripe->lru, &cache->full_stripes);
+		cache->full_stripe_cnt++;
+		if (cache->full_stripe_cnt >= cache->reclaim_batch)
+			r5c_wake_reclaimer(cache,
+				RECLAIM_MEM_FULL);
+	}
+	r5c_unlock_stripe(cache, stripe, &flags2);
+
+	if (error) {
+		bio_list_add(&cache->retry_bio_list, orig_bio);
+		r5c_enter_error_mode(cache, -EIO);
+	}
+	spin_unlock_irqrestore(&cache->tree_lock, flags);
+
+	if (!error) {
+		bio_endio(orig_bio, 0);
+		md_write_end(cache->mddev);
+	}
+
+	r5c_put_stripe(stripe);
+}
+
+static void r5c_copy_bio(struct bio *bio, struct page *pages[], bool tobio)
+{
+	struct bio *src = bio;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	void *src_p, *dst_p;
+	unsigned page_index = 0, page_offset = 0;
+	unsigned bytes;
+
+	iter = src->bi_iter;
+
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
+		}
+
+		bv = bio_iter_iovec(src, iter);
+
+		bytes = min_t(unsigned int, bv.bv_len, PAGE_SIZE - page_offset);
+
+		src_p = kmap_atomic(bv.bv_page);
+		dst_p = kmap_atomic(pages[page_index]);
+
+		if (tobio) {
+			memcpy(src_p + bv.bv_offset,
+			       dst_p + page_offset, bytes);
+		} else {
+			memcpy(dst_p + page_offset,
+			       src_p + bv.bv_offset, bytes);
+		}
+
+		kunmap_atomic(dst_p);
+		kunmap_atomic(src_p);
+
+		bio_advance_iter(src, &iter, bytes);
+		page_offset += bytes;
+	}
+}
+
+static void r5c_bio_flush_task_end(struct r5l_task *task, int error)
+{
+	struct r5c_cache *cache = task->private;
+	struct bio *orig_bio = task->orig_bio;
+	unsigned long flags;
+
+	kfree(task);
+
+	if (error) {
+		spin_lock_irqsave(&cache->tree_lock, flags);
+		bio_list_add(&cache->retry_bio_list, orig_bio);
+		r5c_enter_error_mode(cache, -EIO);
+		spin_unlock_irqrestore(&cache->tree_lock, flags);
+	} else {
+		bio_endio(orig_bio, 0);
+		md_write_end(cache->mddev);
+	}
+}
+
+static void r5c_write_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *io_range;
+	unsigned long index;
+	unsigned int offset;
+	int i, new_pages = 0;
+	unsigned long flags;
+	unsigned int reserved_blocks = 0;
+	unsigned int pages;
+
+	/* Doesn't support discard */
+	if (bio->bi_rw & REQ_DISCARD) {
+		bio_endio(bio, 0);
+		md_write_end(cache->mddev);
+		return;
+	}
+
+	if (r5c_check_wait_error_mode(cache))
+		goto error_mode;
+
+	if (bio->bi_iter.bi_size == 0) {
+		BUG_ON(!(bio->bi_rw & REQ_FLUSH));
+		if (r5l_queue_empty_flush_bio(&cache->log, bio,
+		    r5c_bio_flush_task_end, cache))
+			goto enter_error;
+		return;
+	}
+
+	pages = bio_sectors(bio) >> PAGE_SECTOR_SHIFT;
+	reserved_blocks = 1 + PAGE_BLOCKS(&cache->log, pages);
+	r5l_get_reserve(&cache->log, reserved_blocks);
+
+	STRIPE_INDEX_OFFSET(cache, bio->bi_iter.bi_sector, index, offset);
+
+	stripe = r5c_create_get_stripe(cache, index);
+	if (!stripe)
+		goto enter_error;
+
+	io_range = kmem_cache_alloc(cache->io_range_kc, GFP_NOIO);
+	if (!io_range)
+		goto put_error;
+
+	io_range->bio = bio;
+	io_range->raid_start = bio->bi_iter.bi_sector;
+	io_range->data_sectors = bio_sectors(bio);
+	io_range->stripe = stripe;
+
+	/* FIXME: if read comes in here, it might read random data */
+	offset >>= PAGE_SECTOR_SHIFT;
+	for (i = offset; i < offset + (bio_sectors(bio) >> PAGE_SECTOR_SHIFT);
+	     i++) {
+		if (stripe->data_pages[i])
+			continue;
+		stripe->data_pages[i] = r5c_get_page(cache);
+		new_pages++;
+	}
+
+	r5c_copy_bio(bio, &stripe->data_pages[offset], false);
+
+	r5c_lock_stripe(cache, stripe, &flags);
+	list_add_tail(&io_range->stripe_sibling, &stripe->io_ranges);
+	stripe->existing_pages += new_pages;
+	r5c_unlock_stripe(cache, stripe, &flags);
+
+	if (r5l_queue_bio(&cache->log, bio, r5c_bio_task_end, io_range,
+	    reserved_blocks))
+		goto put_error;
+	return;
+put_error:
+	r5c_put_stripe(stripe);
+enter_error:
+	r5l_put_reserve(&cache->log, reserved_blocks);
+	r5c_enter_error_mode(cache, -ENOMEM);
+	r5c_check_wait_error_mode(cache);
+error_mode:
+	raid5_make_request(cache->mddev, bio);
+}
+
+static void r5c_read_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct r5c_stripe *stripe;
+	u64 stripe_index;
+	int offset;
+	u64 start, end, tmp;
+	struct bio *split;
+
+	STRIPE_INDEX_OFFSET(cache, bio->bi_iter.bi_sector, stripe_index, offset);
+
+	stripe = r5c_get_stripe(cache, stripe_index);
+	if (!stripe) {
+		raid5_make_request(cache->mddev, bio);
+		return;
+	}
+
+	start = offset >> PAGE_SECTOR_SHIFT;
+	end = start + (bio_sectors(bio) >> PAGE_SECTOR_SHIFT);
+
+	while (start < end) {
+		if (stripe->data_pages[start]) {
+			tmp = start;
+			while (tmp < end && stripe->data_pages[tmp])
+				tmp++;
+			if (tmp < end) {
+				split = bio_split(bio,
+					(tmp - start) << PAGE_SECTOR_SHIFT,
+					GFP_NOIO, NULL);
+				bio_chain(split, bio);
+			} else /* all in cache */
+				split = bio;
+
+			r5c_copy_bio(split, &stripe->data_pages[start], true);
+
+			bio_endio(split, 0);
+
+			start = tmp;
+		} else {
+			tmp = start;
+			while (tmp < end && !stripe->data_pages[tmp])
+				tmp++;
+			if (tmp < end) {
+				split = bio_split(bio,
+					(tmp - start) << PAGE_SECTOR_SHIFT,
+					GFP_NOIO, NULL);
+				bio_chain(split, bio);
+			} else
+				split = bio;
+
+			raid5_make_request(cache->mddev, split);
+
+			start = tmp;
+		}
+	}
+	r5c_put_stripe(stripe);
+}
+
+void r5c_flush_pending_parity(struct r5c_cache *cache)
+{
+	if (!cache)
+		return;
+	r5l_run_tasks(&cache->log, true);
+}
+
+static void r5c_flush_pending_io(struct r5c_cache *cache)
+{
+	r5l_run_tasks(&cache->log, false);
+}
+
+static void r5c_unplug_work(struct work_struct *work)
+{
+	struct r5c_cache *cache = container_of(work, struct r5c_cache,
+		pending_io_work);
+	r5c_flush_pending_io(cache);
+}
+
+static void r5c_unplug(struct blk_plug_cb *cb, bool from_schedule)
+{
+	struct r5c_cache *cache = cb->data;
+
+	kfree(cb);
+	if (from_schedule) {
+		schedule_work(&cache->pending_io_work);
+		return;
+	}
+	r5c_flush_pending_io(cache);
+}
+
+void r5c_handle_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct blk_plug_cb *cb;
+
+	if (bio_data_dir(bio) == READ) {
+		r5c_read_bio(cache, bio);
+		return;
+	}
+
+	md_write_start(cache->mddev, bio);
+
+	r5c_write_bio(cache, bio);
+
+	cb = blk_check_plugged(r5c_unplug, cache, sizeof(*cb));
+	if (!cb)
+		r5c_flush_pending_io(cache);
+}
+
+static void r5c_flush_endio(struct bio *bio, int err)
+{
+	struct r5c_stripe *stripe = bio->bi_private;
+	struct r5c_cache *cache = stripe->cache;
+
+	if (atomic_dec_and_test(&stripe->pending_bios)) {
+		stripe->state = STRIPE_INRAID;
+		wake_up_all(r5c_stripe_waitq(cache, stripe));
+	}
+
+	bio_put(bio);
+}
+
+void r5c_write_start(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+	if (!conf->cache)
+		md_write_start(mddev, bi);
+	/* Do nothing, r5c_handle_bio already does md_write_start */
+}
+
+void r5c_write_end(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+	if (!conf->cache) {
+		md_write_end(mddev);
+		return;
+	}
+
+	/*
+	 * r5c_flush_one doesn't set bi_bdev for bio, which doesn't require
+	 * md_write_end. While bio from retry_bio_list has bi_bdev, which
+	 * require md_write_end
+	 **/
+	if (bi->bi_bdev)
+		md_write_end(mddev);
+
+	/* Normal bio, r5c_bio_task_end already does md_write_end */
+}
+
+static void r5c_flush_one(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	int start, int pages)
+{
+	sector_t base;
+	struct bio *bio;
+	int max_vecs;
+	int i, j;
+
+	i = 0;
+	base = STRIPE_RAID_SECTOR(cache, stripe) + (start << PAGE_SECTOR_SHIFT);
+	while (i < pages) {
+		/* Below is ugly, but We don't have a block_device */
+		max_vecs = min_t(int, pages - i, BIO_MAX_PAGES);
+		bio = bio_alloc_bioset(GFP_NOIO, max_vecs, cache->bio_set);
+		bio->bi_iter.bi_sector = base + (i << PAGE_SECTOR_SHIFT);
+		bio->bi_bdev = NULL;
+		bio->bi_private = stripe;
+		for (j = 0; j < max_vecs; j++) {
+			struct bio_vec *bvec;
+			bvec = &bio->bi_io_vec[bio->bi_vcnt];
+			bvec->bv_page = stripe->data_pages[i + start];
+			bvec->bv_len = PAGE_SIZE;
+			bvec->bv_offset = 0;
+			bio->bi_vcnt++;
+			bio->bi_phys_segments++;
+			bio->bi_iter.bi_size += PAGE_SIZE;
+			i++;
+		}
+		bio->bi_end_io = r5c_flush_endio;
+		bio->bi_rw = WRITE;
+		atomic_inc(&stripe->pending_bios);
+		raid5_make_request(cache->mddev, bio);
+	}
+}
+
+static void r5c_put_stripe_dirty(struct r5c_cache *cache, struct r5c_stripe *stripe)
+{
+	if (!atomic_dec_return(&stripe->dirty_stripes)) {
+		stripe->state = STRIPE_PARITY_DONE;
+		wake_up_all(r5c_stripe_waitq(cache, stripe));
+	}
+}
+
+static void r5c_flush_stripe(struct r5c_cache *cache, struct r5c_stripe *stripe)
+{
+	unsigned long *stripe_bits;
+	int chunk_stripes;
+	int start;
+	int end = 0;
+	int i;
+
+	chunk_stripes = cache->chunk_size >> PAGE_SECTOR_SHIFT;
+	stripe_bits = kzalloc(BITS_TO_LONGS(chunk_stripes) * sizeof(long),
+		GFP_NOIO);
+	for (i = 0; i < STRIPE_DATA_PAGES(cache); i++) {
+		if (stripe->data_pages[i])
+			__set_bit(i % chunk_stripes, stripe_bits);
+	}
+	atomic_set(&stripe->dirty_stripes, bitmap_weight(stripe_bits,
+				chunk_stripes) + 1);
+	kfree(stripe_bits);
+
+	while (end < STRIPE_DATA_PAGES(cache)) {
+		while (end < STRIPE_DATA_PAGES(cache) && !stripe->data_pages[end])
+			end++;
+		if (end >= STRIPE_DATA_PAGES(cache))
+			break;
+		start = end;
+		while (end < STRIPE_DATA_PAGES(cache) && stripe->data_pages[end])
+			end++;
+		r5c_flush_one(cache, stripe, start, end - start);
+	}
+	r5c_put_stripe_dirty(cache, stripe);
+}
+
+/* Since r5c_freeze_stripe can sleep, this isn't multithread safe yet */
+static int r5c_select_front_stripes(struct r5c_cache *cache,
+	struct list_head *list, unsigned int count, bool blocking)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	int stripes = 0;
+
+	list_for_each_entry(range, &cache->log_list, log_sibling) {
+		stripe = range->stripe;
+		if (stripe->state >= STRIPE_FROZEN)
+			continue;
+
+		if (!r5c_freeze_stripe(cache, stripe, blocking))
+			continue;
+
+		list_move_tail(&stripe->lru, list);
+		stripes++;
+		if (stripes >= count)
+			break;
+	}
+	return stripes;
+}
+
+static int r5c_select_full_stripes(struct r5c_cache *cache,
+	struct list_head *list, unsigned int count, bool blocking)
+{
+	struct r5c_stripe *stripe, *tmp;
+	int stripes = 0;
+
+	list_for_each_entry_safe(stripe, tmp, &cache->full_stripes, lru) {
+		if (stripe->state >= STRIPE_FROZEN)
+			continue;
+		if (!r5c_freeze_stripe(cache, stripe, blocking))
+			continue;
+
+		list_move_tail(&stripe->lru, list);
+		stripes++;
+		cache->full_stripe_cnt--;
+		if (stripes >= count)
+			break;
+	}
+	if (list_empty(&cache->full_stripes))
+		clear_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
+
+	return stripes;
+}
+
+static void r5c_select_stripes(struct r5c_cache *cache, struct list_head *list)
+{
+	int stripes;
+	bool blocking;
+
+	/*
+	 * generally select full stripe, if no disk space, select first stripe
+	 */
+	spin_lock_irq(&cache->tree_lock);
+	/* Don't need stripe lock, as nobody is operating on the stripe */
+	if (test_bit(RECLAIM_FLUSH_ALL, &cache->reclaim_reason)) {
+		r5c_select_front_stripes(cache, list, cache->reclaim_batch, true);
+	} else if (test_bit(RECLAIM_DISK, &cache->reclaim_reason) ||
+	    test_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason)) {
+		blocking = test_bit(RECLAIM_DISK, &cache->reclaim_reason);
+		r5c_select_front_stripes(cache, list, cache->reclaim_batch, blocking);
+	} else if (test_bit(RECLAIM_MEM, &cache->reclaim_reason) ||
+	           test_bit(RECLAIM_MEM_BACKGROUND, &cache->reclaim_reason)) {
+		stripes = r5c_select_full_stripes(cache, list, cache->reclaim_batch, false);
+		if (stripes < cache->reclaim_batch)
+			stripes += r5c_select_front_stripes(cache, list,
+				cache->reclaim_batch - stripes, false);
+		if (stripes < cache->reclaim_batch)
+			stripes += r5c_select_full_stripes(cache, list,
+				cache->reclaim_batch - stripes, true);
+		if (stripes < cache->reclaim_batch)
+			stripes += r5c_select_front_stripes(cache, list,
+				cache->reclaim_batch - stripes, true);
+	} else if (test_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason)){
+		r5c_select_full_stripes(cache, list, cache->reclaim_batch, false);
+	}
+
+	spin_unlock_irq(&cache->tree_lock);
+}
+
+static void r5c_disks_flush_end(struct bio *bio, int err)
+{
+	struct completion *io_complete = bio->bi_private;
+
+	complete(io_complete);
+	bio_put(bio);
+}
+
+static void r5c_flush_all_disks(struct r5c_cache *cache)
+{
+	struct mddev *mddev = cache->mddev;
+	struct bio *bi;
+	DECLARE_COMPLETION_ONSTACK(io_complete);
+
+	bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
+	bi->bi_end_io = r5c_disks_flush_end;
+	bi->bi_private = &io_complete;
+
+	/* If bio hasn't payload, this function will just flush all disks */
+	md_flush_request(mddev, bi);
+
+	wait_for_completion_io(&io_complete);
+}
+
+static int r5c_stripe_list_cmp(void *priv, struct list_head *a,
+	struct list_head *b)
+{
+	struct r5c_stripe *stripe_a = container_of(a, struct r5c_stripe,
+		lru);
+	struct r5c_stripe *stripe_b = container_of(b, struct r5c_stripe,
+		lru);
+
+	return !(stripe_a->raid_index < stripe_b->raid_index);
+}
+
+static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
+	struct list_head *stripe_list)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	u64 seq;
+	sector_t meta;
+	struct blk_plug plug;
+	size_t size = 0;
+
+	if (list_empty(stripe_list))
+		return;
+	list_sort(NULL, stripe_list, r5c_stripe_list_cmp);
+	list_for_each_entry(stripe, stripe_list, lru) {
+		cache->stripe_flush_data[size] =
+				cpu_to_le64(stripe->raid_index);
+		size++;
+	}
+	size *= sizeof(__le64);
+
+	blk_start_plug(&plug);
+	/* step 1: start write to raid */
+	list_for_each_entry(stripe, stripe_list, lru)
+		r5c_flush_stripe(cache, stripe);
+	blk_finish_plug(&plug);
+
+	/* step 2: wait parity write to cache */
+	list_for_each_entry_reverse(stripe, stripe_list, lru)
+		r5c_stripe_wait_state(cache, stripe, STRIPE_PARITY_DONE);
+
+	/* step 3: make sure data and parity settle down */
+	r5l_flush_block(&cache->log, R5LOG_TYPE_FLUSH_START,
+		cache->stripe_flush_data, size, &seq, &meta);
+
+	/* step 4: continue write to raid */
+	list_for_each_entry(stripe, stripe_list, lru) {
+		while (!list_empty(&stripe->stripes)) {
+			struct stripe_head *sh;
+
+			sh = list_first_entry(&stripe->stripes,
+				struct stripe_head, stripe_list);
+			list_del(&sh->stripe_list);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			release_stripe(sh);
+		}
+	}
+
+	/* step 5: wait to make sure stripe data is in raid */
+	list_for_each_entry_reverse(stripe, stripe_list, lru)
+		r5c_stripe_wait_state(cache, stripe, STRIPE_INRAID);
+
+	/* step 6: flush raid disks */
+	r5c_flush_all_disks(cache);
+
+	/* step 7: mark data is flushed to raid */
+	r5l_flush_block(&cache->log, R5LOG_TYPE_FLUSH_END,
+		cache->stripe_flush_data, size, &seq, &meta);
+
+	/* step 8: mark stripe as dead */
+	while (!list_empty(stripe_list)) {
+		stripe = list_first_entry(stripe_list, struct r5c_stripe,
+			lru);
+		list_del_init(&stripe->lru);
+
+		stripe->state = STRIPE_DEAD;
+		wake_up_all(r5c_stripe_waitq(cache, stripe));
+
+		r5c_put_stripe(stripe);
+	}
+
+	/* step 9: advance superblock checkpoint */
+	spin_lock_irq(&cache->tree_lock);
+	/* if no data, superblock records the next position of checkpoint */
+	if (!list_empty(&cache->log_list)) {
+		range = list_first_entry(&cache->log_list,
+			struct r5c_io_range, log_sibling);
+		/* can't cross checkpoint */
+		if (range->seq < seq) {
+			seq = range->seq;
+			meta = range->meta_start;
+		}
+	}
+	spin_unlock_irq(&cache->tree_lock);
+
+	r5l_write_super(&cache->log, seq, meta);
+}
+
+static void r5c_reclaim_thread(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+	struct r5conf *conf = mddev->private;
+	struct r5c_cache *cache = conf->cache;
+	LIST_HEAD(stripe_list);
+	bool retry;
+
+do_retry:
+	retry = false;
+
+	while (cache->reclaim_reason != 0) {
+		/*
+		 * select stripe will freeze stripe, which will guarantee no
+		 * new task pending in error mode
+		 * */
+		r5c_select_stripes(cache, &stripe_list);
+
+		if (list_empty(&stripe_list)) {
+			clear_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
+			clear_bit(RECLAIM_MEM_BACKGROUND, &cache->reclaim_reason);
+			clear_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason);
+			clear_bit(RECLAIM_FLUSH_ALL, &cache->reclaim_reason);
+		} else
+			r5c_reclaim_stripe_list(cache, &stripe_list);
+
+		wake_up_all(&cache->reclaim_wait);
+	}
+
+	if (cache->error_state == ERROR_PREPARE) {
+		struct bio *bio;
+		spin_lock_irq(&cache->tree_lock);
+		if (!list_empty(&cache->log_list))
+			retry = true;
+		spin_unlock_irq(&cache->tree_lock);
+		if (retry)
+			goto do_retry;
+
+		cache->error_state = ERROR_FINISH;
+		wake_up(&cache->error_wait);
+
+		while ((bio = bio_list_pop(&cache->retry_bio_list)) != NULL)
+			raid5_make_request(cache->mddev, bio);
+
+		if (++cache->retry_cnt < MAX_RETRY) {
+			cache->next_retry_time = jiffies +
+				(cache->error_type != -ENOMEM ? IOERR_RETRY_TIME :
+					MEMERR_RETRY_TIME);
+		}
+	}
+	if (cache->next_retry_time &&
+		time_before(cache->next_retry_time, jiffies)) {
+		/* must guarantee there are no pending IO running in raid */
+		mddev_suspend(cache->mddev);
+		cache->next_retry_time = 0;
+		cache->error_type = 0;
+		cache->error_state = 0;
+		mddev_resume(cache->mddev);
+	}
+	if (cache->quiesce_state == QUIESCE_START) {
+		/* user IO already finished, we just stop reclaim */
+		cache->reclaim_reason = 0;
+		cache->quiesce_state = QUIESCE_END;
+		wake_up(&cache->reclaim_wait);
+		wait_event(cache->reclaim_wait, cache->quiesce_state ==
+			QUIESCE_NONE);
+	}
+}
+
+static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason)
+{
+	set_bit(reason, &cache->reclaim_reason);
+	md_wakeup_thread(cache->reclaim_thread);
+}
+
+static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason)
+{
+	r5c_wake_reclaimer(cache, reason);
+	wait_event(cache->reclaim_wait, !test_bit(reason,
+		&cache->reclaim_reason));
+}
+
+void r5c_quiesce(struct r5conf *conf, int state)
+{
+	struct r5c_cache *cache = conf->cache;
+
+	if (!cache || cache->error_state)
+		return;
+	if (state == 1) {
+		r5c_wake_wait_reclaimer(cache, RECLAIM_FLUSH_ALL);
+		cache->quiesce_state = QUIESCE_START;
+		md_wakeup_thread(cache->reclaim_thread);
+		wait_event(cache->reclaim_wait, cache->quiesce_state ==
+			QUIESCE_END);
+	} else if (state == 0) {
+		cache->quiesce_state = QUIESCE_NONE;
+		wake_up(&cache->reclaim_wait);
+	}
+}
+
+static void r5c_parity_task_end(struct r5l_task *task, int error)
+{
+	struct stripe_head *head_sh = task->private;
+	struct r5conf *conf = head_sh->raid_conf;
+	struct r5c_cache *cache = conf->cache;
+	struct r5c_stripe *stripe = head_sh->stripe;
+
+	/* parity IO error doesn't matter */
+	r5c_put_stripe_dirty(cache, stripe);
+	kfree(task);
+}
+
+/*
+ * we don't record parity range in cache->log_list, because after a success
+ * reclaim, parity always is discarded
+ */
+static void r5c_write_one_stripe_parity(struct r5c_cache *cache,
+	struct r5c_stripe *stripe, struct stripe_head *head_sh,
+	struct stripe_head *sh)
+{
+	u64 stripe_index;
+	int stripe_offset;
+
+	stripe_index = sh->sector;
+	stripe_offset = sector_div(stripe_index, cache->chunk_size);
+	stripe_offset >>= PAGE_SECTOR_SHIFT;
+
+	if (cache->in_recovery) {
+		stripe_offset *= cache->parity_disks;
+
+		copy_highpage(sh->dev[sh->pd_idx].page,
+			stripe->parity_pages[stripe_offset]);
+		if (sh->qd_idx >= 0)
+			copy_highpage(sh->dev[sh->qd_idx].page,
+				stripe->parity_pages[stripe_offset + 1]);
+
+		if (!atomic_dec_return(&stripe->dirty_stripes)) {
+			stripe->state = STRIPE_PARITY_DONE;
+			wake_up_all(r5c_stripe_waitq(cache, stripe));
+		}
+		return;
+	}
+
+	if (cache->error_state) {
+		r5c_put_stripe_dirty(cache, stripe);
+		return;
+	}
+
+	r5l_queue_parity(&cache->log, sh->sector,
+		sh->dev[sh->pd_idx].page,
+		sh->qd_idx >= 0 ? sh->dev[sh->qd_idx].page : NULL,
+		r5c_parity_task_end, head_sh);
+}
+
+int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *head_sh)
+{
+	struct r5c_stripe *stripe;
+	struct stripe_head *sh;
+	u64 stripe_index;
+	int parity_cnt;
+	unsigned long flags;
+
+	/* parity is already written */
+	if (head_sh->stripe || cache->error_state == ERROR_FINISH) {
+		head_sh->stripe = NULL;
+		return -EAGAIN;
+	}
+	if (!test_bit(R5_Wantwrite, &head_sh->dev[head_sh->pd_idx].flags))
+		return -EAGAIN;
+
+	stripe_index = head_sh->sector;
+	sector_div(stripe_index, cache->chunk_size);
+
+	stripe = r5c_search_stripe(cache, stripe_index);
+	r5c_lock_stripe(cache, stripe, &flags);
+	list_add_tail(&head_sh->stripe_list, &stripe->stripes);
+	r5c_unlock_stripe(cache, stripe, &flags);
+	head_sh->stripe = stripe;
+
+	atomic_inc(&head_sh->count);
+
+	parity_cnt = !!(head_sh->pd_idx >= 0) + !!(head_sh->qd_idx >= 0);
+	BUG_ON(parity_cnt != cache->parity_disks);
+
+	sh = head_sh;
+	do {
+		r5c_write_one_stripe_parity(cache, stripe, head_sh, sh);
+		if (!head_sh->batch_head)
+			return 0;
+		sh = list_first_entry(&sh->batch_list, struct stripe_head,
+				      batch_list);
+	} while (sh != head_sh);
+	return 0;
+}
+
+struct r5c_load_ctx {
+	struct r5c_cache *cache;
+	struct list_head io_ranges;
+	struct list_head stripes_with_parity;
+	struct list_head stripes_without_parity;
+	unsigned long *stripe_bits;
+	int chunk_stripes;
+	atomic_t io_cnt;
+	wait_queue_head_t io_wq;
+};
+
+/*
+ * If a stripe has parity in the log and is listed in a flush start block, the
+ * stripe is being flushed to raid. If the stripe is listed in flush end block,
+ * the striep is fully flushed to raid, all its data/parity can be discarded.
+ * Otherwise, the stripe must be recovered. If a stripe has parity data and is
+ * not listed in flush start block, it's not flushed to raid, its parity can be
+ * discarded.
+ * */
+static bool r5c_check_parity_full(struct r5c_load_ctx *ctx,
+	struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	int chunk_stripes = ctx->chunk_stripes;
+	unsigned long *stripe_bits = ctx->stripe_bits;
+	struct r5c_io_range *range;
+	sector_t index;
+	int offset, max;
+
+	memset(stripe_bits, 0, BITS_TO_LONGS(chunk_stripes) * sizeof(long));
+	list_for_each_entry(range, &stripe->io_ranges, stripe_sibling) {
+		STRIPE_INDEX_OFFSET(cache, range->raid_start, index, offset);
+		offset >>= PAGE_SECTOR_SHIFT;
+		max = (range->data_sectors >> PAGE_SECTOR_SHIFT) + offset;
+		for (; offset < max; offset++)
+			__set_bit(offset % chunk_stripes, stripe_bits);
+	}
+	list_for_each_entry(range, &stripe->parity_list, stripe_sibling) {
+		index = range->raid_start;
+
+		offset = sector_div(index, cache->chunk_size);
+		offset >>= PAGE_SECTOR_SHIFT;
+
+		if ((range->data_sectors >> PAGE_SECTOR_SHIFT) ==
+		     cache->parity_disks)
+			__clear_bit(offset, stripe_bits);
+	}
+
+	return bitmap_weight(stripe_bits, chunk_stripes) == 0;
+}
+
+static int r5c_add_flush_start(struct r5c_load_ctx *ctx,
+	struct r5l_flush_block *fb, u64 seq)
+{
+	struct r5c_stripe *stripe;
+	int size;
+	int i;
+	u64 stripe_index;
+
+	size = le32_to_cpu(fb->header.meta_size) -
+		sizeof(struct r5l_flush_block);
+	size /= sizeof(__le64);
+
+	for (i = 0; i < size; i++) {
+		stripe_index = le64_to_cpu(fb->flush_stripes[i]);
+		stripe = r5c_search_stripe(ctx->cache, stripe_index);
+		if (!stripe)
+			return -EINVAL;
+		if (!r5c_check_parity_full(ctx, stripe))
+			return -EINVAL;
+		stripe->recovery_state = RECOVERY_FLUSH_START;
+	}
+	return 0;
+}
+
+static int r5c_add_flush_end(struct r5c_load_ctx *ctx,
+	struct r5l_flush_block *fb, u64 seq)
+{
+	struct r5c_cache *cache = ctx->cache;
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	int size;
+	int i;
+	u64 stripe_index;
+
+	size = le32_to_cpu(fb->header.meta_size) -
+		sizeof(struct r5l_flush_block);
+	size /= sizeof(__le64);
+
+	for (i = 0; i < size; i++) {
+		stripe_index = le64_to_cpu(fb->flush_stripes[i]);
+		stripe = r5c_search_stripe(ctx->cache, stripe_index);
+		if (!stripe)
+			return -EINVAL;
+		if (stripe->recovery_state != RECOVERY_FLUSH_START)
+			return -EINVAL;
+
+		list_del(&stripe->lru);
+		/* essentially r5c_put_stripe */
+		radix_tree_delete(&cache->stripe_tree, stripe->raid_index);
+
+		while (!list_empty(&stripe->io_ranges)) {
+			range = list_first_entry(&stripe->io_ranges,
+				struct r5c_io_range, stripe_sibling);
+			list_del(&range->stripe_sibling);
+
+			list_del(&range->log_sibling);
+
+			kfree(range->checksum);
+			kmem_cache_free(cache->io_range_kc, range);
+		}
+		while (!list_empty(&stripe->parity_list)) {
+			range = list_first_entry(&stripe->parity_list,
+				struct r5c_io_range, stripe_sibling);
+			list_del(&range->stripe_sibling);
+
+			kfree(range->checksum);
+			kmem_cache_free(cache->io_range_kc, range);
+		}
+
+		kmem_cache_free(cache->stripe_kc, stripe);
+	}
+	return 0;
+}
+
+static int r5c_add_data(struct r5c_load_ctx *ctx, u64 seq,
+	sector_t meta_start, sector_t data_start, sector_t raid_start,
+	ssize_t sectors, u32 *checksum)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	u64 index;
+	int offset;
+
+	STRIPE_INDEX_OFFSET(ctx->cache, raid_start, index, offset);
+
+	stripe = r5c_create_get_stripe(ctx->cache, index);
+	if (stripe->recovery_state != RECOVERY_NO_FLUSH)
+		return -EINVAL;
+
+	range = kmem_cache_alloc(ctx->cache->io_range_kc, GFP_NOIO);
+	if (!range)
+		return -ENOMEM;
+
+	range->seq = seq;
+	range->meta_start = meta_start;
+	range->data_start = data_start;
+	range->raid_start = raid_start;
+	range->data_sectors = sectors;
+	range->stripe = stripe;
+	range->checksum = checksum;
+
+	list_add_tail(&range->stripe_sibling, &stripe->io_ranges);
+	list_add_tail(&range->log_sibling, &ctx->io_ranges);
+
+	if (list_empty(&stripe->lru))
+		list_add_tail(&stripe->lru, &ctx->stripes_without_parity);
+
+	r5c_put_stripe(stripe);
+	return 0;
+}
+
+static int r5c_add_parity(struct r5c_load_ctx *ctx, u64 seq,
+	sector_t meta_start, sector_t data_start, sector_t stripe_sect,
+	ssize_t sectors, u32 *checksum)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	sector_t index = stripe_sect;
+
+	sector_div(index, ctx->cache->log.chunk_size);
+
+	stripe = r5c_search_stripe(ctx->cache, index);
+	if (!stripe)
+		return -EINVAL;
+	if (stripe->recovery_state != RECOVERY_NO_FLUSH)
+		return -EINVAL;
+
+	range = kmem_cache_alloc(ctx->cache->io_range_kc, GFP_NOIO);
+	if (!range)
+		return -ENOMEM;
+
+	range->seq = seq;
+	range->meta_start = meta_start;
+	range->data_start = data_start;
+	range->raid_start = stripe_sect;
+	range->data_sectors = sectors;
+	range->stripe = stripe;
+	range->checksum = checksum;
+
+	if (list_empty(&stripe->parity_list))
+		list_move_tail(&stripe->lru, &ctx->stripes_with_parity);
+	list_add_tail(&range->stripe_sibling, &stripe->parity_list);
+
+	return 0;
+}
+
+static void r5c_free_parity_ranges(struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *range;
+
+	while (!list_empty(&stripe->parity_list)) {
+		range = list_first_entry(&stripe->parity_list,
+			struct r5c_io_range, stripe_sibling);
+		list_del(&range->stripe_sibling);
+
+		kfree(range->checksum);
+		kmem_cache_free(cache->io_range_kc, range);
+	}
+	if (stripe->parity_pages) {
+		r5c_put_pages(cache, stripe->parity_pages,
+			STRIPE_PARITY_PAGES(cache));
+		kfree(stripe->parity_pages);
+		stripe->parity_pages = NULL;
+	}
+}
+
+static void r5c_analyse_log(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe, *tmp;
+	int recovery_state;
+	LIST_HEAD(list);
+
+	list_for_each_entry_safe(stripe, tmp, &ctx->stripes_with_parity, lru) {
+		recovery_state = stripe->recovery_state;
+		stripe->recovery_state = RECOVERY_NO_FLUSH;
+
+		if (recovery_state == RECOVERY_NO_FLUSH)
+			list_move_tail(&stripe->lru, &list);
+	}
+	if (list_empty(&list))
+		return;
+	list_for_each_entry(stripe, &list, lru)
+		r5c_free_parity_ranges(stripe);
+	list_splice_tail(&list, &ctx->stripes_without_parity);
+	printk(KERN_ERR"md: %s, parities aren't fully flushed to cache, all parities will be ignored\n",
+		mdname(ctx->cache->mddev));
+}
+
+static void r5l_fetch_endio(struct bio *bio, int err)
+{
+	struct r5c_load_ctx *ctx = bio->bi_private;
+
+	bio_put(bio);
+	if (atomic_dec_and_test(&ctx->io_cnt))
+		wake_up(&ctx->io_wq);
+}
+
+static int r5l_fetch_one_range(struct r5c_load_ctx *ctx,
+	struct r5c_stripe *stripe, struct page **pages,
+	ssize_t page_cnt, sector_t sec, bool data)
+{
+	struct r5l_log *log = &ctx->cache->log;
+	struct bio *bio, *split;
+	int page_index = 0;
+	int nvec;
+	int i;
+
+again:
+	nvec = min_t(int, page_cnt - page_index, bio_get_nr_vecs(log->bdev));
+	bio = bio_kmalloc(GFP_NOIO, nvec);
+	bio->bi_iter.bi_sector = sec;
+	bio->bi_end_io = r5l_fetch_endio;
+	bio->bi_private = ctx;
+	bio->bi_bdev = log->bdev;
+	atomic_inc(&ctx->io_cnt);
+
+	/* FIXME: we might use too many memory */
+	for (i = 0; i < nvec; i++) {
+		pages[page_index] = alloc_page(GFP_NOIO);
+		if (!bio_add_page(bio, pages[page_index], PAGE_SIZE, 0)) {
+			__free_page(pages[page_index]);
+			pages[page_index] = NULL;
+			break;
+		}
+		page_index++;
+		if (data)
+			stripe->existing_pages++;
+		ctx->cache->total_pages++;
+	}
+
+	if (bio_end_sector(bio) > (BLOCK_SECTOR(log, log->last_block))) {
+		split = bio_split(bio, BLOCK_SECTOR(log, log->last_block) -
+			bio->bi_iter.bi_sector, GFP_NOIO, NULL);
+		bio_chain(split, bio);
+		bio->bi_iter.bi_sector = BLOCK_SECTOR(log, log->first_block);
+		r5l_submit_bio(log, READ, split);
+	}
+	sec = BLOCK_SECTOR(log, r5l_ring_add(log, SECTOR_BLOCK(log, sec),
+					PAGE_BLOCKS(log, i)));
+	r5l_submit_bio(log, READ, bio);
+
+	if (page_index < page_cnt)
+		goto again;
+	return 0;
+}
+
+static int r5l_fetch_one_stripe(struct r5c_load_ctx *ctx, struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *range;
+	u64 index;
+	int offset, max, start, range_start;
+
+	/* new data is at the tail */
+	list_for_each_entry_reverse(range, &stripe->io_ranges, stripe_sibling) {
+		STRIPE_INDEX_OFFSET(cache, range->raid_start, index, offset);
+		offset >>= PAGE_SECTOR_SHIFT;
+		range_start = offset;
+		max = (range->data_sectors >> PAGE_SECTOR_SHIFT) + offset;
+again:
+		while (offset < max && stripe->data_pages[offset])
+			offset++;
+		start = offset;
+		while (offset < max && !stripe->data_pages[offset])
+			offset++;
+		if (start >= max)
+			continue;
+		r5l_fetch_one_range(ctx, stripe, &stripe->data_pages[start],
+			offset - start,
+			range->data_start + ((start - range_start) <<
+			PAGE_SECTOR_SHIFT), true);
+		if (offset < max)
+			goto again;
+	}
+
+	if (list_empty(&stripe->parity_list))
+		return 0;
+
+	stripe->parity_pages = kmalloc(STRIPE_PARITY_PAGES(cache) *
+		sizeof(struct page *), GFP_NOIO | __GFP_ZERO);
+
+	list_for_each_entry(range, &stripe->parity_list, stripe_sibling) {
+		index = range->raid_start;
+		offset = sector_div(index, cache->chunk_size);
+		offset >>= PAGE_SECTOR_SHIFT;
+		offset *= cache->parity_disks;
+
+		r5l_fetch_one_range(ctx, stripe, &stripe->parity_pages[offset],
+			cache->parity_disks, range->data_start, false);
+	}
+	return 0;
+}
+
+static int r5l_fetch_stripes(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe;
+	struct blk_plug plug;
+
+	blk_start_plug(&plug);
+	list_for_each_entry(stripe, &ctx->stripes_without_parity, lru) {
+		r5l_fetch_one_stripe(ctx, stripe);
+	}
+	list_for_each_entry(stripe, &ctx->stripes_with_parity, lru) {
+		r5l_fetch_one_stripe(ctx, stripe);
+	}
+	blk_finish_plug(&plug);
+
+	atomic_dec(&ctx->io_cnt);
+	wait_event(ctx->io_wq, atomic_read(&ctx->io_cnt) == 0);
+
+	return 0;
+}
+
+static u32 r5l_calculate_page_checksum(struct r5l_log *log, struct page *page)
+{
+	u32 csum;
+	void *addr = kmap_atomic(page);
+	csum = r5l_calculate_checksum(log, UUID_CHECKSUM(log, true),
+		addr, PAGE_SIZE, true);
+	kunmap_atomic(addr);
+	return csum;
+}
+
+static int r5l_check_one_stripe_checksum(struct r5c_stripe *stripe)
+{
+	struct r5c_cache *cache = stripe->cache;
+	struct r5l_log *log = &cache->log;
+	struct r5c_io_range *range;
+	struct page *page;
+	u64 index;
+	int offset;
+	int ret = 0;
+
+	/* FIXME: we currently ignore all data parity check */
+	list_for_each_entry(range, &stripe->io_ranges, stripe_sibling) {
+		kfree(range->checksum);
+		range->checksum = NULL;
+	}
+
+	list_for_each_entry(range, &stripe->parity_list, stripe_sibling) {
+		index = range->raid_start;
+		offset = sector_div(index, cache->chunk_size);
+		offset >>= PAGE_SECTOR_SHIFT;
+		offset *= cache->parity_disks;
+
+		page = stripe->parity_pages[offset];
+
+		if (le32_to_cpu(range->checksum[0]) !=
+		    r5l_calculate_page_checksum(log, page)) {
+			ret = -EINVAL;
+			break;
+		}
+		if (cache->parity_disks > 1) {
+			page = stripe->parity_pages[offset + 1];
+			if (le32_to_cpu(range->checksum[1]) !=
+			    r5l_calculate_page_checksum(log, page)) {
+				ret = -EINVAL;
+				break;
+			}
+		}
+	}
+	r5c_free_parity_ranges(stripe);
+	return ret;
+}
+
+static int r5l_check_stripes_checksum(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe;
+	bool skip = false;
+
+	while (!list_empty(&ctx->stripes_without_parity)) {
+		stripe = list_first_entry(&ctx->stripes_without_parity,
+			struct r5c_stripe, lru);
+		list_del_init(&stripe->lru);
+
+		r5l_check_one_stripe_checksum(stripe);
+	}
+
+	list_for_each_entry(stripe, &ctx->stripes_with_parity, lru) {
+		if (skip)
+			r5c_free_parity_ranges(stripe);
+		else
+			skip = !!r5l_check_one_stripe_checksum(stripe);
+	}
+
+	/*
+	 * If any parity checksum is wrong, we think the stripes are not hiting
+	 * to raid
+	 * */
+	if (skip) {
+		while (!list_empty(&ctx->stripes_with_parity)) {
+			stripe = list_first_entry(&ctx->stripes_with_parity,
+				struct r5c_stripe, lru);
+			list_del_init(&stripe->lru);
+		}
+	}
+	return 0;
+}
+
+static int r5c_recover_stripes(struct r5c_load_ctx *ctx)
+{
+	struct r5c_cache *cache = ctx->cache;
+
+	r5l_check_stripes_checksum(ctx);
+
+	list_splice_tail(&ctx->io_ranges, &ctx->cache->log_list);
+
+	if (list_empty(&ctx->stripes_with_parity))
+		return 0;
+
+	cache->in_recovery = 1;
+
+	r5c_reclaim_stripe_list(cache, &ctx->stripes_with_parity);
+
+	cache->in_recovery = 0;
+	return 0;
+}
+
+static void *r5l_read_meta_block(struct r5l_log *log, r5blk_t block,
+	u64 expected_seq, struct page **retpage)
+{
+	struct page *page = alloc_page(GFP_KERNEL|__GFP_ZERO);
+	struct r5l_meta_header *header;
+	u32 crc, stored_crc;
+
+	if (!sync_page_io(log->rdev, BLOCK_SECTOR(log, block),
+	    log->block_size, page, READ, false))
+		return NULL;
+
+	header = kmap(page);
+	stored_crc = le32_to_cpu(header->checksum);
+	header->checksum = 0;
+
+	if (le32_to_cpu(header->magic) != R5LOG_MAGIC ||
+	    le64_to_cpu(header->seq) != expected_seq ||
+	    le64_to_cpu(header->position) != block)
+		goto error;
+	if (le32_to_cpu(header->type) != R5LOG_TYPE_META &&
+	    le32_to_cpu(header->type) != R5LOG_TYPE_FLUSH_START &&
+	    le32_to_cpu(header->type) != R5LOG_TYPE_FLUSH_END)
+		goto error;
+
+	crc = r5l_calculate_checksum(log, UUID_CHECKSUM(log, false),
+			header, log->block_size, false);
+	if (stored_crc != crc)
+		goto error;
+
+	if (le32_to_cpu(header->meta_size) > log->block_size)
+		goto error;
+	*retpage = page;
+	return header;
+error:
+	kunmap(page);
+	__free_page(page);
+	return NULL;
+}
+
+static int r5l_load_log(struct r5l_log *log)
+{
+	r5blk_t last_cp = log->last_checkpoint;
+	u64 last_seq = log->last_cp_seq;
+	r5blk_t payload_block;
+	struct page *page = NULL;
+	struct r5l_meta_header *header;
+	void *meta;
+	struct r5l_meta_payload *payload;
+	struct r5c_load_ctx ctx;
+	int offset;
+
+	ctx.cache = log->cache;
+	INIT_LIST_HEAD(&ctx.io_ranges);
+	INIT_LIST_HEAD(&ctx.stripes_with_parity);
+	INIT_LIST_HEAD(&ctx.stripes_without_parity);
+	ctx.chunk_stripes = log->chunk_size >> PAGE_SECTOR_SHIFT;
+	ctx.stripe_bits = kmalloc(BITS_TO_LONGS(ctx.chunk_stripes) * sizeof(long),
+		GFP_KERNEL);
+	atomic_set(&ctx.io_cnt, 1);
+	init_waitqueue_head(&ctx.io_wq);
+
+again:
+	if (page) {
+		kunmap(page);
+		__free_page(page);
+		page = NULL;
+	}
+	header = r5l_read_meta_block(log, last_cp, last_seq, &page);
+	if (!header)
+		goto finish;
+	offset = sizeof(struct r5l_meta_header);
+
+	if (le32_to_cpu(header->type) == R5LOG_TYPE_FLUSH_START) {
+		r5c_add_flush_start(&ctx, (struct r5l_flush_block *)header,
+					last_seq);
+		last_cp = r5l_ring_add(log, last_cp, 1);
+		last_seq++;
+		goto again;
+	}
+
+	if (le32_to_cpu(header->type) == R5LOG_TYPE_FLUSH_END) {
+		r5c_add_flush_end(&ctx, (struct r5l_flush_block *)header,
+				last_seq);
+		last_cp = r5l_ring_add(log, last_cp, 1);
+		last_seq++;
+		goto again;
+	}
+
+	meta = header;
+	payload = meta + offset;
+	payload_block = r5l_ring_add(log, last_cp, 1);
+
+	while (offset < cpu_to_le32(header->meta_size)) {
+		u16 type = le16_to_cpu(payload->payload_type);
+		u16 entries = le32_to_cpu(payload->blocks) >> log->page_block_shift;
+		u32 *checksum;
+
+		checksum = kmalloc(sizeof(u32) * entries, GFP_KERNEL);
+		memcpy(checksum, payload->data_checksum, sizeof(u32) * entries);
+		if (type == R5LOG_PAYLOAD_DATA) {
+			r5c_add_data(&ctx, last_seq,
+			  BLOCK_SECTOR(log, last_cp),
+			  BLOCK_SECTOR(log, payload_block),
+			  le64_to_cpu(payload->location),
+			  entries << PAGE_SECTOR_SHIFT, checksum);
+		} else {
+			r5c_add_parity(&ctx, last_seq,
+			  BLOCK_SECTOR(log, last_cp),
+			  BLOCK_SECTOR(log, payload_block),
+			  le64_to_cpu(payload->location),
+			  entries << PAGE_SECTOR_SHIFT, checksum);
+		}
+		payload_block = r5l_ring_add(log, payload_block,
+			PAGE_BLOCKS(log, entries));
+		offset += sizeof(struct r5l_meta_payload) +
+			entries * sizeof(u32);
+		payload = meta + offset;
+	}
+
+	last_seq++;
+	last_cp = payload_block;
+	goto again;
+finish:
+	if (page) {
+		kunmap(page);
+		__free_page(page);
+	}
+
+	r5c_analyse_log(&ctx);
+
+	r5l_fetch_stripes(&ctx);
+
+	log->seq = last_seq;
+	log->log_start = last_cp;
+	r5c_recover_stripes(&ctx);
+
+	kfree(ctx.stripe_bits);
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
+	sb_blk = kmap_atomic(page);
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
+	kunmap_atomic(sb_blk);
+
+	return 0;
+error:
+	kunmap_atomic(sb_blk);
+	return -EINVAL;
+}
+
+static int r5l_init_log(struct r5c_cache *cache)
+{
+	struct r5l_log *log;
+
+	log = &cache->log;
+
+	log->cache = cache;
+	log->bdev = cache->rdev->bdev;
+	log->rdev = cache->rdev;
+
+	log->do_discard = blk_queue_discard(bdev_get_queue(log->bdev));
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
+	init_waitqueue_head(&log->io_waitq);
+
+	INIT_LIST_HEAD(&log->task_list);
+	INIT_LIST_HEAD(&log->parity_task_list);
+	spin_lock_init(&log->task_lock);
+
+	log->io_kc = KMEM_CACHE(r5l_ioctl, 0);
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
+	log->reserved_blocks = SECTOR_BLOCK(log, cache->reserved_space) + 1;
+
+	if (log->stripe_data_size != cache->stripe_data_size ||
+	    log->chunk_size != cache->chunk_size ||
+	    log->stripe_size != cache->stripe_size ||
+	    log->parity_disks != cache->parity_disks)
+		goto error;
+
+	r5l_load_log(log);
+
+	if (log->total_blocks * log->block_size / 10 < 1024 * 1024 * 1024)
+		log->low_watermark = log->total_blocks / 10;
+	else
+		log->low_watermark = (1024 * 1024 * 1024 / log->block_size);
+	log->high_watermark = log->low_watermark * 3 / 2;
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
+	blkdev_issue_flush(log->bdev, GFP_NOIO, NULL);
+
+	bioset_free(log->bio_set);
+	mempool_destroy(log->io_pool);
+	kmem_cache_destroy(log->io_kc);
+	__free_page(log->super_page);
+}
+
+static void r5c_calculate_watermark(struct r5c_cache *cache)
+{
+	if (cache->max_pages / 10 < 1024)
+		cache->low_watermark = 1024;
+	else
+		cache->low_watermark = cache->max_pages / 10;
+	cache->high_watermark = cache->low_watermark * 3 / 2;
+}
+
+static int r5c_shrink_cache_memory(struct r5c_cache *cache, unsigned long size)
+{
+	LIST_HEAD(page_list);
+	struct page *page, *tmp;
+
+	if (cache->total_pages <= size)
+		return 0;
+
+	spin_lock_irq(&cache->pool_lock);
+	cache->max_pages = size;
+	r5c_calculate_watermark(cache);
+	spin_unlock_irq(&cache->pool_lock);
+
+	while (cache->total_pages > size) {
+		spin_lock_irq(&cache->pool_lock);
+		if (cache->total_pages - cache->free_pages >= size) {
+			list_splice_init(&cache->page_pool, &page_list);
+			cache->total_pages -= cache->free_pages;
+			cache->free_pages = 0;
+		} else {
+			while (cache->total_pages > size) {
+				list_move(cache->page_pool.next, &page_list);
+				cache->total_pages--;
+				cache->free_pages--;
+			}
+		}
+		spin_unlock_irq(&cache->pool_lock);
+
+		list_for_each_entry_safe(page, tmp, &page_list, lru) {
+			list_del_init(&page->lru);
+			__free_page(page);
+		}
+
+		r5c_wake_wait_reclaimer(cache, RECLAIM_MEM_BACKGROUND);
+	}
+	return 0;
+}
+
+static void r5c_free_cache_data(struct r5c_cache *cache)
+{
+	struct r5c_stripe *stripe;
+	struct page *page, *tmp;
+	struct radix_tree_iter iter;
+	void **slot;
+
+	radix_tree_for_each_slot(slot, &cache->stripe_tree, &iter, 0) {
+		stripe = radix_tree_deref_slot(slot);
+		r5c_put_stripe(stripe);
+	}
+
+	BUG_ON(!list_empty(&cache->log_list));
+
+	list_for_each_entry_safe(page, tmp, &cache->page_pool, lru) {
+		list_del_init(&page->lru);
+		__free_page(page);
+	}
+}
+
+struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
+{
+	struct mddev *mddev = rdev->mddev;
+	struct r5c_cache *cache;
+	int i;
+
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
+	if (!cache)
+		return NULL;
+	cache->mddev = mddev;
+	cache->rdev = rdev;
+
+	spin_lock_init(&cache->tree_lock);
+	INIT_RADIX_TREE(&cache->stripe_tree, GFP_ATOMIC);
+	INIT_LIST_HEAD(&cache->log_list);
+	INIT_LIST_HEAD(&cache->full_stripes);
+
+	INIT_LIST_HEAD(&cache->page_pool);
+	spin_lock_init(&cache->pool_lock);
+	INIT_WORK(&cache->pending_io_work, r5c_unplug_work);
+
+	cache->max_pages = MAX_MEM >> PAGE_SHIFT;
+
+	cache->stripe_data_size = conf->chunk_sectors * (conf->raid_disks -
+		conf->max_degraded);
+	cache->chunk_size = conf->chunk_sectors;
+	cache->stripe_size = conf->chunk_sectors * conf->raid_disks;
+	cache->parity_disks = conf->max_degraded;
+
+	cache->stripe_flush_data = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cache->stripe_flush_data)
+		goto io_range_kc;
+
+	cache->io_range_kc = KMEM_CACHE(r5c_io_range, 0);
+	if (!cache->io_range_kc)
+		goto io_range_kc;
+	cache->stripe_kc = kmem_cache_create("r5c_stripe",
+		sizeof(struct r5c_stripe) + sizeof(struct page *) *
+		STRIPE_DATA_PAGES(cache), __alignof__(struct r5c_stripe),
+		0, NULL);
+	if (!cache->stripe_kc)
+		goto stripe_kc;
+
+	cache->bio_set = bioset_create(RECLAIM_BATCH, 0);
+	if (!cache->bio_set)
+		goto bio_set;
+
+	cache->reclaim_batch = RECLAIM_BATCH;
+
+	/* make sure we can add checkpoint */
+	cache->reserved_space = (STRIPE_PARITY_PAGES(cache) <<
+		PAGE_SECTOR_SHIFT) * RECLAIM_BATCH;
+
+	init_waitqueue_head(&cache->reclaim_wait);
+	init_waitqueue_head(&cache->error_wait);
+	bio_list_init(&cache->retry_bio_list);
+
+	for (i = 0; i < (1 << STRIPE_LOCK_BITS); i++) {
+		spin_lock_init(&cache->stripe_locks[i]);
+		init_waitqueue_head(&cache->stripe_waitq[i]);
+	}
+
+	if (r5l_init_log(cache))
+		goto init_log;
+
+	while (cache->total_pages < cache->max_pages) {
+		struct page *page = alloc_page(GFP_KERNEL);
+
+		if (!page)
+			goto err_page;
+		list_add(&page->lru, &cache->page_pool);
+		cache->free_pages++;
+		cache->total_pages++;
+	}
+
+	r5c_calculate_watermark(cache);
+
+	cache->reclaim_thread = md_register_thread(r5c_reclaim_thread,
+		mddev, "reclaim");
+	if (!cache->reclaim_thread)
+		goto err_page;
+	cache->reclaim_thread->timeout = CHECKPOINT_TIMEOUT;
+
+	r5c_shrink_cache_memory(cache, cache->max_pages);
+
+	return cache;
+err_page:
+	r5c_free_cache_data(cache);
+
+	r5l_exit_log(&cache->log);
+init_log:
+	bioset_free(cache->bio_set);
+bio_set:
+	kmem_cache_destroy(cache->stripe_kc);
+stripe_kc:
+	kmem_cache_destroy(cache->io_range_kc);
+io_range_kc:
+	kfree(cache->stripe_flush_data);
+	kfree(cache);
+	return NULL;
+}
+
+void r5c_exit_cache(struct r5c_cache *cache)
+{
+	md_unregister_thread(&cache->reclaim_thread);
+	r5l_exit_log(&cache->log);
+
+	r5c_free_cache_data(cache);
+
+	bioset_free(cache->bio_set);
+	kmem_cache_destroy(cache->stripe_kc);
+	kmem_cache_destroy(cache->io_range_kc);
+
+	kfree(cache->stripe_flush_data);
+	kfree(cache);
+}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 950c3c6..7273f75 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -409,7 +409,7 @@ static int release_stripe_list(struct r5conf *conf,
 	return count;
 }
 
-static void release_stripe(struct stripe_head *sh)
+void release_stripe(struct stripe_head *sh)
 {
 	struct r5conf *conf = sh->raid_conf;
 	unsigned long flags;
@@ -877,6 +877,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (conf->cache) {
+		if (!r5c_write_parity(conf->cache, sh))
+			return;
+	}
+
 	for (i = disks; i--; ) {
 		int rw;
 		int replace_only = 0;
@@ -3058,7 +3063,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+				r5c_write_end(conf->mddev, bi);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
 			}
@@ -3082,7 +3087,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
 			clear_bit(BIO_UPTODATE, &bi->bi_flags);
 			if (!raid5_dec_bi_active_stripes(bi)) {
-				md_write_end(conf->mddev);
+				r5c_write_end(conf->mddev, bi);
 				bi->bi_next = *return_bi;
 				*return_bi = bi;
 			}
@@ -3418,7 +3423,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 					dev->sector + STRIPE_SECTORS) {
 					wbi2 = r5_next_bio(wbi, dev->sector);
 					if (!raid5_dec_bi_active_stripes(wbi)) {
-						md_write_end(conf->mddev);
+						r5c_write_end(conf->mddev, wbi);
 						wbi->bi_next = *return_bi;
 						*return_bi = wbi;
 					}
@@ -3444,6 +3449,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 			WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
 			WARN_ON(dev->page != dev->orig_page);
 		}
+
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
@@ -4630,17 +4636,24 @@ static int raid5_mergeable_bvec(struct mddev *mddev,
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
+	struct r5conf *conf = mddev->private;
 
 	/*
 	 * always allow writes to be mergeable, read as well if array
 	 * is degraded as we'll go through stripe cache anyway.
+	 * with cache, write must align within stripe
 	 */
-	if ((bvm->bi_rw & 1) == WRITE || mddev->degraded)
+	if (((bvm->bi_rw & 1) == WRITE && !conf->cache) || mddev->degraded)
 		return biovec->bv_len;
 
 	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
 		chunk_sectors = mddev->new_chunk_sectors;
 	max =  (chunk_sectors - ((sector & (chunk_sectors - 1)) + bio_sectors)) << 9;
+	if (((bvm->bi_rw & 1) == WRITE) && conf->cache) {
+		chunk_sectors *= conf->raid_disks - conf->max_degraded;
+		max = (chunk_sectors - (sector_div(sector, chunk_sectors) +
+			bio_sectors)) << 9;
+	}
 	if (max < 0) max = 0;
 	if (max <= biovec->bv_len && bio_sectors == 0)
 		return biovec->bv_len;
@@ -5089,12 +5102,12 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
-		md_write_end(mddev);
+		r5c_write_end(mddev, bi);
 		bio_endio(bi, 0);
 	}
 }
 
-static void make_request(struct mddev *mddev, struct bio * bi)
+void raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -5111,7 +5124,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 		return;
 	}
 
-	md_write_start(mddev, bi);
+	r5c_write_start(mddev, bi);
 
 	/*
 	 * If array is degraded, better not do chunk aligned read because
@@ -5247,8 +5260,9 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			}
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
+			/* there's no point to delay stripe with cache */
 			if ((!sh->batch_head || sh == sh->batch_head) &&
-			    (bi->bi_rw & REQ_SYNC) &&
+			    ((bi->bi_rw & REQ_SYNC) || conf->cache) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
@@ -5264,13 +5278,23 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	if (remaining == 0) {
 
 		if ( rw == WRITE )
-			md_write_end(mddev);
+			r5c_write_end(mddev, bi);
 
 		trace_block_bio_complete(mddev->queue, bi, 0);
 		bio_endio(bi, 0);
 	}
 }
 
+static void make_request(struct mddev *mddev, struct bio *bi)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (conf->cache)
+		r5c_handle_bio(conf->cache, bi);
+	else
+		raid5_make_request(mddev, bi);
+}
+
 static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
 
 static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *skipped)
@@ -5655,6 +5679,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 		}
 
 		set_bit(R5_ReadNoMerge, &sh->dev[dd_idx].flags);
+		/* IO read should not trigger r5c IO */
 		handle_stripe(sh);
 		release_stripe(sh);
 		handled++;
@@ -5703,6 +5728,8 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 	for (i = 0; i < batch_size; i++)
 		handle_stripe(batch[i]);
 
+	r5c_flush_pending_parity(conf->cache);
+
 	cond_resched();
 
 	spin_lock_irq(&conf->device_lock);
@@ -6253,6 +6280,9 @@ static void free_conf(struct r5conf *conf)
 {
 	if (conf->shrinker.seeks)
 		unregister_shrinker(&conf->shrinker);
+	if (conf->cache)
+		r5c_exit_cache(conf->cache);
+
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
@@ -6893,6 +6923,23 @@ static int run(struct mddev *mddev)
 						mddev->queue);
 	}
 
+	rdev_for_each(rdev, mddev) {
+		if (test_bit(WriteCache, &rdev->flags)) {
+			char b[BDEVNAME_SIZE];
+			printk(KERN_INFO "using device %s as cache\n",
+					bdevname(rdev->bdev, b));
+			conf->cache = r5c_init_cache(conf, rdev);
+			break;
+		}
+	}
+
+	if (conf->cache) {
+		/* Make sure all write do overwite in current stage */
+		if (mddev->queue)
+			blk_queue_logical_block_size(mddev->queue, STRIPE_SIZE);
+		conf->skip_copy = 1;
+	}
+
 	return 0;
 abort:
 	md_unregister_thread(&mddev->thread);
@@ -7415,6 +7462,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		break;
 
 	case 1: /* stop all writes */
+		r5c_quiesce(conf, state);
 		lock_all_device_hash_locks_irq(conf);
 		/* '2' tells resync/reshape to pause so that all
 		 * active stripes can drain
@@ -7437,6 +7485,7 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 		wake_up(&conf->wait_for_stripe);
 		wake_up(&conf->wait_for_overlap);
 		unlock_all_device_hash_locks_irq(conf);
+		r5c_quiesce(conf, state);
 		break;
 	}
 }
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 7dc0dd8..e4e93bb 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -219,10 +219,11 @@ struct stripe_head {
 	spinlock_t		stripe_lock;
 	int			cpu;
 	struct r5worker_group	*group;
-
 	struct stripe_head	*batch_head; /* protected by stripe lock */
 	spinlock_t		batch_lock; /* only header's lock is useful */
 	struct list_head	batch_list; /* protected by head's batch lock*/
+	struct r5c_stripe	*stripe;
+	struct list_head	stripe_list;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -535,6 +536,7 @@ struct r5conf {
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
+	struct r5c_cache	*cache;
 };
 
 
@@ -601,4 +603,15 @@ static inline int algorithm_is_DDF(int layout)
 
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
+
+void release_stripe(struct stripe_head *sh);
+void raid5_make_request(struct mddev *mddev, struct bio *bi);
+void r5c_handle_bio(struct r5c_cache *cache, struct bio *bi);
+int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *sh);
+void r5c_flush_pending_parity(struct r5c_cache *cache);
+struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev);
+void r5c_exit_cache(struct r5c_cache *cache);
+void r5c_write_start(struct mddev *mddev, struct bio *bi);
+void r5c_write_end(struct mddev *mddev, struct bio *bi);
+void r5c_quiesce(struct r5conf *conf, int state);
 #endif
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 9d36b91..5159cc9 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -313,4 +313,76 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_RECOVERY_BITMAP	\
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
+	__le32 stripe_cache_size; /* bytes */
+	__le32 block_size; /* bytes */
+	__le32 stripe_data_size; /* bytes */
+	__le32 chunk_size; /* bytes */
+	__le32 stripe_size; /* bytes */
+	__le32 parity_disks;
+	__le32 zero_padding;
+	__le64 total_blocks; /* block */
+	__le64 first_block; /* block */
+	__le64 last_checkpoint; /* block */
+	__le64 update_time_sec;
+	__le64 update_time_nsec;
+	__u8 meta_checksum_type;
+	__u8 data_checksum_type;
+	__u8 uuid[16];
+	/* fill with 0 */
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
+enum {
+	/* type */
+	R5LOG_PAYLOAD_DATA = 0,
+	R5LOG_PAYLOAD_PARITY = 1,
+	/* flags */
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
 #endif
-- 
1.8.1

