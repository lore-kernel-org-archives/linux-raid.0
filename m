From: Shaohua Li <shli@fb.com>
Subject: [RFC] A caching layer for RAID5/6
Date: Mon, 20 Apr 2015 22:54:54 -0700
Message-ID: <80235c9f553c50d695565e01ef790d22989fa34b.1429595196.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, dan.j.williams@intel.com, songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

Hi,

This is the new design/code to implement caching layer for RAID5/6. It's not
for merge yet, but basic code works fine here. I'd like to hear some
comments/suggestions early before I continue.

Thanks,
Shaohua

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
has no valid data. Current code chooses the first option, but this can
be easily changed.

We have a simple meta data for the above tuples. It's essentially a
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

We always do reclaim in stripe unit. Reclaim could create holes in the
log, eg, some io_range in the middle is reclaimed, but io_range at the
head remains. So the index list entries don't always have continuous
sequence. But this doesn't matter, the first io_range is always the log
tail. Superblock has a field pointing to the position of log tail. The
hole can waste a lot of disk space though. In the future, we can
implement a garbage collection to mitigrate the issue, eg, copy data
from the index tail to head.

In the process reclaim flush data to raid disk, stripe parity will be
append to cache log. Parity is always after its corresponding data. Data
writing to raid disks only happens after all data and parity are already
in cache disk. This will fix the write whole issue. After a stripe is
flushed to raid disks, we will add a checkpoint. The checkpoint, unlike
classic checkpoint, indicates a stripe is flushed to raid disks only if
the stripe has both data and parity in the log ahead of the chekcpoint.
There are still valid data of other stripes before checkpoint.

Recovery relies on if stripe data and parity matches. If recovery finds
data and parity of a stripe, it will calculate how many parity data the
stripe should have according to its data. If not all parity exist in the
log, the stripe hasn't started to be flushed to raid disks yet, so the
parity can be ignored.  Otherwise, recovery might write both data and
parity of a stripe to raid disks depending on if checkpoint is found.

IO write code path:
1. copy bio data to stripe memory pages
2. append metadata and data to cache log
3. IO write endio

reclaim code path:
1. select stripe to reclaim
2. write all stripe data to raid disk
3. in raid5 ops_run_io, append metadata and parity data to cache log.
    ops_run_io doesn't write data/parity to raid disks at this time
4. flush cache disk cache
5. ops_run_io continues. data/parity will be written to raid disks
6. flush all raid disks cache
7. add a checkpoint
8. delete in-memory index of the stripe, and advance superblock log checkpoint

Recovery:
Crash in IO write code path doesn't need recovery. If data and checksum
don't match, the data will be ignored so read will return old data. In
reclaim code path, crash before step 4 doesn't need recovery as
data/parity don't touch raid disk yet. Parity can be ignored too. crash
after 7 doesn't need recovery too, as the stripe is fully flushed to
raid disks. Crash between 4 and 7 need recovery. Data and parity in the
log will be written to raid disks.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/Makefile            |    2 +-
 drivers/md/raid5-cache.c       | 2412 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |   51 +-
 drivers/md/raid5.h             |   10 +
 include/uapi/linux/raid/md_p.h |   70 ++
 5 files changed, 2540 insertions(+), 5 deletions(-)
 create mode 100644 drivers/md/raid5-cache.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a2da532..7d85784 100644
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
index 0000000..cfb8bed
--- /dev/null
+++ b/drivers/md/raid5-cache.c
@@ -0,0 +1,2412 @@
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/blkdev.h>
+#include <linux/raid/md_p.h>
+#include <linux/crc32.h>
+#include "md.h"
+#include "raid5.h"
+
+#define MAX_MEM (256 * 1024 * 1024)
+#define RECLAIM_BATCH 16
+#define RECLAIM_TIMEOUT (5 * HZ)
+#define FULL_STRIPE_MAX_AGE (10 * HZ)
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
+	int block_size; /* bytes */
+	int block_sector_shift;
+	int page_block_shift;
+	int stripe_data_size; /* sector */
+	int chunk_size; /* sector */
+	int stripe_size; /* sector */
+	int parity_disks;
+
+	u64 total_blocks;
+	u64 first_block;
+	u64 last_block;
+
+	u64 low_watermark; /* For disk space, block */
+	u64 high_watermark;
+
+	u64 last_checkpoint; /* block */
+	u64 last_cp_seq;
+
+	int do_discard;
+
+	u64 seq; /* get after read log */
+	u64 log_start; /* get after read log */
+
+	u8 data_checksum_type;
+	u8 meta_checksum_type;
+
+	ssize_t reserved_blocks;
+	wait_queue_head_t space_waitq;
+
+	struct mutex io_mutex;
+	struct r5l_ioctl *current_io;
+
+	spinlock_t io_list_lock;
+	struct list_head running_ios; /* order is important */
+	wait_queue_head_t io_waitq;
+};
+
+struct r5l_task;
+/* end function must free task */
+typedef void (r5l_task_end_fn)(struct r5l_task *task);
+struct r5l_task {
+	struct list_head list;
+	int type;
+	struct bio *bio;
+	union {
+		struct {
+			bio_end_io_t *saved_endio;
+			void *saved_private;
+		};
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
+};
+
+struct r5l_rsv {
+	ssize_t reserved;
+	ssize_t used;
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
+	ssize_t data_sectors;
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
+
+	struct list_head page_pool;
+	spinlock_t pool_lock;
+	u64 free_pages;
+	u64 total_pages;
+	u64 max_pages;
+	u64 low_watermark; /* for memory, pages */
+	u64 high_watermark;
+	unsigned long full_stripe_ready_time;
+
+	int stripe_data_size; /* stripe size excluding parity, sector */
+	int chunk_size; /* one disk chunk size including parity, sector */
+	int stripe_size; /* stripe size including parity, sector */
+	int parity_disks;
+
+	int reserved_space; /* log reserved size, sector */
+
+	unsigned long reclaim_reason;
+	wait_queue_head_t reclaim_wait;
+	struct md_thread *reclaim_thread;
+
+	int in_recovery;
+
+	spinlock_t stripe_locks[1 << STRIPE_LOCK_BITS];
+	wait_queue_head_t stripe_waitq[1 << STRIPE_LOCK_BITS];
+};
+
+enum {
+	RECLAIM_MEM = 0, /* work hard to reclaim memory */
+	RECLAIM_MEM_BACKGROUND = 1, /* try to reclaim memory */
+	RECLAIM_MEM_FULL = 2, /* only reclaim full stripe */
+	RECLAIM_DISK = 8, /* work hard to reclaim disk */
+	RECLAIM_DISK_BACKGROUND = 9, /* try to reclaim disk */
+};
+
+#define STRIPE_INDEX_OFFSET(c, sect, index, offset) \
+({ \
+	sector_t tmp = sect; \
+	offset = sector_div(tmp, c->stripe_data_size); \
+	index = tmp; \
+})
+
+#define STRIPE_RAID_SECTOR(cache, stripe) \
+	(stripe->raid_index * cache->stripe_data_size)
+
+#define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
+
+#define STRIPE_DATA_PAGES(c) (c->stripe_data_size >> PAGE_SECTOR_SHIFT)
+#define STRIPE_PARITY_PAGES(c) \
+	((c->stripe_size - c->stripe_data_size) >> PAGE_SECTOR_SHIFT)
+#define BLOCK_SECTOR(log, b) ((b) << log->block_sector_shift)
+#define PAGE_BLOCKS(log, p) ((p) >> log->page_block_shift)
+
+#define UUID_CHECKSUM(log, data) \
+	(data ? log->uuid_checksum_data : log->uuid_checksum_meta)
+
+static u32 r5l_calculate_checksum(struct r5l_log *log, u32 crc,
+	void *buf, ssize_t size, bool data)
+{
+	if (log->data_checksum_type != R5LOG_CHECKSUM_CRC32)
+		BUG();
+	if (log->meta_checksum_type != R5LOG_CHECKSUM_CRC32)
+		BUG();
+	return crc32_le(crc, buf, size);
+}
+
+static u64 r5l_ring_add(struct r5l_log *log, u64 block, int inc)
+{
+	block += inc;
+	if (block >= log->last_block)
+		block = block - log->last_block + log->first_block;
+	return block;
+}
+
+static void r5c_wake_wait_reclaimer(struct r5c_cache *cache, int reason);
+static void r5c_wake_reclaimer(struct r5c_cache *cache, int reason);
+static void r5l_reclaim_space(struct r5l_log *log)
+{
+	r5c_wake_wait_reclaimer(log->cache, RECLAIM_DISK);
+	wake_up_all(&log->space_waitq);
+}
+
+static u64 r5l_free_space(struct r5l_log *log)
+{
+	u64 used_size = (log->total_blocks + log->log_start -
+		log->last_checkpoint) % log->total_blocks;
+	return log->total_blocks - used_size - log->reserved_blocks;
+}
+
+static int r5l_get_reserve(struct r5l_log *log,
+	struct r5l_rsv *rsv, ssize_t size, bool parity)
+{
+	u64 free;
+	BUG_ON(!mutex_is_locked(&log->io_mutex));
+
+	if (parity)
+		size = 0;
+	rsv->reserved = size;
+	rsv->used = 0;
+
+	free = r5l_free_space(log);
+	if (free >= size) {
+		log->reserved_blocks += size;
+
+		if (free - size < log->low_watermark)
+			r5c_wake_reclaimer(log->cache,
+				RECLAIM_DISK_BACKGROUND);
+		return 0;
+	}
+
+	mutex_unlock(&log->io_mutex);
+
+	r5l_reclaim_space(log);
+
+	mutex_lock(&log->io_mutex);
+	wait_event_cmd(log->space_waitq, r5l_free_space(log) >= size,
+		mutex_unlock(&log->io_mutex), mutex_lock(&log->io_mutex));
+	log->reserved_blocks += size;
+
+	return 0;
+}
+
+static void r5l_put_reserve(struct r5l_log *log,
+	struct r5l_rsv *rsv)
+{
+	ssize_t remaining;
+
+	BUG_ON(!mutex_is_locked(&log->io_mutex));
+	remaining = rsv->reserved - rsv->used;
+
+	if (remaining < 0)
+		remaining = 0;
+	log->reserved_blocks -= remaining;
+	if (remaining > 0)
+		wake_up_all(&log->space_waitq);
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
+static void r5l_put_ioctl(struct r5l_ioctl *io)
+{
+	struct r5l_log *log = io->log;
+	LIST_HEAD(finished_io);
+	unsigned long flags;
+	bool do_wakeup;
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
+			if (task->type == R5LOG_PAYLOAD_DATA) {
+				task->bio->bi_end_io = task->saved_endio;
+				task->bio->bi_private = task->saved_private;
+			}
+			task->fn(task);
+		}
+		__free_page(io->meta_page);
+		kfree(io);
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
+	r5l_put_ioctl(io);
+}
+
+static int r5l_submit_io(struct r5l_log *log)
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
+	r5l_put_ioctl(io);
+	return 0;
+}
+
+static struct r5l_ioctl *r5l_new_meta(struct r5l_log *log, struct r5l_rsv *rsv)
+{
+	struct r5l_ioctl *io;
+
+	io = kmalloc(sizeof(*io), GFP_NOIO);
+	io->log = log;
+	io->meta_page = alloc_page(GFP_NOIO|__GFP_ZERO);
+	io->meta_sector = BLOCK_SECTOR(log, log->log_start);
+	io->meta_offset = sizeof(struct r5l_meta_header);
+	atomic_set(&io->refcnt, 1);
+	INIT_LIST_HEAD(&io->tasks);
+	io->seq = log->seq;
+
+	io->meta_bio = bio_kmalloc(GFP_NOIO, bio_get_nr_vecs(log->bdev));
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
+	rsv->used++;
+	return io;
+}
+
+static int r5l_get_meta(struct r5l_log *log, struct r5l_rsv *rsv,
+	ssize_t pages, bool is_bio)
+{
+	struct r5l_ioctl *io;
+	struct r5l_meta_header *header;
+	ssize_t meta_size;
+
+	meta_size = sizeof(struct r5l_meta_payload) +
+		sizeof(u32) * pages;
+	io = log->current_io;
+	if (io && io->meta_offset + meta_size > log->block_size)
+		r5l_submit_io(log);
+	io = log->current_io;
+	if (io)
+		return 0;
+
+	io = r5l_new_meta(log, rsv);
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
+		bio = bio_kmalloc(GFP_NOIO, bio_get_nr_vecs(log->bdev));
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
+static int r5l_queue_task(struct r5l_log *log, struct r5l_task *task)
+{
+	ssize_t pages;
+	struct r5l_ioctl *io;
+	struct r5l_rsv rsv;
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
+	/* FIXME: handle tasks in batch to be more efficient */
+	mutex_lock(&log->io_mutex);
+
+	r5l_get_reserve(log, &rsv, 1 + (pages << log->page_block_shift),
+		task->type != R5LOG_PAYLOAD_DATA);
+
+	r5l_get_meta(log, &rsv, pages, task->type == R5LOG_PAYLOAD_DATA);
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
+	else {
+		bio = task->bio;
+		/* endio will bio_put, but this bio isn't allocated by us */
+		bio_get(bio);
+	}
+
+	if (bio_end_sector(bio) > (BLOCK_SECTOR(log, log->last_block))) {
+		struct bio *split;
+		split = bio_split(bio, BLOCK_SECTOR(log, log->last_block) -
+			bio->bi_iter.bi_sector, GFP_NOIO, NULL);
+		bio->bi_next = split;
+		bio_chain(split, bio);
+		bio->bi_iter.bi_sector = BLOCK_SECTOR(log, log->first_block);
+	}
+
+	log->log_start = r5l_ring_add(log, log->log_start,
+		PAGE_BLOCKS(log, pages));
+	rsv.used += PAGE_BLOCKS(log, pages);
+
+	list_add_tail(&task->list, &io->tasks);
+
+	r5l_submit_io(log);
+
+	r5l_put_reserve(log, &rsv);
+	mutex_unlock(&log->io_mutex);
+	return 0;
+}
+
+/*
+ * Since we finish IO in order and meta is written with FUA, so meta is always
+ * consistent. For FUA, just make sure both meta and data are written with FUA
+ * and finish IO after both parts are finished. For FLUSH, previous data and
+ * meta are already finished, just need flush the disk. In either case, bio
+ * already has the flag, so just handle them like normal bio
+ */
+static void r5l_queue_empty_flush_bio(struct r5l_log *log, struct bio *bio)
+{
+	bio->bi_bdev = log->bdev;
+	generic_make_request(bio);
+}
+
+static int r5l_queue_bio(struct r5l_log *log, struct bio *bio,
+	r5l_task_end_fn fn, void *private)
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
+
+	INIT_LIST_HEAD(&task->list);
+	task->type = R5LOG_PAYLOAD_DATA;
+	task->bio = bio;
+	task->saved_endio = bio->bi_end_io;
+	task->saved_private = bio->bi_private;
+	task->fn = fn;
+	task->private = private;
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
+	return r5l_queue_task(log, task);
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
+
+	INIT_LIST_HEAD(&task->list);
+	task->type = R5LOG_PAYLOAD_PARITY;
+	task->bio = NULL;
+	task->stripe_sector = stripe_sector;
+	task->page_p = page_p;
+	task->page_q = page_q;
+	task->fn = fn;
+	task->private = private;
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
+	return r5l_queue_task(log, task);
+}
+
+/* all previous queued data are settled down */
+static void r5l_commit(struct r5l_log *log)
+{
+	blkdev_issue_flush(log->bdev, GFP_NOIO, NULL);
+}
+
+static void r5l_cp_end(struct r5l_task *task)
+{
+	struct completion *comp = task->private;
+	complete(comp);
+}
+
+static int r5l_checkpoint(struct r5l_log *log, u64 *next_seq, sector_t *next_sec)
+{
+	struct r5l_ioctl *io;
+	struct r5l_rsv rsv;
+	struct r5l_checkpoint_block *cp;
+	struct timespec now = current_kernel_time();
+	struct r5l_task task;
+	DECLARE_COMPLETION_ONSTACK(cp_complete);
+	u32 crc;
+
+	mutex_lock(&log->io_mutex);
+	r5l_get_reserve(log, &rsv, 1, true);
+
+	if (log->current_io)
+		r5l_submit_io(log);
+
+	/* FIXME: we already wait in reclaim thread, don't need wait again */
+	spin_lock_irq(&log->io_list_lock);
+	wait_event_lock_irq(log->io_waitq, list_empty(&log->running_ios),
+		log->io_list_lock);
+	spin_unlock_irq(&log->io_list_lock);
+
+	io = r5l_new_meta(log, &rsv);
+	task.fn = r5l_cp_end;
+	task.private = &cp_complete;
+	/* pretend we are parity, so r5l_put_ioctl knows how to handle it */
+	task.type = R5LOG_PAYLOAD_PARITY;
+
+	cp = kmap_atomic(io->meta_page);
+	cp->header.magic = cpu_to_le32(R5LOG_MAGIC);
+	cp->header.type = cpu_to_le32(R5LOG_TYPE_CHECKPOINT);
+	cp->header.seq = cpu_to_le64(log->seq - 1);
+	if (log->log_start == log->first_block)
+		cp->header.position = cpu_to_le64(log->last_block - 1);
+	else
+		cp->header.position = cpu_to_le64(log->log_start - 1);
+	cp->header.meta_size = cpu_to_le32(sizeof(struct r5l_checkpoint_block));
+	cp->cp_sec = cpu_to_le64(now.tv_sec);
+	cp->cp_nsec = cpu_to_le64(now.tv_nsec);
+	crc = r5l_calculate_checksum(log, UUID_CHECKSUM(log, false), cp,
+			log->block_size, false);
+	cp->header.checksum = cpu_to_le32(crc);
+	kunmap_atomic(cp);
+
+	list_add_tail(&task.list, &io->tasks);
+
+	r5l_submit_bio(log, WRITE_FLUSH_FUA, io->meta_bio);
+	r5l_put_ioctl(io);
+
+	r5l_put_reserve(log, &rsv);
+	*next_seq = log->seq;
+	*next_sec = BLOCK_SECTOR(log, log->log_start);
+
+	mutex_unlock(&log->io_mutex);
+
+	wait_for_completion_io(&cp_complete);
+	return 0;
+}
+
+static void r5l_discard_blocks(struct r5l_log *log, u64 start, u64 end)
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
+	u32 crc;
+
+	if (seq == log->last_cp_seq)
+		return 0;
+
+	mutex_lock(&log->io_mutex);
+	r5l_discard_blocks(log, log->last_checkpoint, cp);
+
+	log->last_cp_seq = seq;
+	log->last_checkpoint = cp >> log->block_sector_shift;
+
+	clear_bit(RECLAIM_DISK, &cache->reclaim_reason);
+	if (r5l_free_space(log) > log->high_watermark)
+		clear_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason);
+
+	mutex_unlock(&log->io_mutex);
+
+	sb_blk = kmap_atomic(log->super_page);
+	sb_blk->header.seq = cpu_to_le64(seq);
+	sb_blk->last_checkpoint = cpu_to_le64(cp);
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
+	int i;
+
+	spin_lock_irqsave(&cache->pool_lock, flags);
+	for (i = 0; i < size; i++) {
+		if (pages[i])
+			list_add(&pages[i]->lru, &cache->page_pool);
+	}
+	cache->free_pages += size;
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
+	new = kzalloc(sizeof(struct r5c_stripe) + sizeof(struct page *) *
+		STRIPE_DATA_PAGES(cache), GFP_NOIO);
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
+		kfree(new);
+		return NULL;
+	}
+
+	spin_lock_irq(&cache->tree_lock);
+	if (radix_tree_insert(&cache->stripe_tree, stripe_index, new)) {
+		stripe = radix_tree_lookup(&cache->stripe_tree, stripe_index);
+		atomic_inc(&stripe->ref);
+		kfree(new);
+	} else
+		stripe = new;
+	spin_unlock_irq(&cache->tree_lock);
+
+	radix_tree_preload_end();
+
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
+	int ref = atomic_dec_return(&stripe->ref);
+	unsigned long flags, flags2;
+
+	/* the stripe is freezing, might wait for ref */
+	if (ref == 1)
+		wake_up_all(r5c_stripe_waitq(cache, stripe));
+
+	if (ref)
+		return;
+
+	spin_lock_irqsave(&cache->tree_lock, flags);
+	radix_tree_delete(&cache->stripe_tree, stripe->raid_index);
+
+	r5c_lock_stripe(cache, stripe, &flags2);
+	while (!list_empty(&stripe->io_ranges)) {
+		range = list_first_entry(&stripe->io_ranges,
+			struct r5c_io_range, stripe_sibling);
+		list_del(&range->stripe_sibling);
+
+		list_del(&range->log_sibling);
+
+		kfree(range);
+	}
+	r5c_put_pages(cache, stripe->data_pages, STRIPE_DATA_PAGES(cache));
+	BUG_ON(stripe->parity_pages);
+
+	r5c_unlock_stripe(cache, stripe, &flags2);
+
+	spin_unlock_irqrestore(&cache->tree_lock, flags);
+
+	kfree(stripe);
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
+			atomic_read(&stripe->ref) == 1, cache->tree_lock);
+	stripe->state = STRIPE_FROZEN;
+	return true;
+}
+
+static void r5c_bio_task_end(struct r5l_task *task)
+{
+	struct r5c_io_range *range = task->private;
+	struct r5c_stripe *stripe = range->stripe;
+	struct r5c_cache *cache = stripe->cache;
+	struct r5c_io_range *tmp;
+	unsigned long flags, flags2;
+
+	range->seq = task->seq;
+	range->meta_start = task->meta_start;
+	range->data_start = task->data_start;
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
+		if (!cache->full_stripe_ready_time)
+			cache->full_stripe_ready_time = jiffies;
+	}
+	r5c_unlock_stripe(cache, stripe, &flags2);
+
+	spin_unlock_irqrestore(&cache->tree_lock, flags);
+
+	r5c_put_stripe(stripe);
+
+	bio_endio_nodec(range->bio, 0);
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
+static void r5c_write_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *io_range;
+	unsigned long index;
+	unsigned int offset;
+	int i, new_pages = 0;
+	unsigned long flags;
+
+	/* Doesn't support discard */
+	if (bio->bi_rw & REQ_DISCARD) {
+		bio_endio(bio, 0);
+		return;
+	}
+	if (bio->bi_iter.bi_size == 0) {
+		BUG_ON(!(bio->bi_rw & REQ_FLUSH));
+		r5l_queue_empty_flush_bio(&cache->log, bio);
+		return;
+	}
+
+	STRIPE_INDEX_OFFSET(cache, bio->bi_iter.bi_sector, index, offset);
+
+	stripe = r5c_create_get_stripe(cache, index);
+
+	io_range = kmalloc(sizeof(struct r5c_io_range), GFP_NOIO);
+	io_range->bio = bio;
+	io_range->raid_start = bio->bi_iter.bi_sector;
+	io_range->data_sectors = bio_sectors(bio);
+	io_range->stripe = stripe;
+
+	/* FIXME: read can get garbage data here */
+	offset >>= PAGE_SECTOR_SHIFT;
+	for (i = offset; i < offset + (bio_sectors(bio) >> PAGE_SECTOR_SHIFT);
+	     i++) {
+		if (stripe->data_pages[i])
+			continue;
+		stripe->data_pages[i] = r5c_get_page(cache);
+		new_pages++;
+	}
+
+	r5c_lock_stripe(cache, stripe, &flags);
+	list_add_tail(&io_range->stripe_sibling, &stripe->io_ranges);
+	stripe->existing_pages += new_pages;
+	r5c_unlock_stripe(cache, stripe, &flags);
+
+	r5c_copy_bio(bio, &stripe->data_pages[offset], false);
+
+	r5l_queue_bio(&cache->log, bio, r5c_bio_task_end, io_range);
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
+void r5c_handle_bio(struct r5c_cache *cache, struct bio *bio)
+{
+	if (bio_data_dir(bio) == READ)
+		r5c_read_bio(cache, bio);
+	else
+		r5c_write_bio(cache, bio);
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
+static void r5c_flush_one(struct r5c_cache *cache, struct r5c_stripe *stripe,
+	struct block_device *bdev, int start, int pages)
+{
+	sector_t base;
+	struct bio *bio;
+	int i;
+
+	i = 0;
+	base = STRIPE_RAID_SECTOR(cache, stripe) + (start << PAGE_SECTOR_SHIFT);
+	while (i < pages) {
+		bio = bio_kmalloc(GFP_NOIO, min_t(int, pages - i,
+			bio_get_nr_vecs(bdev)));
+		bio->bi_iter.bi_sector = base + (i << PAGE_SECTOR_SHIFT);
+		bio->bi_bdev = bdev;
+		bio->bi_private = stripe;
+		while (i < pages) {
+			if (!bio_add_page(bio, stripe->data_pages[i + start],
+			    PAGE_SIZE, 0))
+				break;
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
+static void r5c_flush_stripe(struct r5c_cache *cache, struct block_device *bdev,
+	struct r5c_stripe *stripe)
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
+		r5c_flush_one(cache, stripe, bdev, start, end - start);
+	}
+	r5c_put_stripe_dirty(cache, stripe);
+}
+
+static int r5c_select_front_stripes(struct r5c_cache *cache,
+	struct list_head *list, int count, bool blocking)
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
+	struct list_head *list, int count, bool blocking)
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
+		if (stripes >= count)
+			break;
+	}
+	if (list_empty(&cache->full_stripes)) {
+		cache->full_stripe_ready_time = 0;
+		clear_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
+	}
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
+	if (test_bit(RECLAIM_DISK, &cache->reclaim_reason) ||
+	    test_bit(RECLAIM_DISK_BACKGROUND, &cache->reclaim_reason)) {
+		blocking = test_bit(RECLAIM_DISK, &cache->reclaim_reason);
+		r5c_select_front_stripes(cache, list, RECLAIM_BATCH, blocking);
+	} else if (test_bit(RECLAIM_MEM, &cache->reclaim_reason) ||
+	           test_bit(RECLAIM_MEM_BACKGROUND, &cache->reclaim_reason)) {
+		stripes = r5c_select_full_stripes(cache, list, RECLAIM_BATCH, false);
+		if (stripes < RECLAIM_BATCH)
+			r5c_select_front_stripes(cache, list, RECLAIM_BATCH, false);
+	} else if (test_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason)){
+		r5c_select_full_stripes(cache, list, -1, false);
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
+static void r5c_reclaim_stripe_list(struct r5c_cache *cache,
+	struct list_head *stripe_list)
+{
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+	u64 seq;
+	sector_t meta;
+	struct blk_plug plug;
+	struct block_device *md_bdev;
+
+	if (list_empty(stripe_list))
+		return;
+	md_bdev = blkdev_get_by_dev(cache->mddev->unit,
+		FMODE_READ|FMODE_WRITE, NULL);
+
+	blk_start_plug(&plug);
+	/* step 1: start write to raid */
+	list_for_each_entry(stripe, stripe_list, lru)
+		r5c_flush_stripe(cache, md_bdev, stripe);
+	blk_finish_plug(&plug);
+
+	/* step 2: wait parity write to cache */
+	list_for_each_entry_reverse(stripe, stripe_list, lru)
+		r5c_stripe_wait_state(cache, stripe, STRIPE_PARITY_DONE);
+
+	/* step 3: make sure data and parity settle down */
+	r5l_commit(&cache->log);
+
+	/* step 4: continue write to raid */
+	list_for_each_entry(stripe, stripe_list, lru) {
+		atomic_set(&stripe->dirty_stripes, 1);
+		while (!list_empty(&stripe->stripes)) {
+			struct stripe_head *sh;
+
+			sh = list_first_entry(&stripe->stripes,
+				struct stripe_head, stripe_list);
+			list_del(&sh->stripe_list);
+			set_bit(STRIPE_HANDLE, &sh->state);
+			if (!list_empty(&stripe->stripes))
+				atomic_inc(&stripe->dirty_stripes);
+			release_stripe(sh);
+		}
+	}
+
+	/* step 5: wait to make sure stripe data is in raid */
+	list_for_each_entry_reverse(stripe, stripe_list, lru)
+		r5c_stripe_wait_state(cache, stripe, STRIPE_INRAID);
+
+	blkdev_put(md_bdev, FMODE_READ|FMODE_WRITE);
+
+	/* step 6: flush raid disks */
+	r5c_flush_all_disks(cache);
+
+	/* step 7: add a checkpoint */
+	r5l_checkpoint(&cache->log, &seq, &meta);
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
+
+	if (cache->full_stripe_ready_time && cache->full_stripe_ready_time +
+	    FULL_STRIPE_MAX_AGE < jiffies)
+		set_bit(RECLAIM_MEM_FULL, &cache->reclaim_reason);
+	while (cache->reclaim_reason != 0) {
+		r5c_select_stripes(cache, &stripe_list);
+
+		r5c_reclaim_stripe_list(cache, &stripe_list);
+
+		wake_up_all(&cache->reclaim_wait);
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
+static void r5c_parity_task_end(struct r5l_task *task)
+{
+	struct stripe_head *sh = task->private;
+	struct r5conf *conf = sh->raid_conf;
+	struct r5c_cache *cache = conf->cache;
+	struct r5c_stripe *stripe = sh->stripe;
+
+	r5c_put_stripe_dirty(cache, stripe);
+	kfree(task);
+}
+
+/*
+ * we don't record parity range in cache->log_list, because after a success
+ * reclaim, parity always is discarded
+ */
+int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *sh)
+{
+	struct r5c_stripe *stripe;
+	u64 stripe_index;
+	int stripe_offset;
+	int parity_cnt;
+	unsigned long flags;
+
+	/* parity is already written */
+	if (sh->stripe) {
+		sh->stripe = NULL;
+		return -EAGAIN;
+	}
+	if (!test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags))
+		return -EAGAIN;
+
+	stripe_index = sh->sector;
+	stripe_offset = sector_div(stripe_index, cache->chunk_size);
+	stripe_offset >>= PAGE_SECTOR_SHIFT;
+
+	stripe = r5c_search_stripe(cache, stripe_index);
+	r5c_lock_stripe(cache, stripe, &flags);
+	list_add_tail(&sh->stripe_list, &stripe->stripes);
+	r5c_unlock_stripe(cache, stripe, &flags);
+	sh->stripe = stripe;
+
+	atomic_inc(&sh->count);
+
+	parity_cnt = !!(sh->pd_idx >= 0) + !!(sh->qd_idx >= 0);
+	BUG_ON(parity_cnt != cache->parity_disks);
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
+		return 0;
+	}
+
+	r5l_queue_parity(&cache->log, sh->sector,
+		sh->dev[sh->pd_idx].page,
+		sh->qd_idx >= 0 ? sh->dev[sh->qd_idx].page : NULL,
+		r5c_parity_task_end, sh);
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
+static int r5c_add_checkpoint(struct r5c_load_ctx *ctx, u64 seq)
+{
+	struct r5c_cache *cache = ctx->cache;
+	struct r5c_stripe *stripe;
+	struct r5c_io_range *range;
+
+	while (!list_empty(&ctx->stripes_with_parity)) {
+		stripe = list_first_entry(&ctx->stripes_with_parity,
+			struct r5c_stripe, lru);
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
+			kfree(range);
+		}
+		while (!list_empty(&stripe->parity_list)) {
+			range = list_first_entry(&stripe->parity_list,
+				struct r5c_io_range, stripe_sibling);
+			list_del(&range->stripe_sibling);
+
+			kfree(range->checksum);
+			kfree(range);
+		}
+
+		kfree(stripe);
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
+
+	range = kmalloc(sizeof(struct r5c_io_range), GFP_NOIO);
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
+	stripe = r5c_get_stripe(ctx->cache, index);
+	BUG_ON(!stripe);
+
+	range = kmalloc(sizeof(struct r5c_io_range), GFP_NOIO);
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
+	r5c_put_stripe(stripe);
+	return 0;
+}
+
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
+		kfree(range);
+	}
+	if (stripe->parity_pages) {
+		r5c_put_pages(cache, stripe->parity_pages,
+			STRIPE_PARITY_PAGES(cache));
+		kfree(stripe->parity_pages);
+		stripe->parity_pages = NULL;
+	}
+}
+
+/* If there is commit block after parity, all stripes with parity are already in
+ * raid. All data and parity can be ignored. Otherwise, if all stripes with
+ * parity have full parity, those stripes are in the process writting to raid,
+ * such stripes must be recovered. Otherwise, ignore all parity
+ */
+static int r5c_analyse_log(struct r5c_load_ctx *ctx)
+{
+	struct r5c_stripe *stripe;
+	bool full = true;
+
+	list_for_each_entry(stripe, &ctx->stripes_with_parity, lru) {
+		if (r5c_check_parity_full(ctx, stripe))
+			continue;
+		full = false;
+		break;
+	}
+	if (!full) {
+		list_for_each_entry(stripe, &ctx->stripes_with_parity, lru) {
+			r5c_free_parity_ranges(stripe);
+		}
+		list_splice_tail_init(&ctx->stripes_with_parity,
+			&ctx->stripes_without_parity);
+	}
+	return 0;
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
+		pages[i + page_index] = alloc_page(GFP_NOIO);
+		if (data)
+			stripe->existing_pages++;
+		ctx->cache->total_pages++;
+		bio_add_page(bio, pages[i + page_index], PAGE_SIZE, 0);
+	}
+
+	if (bio_end_sector(bio) > (BLOCK_SECTOR(log, log->last_block))) {
+		split = bio_split(bio, BLOCK_SECTOR(log, log->last_block) -
+			bio->bi_iter.bi_sector, GFP_NOIO, NULL);
+		bio_chain(split, bio);
+		bio->bi_iter.bi_sector = BLOCK_SECTOR(log, log->first_block);
+		r5l_submit_bio(log, READ, split);
+	}
+	sec = BLOCK_SECTOR(log, r5l_ring_add(log, sec >> log->block_sector_shift,
+					PAGE_BLOCKS(log, nvec)));
+	page_index += nvec;
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
+	int offset, max, start;
+
+	/* new data is at the tail */
+	list_for_each_entry_reverse(range, &stripe->io_ranges, stripe_sibling) {
+		STRIPE_INDEX_OFFSET(cache, range->raid_start, index, offset);
+		offset >>= PAGE_SECTOR_SHIFT;
+		max = (range->data_sectors >> PAGE_SECTOR_SHIFT) + offset;
+again:
+		while (offset < max && stripe->data_pages[offset])
+			offset++;
+		start = offset;
+		while (offset < max && !stripe->data_pages[offset])
+			offset++;
+		r5l_fetch_one_range(ctx, stripe, &stripe->data_pages[start],
+			offset - start,
+			range->data_start + (start << PAGE_SECTOR_SHIFT), true);
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
+	/* If any parity checksum is wrong, we think the stripes are not hiting to raid */
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
+static void *r5l_read_meta_block(struct r5l_log *log, u64 block,
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
+	    le32_to_cpu(header->type) != R5LOG_TYPE_CHECKPOINT)
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
+	u64 last_cp = log->last_checkpoint;
+	u64 last_seq = log->last_cp_seq;
+	u64 payload_block;
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
+	if (le32_to_cpu(header->type) == R5LOG_TYPE_CHECKPOINT) {
+		r5c_add_checkpoint(&ctx, last_seq);
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
+		u16 entries = le32_to_cpu(payload->blocks) >>log->page_block_shift;
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
+			entries << log->page_block_shift);
+		offset += sizeof(struct r5l_meta_payload) +
+			entries * sizeof(u32);
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
+void r5l_fake_super(struct r5c_cache *cache, struct md_rdev *rdev)
+{
+	struct page *page = alloc_page(GFP_KERNEL|__GFP_ZERO);
+	struct r5l_super_block *sb_blk;
+	u32 crc;
+
+#define BLKSIZE 4096
+	sb_blk = kmap_atomic(page);
+	sb_blk->header.magic = cpu_to_le32(R5LOG_MAGIC);
+	sb_blk->header.type = cpu_to_le32(R5LOG_TYPE_SUPER);
+	sb_blk->header.seq = cpu_to_le32(0x111);
+	sb_blk->header.meta_size = cpu_to_le32(sizeof(*sb_blk));
+	sb_blk->version = cpu_to_le32(R5LOG_VERSION);
+	sb_blk->stripe_cache_size = cpu_to_le32(PAGE_SIZE);
+	sb_blk->block_size = cpu_to_le32(BLKSIZE);
+	sb_blk->total_blocks = (rdev->sectors * 512 / BLKSIZE) - 1;
+	sb_blk->stripe_data_size = cpu_to_le32(cache->stripe_data_size << 9);
+	sb_blk->chunk_size = cpu_to_le32(cache->chunk_size << 9);
+	sb_blk->stripe_size = cpu_to_le32(cache->stripe_size << 9);
+	sb_blk->parity_disks = cpu_to_le32(cache->parity_disks);
+
+	sb_blk->first_block = cpu_to_le64(1);
+	sb_blk->last_checkpoint = cpu_to_le64(1);
+	sb_blk->meta_checksum_type = R5LOG_CHECKSUM_CRC32;
+	sb_blk->data_checksum_type = R5LOG_CHECKSUM_CRC32;
+	memcpy(sb_blk->uuid, rdev->mddev->uuid, sizeof(sb_blk->uuid));
+
+	crc = crc32_le(~0, sb_blk, BLKSIZE);
+	crc = crc32_le(crc, sb_blk->uuid, sizeof(sb_blk->uuid));
+	sb_blk->header.checksum = crc;
+	kunmap_atomic(sb_blk);
+
+	sync_page_io(rdev, 0, BLKSIZE, page, WRITE, false);
+	__free_page(page);
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
+		sb_blk, log->block_size, false);
+	crc = r5l_calculate_checksum(log, crc,
+		sb_blk->uuid, sizeof(sb_blk->uuid), false);
+	if (crc != stored_crc)
+		goto error;
+
+	if (memcmp(log->uuid, sb_blk->uuid, sizeof(log->uuid)))
+		goto error;
+
+	log->first_block = le64_to_cpu(sb_blk->first_block);
+	if (log->first_block != 1)
+		goto error;
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
+	memcpy(log->uuid, cache->mddev->uuid, sizeof(log->uuid));
+
+	init_waitqueue_head(&log->space_waitq);
+	mutex_init(&log->io_mutex);
+
+	spin_lock_init(&log->io_list_lock);
+	INIT_LIST_HEAD(&log->running_ios);
+	init_waitqueue_head(&log->io_waitq);
+
+	if (r5l_read_super(log)) {
+		r5l_fake_super(cache, log->rdev);
+		if (r5l_read_super(log))
+			goto error;
+	}
+	log->uuid_checksum_data = r5l_calculate_checksum(log, ~0, log->uuid,
+		sizeof(log->uuid), true);
+	log->uuid_checksum_meta = r5l_calculate_checksum(log, ~0, log->uuid,
+		sizeof(log->uuid), false);
+
+	log->reserved_blocks = (cache->reserved_space >>
+		log->block_sector_shift) + 1;
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
+	__free_page(log->super_page);
+	kfree(log);
+	return -EINVAL;
+}
+
+static void r5l_exit_log(struct r5l_log *log)
+{
+	r5l_commit(log);
+
+	__free_page(log->super_page);
+	kfree(log);
+}
+
+struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev)
+{
+	struct mddev *mddev = rdev->mddev;
+	struct r5c_cache *cache;
+	int i;
+
+	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
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
+	cache->max_pages = MAX_MEM >> PAGE_SHIFT;
+
+	cache->stripe_data_size = conf->chunk_sectors * (conf->raid_disks -
+		conf->max_degraded);
+	cache->chunk_size = conf->chunk_sectors;
+	cache->stripe_size = conf->chunk_sectors * conf->raid_disks;
+	cache->parity_disks = conf->max_degraded;
+
+	/* make sure we can add checkpoint */
+	cache->reserved_space = (STRIPE_PARITY_PAGES(cache) <<
+		PAGE_SECTOR_SHIFT) * RECLAIM_BATCH;
+
+	init_waitqueue_head(&cache->reclaim_wait);
+
+	for (i = 0; i < (1 << STRIPE_LOCK_BITS); i++) {
+		spin_lock_init(&cache->stripe_locks[i]);
+		init_waitqueue_head(&cache->stripe_waitq[i]);
+	}
+
+	r5l_init_log(cache);
+
+	while (cache->total_pages < cache->max_pages) {
+		struct page *page = alloc_page(GFP_KERNEL);
+
+		list_add(&page->lru, &cache->page_pool);
+		cache->free_pages++;
+		cache->total_pages++;
+	}
+
+	if (cache->max_pages / 10 < 1024)
+		cache->low_watermark = 1024;
+	else
+		cache->low_watermark = cache->max_pages / 10;
+	cache->high_watermark = cache->low_watermark * 3 /2;
+
+	cache->reclaim_thread = md_register_thread(r5c_reclaim_thread,
+		mddev, "reclaim");
+	cache->reclaim_thread->timeout = RECLAIM_TIMEOUT;
+	//FIXME: make sure total_pages < max_pages
+	return cache;
+}
+
+void r5c_exit_cache(struct r5c_cache *cache)
+{
+	struct r5c_stripe *stripe;
+	struct page *page, *tmp;
+	struct radix_tree_iter iter;
+	void **slot;
+
+	md_unregister_thread(&cache->reclaim_thread);
+	r5l_exit_log(&cache->log);
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
+//sysfs max memory
+//background reclaim time
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd2f96b..fbef599 100644
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
@@ -741,6 +741,11 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (conf->cache) {
+		if (!r5c_write_parity(conf->cache, sh))
+			return;
+	}
+
 	for (i = disks; i--; ) {
 		int rw;
 		int replace_only = 0;
@@ -3125,6 +3130,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
 			WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
 			WARN_ON(dev->page != dev->orig_page);
 		}
+
 	if (!discard_pending &&
 	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
 		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
@@ -4179,13 +4185,20 @@ static int raid5_mergeable_bvec(struct mddev *mddev,
 	int max;
 	unsigned int chunk_sectors = mddev->chunk_sectors;
 	unsigned int bio_sectors = bvm->bi_size >> 9;
+	struct r5conf *conf = mddev->private;
 
-	if ((bvm->bi_rw & 1) == WRITE)
+	/* with cache, write must align within stripe */
+	if (((bvm->bi_rw & 1) == WRITE) && !conf->cache)
 		return biovec->bv_len; /* always allow writes to be mergeable */
 
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
@@ -4637,7 +4650,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	}
 }
 
-static void make_request(struct mddev *mddev, struct bio * bi)
+void raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	struct r5conf *conf = mddev->private;
 	int dd_idx;
@@ -4785,7 +4798,8 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			}
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
-			if ((bi->bi_rw & REQ_SYNC) &&
+			/* there's no point to delay stripe with cache */
+			if (((bi->bi_rw & REQ_SYNC) || conf->cache) &&
 			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
 				atomic_inc(&conf->preread_active_stripes);
 			release_stripe_plug(mddev, sh);
@@ -4809,6 +4823,16 @@ static void make_request(struct mddev *mddev, struct bio * bi)
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
@@ -5740,6 +5764,9 @@ static void raid5_free_percpu(struct r5conf *conf)
 
 static void free_conf(struct r5conf *conf)
 {
+	if (conf->cache)
+		r5c_exit_cache(conf->cache);
+
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
@@ -6339,6 +6366,22 @@ static int run(struct mddev *mddev)
 						mddev->queue);
 	}
 
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk < 0) {
+			char b[BDEVNAME_SIZE];
+			printk(KERN_INFO "using device %s as cache\n",
+				bdevname(rdev->bdev, b));
+			conf->cache = r5c_init_cache(conf, rdev);
+		}
+	}
+
+	if (conf->cache) {
+		/* Make sure all write do overwite */
+		if (mddev->queue)
+			blk_queue_logical_block_size(mddev->queue, STRIPE_SIZE);
+		conf->skip_copy = 1;
+	}
+
 	return 0;
 abort:
 	md_unregister_thread(&mddev->thread);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 983e18a..4c0d573 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -215,6 +215,8 @@ struct stripe_head {
 	spinlock_t		stripe_lock;
 	int			cpu;
 	struct r5worker_group	*group;
+	struct r5c_stripe	*stripe;
+	struct list_head	stripe_list;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -495,6 +497,7 @@ struct r5conf {
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
+	struct r5c_cache	*cache;
 };
 
 /*
@@ -560,4 +563,11 @@ static inline int algorithm_is_DDF(int layout)
 
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
+
+void release_stripe(struct stripe_head *sh);
+void raid5_make_request(struct mddev *mddev, struct bio *bi);
+void r5c_handle_bio(struct r5c_cache *cache, struct bio *bi);
+int r5c_write_parity(struct r5c_cache *cache, struct stripe_head *sh);
+struct r5c_cache *r5c_init_cache(struct r5conf *conf, struct md_rdev *rdev);
+void r5c_exit_cache(struct r5c_cache *cache);
 #endif
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 49f4210..ed4e504 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -305,4 +305,74 @@ struct mdp_superblock_1 {
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
+	R5LOG_TYPE_CHECKPOINT = 1,
+	R5LOG_TYPE_SUPER = 2,
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
+	__le64 total_blocks;
+	__le64 first_block;
+	__le64 last_checkpoint; /* block */
+	__le64 update_time_sec;
+	__le64 update_time_nsec;
+	__u8 meta_checksum_type;
+	__u8 data_checksum_type;
+	__u8 uuid[16];
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
+	__le32 blocks; /* for parity, blocks should be 1 or 2 pages */
+	/* For data, it's raid sector. For stripe, it's stripe sector */
+	__le64 location; /* sector */
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
+struct r5l_checkpoint_block {
+	struct r5l_meta_header header;
+	__le64 cp_sec;
+	__le64 cp_nsec;
+} __attribute__ ((__packed__));
 #endif
-- 
1.8.1

