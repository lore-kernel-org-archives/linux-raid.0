From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH v3 3/8] raid5: A caching layer for RAID5/6
Date: Wed, 17 Jun 2015 22:24:19 -0700
Message-ID: <20150618052417.GA3639038@devbig257.prn2.facebook.com>
References: <cover.1433356864.git.shli@fb.com>
 <c6df8779f11a4dc3362a04e7cee0be2aec213ebe.1433356864.git.shli@fb.com>
 <20150618110036.0486645c@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618110036.0486645c@home.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, Jun 18, 2015 at 11:00:36AM +1000, Neil Brown wrote:
> On Wed, 3 Jun 2015 15:48:38 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> Hi,
>  sorry for the delay in getting to this.
> 
> 3000 lines of code is rather hard to review - especially with so few
> comments :-)
> There seem to be a number of fairly well defined modules in the code,
> such as managing the various data structures.  Maybe if these arrived
> one per patch it would be easier  to review them individually.

ok, I'll try to split this one.
 
> > Main goal of the caching layer is to aggregate IO write to hopefully
> > make full stripe IO write and fix write hole issue. This might speed up
> > read too, but it's not optimized for read, eg, we don't proactively
> > cache data for read. The aggregation makes a lot of sense for workloads
> > which sequentially write to several files with/without fsync. Such
> > workloads are popular in today's datacenter.
> > 
> > Write IO data will write to a cache disk (SSD) first, then later the
> > data will be flushed to raid disks.
> > 
> > The cache disk will be organized as a simple ring buffer log. For IO
> > data, a tuple (raid_sector, io length, checksum, data) will be appended
> > to the log; for raid 5/6 parity, a tuple (stripe_sector, parity length,
> > checksum, parity data) will be appended to the log. We don't have
> > on-disk index for the data appended to the log. So either we can rebuild
> > an in-memory index at startup with scanning the whole log, or we can
> > flush all data from cache disk to raid disks at shutdown so cache disk
> > has no valid data. Current code chooses the second option, but this can
> > be easily changed.
> > 
> > We have a simple meta data for above tuples. It's essentially a
> > tuple (sequence, metadata length).
> 
> How are these tuples store in the log?  One tuples per block?  A block
> with lots of tuples followed by all the described data?  Or does the
> block of tuples follow the data?

one or several tuples per block. I'll give more details in later post. 
> >                                    Crash recovery or startup will scan
> > the log to read the metadata and rebuild in-memory index. If metadata is
> > broken at the head of the log, even metadata afterward is ok, the
> > scanning will not work well. So we take some steps to mitigate the
> > issue:
> > -A flush request is sent to cache disk every second to relieve the issue
> 
> I don't feel at all comfortable about the every-second flush.
> I can certainly understand a flush after 50% of the log space is
> written, or even 25%.  but time-based flushes should be coming from the
> filesystem.

Do you like to delete the every-second flush logic? The reclaim will do
flush too, so this is barely running, just for the worst case.

> > -FLUSH/FUA request is carefully handled. FLUSH/FUA will only be
> > dispatched after all previous requests finish.
> 
> This certainly makes sense.
> 
> > 
> > The in-memory index is a simple list of io_range (sequence, metadata
> > sector, data sector, length). The list is orded by sequence. The first
> > io_range entry's metadata sector is the tail of the log. There is also a
> > struct to track io ranges within a stripe. All stripes will be organized
> > as a radix tree.
> 
> It would be useful here to briefly say how these data structures are
> used.
> I assumed the order-by-sequence list is to flush data to RAID when the
> log is getting full?
> The radix-tree tracks where in the log each stripe is - is that correct?
> So it is easy to find the stripe at the tail of the list to flush it
> out.

The order-by-sequence list maintains the valid data in log which hasn't
been flushed to raid yet. The radix-tree maps stripe sector to stripe.

> > All IO data will be copied to a memory pool for caching too until the
> > data is flushed to raid disks. This is just to simplify the
> > implementation, it's not mandated. In the future flush can do a data
> > copy from cache disk to raid disks, so the memory pool can be discarded.
> > If a stripe is flushed to raid disks, memory of the stripe can be
> > reused.
> 
> Again, why a separate memory pool rather than just leaving the data in
> the stripe cache until it is safe in the RAID?

I'd say a separate pool is much more convenient than using stripe cache.
The stripe cache handling state machine is complex enough, which I don't
like to make it even more. Plus, the pool isn't a must-have. A small
pool will cause frequent stripe flush to raid disks, which impacts both
performance and latency. I'm planing to remove it in the future, though
if that happens error handling will be hard.

> > We have two limited resources here, memory pool and cache disk space. If
> > resource is tight, we will do reclaim. In either case, we will flush
> > some data from cache disk to raid disks. However, we implement different
> > strategies. For memory reclaim, we prefer reclaiming full stripe. For
> > cache disk space reclaim, we prefer reclaiming io_range entry at the
> > head of index list.
> 
> Wouldn't full stripes be scheduled to the RAID immediately they become
> full (or immediately after the parity is safe in the log)?
> So for memory reclaim it would make sense to prefer stripes that have
> been idle for a long time - so an LRU list.
> 
> Certainly when the log approaches full you need to start flushing
> things at the start of the log.

Yep, a LRU list does make sense, though we don't have it yet. The full
stripes are flushed out till we have several such stripes. It's a
performance consideration, as flush must flush disk cache, which I don't
want to run very frequently.
> 
> > 
> > If cache disk has IO error, since all data are in memory pool, we will
> > flush all data to raid disks and fallback to no-cache-disk mode. IO
> > error of cache disk doesn't corrupt any data. After some time, we will
> > try to use cache disk again if the disk is ok. The retry will stop after
> > several rounds of failure.
> 
> The normal data flow involves lots of writing to the cache device and
> very little if any reading.  So we will probably need some sort of
> "scrub" process to read and verify the log occasionally, just to be
> sure that reads still work.  That could be largely done in user-space.

makes sense.
> > 
> > We always do reclaim in stripe unit. Reclaim could create holes in the
> > log, eg, some io_range in the middle is reclaimed, but io_range at the
> > head remains. So the index list entries don't always have continuous
> > sequence. But this doesn't matter, the first io_range is always the log
> > tail. Superblock has a field pointing to the position of log tail. The
> > hole can waste a lot of disk space though. In the future, we can
> > implement a garbage collection to mitigate the issue, eg, copy data
> > from the index tail to head.
> 
> I doubt there would be value in garbage collection.  Just flush the old
> stripes to the RAID.  Maybe I'm wrong, but I certainly agree that it
> isn't a priority.
> 
> > 
> > In the process reclaim flush data to raid disk, stripe parity will be
> > append to cache log. Parity is always appended after its corresponding
> > data. After parity is in cache disk, a flush_start block is appended to
> > log, which indicates stripe is flushing to raid disks. Data writing to
> > raid disks only happens after all data and parity are already in cache
> > disk. This will fix the write whole issue. After a stripe is flushed to
> > raid disks, a flush_end block is appended to log, which indicates a
> > stripe is settled down in raid disks.
> 
> I'm not sure that a separate "flush start" block is needed. Once all
> the parity blocks have been written we can assume that the flush has
> started.
> A "flush-end" block does make sense, though I would think of it as an
> 'invalidate' block in that it invalidates specific previous data blocks.
> Same concept though.

My original implementation doesn't have the 'flush start' block, but
when we have multiple reclaim threads (or a state machine you mentioned
handling several sets of stripe flushing), the 'flush start' block let
recovery code correctly destinguish stripe flush states and finish
recovery. The reason is we have multiple set of stripes and crash,
recovery can't destinguish a set. For example, a set have 8 stripes
writting parity to cache, but recovery only see 7 have parity and it
doesn't know there should be 8 stripes. In this case, the parity of 7
stripes should be discarded because disk cache isn't flushed yet (we
flush cache disk cache after the 8 stripes have parity in disk), we
shouldn't trust the parity data. Maybe the log checksum can help here, I
must double check.

> > Recovery relies on the flush_start and flush_end block. If recovery
> > finds data and parity of a stripe, the flush start/end block will be
> > used to determine which stage the stripe is in flush. If the stripe is
> > listed in flush end block, the stripe is in raid disks, all data and
> > parity of the stripe can be discarded. If the stripe isn't listed in
> > flush start block, the stripe hasn't started flush to raid yet, its
> > parity can be ignored. Otherwise, the stripe is in the middle of
> > flushing to raid disks.  Since we have both data and parity, the
> > recovery just rewrite them to raid disks.
> > 
> > IO write code path:
> > 1. copy bio data to stripe memory pages
> > 2. append metadata and data to cache log
> > 3. IO write endio
> > 
> > reclaim code path:
> > 1. select stripe to reclaim
> > 2. write all stripe data to raid disk
> > 3. in raid5 ops_run_io, append metadata and parity data to cache log.
> >     ops_run_io doesn't write data/parity to raid disks at this time
> > 4. flush cache disk and write flush_start block
> > 5. ops_run_io continues. data/parity will be written to raid disks
> > 6. flush all raid disks cache
> > 7. write flush_end block
> > 8. delete in-memory index of the stripe, and advance superblock log checkpoint
> 
> I find this a bit confusing.  Step 2 writes to the raid disk, but step
> 3 says it doesn't write to the raid disk yet.  It also doesn't tell me
> when parity is calculated.
It's in step 2, just like step 2 and part of 3 in what you write below

> I imagine:
> 
> 1. select stripe to reclaim
> 2. read missing data or parity block so new parity can be calculated.
> 3. calculate parity and write to log - this records that the flush has
>    started.
> 4. flush cache device - probably multiple stripes will get up to the
>    step, and then a single flush will be performed for all of them.
> 5. schedule writes to the RAID disks, both data an parity.
> 6. flush RAID disks - again, wait for lots of stripes to reach this
>    point, then perform a single flush
> 7. write flush_end / invalidate block for all of the flushed stripes
> 8. delete in-memory index and advance superblock log checkpoint.
>    flush the invalidate blocks before writing the superblock.
> 
> If you get '4' for one set of stripes to line up with '8' for the
> previous set of stripes, then you can combine the two 'flush'
> operations to the cache devices.
> So the cache device see:
>   FLUSH superblock update, new parity writes, flush_end of older writes FLUSH
> which data writes sprinkled through wherever needed.

Agree.

> > Recovery:
> > Crash in IO write code path doesn't need recovery. If data and checksum
> > don't match, the data will be ignored so read will return old data. In
> > reclaim code path, crash before step 4 doesn't need recovery as
> > data/parity don't touch raid disk yet. Parity can be ignored too. crash
> > after 7 doesn't need recovery too, as the stripe is fully flushed to
> > raid disks. Crash between 4 and 7 need recovery. Data and parity in the
> > log will be written to raid disks.
> 
> So recovery involves reading everything in the log, adding data and
> parity to the stripe cache as it is found, invalidating any entries
> when an 'invalidate' block is found.
> Then any stripe that has all required parity is written to the RAID,
> and any other stripe is discarded.
> Then the log is emptied and we start from scratch.

right
> > 
> > The performance of the raid will largely be determined by reclaim speed
> > at run time. Several stages of the reclaim process involves IO wait or
> > disk cache flush, which significantly impact the raid disk utilization
> > and performance. The flush_start and flush_end block make running
> > multiple reclaim possible. Each reclaim only records stripes in the
> > flush start/end block which it is reclaiming.  Recovery can use the
> > information to correctly determine stripe's flush stage. An example of 2
> > reclaimer:
> > 
> > xxx1 belongs to stripe1 and the same for stripe2
> > 
> > reclaim 1:  |data1|...|parity1|...|flush_start1|...|flush_end1|
> > reclaim 2:      |data2|..|parity2|...............|flush_start2|...|flush_end2|
> > 
> > the reclaims only record its own stripes in flush block. If, for
> > exmaple, recovery finds flush_start1, it knows stripe1 is flushing to
> > raid disk. Recovery will ignore stripe2, since stripe2 isn't in
> > flush_start1.
> > 
> > Multiple reclaim will efficiently solve the performance issue. Current
> > code hasn't add multiple reclaim yet, but certainly will be added soon.
> 
> Maybe this is what you have in mind, but I would use a state-machine
> approach for the reclaim
> i.e. schedule a collection of stripes for parity calculation.
>     as they complete, schedule the writes to cache
>     When there are no pending writes to cache, schedule a flush
>     etc.

the state machine approach is a good choice too. The problem here is
reclaim thread sometimes writes cache disk and sometimes write raid
disks, the cache disk and raid disks haven't enough IO in the meaning
time. With multiple reclaim threads, the threads (hopefully) are in
different stage and dispatch enough IO to all disks. a state machien
approach can do the similar thing too if it's done correctly. I think we
must make sure recover works with multiple stripe flushing sets
currently, we can try different reclaim approaches later.


> > 
> > V3:
> > -fix a use after free bug. fix bio to cache disk crosses disk boundary
> > -adjust memory watermark
> > V2:
> > -fix bugs and code clean up
> > -log meta data write isn't FUA any more
> > -discard only runs when the discard area is big enough
> > 
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/Makefile            |    2 +-
> >  drivers/md/raid5-cache.c       | 3246 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/md/raid5.c             |   69 +-
> >  drivers/md/raid5.h             |   15 +-
> >  include/uapi/linux/raid/md_p.h |   72 +
> >  5 files changed, 3392 insertions(+), 12 deletions(-)
> >  create mode 100644 drivers/md/raid5-cache.c
> > 
> > diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> > index dba4db5..aeb4330 100644
> > --- a/drivers/md/Makefile
> > +++ b/drivers/md/Makefile
> > @@ -16,7 +16,7 @@ dm-cache-mq-y   += dm-cache-policy-mq.o
> >  dm-cache-cleaner-y += dm-cache-policy-cleaner.o
> >  dm-era-y	+= dm-era-target.o
> >  md-mod-y	+= md.o bitmap.o
> > -raid456-y	+= raid5.o
> > +raid456-y	+= raid5.o raid5-cache.o
> >  
> >  # Note: link order is important.  All raid personalities
> >  # and must come before md.o, as they each initialise 
> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> > new file mode 100644
> > index 0000000..c21d2f2
> > --- /dev/null
> > +++ b/drivers/md/raid5-cache.c
> > @@ -0,0 +1,3246 @@
> > +/*
> > + * A caching layer for raid 4/5/6
> > + *
> > + * Copyright (C) 2015 Shaohua Li <shli@fb.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program; if not, write to the Free Software Foundation, Inc.,
> > + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> > + */
> > +#include <linux/kernel.h>
> > +#include <linux/wait.h>
> > +#include <linux/blkdev.h>
> > +#include <linux/slab.h>
> > +#include <linux/raid/md_p.h>
> > +#include <linux/crc32.h>
> > +#include <linux/list_sort.h>
> > +#include "md.h"
> > +#include "raid5.h"
> > +
> > +/* the log disk cache will be flushed forcely every second */
> > +#define LOG_FLUSH_TIME HZ
> > +#define LOG_SUPER_WRITE_TIME (5 * HZ)
> > +
> > +#define MAX_MEM (256 * 1024 * 1024)
> > +#define RECLAIM_BATCH 16
> > +#define CHECKPOINT_TIMEOUT (5 * HZ)
> > +
> > +#define MAX_RETRY 10
> > +#define IOERR_RETRY_TIME (5 * 60 * HZ)
> > +#define MEMERR_RETRY_TIME (60 * HZ)
> > +
> > +typedef u64 r5blk_t; /* log blocks, could be 512B - 4k */
> 
> Why isn't this just "sector_t" ??

It can be sector_t. But with the new type, it's clear to know code is
working on a sector or a block. It helps avoid bug.

> > +
> > +struct r5l_log {
> > +	struct r5c_cache *cache;
> 
> It isn't immediately clear what the "log" is separate from the "cache".
> If there is a good reason, then a comment with that reason here would
> be very helpful.

ok, will do

> > +	struct block_device *bdev;
> > +	struct md_rdev *rdev;
> 
> Is there a reason for storing both of these instead of just 'rdev' and
> using 'rdev->bdev' when that is needed?

It's just for convenience 
> 
> > +
> > +	struct page *super_page;
> > +	u8 uuid[16];
> > +	u32 uuid_checksum_data;
> > +	u32 uuid_checksum_meta;
> > +
> > +	unsigned int block_size; /* bytes */
> > +	unsigned int block_sector_shift;
> > +	unsigned int page_block_shift;
> > +	unsigned int stripe_data_size; /* sector */
> > +	unsigned int chunk_size; /* sector */
> > +	unsigned int stripe_size; /* sector */
> > +	unsigned int parity_disks;
> 
> Some of these are obvious, some are not.
> Some more specific comments would help.

Ok, I'll split the patch and add more comments.

Thanks,
Shaohua
