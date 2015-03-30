From: Shaohua Li <shli@fb.com>
Subject: [RFC] raid5: add a log device to fix raid5/6 write hole issue
Date: Mon, 30 Mar 2015 15:25:17 -0700
Message-ID: <20150330222459.GA575371@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, dan.j.williams@intel.com, linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, Kernel-team@fb.com
List-Id: linux-raid.ids

This is my attempt to fix raid5/6 write hole issue, it's not for merge
yet, I post it out for comments. Any comments and suggestions are
welcome!

Thanks,
Shaohua

We expect a completed raid5/6 stack with reliability and high
performance. Currently raid5/6 has 2 issues:

1. read-modify-write for small size IO. To fix this issue, a cache layer
above raid5/6 can be used to aggregate write to full stripe write.
2. write hole issue. A write log below raid5/6 can fix the issue.

We plan to use a SSD to fix the two issues. Here we just fix the write
hole issue.

1. We don't try to fix the issues together. A cache layer will do write
acceleration. A log layer will fix write hole. The seperation will
simplify things a lot.

2. Current assumption is flashcache/bcache will be used as the cache
layer. If they don't work well, we can fix them or add a simple cache
layer for raid write aggregation later. We also assume cache layer will
absorb write, so log doesn't worry about write latency.

3. For log, write will hit to log disk first, then raid disks, and
finally IO completion is reported. An optimal way is to report IO
completion just after IO hits to log disk to cut write latency. But in
that way, read path need query log disk and increase complexity. And
since we don't worry about write latency, we choose a simple soltuion.
This will be revisited if there is performance issue.

This design isn't intrusive for raid5/6. Actully only very few changes
of existing code is required.

Log looks like jbd. Stripe IO to raid disks will be written to log disk
first in atomic way. Several stripe IO will consist a transaction. If
all stripes of a transaction are finished, the tranaction can be
checkpoint.

Basic logic of raid 5/6 write will be:
1. normal raid5/6 steps for a stripe (fetch data, calculate checksum,
and etc). log hooks to ops_run_io.
2. stripe is added to a transaction. Write stripe data to log disk (metadata
block, stripe data)
3. write commit block to log disk
4. flush log disk cache.
5. stripe is logged now and normal stripe handling continues

Transaction checkpoint process:
1. all stripes of a transaction are finished
2. flush disk cache of all raid disks
3. change log super to reflect new log checkpoint position
4. WRITE_FUA log super

metadata, data and commit block IO can run in the meaning time, as
checksum will be used to make sure their data is correct (like jbd2).
Log IO doesn't wait 5s to start like jbd, instead the IO will start
every time a metadata block is full. This can cut some latency.

Disk layout:

|super|metadata|data|metadata| data ... |commitdata|metadata|data| ... |commitdata|
super, metadata, commit will use one block

This is an initial version, which works but a lot of stuffes are
missing:
1. error handling
2. log recovery and impact to raid resync (don't need resync anymore)
3. utility changes

The big question is how we report log disk. In this patch, I simply use
a spare disk for testing. We need a new raid disk role for log disk.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/Makefile            |    2 +-
 drivers/md/raid5-log.c         | 1017 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid5.c             |   42 +-
 drivers/md/raid5.h             |   16 +
 include/uapi/linux/raid/md_p.h |   64 +++
 5 files changed, 1136 insertions(+), 5 deletions(-)
 create mode 100644 drivers/md/raid5-log.c

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a2da532..a0dee4c 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -16,7 +16,7 @@ dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
 dm-era-y	+= dm-era-target.o
 md-mod-y	+= md.o bitmap.o
-raid456-y	+= raid5.o
+raid456-y	+= raid5.o raid5-log.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
diff --git a/drivers/md/raid5-log.c b/drivers/md/raid5-log.c
new file mode 100644
index 0000000..d27317f
--- /dev/null
+++ b/drivers/md/raid5-log.c
@@ -0,0 +1,1017 @@
+#include <linux/kernel.h>
+#include <linux/wait.h>
+#include <linux/blkdev.h>
+#include <linux/crc32.h>
+#include <linux/raid/md_p.h>
+#include "md.h"
+#include "raid5.h"
+
+struct r5log_journal {
+	struct mddev *mddev;
+	struct md_rdev *rdev;
+	struct page *super_page;
+
+	u64 transaction_id; /* next tid for transaction */
+	u64 checkpoint_transaction_id;
+
+	u32 block_size;
+	u32 block_sector_shift;
+	u64 total_blocks;
+	u64 first_block;
+	u64 last_block;
+
+	u64 last_checkpoint;
+	u64 log_start; /* next transaction starts here */
+
+	u8 data_checksum_type;
+	u8 meta_checksum_type;
+
+	u8 uuid[16];
+
+	struct list_head transaction_list;
+	int transaction_cnt;
+	struct r5log_transaction *current_trans;
+
+	struct list_head pending_stripes;
+	spinlock_t stripes_lock;
+
+	struct md_thread *thread;
+	unsigned long last_commit_time;
+
+	struct mutex jlock;
+
+	int aborted;
+	int do_commit;
+	int do_discard;
+};
+
+struct r5log_io_control {
+	struct r5log_transaction *trans;
+	struct page *meta_page;
+	struct page *commit_page;
+	int tag_index;
+
+	struct bio_list bios;
+	struct bio *current_bio;
+	atomic_t refcnt;
+};
+
+struct r5log_transaction {
+	struct r5log_journal *journal;
+	u64 transaction_id;
+	struct list_head stripe_list;
+	int stripe_cnt;
+	struct r5log_io_control *current_io;
+	atomic_t io_pending;
+	atomic_t stripe_pending;
+	u64 log_start; /* block */
+	u64 log_end; /* block */
+	struct list_head next_trans;
+
+	int state;
+	wait_queue_head_t wait_state;
+
+	struct mutex tlock;
+
+	struct work_struct flush_work;
+};
+
+enum {
+	/* transaction accepts new IO */
+	TRANSACTION_RUNNING = 0,
+	/* transaction is frozen. commit block IO is running */
+	TRANSACTION_COMMITED = 1,
+	/* transaction IO is finished, FLUSH request is running */
+	TRANSACTION_FLUSHING = 2,
+	/*
+	 * transaction FLUSH request is finished, stripes are considered
+	 * on-disk now, those stripes start hitting to raid disks
+	 * */
+	TRANSACTION_STRIPE_RUNNING = 3,
+	/*
+	 * Stripes of transaction hit to raid disks, transaction space can be
+	 * reclaimed
+	 * */
+	TRANSACTION_CHECKPOINT_READY = 4,
+};
+
+#define MAX_TAG_PER_BLOCK(journal) ((journal->block_size - \
+	sizeof(struct r5log_meta_header)) / \
+	sizeof(struct r5log_meta_block_tag))
+#define PAGE_TO_BLOCKS(journal) (PAGE_SIZE / journal->block_size)
+#define BLOCK_TO_SECTOR(b, journal) ((b) << journal->block_sector_shift)
+
+#define TRANSACTION_MAX_SIZE (2 * 1024 * 1024)
+#define TRANSACTION_MAX_STRIPES 128
+#define TRANSACTION_TIMEOUT (5 * HZ)
+
+static void r5log_journal_thread(struct md_thread *thread);
+static int r5log_do_commit(struct r5log_transaction *trans);
+static int r5log_do_checkpoint(struct r5log_journal *journal, u64 blocks);
+
+static u32 r5log_calculate_checksum(struct r5log_journal *journal, u32 crc,
+	void *buf, ssize_t size, bool data)
+{
+	if (journal->data_checksum_type != R5LOG_CHECKSUM_CRC32)
+		BUG();
+	if (journal->meta_checksum_type != R5LOG_CHECKSUM_CRC32)
+		BUG();
+	return crc32_le(crc, buf, size);
+}
+
+static int r5log_read_super(struct r5log_journal *journal)
+{
+	struct md_rdev *rdev = journal->rdev;
+	struct r5log_super_block *sb_blk;
+	struct page *page = journal->super_page;
+	u32 crc = ~0, stored_crc;
+
+	if (!sync_page_io(rdev, 0, PAGE_SIZE, page, READ, false))
+		return -EIO;
+
+	sb_blk = kmap_atomic(page);
+
+	if (le32_to_cpu(sb_blk->version) != RAID5_LOG_VERSION ||
+	    le32_to_cpu(sb_blk->header.magic) != RAID5_LOG_MAGIC ||
+	    le32_to_cpu(sb_blk->header.type) != R5LOG_TYPE_SUPER ||
+	    le64_to_cpu(sb_blk->header.position) != 0)
+		goto error;
+
+	journal->checkpoint_transaction_id =
+		le64_to_cpu(sb_blk->header.transaction_id);
+	journal->transaction_id = journal->checkpoint_transaction_id + 1;
+
+	journal->block_size = le32_to_cpu(sb_blk->block_size);
+	journal->block_sector_shift = ilog2(journal->block_size >> 9);
+
+	/* Only support this stripe size right now */
+	if (le32_to_cpu(sb_blk->stripe_size) != PAGE_SIZE)
+		goto error;
+	if (journal->block_size > PAGE_SIZE)
+		goto error;
+
+	if (sb_blk->meta_checksum_type >= R5LOG_CHECKSUM_NR ||
+	    sb_blk->data_checksum_type >= R5LOG_CHECKSUM_NR)
+		goto error;
+	journal->meta_checksum_type = sb_blk->meta_checksum_type;
+	journal->data_checksum_type = sb_blk->data_checksum_type;
+
+	stored_crc = le32_to_cpu(sb_blk->header.checksum);
+	sb_blk->header.checksum = 0;
+	crc = r5log_calculate_checksum(journal, ~0,
+		sb_blk, journal->block_size, false);
+	crc = r5log_calculate_checksum(journal, crc,
+		sb_blk->uuid, sizeof(sb_blk->uuid), false);
+	if (crc != stored_crc)
+		goto error;
+
+	if (memcmp(journal->uuid, sb_blk->uuid, sizeof(journal->uuid)))
+		goto error;
+
+	journal->first_block = le64_to_cpu(sb_blk->first_block);
+	if (journal->first_block != 1)
+		goto error;
+	journal->total_blocks = le64_to_cpu(sb_blk->total_blocks);
+	journal->last_block = journal->first_block + journal->total_blocks;
+	journal->last_checkpoint = le64_to_cpu(sb_blk->last_checkpoint);
+	kunmap_atomic(sb_blk);
+
+	return 0;
+error:
+	kunmap_atomic(sb_blk);
+	return -EINVAL;
+}
+
+static int r5log_write_super(struct r5log_journal *journal)
+{
+	struct r5log_super_block *sb_blk;
+	u32 crc;
+	struct timespec now = current_kernel_time();
+
+	sb_blk = kmap_atomic(journal->super_page);
+	sb_blk->header.checksum = 0;
+	sb_blk->header.transaction_id =
+		cpu_to_le64(journal->checkpoint_transaction_id);
+	sb_blk->last_checkpoint =
+		cpu_to_le64(journal->last_checkpoint);
+	sb_blk->update_time_sec = cpu_to_le64(now.tv_sec);
+	sb_blk->update_time_nsec = cpu_to_le64(now.tv_nsec);
+
+	crc = r5log_calculate_checksum(journal, ~0,
+		sb_blk, journal->block_size, false);
+	crc = r5log_calculate_checksum(journal, crc,
+		sb_blk->uuid, sizeof(sb_blk->uuid), false);
+	sb_blk->header.checksum = cpu_to_le32(crc);
+	kunmap_atomic(sb_blk);
+
+	if (sync_page_io(journal->rdev, 0, journal->block_size,
+	    journal->super_page, WRITE_FUA, false))
+		return 0;
+	return -EIO;
+}
+
+static int r5log_recover_journal(struct r5log_journal *journal)
+{
+	return 0;
+}
+
+#define DBG 1
+#if DBG
+void r5log_fake_super(struct md_rdev *rdev)
+{
+	struct page *page = alloc_page(GFP_KERNEL|__GFP_ZERO);
+	struct r5log_super_block *sb_blk;
+	u32 crc;
+
+#define BLKSIZE 4096
+	sb_blk = kmap_atomic(page);
+	sb_blk->header.magic = cpu_to_le32(RAID5_LOG_MAGIC);
+	sb_blk->header.type = cpu_to_le32(R5LOG_TYPE_SUPER);
+	sb_blk->header.transaction_id = cpu_to_le32(0x111);
+	sb_blk->version = cpu_to_le32(RAID5_LOG_VERSION);
+	sb_blk->stripe_size = cpu_to_le32(PAGE_SIZE);
+	sb_blk->block_size = cpu_to_le32(BLKSIZE);
+	sb_blk->total_blocks = rdev->sectors * 512 / BLKSIZE;
+	sb_blk->first_block = 1;
+	sb_blk->last_checkpoint = 0;
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
+#endif
+
+struct r5log_journal *r5log_load_journal(struct md_rdev *rdev)
+{
+	struct r5log_journal *journal;
+
+#if DBG
+	r5log_fake_super(rdev);
+#endif
+
+	journal = kzalloc(sizeof(*journal), GFP_KERNEL);
+	if (!journal)
+		return NULL;
+
+	journal->super_page = alloc_page(GFP_KERNEL);
+	if (!journal->super_page)
+		goto err_page;
+
+	journal->mddev = rdev->mddev;
+	journal->rdev = rdev;
+	memcpy(journal->uuid, rdev->mddev->uuid, sizeof(journal->uuid));
+
+	INIT_LIST_HEAD(&journal->transaction_list);
+	INIT_LIST_HEAD(&journal->pending_stripes);
+	spin_lock_init(&journal->stripes_lock);
+	mutex_init(&journal->jlock);
+
+	if (r5log_read_super(journal))
+		goto err_super;
+
+	journal->do_discard = blk_queue_discard(bdev_get_queue(rdev->bdev));
+
+	if (journal->last_checkpoint != 0) {
+		if (r5log_recover_journal(journal))
+			goto err_super;
+	}
+
+	journal->log_start = 1;
+	journal->last_checkpoint = 1;
+
+	journal->last_commit_time = jiffies;
+	journal->thread = md_register_thread(r5log_journal_thread,
+		journal->mddev, "journal");
+	journal->thread->timeout = TRANSACTION_TIMEOUT;
+
+	return journal;
+err_super:
+	__free_page(journal->super_page);
+err_page:
+	kfree(journal);
+	return NULL;
+}
+
+int r5log_flush_journal(struct r5log_journal *journal)
+{
+	mutex_lock(&journal->jlock);
+	r5log_do_checkpoint(journal, -1);
+	mutex_unlock(&journal->jlock);
+	return 0;
+}
+
+void r5log_free_journal(struct r5log_journal *journal)
+{
+	r5log_flush_journal(journal);
+	md_unregister_thread(&journal->thread);
+
+	__free_page(journal->super_page);
+	kfree(journal);
+}
+
+static u64 r5log_ring_size(struct r5log_journal *journal, u64 start,
+	u64 end)
+{
+	return (journal->total_blocks + end - start) %
+		journal->total_blocks;
+}
+
+static bool r5log_has_room(struct r5log_journal *journal,
+	u64 log_end, int data_blocks)
+{
+	int tags = data_blocks * journal->block_size / PAGE_SIZE;
+	/* data + commit + meta + possible hole */
+	int blocks = data_blocks + 1 +
+		tags / MAX_TAG_PER_BLOCK(journal) + 1 +
+		PAGE_SIZE / journal->block_size - 1;
+
+	return journal->total_blocks - r5log_ring_size(journal,
+		journal->last_checkpoint, log_end)
+		>= blocks + 1;
+}
+
+static int r5log_wait_for_space(struct r5log_transaction *trans,
+	int data_blocks)
+{
+	BUG_ON(!mutex_is_locked(&trans->tlock));
+
+	if (r5log_has_room(trans->journal, trans->log_end, data_blocks))
+		return 0;
+	mutex_unlock(&trans->tlock);
+	r5log_do_checkpoint(trans->journal, data_blocks);
+	return -EAGAIN;
+}
+
+static bool r5log_check_and_freeze_current_transaction(
+	struct r5log_journal *journal)
+{
+	struct r5log_transaction *trans = journal->current_trans;
+
+	BUG_ON(!mutex_is_locked(&journal->jlock));
+
+	/*
+	 * r5log_do_commit doesn't do this because journal->jlock
+	 * isn't hold
+	 **/
+	if (trans && trans->state >= TRANSACTION_COMMITED) {
+		journal->log_start = trans->log_end;
+		journal->current_trans = NULL;
+		return true;
+	}
+	return false;
+}
+
+static struct r5log_transaction *
+r5log_start_transaction(struct r5log_journal *journal, int data_blocks)
+{
+	struct r5log_transaction *trans;
+
+	mutex_lock(&journal->jlock);
+	/* FIXME: if transaction_cnt >= xxx, do checkpoint */
+again:
+	trans = journal->current_trans;
+	if (!trans) {
+		trans = kzalloc(sizeof(*trans), GFP_NOIO | __GFP_REPEAT);
+		trans->journal = journal;
+		trans->transaction_id = journal->transaction_id;
+		atomic_set(&trans->io_pending, 1);
+		atomic_set(&trans->stripe_pending, 1);
+		INIT_LIST_HEAD(&trans->stripe_list);
+		trans->log_start = journal->log_start;
+		trans->log_end = journal->log_start;
+		trans->state = TRANSACTION_RUNNING;
+		init_waitqueue_head(&trans->wait_state);
+		mutex_init(&trans->tlock);
+
+		list_add_tail(&trans->next_trans, &journal->transaction_list);
+		journal->transaction_id++;
+		journal->current_trans = trans;
+		journal->transaction_cnt++;
+	}
+	mutex_lock(&trans->tlock);
+
+	if (r5log_check_and_freeze_current_transaction(journal)) {
+		mutex_unlock(&trans->tlock);
+		goto again;
+	}
+
+	if (r5log_wait_for_space(trans, data_blocks))
+		goto again;
+
+	mutex_unlock(&journal->jlock);
+	return trans;
+}
+
+static u64 r5log_transaction_size(struct r5log_transaction *trans)
+{
+	struct r5log_journal *journal = trans->journal;
+
+	return r5log_ring_size(journal, trans->log_start, trans->log_end);
+}
+
+static void r5log_end_transaction(struct r5log_transaction *trans)
+{
+	struct r5log_journal *journal = trans->journal;
+
+	/* trans is big, commit it */
+	if (r5log_transaction_size(trans) * journal->block_size >=
+	    TRANSACTION_MAX_SIZE || trans->stripe_cnt >=
+	    TRANSACTION_MAX_STRIPES)
+		r5log_do_commit(trans);
+	mutex_unlock(&trans->tlock);
+}
+
+static void r5log_transaction_finish_stripe(struct r5log_transaction *trans)
+{
+	if (!atomic_dec_and_test(&trans->stripe_pending))
+		return;
+	trans->state = TRANSACTION_CHECKPOINT_READY;
+	wake_up(&trans->wait_state);
+}
+
+static void r5log_restore_stripe_data(struct stripe_head *sh)
+{
+	int i;
+
+	for (i = 0; i < sh->disks; i++) {
+		void *addr;
+		if (!test_and_clear_bit(R5_Escaped, &sh->dev[i].flags))
+			continue;
+		addr = kmap_atomic(sh->dev[i].page);
+		*(__le32 *)addr = cpu_to_le32(RAID5_LOG_MAGIC);
+		kunmap_atomic(addr);
+	}
+}
+
+static void r5log_trans_flush_diskcache(struct work_struct *work)
+{
+	struct r5log_transaction *trans;
+	struct stripe_head *sh;
+
+	trans = container_of(work, struct r5log_transaction, flush_work);
+	blkdev_issue_flush(trans->journal->rdev->bdev, GFP_NOIO, NULL);
+	trans->state = TRANSACTION_STRIPE_RUNNING;
+	wake_up(&trans->wait_state);
+
+	while (!list_empty(&trans->stripe_list)) {
+		sh = list_first_entry(&trans->stripe_list, struct stripe_head,
+			log_list);
+		list_del_init(&sh->log_list);
+		r5log_restore_stripe_data(sh);
+		atomic_inc(&trans->stripe_pending);
+		set_bit(STRIPE_HANDLE, &sh->state);
+		release_stripe(sh);
+	}
+	r5log_transaction_finish_stripe(trans);
+}
+
+static void r5log_transaction_finish_io(struct r5log_transaction *trans)
+{
+	if (!atomic_dec_and_test(&trans->io_pending))
+		return;
+
+	/*
+	 * FIXME: we can release_stripe before flush disk cache if there is no
+	 * FUA or FLUSH request
+	 * */
+	trans->state = TRANSACTION_FLUSHING;
+	INIT_WORK(&trans->flush_work, r5log_trans_flush_diskcache);
+	schedule_work(&trans->flush_work);
+}
+
+static void r5log_put_io_control(struct r5log_io_control *io)
+{
+	struct r5log_transaction *trans = io->trans;
+
+	if (!atomic_dec_and_test(&io->refcnt))
+		return;
+	__free_page(io->meta_page);
+	if (io->commit_page)
+		__free_page(io->commit_page);
+	kfree(io);
+
+	r5log_transaction_finish_io(trans);
+}
+
+static void r5log_end_io(struct bio *bio, int error)
+{
+	struct r5log_io_control *io = bio->bi_private;
+
+	if (error) {
+		io->trans->journal->aborted = 1;
+		printk(KERN_ERR"r5log IO error\n");
+	}
+	r5log_put_io_control(io);
+	bio_put(bio);
+}
+
+static int r5log_submit_io(struct r5log_transaction *trans)
+{
+	struct r5log_journal *journal = trans->journal;
+	struct r5log_io_control *io = trans->current_io;
+	struct bio *bio;
+	struct r5log_meta_block *meta;
+	u32 crc;
+	u32 tag_flags;
+
+	meta = kmap_atomic(io->meta_page);
+	tag_flags = le32_to_cpu(meta->tags[io->tag_index - 1].flags);
+	tag_flags |= R5LOG_TAG_FLAG_LAST_TAG;
+	meta->tags[io->tag_index - 1].flags = cpu_to_le32(tag_flags);
+
+	crc = r5log_calculate_checksum(journal, ~0, meta,
+		journal->block_size, false);
+	crc = r5log_calculate_checksum(journal, crc, journal->uuid,
+		sizeof(journal->uuid), false);
+	meta->header.checksum = cpu_to_le32(crc);
+	kunmap_atomic(meta);
+
+	while ((bio = bio_list_pop(&io->bios)))
+		submit_bio(WRITE, bio);
+	r5log_put_io_control(io);
+	trans->current_io = NULL;
+	return 0;
+}
+
+int r5log_io_add_page(struct r5log_transaction *trans, struct page *page,
+	ssize_t size)
+{
+	struct r5log_journal *journal = trans->journal;
+	struct r5log_io_control *current_io = trans->current_io;
+	sector_t pos = BLOCK_TO_SECTOR(trans->log_end, journal);
+	struct bio *bio;
+	int blocks = size / journal->block_size;
+
+	/*
+	 * if PAGE_SIZE > block size, there might be one block size hole at the
+	 * tail. Recover code should be aware of this
+	 * */
+	if (trans->log_end + blocks > journal->last_block) {
+		pos = BLOCK_TO_SECTOR(journal->first_block, journal);
+		goto allocate_bio;
+	}
+
+retry:
+	bio = current_io->current_bio;
+	if (!bio)
+		goto allocate_bio;
+
+	if (!bio_add_page(bio, page, size, 0))
+		goto allocate_bio;
+
+	if (trans->log_end + blocks > journal->last_block)
+		trans->log_end = journal->first_block;
+	trans->log_end += blocks;
+	return 0;
+allocate_bio:
+	current_io->current_bio = NULL;
+	bio = bio_alloc_mddev(GFP_NOIO,
+		MAX_TAG_PER_BLOCK(trans->journal), trans->journal->mddev);
+
+	bio->bi_bdev = journal->rdev->bdev;
+	bio->bi_iter.bi_sector = pos + journal->rdev->data_offset;
+	bio->bi_private = current_io;
+	bio->bi_end_io = r5log_end_io;
+	
+	bio_list_add(&current_io->bios, bio);
+	atomic_inc(&current_io->refcnt);
+	current_io->current_bio = bio;
+	goto retry;
+}
+
+static int r5log_transaction_get_tag(struct r5log_transaction *trans)
+{
+	struct r5log_io_control *current_io;
+	struct r5log_meta_block *meta;
+
+	current_io = trans->current_io;
+	if (current_io && current_io->tag_index >=
+	    MAX_TAG_PER_BLOCK(trans->journal))
+		r5log_submit_io(trans);
+
+	current_io = trans->current_io;
+	if (current_io)
+		return 0;
+
+	current_io = kmalloc(sizeof(*current_io), GFP_NOIO|__GFP_REPEAT);
+	if (!current_io)
+		return -ENOMEM;
+	current_io->meta_page = alloc_page(GFP_NOIO|__GFP_ZERO|__GFP_REPEAT);
+	if (!current_io->meta_page) {
+		kfree(current_io);
+		return -ENOMEM;
+	}
+
+	current_io->trans = trans;
+	current_io->commit_page = NULL;
+	current_io->tag_index = 0;
+	bio_list_init(&current_io->bios);
+	current_io->current_bio = NULL;
+	atomic_set(&current_io->refcnt, 1);
+
+	atomic_inc(&trans->io_pending);
+	trans->current_io = current_io;
+
+	r5log_io_add_page(trans, current_io->meta_page,
+				trans->journal->block_size);
+
+	meta = kmap_atomic(current_io->meta_page);
+	meta->header.magic = cpu_to_le32(RAID5_LOG_MAGIC);
+	meta->header.type = cpu_to_le32(R5LOG_TYPE_META);
+	meta->header.transaction_id =
+			cpu_to_le64(trans->transaction_id);
+	/* we never hit journal->first_block */
+	meta->header.position = cpu_to_le64(trans->log_end - 1);
+	kunmap_atomic(meta);
+	return 0;
+}
+
+int r5log_add_stripe_page(struct r5log_transaction *trans,
+	struct stripe_head *sh, int disk_index)
+{
+	struct r5log_meta_block_tag *tag;
+	struct r5log_meta_block *meta;
+	struct r5dev *rdev;
+	struct r5log_io_control *current_io;
+	u32 crc;
+
+	rdev = &sh->dev[disk_index];
+
+	if (r5log_transaction_get_tag(trans))
+		return -ENOMEM;
+	current_io = trans->current_io;
+
+	crc = r5log_calculate_checksum(trans->journal, rdev->log_checksum,
+		trans->journal->uuid, sizeof(trans->journal->uuid), true);
+	crc = r5log_calculate_checksum(trans->journal, crc,
+		&trans->transaction_id, sizeof(trans->transaction_id), true);
+
+	meta = kmap_atomic(current_io->meta_page);
+	tag = &meta->tags[current_io->tag_index];
+	if (test_bit(R5_Discard, &rdev->flags))
+		tag->flags |= R5LOG_TAG_FLAG_DISCARD;
+	if (test_bit(R5_Escaped, &rdev->flags))
+		tag->flags |= R5LOG_TAG_FLAG_ESCAPED;
+	tag->flags = cpu_to_le32(tag->flags);
+	tag->disk_index = cpu_to_le32(disk_index);
+	tag->disk_sector = cpu_to_le64(sh->sector);
+	kunmap_atomic(meta);
+
+	current_io->tag_index++;
+	r5log_io_add_page(trans, rdev->page, PAGE_SIZE);
+	return 0;
+}
+
+static int r5log_journal_one_stripe(struct r5log_journal *journal,
+	struct stripe_head *sh)
+{
+	struct r5log_transaction *trans;
+	int i;
+	int data_disks = 0;
+
+	for (i = 0; i < sh->disks; i++) {
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+			continue;
+		if (test_bit(R5_Discard, &sh->dev[i].flags))
+			continue;
+		data_disks++;
+	}
+
+	trans = r5log_start_transaction(journal,
+			data_disks * PAGE_TO_BLOCKS(journal));
+	if (!trans)
+		goto abort_trans;
+	for (i = 0; i < sh->disks; i++) {
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+			continue;
+		if (r5log_add_stripe_page(trans, sh, i))
+			goto abort_trans;
+	}
+
+	list_add_tail(&sh->log_list, &trans->stripe_list);
+	trans->stripe_cnt++;
+	sh->log_trans = trans;
+
+	r5log_end_transaction(trans);
+	return 0;
+abort_trans:
+	journal->aborted = 1;
+	printk(KERN_ERR"r5log journal failed\n");
+	r5log_restore_stripe_data(sh);
+	/* skip journal is still ok, but lose the protection */
+	set_bit(STRIPE_HANDLE, &sh->state);
+	release_stripe(sh);
+	return -ENOMEM;
+}
+
+static void r5log_journal_thread(struct md_thread *thread)
+{
+	struct mddev *mddev = thread->mddev;
+        struct r5conf *conf = mddev->private;
+	struct r5log_journal *journal = conf->journal;
+	struct r5log_transaction *trans;
+	struct stripe_head *sh;
+	LIST_HEAD(stripe_list);
+	struct blk_plug plug;
+	bool did_something;
+
+	blk_start_plug(&plug);
+again:
+	did_something = false;
+	spin_lock(&journal->stripes_lock);
+	list_splice_init(&journal->pending_stripes, &stripe_list);
+	spin_unlock(&journal->stripes_lock);
+
+	while (!list_empty(&stripe_list)) {
+		sh = list_first_entry(&stripe_list, struct stripe_head, log_list);
+		list_del_init(&sh->log_list);
+		r5log_journal_one_stripe(journal, sh);
+		did_something = true;
+	}
+
+	if (journal->do_commit || time_after(jiffies,
+	    journal->last_commit_time + TRANSACTION_TIMEOUT)) {
+		mutex_lock(&journal->jlock);
+		r5log_check_and_freeze_current_transaction(journal);
+		trans = journal->current_trans;
+		if (trans)
+			mutex_lock(&trans->tlock);
+		mutex_unlock(&journal->jlock);
+		journal->do_commit = 0;
+		journal->last_commit_time = jiffies;
+
+		if (trans) {
+			r5log_do_commit(trans);
+			mutex_unlock(&trans->tlock);
+
+			did_something = true;
+		}
+	}
+
+	if (did_something)
+		goto again;
+	blk_finish_plug(&plug);
+}
+
+
+int r5log_write_stripe(struct r5log_journal *journal, struct stripe_head *sh)
+{
+	int i;
+	int write_disks = 0;
+
+	/* fulls stripe write doesn't have write hole issue */
+	if (sh->log_trans || test_bit(STRIPE_FULL_WRITE, &sh->state))
+		return -EAGAIN;
+	if (journal->aborted)
+		return -ENODEV;
+
+	for (i = 0; i < sh->disks; i++) {
+		void *addr;
+		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
+			continue;
+		write_disks++;
+		if (test_bit(R5_Discard, &sh->dev[i].flags)) {
+			sh->dev[i].log_checksum = ~0;
+			continue;
+		}
+		addr = kmap_atomic(sh->dev[i].page);
+
+		if (*(__le32 *)addr == cpu_to_le32(RAID5_LOG_MAGIC)) {
+			*(u32 *)addr = 0;
+			set_bit(R5_Escaped, &sh->dev[i].flags);
+		}
+		sh->dev[i].log_checksum = r5log_calculate_checksum(journal,
+			~0, addr, PAGE_SIZE, true);
+		kunmap_atomic(addr);
+	}
+	if (!write_disks)
+		return -EINVAL;
+
+	atomic_inc(&sh->count);
+
+	/*
+	 * this function shouldn't wait on journal related stuff, journal
+	 * checkpoint might wait for stripes to handle
+	 **/
+	spin_lock(&journal->stripes_lock);
+	list_add_tail(&sh->log_list, &journal->pending_stripes);
+	spin_unlock(&journal->stripes_lock);
+	md_wakeup_thread(journal->thread);
+
+	return 0;
+}
+
+static void r5log_wait_transaction(struct r5log_transaction *trans,
+	int state)
+{
+	wait_event(trans->wait_state, trans->state >= state);
+}
+
+static int r5log_do_commit(struct r5log_transaction *trans)
+{
+	struct r5log_journal *journal = trans->journal;
+	struct r5log_io_control *current_io;
+	struct page *page;
+	struct r5log_commit_block *commit;
+	struct timespec now = current_kernel_time();
+	u32 crc;
+
+	BUG_ON(!mutex_is_locked(&trans->tlock));
+
+	if (trans->state >= TRANSACTION_COMMITED)
+		return 0;
+
+	trans->stripe_cnt = 0;
+
+	journal->last_commit_time = jiffies;
+
+	current_io = trans->current_io;
+	/* The transaction hasn't done anything yet */
+	if (!current_io)
+		BUG();
+
+	page = alloc_page(GFP_NOIO|__GFP_ZERO|__GFP_REPEAT);
+	r5log_io_add_page(trans, page, journal->block_size);
+	current_io->commit_page = page;
+
+	commit = kmap_atomic(page);
+	commit->header.magic = cpu_to_le32(RAID5_LOG_MAGIC);
+	commit->header.type = cpu_to_le32(R5LOG_TYPE_COMMIT);
+	commit->header.transaction_id =
+			cpu_to_le64(trans->transaction_id);
+	commit->commit_sec = cpu_to_le64(now.tv_sec);
+	commit->commit_nsec = cpu_to_le64(now.tv_nsec);
+	commit->header.position = cpu_to_le64(trans->log_end - 1);
+
+	crc = r5log_calculate_checksum(journal, ~0, commit,
+		journal->block_size, false);
+	crc = r5log_calculate_checksum(journal, crc, journal->uuid,
+		sizeof(journal->uuid), false);
+	commit->header.checksum = cpu_to_le32(crc);
+	kunmap_atomic(commit);
+
+	r5log_submit_io(trans);
+	trans->state = TRANSACTION_COMMITED;
+	r5log_transaction_finish_io(trans);
+
+	return 0;
+}
+
+static void r5log_start_commit(struct r5log_journal *journal)
+{
+	journal->do_commit = 1;
+	md_wakeup_thread(journal->thread);
+}
+
+static void r5log_disks_flush_end(struct bio *bio, int err)
+{
+	struct completion *io_complete = bio->bi_private;
+
+	complete(io_complete);
+	bio_put(bio);
+}
+
+static void r5log_flush_all_disks(struct r5log_journal *journal)
+{
+	struct mddev *mddev = journal->mddev;
+	struct bio *bi;
+	DECLARE_COMPLETION_ONSTACK(io_complete);
+
+	bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
+	bi->bi_end_io = r5log_disks_flush_end;
+	bi->bi_private = &io_complete;
+
+	md_flush_request(mddev, bi);
+
+	wait_for_completion_io(&io_complete);
+}
+
+static void r5log_discard_blocks(struct r5log_journal *journal,
+	u64 start, u64 end)
+{
+	if (!journal->do_discard)
+		return;
+	if (start < end) {
+		blkdev_issue_discard(journal->rdev->bdev,
+			BLOCK_TO_SECTOR(start, journal),
+			BLOCK_TO_SECTOR(end - start, journal),
+			GFP_NOIO, 0);
+	} else {
+		blkdev_issue_discard(journal->rdev->bdev,
+			BLOCK_TO_SECTOR(start, journal),
+			BLOCK_TO_SECTOR(journal->last_block - start, journal),
+			GFP_NOIO, 0);
+		blkdev_issue_discard(journal->rdev->bdev,
+			BLOCK_TO_SECTOR(journal->first_block, journal),
+			BLOCK_TO_SECTOR(end - journal->first_block, journal),
+			GFP_NOIO, 0);
+	}
+}
+
+static int r5log_do_checkpoint(struct r5log_journal *journal,
+	u64 blocks)
+{
+	u64 cp_block = journal->last_checkpoint;
+	u64 cp_tid = journal->checkpoint_transaction_id;
+	struct r5log_transaction *trans;
+	bool enough = false;
+	u64 freed = 0;
+
+	BUG_ON(!mutex_is_locked(&journal->jlock));
+
+	trans = journal->current_trans;
+	if (trans && r5log_ring_size(journal, journal->last_checkpoint,
+	    trans->log_start) < blocks) {
+		mutex_lock(&trans->tlock);
+		r5log_do_commit(trans);
+		mutex_unlock(&trans->tlock);
+	}
+
+	r5log_check_and_freeze_current_transaction(journal);
+
+	while (!list_empty(&journal->transaction_list)) {
+		trans = list_first_entry(&journal->transaction_list,
+			struct r5log_transaction, next_trans);
+
+		if (cp_tid + 1 != trans->transaction_id ||
+		       cp_block != trans->log_start) {
+			BUG();
+		}
+
+		if (!enough)
+			r5log_wait_transaction(trans,
+				TRANSACTION_CHECKPOINT_READY);
+		else if (trans->state < TRANSACTION_CHECKPOINT_READY)
+			break;
+		cp_block = trans->log_end;
+		cp_tid = trans->transaction_id;
+
+		freed += r5log_transaction_size(trans);
+		list_del(&trans->next_trans);
+		kfree(trans);
+
+		journal->transaction_cnt--;
+
+		if (freed > blocks)
+			enough = true;
+	}
+	/* Nothing happened */
+	if (journal->checkpoint_transaction_id == cp_tid)
+		return 0;
+
+	r5log_discard_blocks(journal, journal->last_checkpoint, cp_block);
+
+	r5log_flush_all_disks(journal);
+
+	journal->checkpoint_transaction_id = cp_tid;
+	journal->last_checkpoint = cp_block;
+	/* teardown the journal */
+	if (blocks == -1)
+		journal->last_checkpoint = 0;
+	/* FIXME: trim the range for SSD */
+	r5log_write_super(journal);
+	return 0;
+}
+
+void r5log_stripe_write_finished(struct stripe_head *sh)
+{
+	struct r5log_transaction *trans = sh->log_trans;
+
+	sh->log_trans = NULL;
+	r5log_transaction_finish_stripe(trans);
+}
+
+void r5log_flush_transaction(struct r5log_journal *journal)
+{
+	if (journal->aborted)
+		return;
+	r5log_start_commit(journal);
+}
+
+int r5log_handle_flush_request(struct mddev *mddev, struct bio *bio)
+{
+	struct r5conf *conf = mddev->private;
+	struct r5log_journal *journal = conf->journal;
+
+	if (journal->aborted)
+		return -ENODEV;
+
+	/*
+	 * we flush disk cache and then release_stripe. So if a stripe is
+	 * finished, the disk cache is flushed already, so we don't need flush
+	 * again
+	 * */
+	if (bio->bi_iter.bi_size == 0) {
+		bio_endio(bio, 0);
+		return 0;
+	}
+	bio->bi_rw &= ~REQ_FLUSH;
+	return -EAGAIN;
+}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd2f96b..153cb9c 100644
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
@@ -741,6 +741,10 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 	might_sleep();
 
+	if (!sh->log_trans && conf->journal) {
+		if (!r5log_write_stripe(conf->journal, sh))
+			return;
+	}
 	for (i = disks; i--; ) {
 		int rw;
 		int replace_only = 0;
@@ -4111,6 +4115,8 @@ static void handle_stripe(struct stripe_head *sh)
 			md_wakeup_thread(conf->mddev->thread);
 	}
 
+	if (s.return_bi && sh->log_trans)
+		r5log_stripe_write_finished(sh);
 	return_io(s.return_bi);
 
 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
@@ -4650,8 +4656,17 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	bool do_prepare;
 
 	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
-		md_flush_request(mddev, bi);
-		return;
+		int ret = -ENODEV;
+		if (conf->journal) {
+			ret = r5log_handle_flush_request(mddev, bi);
+			if (!ret)
+				return;
+		}
+		if (!conf->journal || ret == -ENODEV) {
+			md_flush_request(mddev, bi);
+			return;
+		}
+		BUG_ON(ret != -EAGAIN);
 	}
 
 	md_write_start(mddev, bi);
@@ -5283,6 +5298,8 @@ static void raid5_do_work(struct work_struct *work)
 	spin_unlock_irq(&conf->device_lock);
 	blk_finish_plug(&plug);
 
+	if (conf->journal)
+		r5log_flush_transaction(conf->journal);
 	pr_debug("--- raid5worker inactive\n");
 }
 
@@ -5354,6 +5371,9 @@ static void raid5d(struct md_thread *thread)
 	async_tx_issue_pending_all();
 	blk_finish_plug(&plug);
 
+	if (conf->journal)
+		r5log_flush_transaction(conf->journal);
+
 	pr_debug("--- raid5d inactive\n");
 }
 
@@ -5740,6 +5760,9 @@ static void raid5_free_percpu(struct r5conf *conf)
 
 static void free_conf(struct r5conf *conf)
 {
+	if (conf->journal)
+		r5log_free_journal(conf->journal);
+
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
@@ -5811,7 +5834,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 {
 	struct r5conf *conf;
 	int raid_disk, memory, max_disks;
-	struct md_rdev *rdev;
+	struct md_rdev *rdev, *spare_rdev = NULL;
 	struct disk_info *disk;
 	char pers_name[6];
 	int i;
@@ -5914,6 +5937,12 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	rdev_for_each(rdev, mddev) {
 		raid_disk = rdev->raid_disk;
+		if (raid_disk < 0) {
+			char b[BDEVNAME_SIZE];
+			spare_rdev = rdev;
+			printk(KERN_INFO "using device %s as log\n",
+				bdevname(rdev->bdev, b));
+		}
 		if (raid_disk >= max_disks
 		    || raid_disk < 0)
 			continue;
@@ -5973,6 +6002,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	}
 
+	if (spare_rdev)
+		conf->journal = r5log_load_journal(spare_rdev);
+
 	return conf;
 
  abort:
@@ -6873,6 +6905,8 @@ static void raid5_quiesce(struct mddev *mddev, int state)
 				    lock_all_device_hash_locks_irq(conf));
 		conf->quiesce = 1;
 		unlock_all_device_hash_locks_irq(conf);
+		if (conf->journal)
+			r5log_flush_journal(conf->journal);
 		/* allow reshape to continue */
 		wake_up(&conf->wait_for_overlap);
 		break;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 983e18a..93cfb5a 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -198,6 +198,7 @@ struct stripe_head {
 	struct hlist_node	hash;
 	struct list_head	lru;	      /* inactive_list or handle_list */
 	struct llist_node	release_list;
+	struct list_head	log_list;
 	struct r5conf		*raid_conf;
 	short			generation;	/* increments with every
 						 * reshape */
@@ -215,6 +216,7 @@ struct stripe_head {
 	spinlock_t		stripe_lock;
 	int			cpu;
 	struct r5worker_group	*group;
+	struct r5log_transaction *log_trans;
 	/**
 	 * struct stripe_operations
 	 * @target - STRIPE_OP_COMPUTE_BLK target
@@ -236,6 +238,7 @@ struct stripe_head {
 		struct bio	*toread, *read, *towrite, *written;
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
+		u32 log_checksum;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
@@ -300,6 +303,7 @@ enum r5dev_flags {
 			 */
 	R5_Discard,	/* Discard the stripe */
 	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
+	R5_Escaped,	/* data is escaped by log */
 };
 
 /*
@@ -495,6 +499,8 @@ struct r5conf {
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
+
+	struct r5log_journal	*journal;
 };
 
 /*
@@ -560,4 +566,14 @@ static inline int algorithm_is_DDF(int layout)
 
 extern void md_raid5_kick_device(struct r5conf *conf);
 extern int raid5_set_cache_size(struct mddev *mddev, int size);
+
+void release_stripe(struct stripe_head *sh);
+
+struct r5log_journal *r5log_load_journal(struct md_rdev *rdev);
+int r5log_flush_journal(struct r5log_journal *journal);
+void r5log_free_journal(struct r5log_journal *journal);
+int r5log_write_stripe(struct r5log_journal *journal, struct stripe_head *sh);
+int r5log_handle_flush_request(struct mddev *mddev, struct bio *bio);
+void r5log_stripe_write_finished(struct stripe_head *sh);
+void r5log_flush_transaction(struct r5log_journal *journal);
 #endif
diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
index 49f4210..84abf0c 100644
--- a/include/uapi/linux/raid/md_p.h
+++ b/include/uapi/linux/raid/md_p.h
@@ -305,4 +305,68 @@ struct mdp_superblock_1 {
 					|MD_FEATURE_RECOVERY_BITMAP	\
 					)
 
+/* all disk position of below struct start from rdev->start_offset */
+struct r5log_meta_header {
+	__le32 magic;
+	__le32 type;
+	__le32 checksum; /* checksum(metadata block + uuid) */
+	__le32 zero_padding;
+	__le64 transaction_id;
+	__le64 position; /* block number the meta is written */
+} __attribute__ ((__packed__));
+
+#define RAID5_LOG_VERSION 0x1
+#define RAID5_LOG_MAGIC 0x28670308
+
+enum {
+	R5LOG_TYPE_META = 0,
+	R5LOG_TYPE_COMMIT = 1,
+	R5LOG_TYPE_SUPER = 2,
+};
+
+struct r5log_super_block {
+	struct r5log_meta_header header;
+	__le32 version;
+	__le32 stripe_size;
+	__le32 block_size;
+	__le64 total_blocks;
+	__le64 first_block;
+	__le64 last_checkpoint;
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
+struct r5log_meta_block_tag {
+	__le32 flags;
+	__le32 disk_index;
+	__le32 checksum; /* checksum(data + uuid + transaction_id) */
+	__le32 zero_padding;
+	__le64 disk_sector; /* raid disk sector */
+} __attribute__ ((__packed__));
+
+enum {
+	R5LOG_TAG_FLAG_ESCAPED = 1 << 0, /* data is escaped */
+	R5LOG_TAG_FLAG_LAST_TAG = 1 << 1, /* last tag in the meta block */
+	R5LOG_TAG_FLAG_DISCARD = 1 << 2, /* a discard request, no data */
+};
+
+struct r5log_meta_block {
+	struct r5log_meta_header header;
+	struct r5log_meta_block_tag tags[];
+} __attribute__ ((__packed__));
+
+struct r5log_commit_block {
+	struct r5log_meta_header header;
+	__le64 commit_sec;
+	__le64 commit_nsec;
+} __attribute__ ((__packed__));
+
 #endif
-- 
1.8.1

