From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/9] raid5: add basic stripe log
Date: Wed, 5 Aug 2015 13:07:36 +1000
Message-ID: <20150805130736.7ba8a6d5@noble>
References: <cover.1438215986.git.shli@fb.com>
	<29c5d697b86094fb7141b23875eb4da6abc6022c.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29c5d697b86094fb7141b23875eb4da6abc6022c.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:43 -0700 Shaohua Li <shli@fb.com> wrote:

> This introduces a simple log for raid5. Data/parity writting to raid
> array first writes to the log, then write to raid array disks. If crash
> happens, we can recovery data from the log. This can speed up raid
> resync and fix write hole issue.
> 
> The log structure is pretty simple. Data/meta data is stored in block
> unit, which is 4k generally. It has only one type of meta data block.
> The meta data block can track 3 types of data, stripe data, stripe
> parity and flush block. MD superblock will point to the last valid meta
> data block. Each meta data block has checksum/seq number, so recovery
> can scan the log correctly. We store a checksum of stripe data/parity to
> the metadata block, so meta data and stripe data/parity can be written
> to log disk together. otherwise, meta data write must wait till stripe
> data/parity is finished.
> 
> For stripe data, meta data block will record stripe data sector and
> size. Currently the size is always 4k. This meta data record can be made
> simpler if we just fix write hole (eg, we can record data of a stripe's
> different disks together), but this format can be extended to support
> caching in the future, which must record data address/size.
> 
> For stripe parity, meta data block will record stripe sector. It's size
> should be 4k (for raid5) or 8k (for raid6). We always store p parity
> first. This format should work for caching too.

It feels a bit odd have a 8K parity block for RAID6 as it is really two
blocks: a parity block and a Q-syndrome block.  What would you think of
introducing another block type for Q?  So there are Data blocks, Parity
blocks, and Q blocks ???

Not a big issue, but I thought I would mention it.

> 
> flush block indicates a stripe is in raid array disks. Fixing write hole
> doesn't need this type of meta data, it's for caching extention.
> 
> We should be careful about deadlock. Appending stripe data/parity to log
> is done in raid5d. The append need log space, which can trigger log
> reclaim, which might wait for raid5d to run (to flush data from log to
> raid array disks). Here we always do the log write in a separate thread.

I'm not convinced about the need for a separate thread.  As
raid5d/handle_stripe works as a state machine, and as all IO is async,
we should at most need an extra state, not an extra thread.

I think a key issue is that you don't call r5l_get_reserve() until you
are about to submit writes to the log.
If instead you reserved the space in r5l_write_stripe and delay the
stripe if space is not available, there there would be no deadlock.
Then when available space crosses some threshold, re-activate those
delayed stripes.


> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/Makefile            |   2 +-
>  drivers/md/raid5-cache.c       | 677 +++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid5.c             |   8 +-
>  drivers/md/raid5.h             |  10 +
>  include/uapi/linux/raid/md_p.h |  48 +++
>  5 files changed, 741 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/md/raid5-cache.c
> 
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 462f443..f34979c 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -17,7 +17,7 @@ dm-cache-smq-y   += dm-cache-policy-smq.o
>  dm-cache-cleaner-y += dm-cache-policy-cleaner.o
>  dm-era-y	+= dm-era-target.o
>  md-mod-y	+= md.o bitmap.o
> -raid456-y	+= raid5.o
> +raid456-y	+= raid5.o raid5-cache.o
>  
>  # Note: link order is important.  All raid personalities
>  # and must come before md.o, as they each initialise 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> new file mode 100644
> index 0000000..5c9bab6
> --- /dev/null
> +++ b/drivers/md/raid5-cache.c
> @@ -0,0 +1,677 @@
> +/*
> + * Copyright (C) 2015 Shaohua Li <shli@fb.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +#include <linux/kernel.h>
> +#include <linux/wait.h>
> +#include <linux/blkdev.h>
> +#include <linux/slab.h>
> +#include <linux/raid/md_p.h>
> +#include <linux/crc32.h>
> +#include <linux/random.h>
> +#include "md.h"
> +#include "raid5.h"
> +
> +typedef u64 r5blk_t; /* log blocks, 512B - 4k */

I would much rather use sector_t throughout and keep all addresses as
sector addresses.  Much less room for confusion that way.

If we wanted to pack lots of addresses into limited space then using
block addresses might be justified (filesystems do that), but I don't
think it is called for here at all.

> +
> +struct r5l_log {
> +	struct mddev *mddev;
> +	struct md_rdev *rdev;

As the rdev contains a pointer to the mddev, storing the mddev as well
isn't strictly necessary - though it doesn't really hurt.
You don't seem to use it very much....


> +
> +	u32 uuid_checksum;
> +
> +	unsigned int block_size; /* bytes */
> +	unsigned int block_sector_shift;
> +	unsigned int page_block_shift; /* page to block */

These last two probably aren't needed if everything is in sectors.


> +
> +	r5blk_t total_blocks;
> +	r5blk_t first_block;
> +	r5blk_t last_block;
> +
> +	r5blk_t last_checkpoint; /* log tail */
> +	u64 last_cp_seq; /* log tail sequence */
> +
> +	u64 seq; /* current sequence */
> +	r5blk_t log_start; /* current log position */

How is this different from first_block?  Or maybe it is last_block.
It is good that you have some comments here, but a few more wouldn't
hurt.
Also it sometimes helps to say how something is used as well as what
it is.
e.g. is the "current sequence" number the sequence number of the last
metadata block written, or of the next metadata block to be written?


> +
> +	r5blk_t reserved_blocks;
> +	wait_queue_head_t space_waitq;
> +
> +	struct mutex io_mutex;
> +	struct r5l_io_unit *current_io;
> +
> +	spinlock_t io_list_lock;
> +	struct list_head running_ios; /* running io_unit list */

A few more words to make it clear what "running" means would be good.
An io_unit becomes "running" when .... and ceases to be "running"
when .......

> +
> +	struct kmem_cache *io_kc;
> +
> +	struct md_thread *log_thread;
> +	struct list_head log_stripes;
> +	spinlock_t log_stripes_lock;
> +};
> +
> +/*
> + * an IO range starts from a meta data block and end at the next meta data
> + * block. The io unit's the meta data block tracks data/parity followed it. io
> + * unit is written to log disk with normal write, as we always flush log disk
> + * first and then start move data to raid disks, there is no requirement to
> + * write io unit with FLUSH/FUA
> + * */
> +struct r5l_io_unit {
> +	struct r5l_log *log;
> +
> +	struct page *meta_page; /* store meta block */
> +	int meta_offset; /* current offset in meta_page */
> +
> +	struct bio_list bios;
> +	struct bio *current_bio; /* current_bio accepting pages */
> +	atomic_t pending_io; /* pending bios not writting to log */

"now writing" ??  (I often type 'now' and 'not' :-)

Actually it is often "1 more than the number of bios queued but which
have not yet completed".
In this case there is no need for that "one more than" as we first
queue all the bios, then we submit them.
You only need the "one more than" thing if you might keep incrementing
the counter after you start submitting bios.


> +
> +	atomic_t pending_stripe; /* how many stripes not flushed to raid */
> +	u64 seq;
> +	r5blk_t log_start; /* where the io_unit starts */
> +	r5blk_t log_end; /* where the io_unit ends */
> +	struct list_head log_sibling; /* log->running_ios */
> +	struct list_head stripe_list; /* stripes added to the io_unit */
> +	int state;
> +	wait_queue_head_t wait_state;
> +};
> +
> +/* r5l_io_unit state */
> +enum {
> +	IO_UNIT_RUNNING = 0, /* accepting new IO */
> +	IO_UNIT_IO_START = 1, /* io_unit is writting to log */
> +	IO_UNIT_IO_END = 2, /* io_unit is in log */
> +	IO_UNIT_STRIPE_START = 3, /* stripes of io_unit are running */
> +	IO_UNIT_STRIPE_END = 4, /* stripes data are in raid disks */
> +};

0, 1, and 3 tell me what is currently happening to the stripe.
4 tells me that nothing is happening any more.
What does '2' tell me exactly?  What is happening when state is 2?
Is that state needed?


> +
> +#define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
> +
> +static inline struct block_device *r5l_bdev(struct r5l_log *log)
> +{
> +	return log->rdev->bdev;
> +}
> +
> +static inline sector_t r5l_block_to_sector(struct r5l_log *log, r5blk_t block)
> +{
> +	return block << log->block_sector_shift;
> +}
> +
> +static inline r5blk_t r5l_sector_to_block(struct r5l_log *log, sector_t s)
> +{
> +	return s >> log->block_sector_shift;
> +}
> +
> +static inline int r5l_page_blocks(struct r5l_log *log, int pages)
> +{
> +	return pages << log->page_block_shift;
> +}
> +
> +static u32 r5l_calculate_checksum(struct r5l_log *log, u32 crc,
> +	void *buf, size_t size)
> +{
> +	return crc32_le(crc, buf, size);
> +}
> +

Tiny little inlines and defines like this worry me.
Do they really add useful abstractions, or do they just hide important
detail?
Putting this sort of thing in a header file and making it part of an
interface is quite different from putting them in a .c file and making
the code harder to read (because I keep having to check exactly what
the function does).

If r5l_calculate_checksum copied out the old checksum, stored a zero
there, performed the calculation, then put the old checksum back, then
that might be a useful separate function.  But as it is there seems no
point.

PAGE_SECTOR_SHIFT is more typing than PAGE_SHIFT - 9 and isn't any more
clear.  And you only use it once where I'm not at all sure that you
should.


> +static r5blk_t r5l_ring_add(struct r5l_log *log, r5blk_t block, int inc)
> +{
> +	block += inc;
> +	if (block >= log->last_block)
> +		block = block - log->total_blocks;
> +	return block;
> +}
> +
> +static void r5l_wake_reclaim(struct r5l_log *log, r5blk_t space);
> +static r5blk_t r5l_free_space(struct r5l_log *log)
> +{
> +	r5blk_t used_size;
> +
> +	if (log->log_start >= log->last_checkpoint)
> +		used_size = log->log_start - log->last_checkpoint;
> +	else
> +		used_size = log->log_start + log->total_blocks -
> +			log->last_checkpoint;
> +
> +	if (log->total_blocks > used_size + log->reserved_blocks)
> +		return log->total_blocks - used_size - log->reserved_blocks;
> +	return 0;

Maybe I'm getting confused by terminology, but this looks wrong.
I would think that "last_checkpoint" was something written fairly
recently, and "log_start" was something written a long time ago.
So if the log hasn't wrapped, then the "used_size" would be
   last_checkpoint - log_start
while it if had wrapped, it would be

   last_checkpoint + total_blocks - log_start

???


> +}
> +
> +/* Make sure we have enough free space in log device */
> +static void r5l_get_reserve(struct r5l_log *log, unsigned int size)
> +{
> +	r5blk_t free;
> +
> +	BUG_ON(!mutex_is_locked(&log->io_mutex));
> +	free = r5l_free_space(log);
> +	if (free >= size) {
> +		log->reserved_blocks += size;
> +		return;
> +	}
> +
> +	log->reserved_blocks += size;
> +	mutex_unlock(&log->io_mutex);
> +
> +	r5l_wake_reclaim(log, size);
> +
> +	mutex_lock(&log->io_mutex);
> +	wait_event_cmd(log->space_waitq, r5l_free_space(log) > 0,
> +		mutex_unlock(&log->io_mutex), mutex_lock(&log->io_mutex));
> +}

As I've already said I don't think that blocking when out of space is a
good idea, but couldn't this be much simpler?

 log->reserved_blocks += size;
 wait_event_cmd(log->space_waitq, r5l_free_space(log) > 0,
                mutex_unlock(&log->io_mutex); 
                   r5l_wake_reclaim(log, size),
                mutex_lock(&log->io_mutex));

??

> +
> +static void r5l_put_reserve(struct r5l_log *log, unsigned int reserved_blocks)
> +{
> +	BUG_ON(!mutex_is_locked(&log->io_mutex));
> +
> +	log->reserved_blocks -= reserved_blocks;
> +	if (r5l_free_space(log) > 0)
> +		wake_up(&log->space_waitq);
> +}
> +
> +static struct r5l_io_unit *r5l_alloc_io_unit(struct r5l_log *log)
> +{
> +	struct r5l_io_unit *io;
> +	gfp_t gfp = GFP_NOIO | __GFP_NOFAIL;
> +
> +	io = kmem_cache_zalloc(log->io_kc, gfp);
> +	if (!io)
> +		return NULL;
> +	io->log = log;
> +	io->meta_page = alloc_page(gfp | __GFP_ZERO);
> +	if (!io->meta_page) {
> +		kmem_cache_free(log->io_kc, io);
> +		return NULL;
> +	}

This can return NULL, but the one place where you call it you do not
check for NULL.
Maybe a mempool would be appropriate, maybe something else - I haven't
examine the issue closely.


> +
> +	bio_list_init(&io->bios);
> +	atomic_set(&io->pending_io, 1);
> +	INIT_LIST_HEAD(&io->log_sibling);
> +	INIT_LIST_HEAD(&io->stripe_list);
> +	io->state = IO_UNIT_RUNNING;
> +	init_waitqueue_head(&io->wait_state);
> +	return io;
> +}
> +
> +static void r5l_free_io_unit(struct r5l_log *log, struct r5l_io_unit *io)
> +{
> +	__free_page(io->meta_page);
> +	kmem_cache_free(log->io_kc, io);
> +}
> +
> +static void r5l_wait_io_unit_state(struct r5l_io_unit *io, int state)
> +{
> +	wait_event(io->wait_state, io->state >= state);
> +}

This is another of those tiny inlines which I think just make the code
harder to read.


> +
> +static void r5l_set_io_unit_state(struct r5l_io_unit *io, int state)
> +{
> +	if (io->state >= state)
> +		return;

Should this ever actually 'return'?
    if (WARN_ON(..)) return; ???
Not sure - I haven't examined closely.


> +	io->state = state;
> +	wake_up(&io->wait_state);
> +}
> +
> +static void r5l_submit_bio(struct r5l_log *log, int rw, struct bio *bio)
> +{
> +	/* all IO must start from rdev->data_offset */
> +	bio->bi_iter.bi_sector += log->rdev->data_offset;
> +	submit_bio(rw, bio);
> +}

This might almost be worthy of its own function if it was called more
than once.  But as it is...


> +
> +static void r5l_io_unit_ioend(struct r5l_io_unit *io, int error)
> +{
> +	struct r5l_log *log = io->log;
> +	if (!atomic_dec_and_test(&io->pending_io))
> +		return;
> +
> +	r5l_set_io_unit_state(io, IO_UNIT_IO_END);
> +	md_wakeup_thread(log->mddev->thread);
> +}
> +
> +static void r5l_log_endio(struct bio *bio, int error)
> +{
> +	struct r5l_io_unit *io = bio->bi_private;
> +
> +	bio_put(bio);
> +	r5l_io_unit_ioend(io, error);
> +}
> +
> +static void r5l_submit_io(struct r5l_log *log, struct r5l_io_unit *io)
> +{
> +	struct bio *bio;
> +	while ((bio = bio_list_pop(&io->bios)))
> +		r5l_submit_bio(log, WRITE, bio);
> +
> +	r5l_io_unit_ioend(io, 0);
> +}
> +
> +static void r5l_submit_current_io(struct r5l_log *log)
> +{
> +	struct r5l_io_unit *io = log->current_io;
> +	struct r5l_meta_block *block;
> +	u32 crc;
> +
> +	if (!io)
> +		return;
> +
> +	block = page_address(io->meta_page);
> +	block->meta_size = cpu_to_le32(io->meta_offset);
> +	crc = r5l_calculate_checksum(log, log->uuid_checksum,
> +		block, log->block_size);
> +	block->checksum = cpu_to_le32(crc);
> +
> +	log->current_io = NULL;
> +	r5l_set_io_unit_state(io, IO_UNIT_IO_START);
> +
> +	r5l_submit_io(log, io);
> +}
> +
> +static struct r5l_io_unit *r5l_new_meta(struct r5l_log *log)
> +{
> +	struct r5l_io_unit *io;
> +	struct r5l_meta_block *block;
> +	struct bio *bio;
> +
> +	io = r5l_alloc_io_unit(log);
> +
> +	block = page_address(io->meta_page);
> +	block->magic = cpu_to_le32(R5LOG_MAGIC);
> +	block->version = R5LOG_VERSION;
> +	block->block_size = cpu_to_le16(log->block_size);
> +	block->seq = cpu_to_le64(log->seq);
> +	block->position = cpu_to_le64(log->log_start);
> +
> +	io->log_start = log->log_start;
> +	io->meta_offset = sizeof(struct r5l_meta_block);
> +	io->seq = log->seq;
> +
> +	bio = bio_alloc(GFP_NOIO | __GFP_NOFAIL,
> +		bio_get_nr_vecs(r5l_bdev(log)));

bio_alloc uses a mempool so __GFP_NOFAIL is not relevant.
Maybe this should use the mddev's mempool?

> +	io->current_bio = bio;
> +	bio->bi_rw = WRITE;
> +	bio->bi_bdev = r5l_bdev(log);
> +	bio->bi_iter.bi_sector = r5l_block_to_sector(log, log->log_start);
> +	bio_add_page(bio, io->meta_page, log->block_size, 0);
> +	bio->bi_end_io = r5l_log_endio;
> +	bio->bi_private = io;
> +
> +	bio_list_add(&io->bios, bio);
> +	atomic_inc(&io->pending_io);
> +
> +	log->seq++;
> +	log->log_start = r5l_ring_add(log, log->log_start, 1);
> +	io->log_end = log->log_start;
> +	/* current bio hit disk end */
> +	if (log->log_start == log->first_block)
> +		io->current_bio = NULL;
> +
> +	spin_lock(&log->io_list_lock);
> +	list_add_tail(&io->log_sibling, &log->running_ios);
> +	spin_unlock(&log->io_list_lock);
> +
> +	return io;
> +}
> +
> +static int r5l_get_meta(struct r5l_log *log, unsigned int payload_size)
> +{
> +	struct r5l_io_unit *io;
> +
> +	io = log->current_io;
> +	if (io && io->meta_offset + payload_size > log->block_size)
> +		r5l_submit_current_io(log);
> +	io = log->current_io;
> +	if (io)
> +		return 0;
> +
> +	log->current_io = r5l_new_meta(log);
> +	return 0;
> +}
> +
> +static void r5l_log_pages(struct r5l_log *log, u16 type, sector_t location,
> +	struct page *page1, u32 checksum1,
> +	struct page *page2, u32 checksum2)
> +{
> +	struct r5l_io_unit *io = log->current_io;
> +	struct r5l_payload_data_parity *payload;
> +
> +	payload = page_address(io->meta_page) + io->meta_offset;
> +	payload->header.type = cpu_to_le16(type);
> +	payload->header.flags = cpu_to_le16(0);
> +	payload->blocks = cpu_to_le32(r5l_page_blocks(log, 1 + !!page2));
> +	payload->location = cpu_to_le64(location);
> +	payload->checksum[0] = cpu_to_le32(checksum1);
> +	if (page2)
> +		payload->checksum[1] = cpu_to_le32(checksum2);
> +
> +alloc_bio:
> +	if (!io->current_bio) {
> +		struct bio *bio;
> +		bio = bio_alloc(GFP_NOIO | __GFP_NOFAIL,
> +			bio_get_nr_vecs(r5l_bdev(log)));

ditto - __GFP_NOFAIL not appropriate.


> +		bio->bi_rw = WRITE;
> +		bio->bi_bdev = r5l_bdev(log);
> +		bio->bi_iter.bi_sector = r5l_block_to_sector(log, log->log_start);
> +		bio->bi_end_io = r5l_log_endio;
> +		bio->bi_private = io;
> +		bio_list_add(&io->bios, bio);
> +		atomic_inc(&io->pending_io);
> +		io->current_bio = bio;
> +	}
> +	if (page1) {
> +		if (!bio_add_page(io->current_bio, page1, PAGE_SIZE, 0)) {
> +			io->current_bio = NULL;
> +			goto alloc_bio;
> +		}
> +		log->log_start = r5l_ring_add(log, log->log_start,
> +			r5l_page_blocks(log, 1));
> +		/* current bio hit disk end */
> +		if (log->log_start == log->first_block)
> +			io->current_bio = NULL;
> +	}
> +
> +	page1 = NULL;
> +	if (page2) {
> +		if (io->current_bio == NULL)
> +			goto alloc_bio;
> +		if (!bio_add_page(io->current_bio, page2, PAGE_SIZE, 0)) {
> +			io->current_bio = NULL;
> +			goto alloc_bio;
> +		}
> +		log->log_start = r5l_ring_add(log, log->log_start,
> +			r5l_page_blocks(log, 1));
> +		/* current bio hit disk end */
> +		if (log->log_start == log->first_block)
> +			io->current_bio = NULL;
> +	}
> +
> +	io->meta_offset += sizeof(struct r5l_payload_data_parity) +
> +		sizeof(__le32) * (1 + !!page2);
> +	io->log_end = log->log_start;
> +}

Allowing either 1 or 2 pages to be passed to this function makes it
more complex than I would like.
It would be much nicer if you could just call r5l_log_pages() twice for
the P and Q blocks.


> +
> +static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh)
> +{
> +	int i;
> +	int meta_size;
> +	int write_disks = 0;
> +	int data_pages, parity_pages;
> +	struct r5l_io_unit *io;
> +	int reserve;
> +
> +	for (i = 0; i < sh->disks; i++) {
> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
> +			continue;
> +		write_disks++;
> +	}
> +	parity_pages = 1 + !!(sh->qd_idx >= 0);
> +	data_pages = write_disks - parity_pages;
> +
> +	meta_size = (sizeof(struct r5l_payload_data_parity) + sizeof(__le32)) *
> +		data_pages + sizeof(struct r5l_payload_data_parity) +
> +		sizeof(__le32) * parity_pages;

In quite a lot of places your indentation is not correct.
When you have any sort of bracket/brace/parenthesis, and
the opening bracket is not at the end of the line, then everything
within the brackets must be immediately to the right of the opening
bracket.

I'm happy to fix most of this up when I ultimately accept that patch
(emacs makes it easy).  However this line is just wrong.  A line break
must be at a low-precedence point in the line.  So e.g. break after '+'
rather than after '*' etc.
This should be more like:

meta_size = (sizeof(struct r5l_payload_data_parity) + sizeof(__le32))
	     * data_pages +
	     sizeof(struct r5l_payload_data_parity) +
	     sizeof(__le32) * parity_pages;

which suddenly I can actually read and understand....
Of course if you didn't combine the two P+Q blocks as suggested
earlier, this would become even simpler.


> +
> +	/* meta + data */
> +	reserve = 1 + r5l_page_blocks(log, write_disks);
> +	r5l_get_reserve(log, reserve);
> +
> +	r5l_get_meta(log, meta_size);
> +	io = log->current_io;
> +
> +	for (i = 0; i < sh->disks; i++) {
> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
> +			continue;
> +		if (i == sh->pd_idx || i == sh->qd_idx)
> +			continue;
> +		r5l_log_pages(log, R5LOG_PAYLOAD_DATA,
> +			compute_blocknr(sh, i, 0),
> +			sh->dev[i].page, sh->dev[i].log_checksum,
> +			NULL, 0);
> +	}
> +	r5l_log_pages(log, R5LOG_PAYLOAD_PARITY,
> +		sh->sector, sh->dev[sh->pd_idx].page,
> +		sh->dev[sh->pd_idx].log_checksum,
> +		sh->qd_idx >= 0 ? sh->dev[sh->qd_idx].page : NULL,
> +		sh->qd_idx >= 0 ? sh->dev[sh->qd_idx].log_checksum : 0);
> +
> +	list_add_tail(&sh->log_list, &io->stripe_list);
> +	atomic_inc(&io->pending_stripe);
> +	sh->log_io = io;
> +
> +	r5l_put_reserve(log, reserve);
> +}
> +
> +static void r5l_log_thread(struct md_thread *thread)
> +{
> +	struct mddev *mddev = thread->mddev;
> +	struct r5conf *conf = mddev->private;
> +	struct r5l_log *log = conf->log;
> +	struct stripe_head *sh;
> +	LIST_HEAD(list);
> +	struct blk_plug plug;
> +
> +	if (!log)
> +		return;
> +
> +	spin_lock(&log->log_stripes_lock);
> +	list_splice_init(&log->log_stripes, &list);
> +	spin_unlock(&log->log_stripes_lock);
> +
> +	if (list_empty(&list))
> +		return;
> +	mutex_lock(&log->io_mutex);
> +	blk_start_plug(&plug);
> +	while (!list_empty(&list)) {
> +		sh = list_first_entry(&list, struct stripe_head, log_list);
> +		list_del_init(&sh->log_list);
> +		r5l_log_stripe(log, sh);
> +	}
> +	r5l_submit_current_io(log);
> +	blk_finish_plug(&plug);
> +	mutex_unlock(&log->io_mutex);
> +}
> +
> +/*
> + * running in raid5d, where reclaim could wait for raid5d too (when it flushes
> + * data from log to raid disks), so we shouldn't wait for reclaim here
> + * */
> +int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
> +{
> +	int write_disks = 0;
> +	int data_pages, parity_pages;
> +	int meta_size;
> +	int i;
> +
> +	if (!log)
> +		return -EAGAIN;
> +	/* Don't support stripe batch */
> +	if (sh->log_io ||!test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags) ||
> +	    test_bit(STRIPE_SYNCING, &sh->state))
> +		return -EAGAIN;
> +
> +	for (i = 0; i < sh->disks; i++) {
> +		void *addr;
> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
> +			continue;
> +		write_disks++;
> +		addr = kmap_atomic(sh->dev[i].page);
> +		sh->dev[i].log_checksum = r5l_calculate_checksum(log,
> +			log->uuid_checksum, addr, PAGE_SIZE);
> +		kunmap_atomic(addr);
> +	}
> +	parity_pages = 1 + !!(sh->qd_idx >= 0);
> +	data_pages = write_disks - parity_pages;
> +
> +	meta_size = (sizeof(struct r5l_payload_data_parity) + sizeof(__le32)) *
> +		data_pages + sizeof(struct r5l_payload_data_parity) +
> +		sizeof(__le32) * parity_pages;
> +	/* Doesn't work with very big raid array */
> +	if (meta_size + sizeof(struct r5l_meta_block) >
> +			log->block_size)
> +		return -EINVAL;
> +
> +	atomic_inc(&sh->count);
> +
> +	spin_lock(&log->log_stripes_lock);
> +	list_add_tail(&sh->log_list, &log->log_stripes);
> +	spin_unlock(&log->log_stripes_lock);
> +	return 0;
> +}
> +
> +void r5l_write_stripe_run(struct r5l_log *log)
> +{
> +	if (!log)
> +		return;
> +	md_wakeup_thread(log->log_thread);
> +}

if (log)
   md_wakeup_thread(log->log_thread);
??
Does it need a separate function?

> +
> +static void r5l_wake_reclaim(struct r5l_log *log, r5blk_t space)
> +{
> +}
> +

A comment that this will be fleshed out it subsequent patch wouldn't
hurt, but isn't entirely necessary.


> +static int r5l_recovery_log(struct r5l_log *log)
> +{
> +	/* fake recovery */
> +	log->seq = log->last_cp_seq + 1;
> +	log->log_start = r5l_ring_add(log, log->last_checkpoint, 1);
> +	return 0;
> +}
> +
> +static void r5l_write_super(struct r5l_log *log, sector_t cp)
> +{
> +	log->rdev->recovery_offset = cp;
> +	md_update_sb(log->mddev, 1);
> +}

This is only called from run() when the log is first initialised.  At
this point there is nothing useful in the log, so recording it's
location is pointless.  At most you  could set the MD_SB_DIRTY flag (or
whatever it is).
So it really doesn't need to be a separate function.



> +
> +static int r5l_load_log(struct r5l_log *log)
> +{
> +	struct md_rdev *rdev = log->rdev;
> +	struct page *page;
> +	struct r5l_meta_block *mb;
> +	sector_t cp = log->rdev->recovery_offset;
> +	u32 stored_crc, expected_crc;
> +	bool create_super = false;
> +	int ret;
> +
> +	/* Make sure it's valid */
> +	if (cp >= rdev->sectors)
> +		cp = 0;
> +	page = alloc_page(GFP_KERNEL);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	if (!sync_page_io(rdev, cp, PAGE_SIZE, page, READ, false)) {
> +		ret = -EIO;
> +		goto ioerr;
> +	}
> +	mb = page_address(page);
> +
> +	if (le32_to_cpu(mb->magic) != R5LOG_MAGIC ||
> +		mb->version != R5LOG_VERSION ||
> +		le16_to_cpu(mb->block_size) > PAGE_SIZE) {
> +		create_super = true;
> +		goto create;
> +	}
> +	stored_crc = le32_to_cpu(mb->checksum);
> +	mb->checksum = 0;
> +	expected_crc = r5l_calculate_checksum(log, log->uuid_checksum,
> +		mb, le16_to_cpu(mb->block_size));
> +	if (stored_crc != expected_crc) {
> +		create_super = true;
> +		goto create;
> +	}
> +	if (le64_to_cpu(mb->position) * (le16_to_cpu(mb->block_size) >> 9) !=
> +		cp) {
> +		create_super = true;
> +		goto create;
> +	}
> +create:
> +	if (create_super) {
> +		log->block_size = PAGE_SIZE;
> +		log->last_cp_seq = prandom_u32();
> +		cp = (cp >> PAGE_SECTOR_SHIFT) << PAGE_SECTOR_SHIFT;

This isn't the way we normally round down - we have the "round_down()"
macro for that.

But if you are creating a new log, why not just set 'cp' to zero??


> +		/* Make sure super points to correct address */
> +		r5l_write_super(log, cp);
> +	} else {
> +		log->block_size = le16_to_cpu(mb->block_size);
> +		log->last_cp_seq = le64_to_cpu(mb->seq);
> +	}
> +	log->block_sector_shift = ilog2(log->block_size >> 9);
> +	log->page_block_shift = PAGE_SHIFT - ilog2(log->block_size);
> +
> +	log->first_block = 0;
> +	log->total_blocks = r5l_sector_to_block(log, rdev->sectors);
> +	log->last_block = log->first_block + log->total_blocks;
> +	log->last_checkpoint = r5l_sector_to_block(log, cp);
> +
> +	__free_page(page);
> +
> +	return r5l_recovery_log(log);
> +ioerr:
> +	__free_page(page);
> +	return ret;
> +}
> +
> +int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
> +{
> +	struct r5l_log *log;
> +
> +	log = kzalloc(sizeof(*log), GFP_KERNEL);
> +	if (!log)
> +		return -ENOMEM;
> +	log->mddev = rdev->mddev;
> +	log->rdev = rdev;
> +
> +	log->uuid_checksum = r5l_calculate_checksum(log, ~0, rdev->mddev->uuid,
> +		sizeof(rdev->mddev->uuid));
> +
> +	init_waitqueue_head(&log->space_waitq);
> +	mutex_init(&log->io_mutex);
> +
> +	spin_lock_init(&log->io_list_lock);
> +	INIT_LIST_HEAD(&log->running_ios);
> +
> +	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
> +	if (!log->io_kc)
> +		goto io_kc;
> +
> +	INIT_LIST_HEAD(&log->log_stripes);
> +	spin_lock_init(&log->log_stripes_lock);
> +	log->log_thread = md_register_thread(r5l_log_thread,
> +		log->mddev, "log");
> +	if (!log->log_thread)
> +		goto log_thread;
> +
> +	if (r5l_load_log(log))
> +		goto error;
> +
> +	conf->log = log;
> +	return 0;
> +error:
> +	md_unregister_thread(&log->log_thread);
> +log_thread:
> +	kmem_cache_destroy(log->io_kc);
> +io_kc:
> +	kfree(log);
> +	return -EINVAL;
> +}
> +
> +void r5l_exit_log(struct r5l_log *log)
> +{
> +	md_unregister_thread(&log->log_thread);
> +
> +	kmem_cache_destroy(log->io_kc);
> +	kfree(log);
> +}
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 59e44e9..9608a44 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -899,6 +899,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
>  
>  	might_sleep();
>  
> +	if (!r5l_write_stripe(conf->log, sh))
> +		return;

If no log is configured, r5l_write_stripe will return -EAGAIN, and so
ops_run_io will never submit any IO....



>  	for (i = disks; i--; ) {
>  		int rw;
>  		int replace_only = 0;
> @@ -2478,8 +2480,6 @@ static void raid5_end_write_request(struct bio *bi, int error)
>  		release_stripe(sh->batch_head);
>  }
>  
> -static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);
> -
>  static void raid5_build_block(struct stripe_head *sh, int i, int previous)
>  {
>  	struct r5dev *dev = &sh->dev[i];
> @@ -2729,7 +2729,7 @@ static sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
>  	return new_sector;
>  }
>  
> -static sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
> +sector_t compute_blocknr(struct stripe_head *sh, int i, int previous)
>  {
>  	struct r5conf *conf = sh->raid_conf;
>  	int raid_disks = sh->disks;
> @@ -3498,6 +3498,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>  			WARN_ON(test_bit(R5_SkipCopy, &dev->flags));
>  			WARN_ON(dev->page != dev->orig_page);
>  		}
> +
>  	if (!discard_pending &&
>  	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
>  		clear_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> @@ -5746,6 +5747,7 @@ static int handle_active_stripes(struct r5conf *conf, int group,
>  
>  	for (i = 0; i < batch_size; i++)
>  		handle_stripe(batch[i]);
> +	r5l_write_stripe_run(conf->log);
>  
>  	cond_resched();
>  
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 02c3bf8..a8daf39 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -223,6 +223,9 @@ struct stripe_head {
>  	struct stripe_head	*batch_head; /* protected by stripe lock */
>  	spinlock_t		batch_lock; /* only header's lock is useful */
>  	struct list_head	batch_list; /* protected by head's batch lock*/
> +
> +	struct r5l_io_unit	*log_io;
> +	struct list_head	log_list;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target

I wonder if we really need yet another 'list_head' in 'stripe_head'.
I guess one more is no great cost.



> @@ -244,6 +247,7 @@ struct stripe_head {
>  		struct bio	*toread, *read, *towrite, *written;
>  		sector_t	sector;			/* sector of this page */
>  		unsigned long	flags;
> +		u32		log_checksum;
>  	} dev[1]; /* allocated with extra space depending of RAID geometry */
>  };
>  
> @@ -539,6 +543,7 @@ struct r5conf {
>  	struct r5worker_group	*worker_groups;
>  	int			group_cnt;
>  	int			worker_cnt_per_group;
> +	struct r5l_log		*log;
>  };
>  
>  
> @@ -605,4 +610,9 @@ static inline int algorithm_is_DDF(int layout)
>  
>  extern void md_raid5_kick_device(struct r5conf *conf);
>  extern int raid5_set_cache_size(struct mddev *mddev, int size);
> +extern sector_t compute_blocknr(struct stripe_head *sh, int i, int previous);

When making static functions extern, you need to make sure the module
name is mentioned somehow.  So raid5_compute_blocknr, or r5_.. or
md_... 

> +extern int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev);
> +extern void r5l_exit_log(struct r5l_log *log);
> +extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
> +extern void r5l_write_stripe_run(struct r5l_log *log);
>  #endif
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index 8c8e12c..418b1ba 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -315,4 +315,52 @@ struct mdp_superblock_1 {
>  					|MD_FEATURE_WRITE_CACHE		\
>  					)
>  
> +struct r5l_payload_header {
> +	__le16 type;
> +	__le16 flags;
> +} __attribute__ ((__packed__));
> +
> +enum {
> +	R5LOG_PAYLOAD_DATA = 0,
> +	R5LOG_PAYLOAD_PARITY = 1,
> +	R5LOG_PAYLOAD_FLUSH = 2,
> +};

I would really like it if this was 
   enum r5l_payload_type {

so I knew immediately where the numbers would appear.
Then have the two different 'flags' enums immediately afterwards also
with useful names.


> +
> +struct r5l_payload_data_parity {
> +	struct r5l_payload_header header;
> +	__le32 blocks; /* block. data/parity size. each 4k has a checksum */
> +	__le64 location; /* sector. For data, it's raid sector. For
> +				parity, it's stripe sector */
> +	__le32 checksum[];
> +} __attribute__ ((__packed__));
> +
> +enum {
> +	R5LOG_PAYLOAD_FLAG_DISCARD = 1,
> +};
> +
> +struct r5l_payload_flush {
> +	struct r5l_payload_header header;
> +	__le32 size; /* flush_stripes size, bytes */
> +	__le64 flush_stripes[];
> +} __attribute__ ((__packed__));
> +
> +enum {
> +	R5LOG_PAYLOAD_FLAG_FLUSH_STRIPE = 1, /* data represents whole stripe */
> +};
> +
> +struct r5l_meta_block {
> +	__le32 magic;
> +	__le32 checksum;
> +	__u8 version;
> +	__u8 __zero_pading;
> +	__le16 block_size; /* 512B - 4k */
> +	__le32 meta_size; /* whole size of the block */
> +
> +	__le64 seq;
> +	__le64 position; /* block, start from rdev->data_offset, current position */
> +	struct r5l_payload_header payloads[];
> +} __attribute__ ((__packed__));
> +
> +#define R5LOG_VERSION 0x1
> +#define R5LOG_MAGIC 0x6433c509
>  #endif

Thanks,
NeilBrown
