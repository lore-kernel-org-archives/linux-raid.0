From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 5/9] raid5: log recovery
Date: Wed, 5 Aug 2015 14:05:25 +1000
Message-ID: <20150805140525.0e0774ae@noble>
References: <cover.1438215986.git.shli@fb.com>
 <5683d4e81fe802c46350732560bbdd0a70212413.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5683d4e81fe802c46350732560bbdd0a70212413.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:45 -0700 Shaohua Li <shli@fb.com> wrote:

> This is the log recovery support. The process is quite straightforward.
> We scan the log and read all valid meta/data/parity into memory. If a
> stripe's data/parity checksum is correct, the stripe will be recoveried.
> Otherwise, it's discarded and we don't scan the log further. The reclaim
> process guarantees stripe which starts to be flushed raid disks has
> completed data/parity and has correct checksum. To recovery a stripe, we
> just copy its data/parity to corresponding raid disks.
> 
> The trick thing is superblock update after recovery. we can't let
> superblock point to last valid meta block. The log might look like:
> | meta 1| meta 2| meta 3|
> meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If superblock
> points to meta 1, we write a new valid meta 2n.  If crash happens again,
> new recovery will start from meta 1. Since meta 2n is valid, recovery
> will think meta 3 is valid, which is wrong.  The solution is we create a
> new meta in meta2 with its seq == meta 1's seq + 2 and let superblock
> points to meta2.  recovery will not think meta 3 is a valid meta,
> because its seq is wrong

I like the idea of using a slightly larger 'seq' to avoid collisions -
except that I would probably feel safer with a much larger seq. May add
1024 or something (at least 10).

> 
> TODO:
> -recovery should run the stripe cache state machine in case of disk
> breakage.

Why?

when you write to the log, you write all of the blocks that need
updating, whether they are destined for a failed device or not.

When you recover, you then have all the blocks that you might want to
write.  So write all the ones for which you have working devices, and
ignore the rest.

Did I miss something?

Not that I object, but if it works....



> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5-cache.c | 310 ++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/md/raid5.c       |   4 +-
>  drivers/md/raid5.h       |   6 +
>  3 files changed, 315 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index a418e45..17dab66 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -785,11 +785,315 @@ static void r5l_wake_reclaim(struct r5l_log *log, r5blk_t space)
>  	md_wakeup_thread(log->reclaim_thread);
>  }
>  
> +struct r5l_recovery_ctx {
> +	struct page *meta_page;
> +	unsigned int meta_total_blocks;
> +	r5blk_t pos;
> +	u64 seq;
> +};
> +
> +static inline sector_t r5l_sector_to_stripe_sector(struct r5l_log *log,
> +       sector_t sect)
> +{
> +	struct r5conf *conf = log->mddev->private;
> +	int dd;
> +	return raid5_compute_sector(conf, sect, 0, &dd, NULL);
> +}
> +
> +static int r5l_read_meta_block(struct r5l_log *log,
> +	struct r5l_recovery_ctx *ctx)
> +{
> +	struct r5conf *conf = log->mddev->private;
> +	struct page *page = ctx->meta_page;
> +	struct r5l_meta_block *mb;
> +	u32 crc, stored_crc;
> +	struct r5l_payload_header *header;
> +	int next_type = -1;
> +	int last_type = -1;
> +	sector_t last_stripe_sector = 0;
> +	int offset;
> +
> +	if (!sync_page_io(log->rdev, r5l_block_to_sector(log, ctx->pos),
> +	    log->block_size, page, READ, false))
> +		return -EIO;
> +
> +	mb = page_address(page);
> +	stored_crc = le32_to_cpu(mb->checksum);
> +	mb->checksum = 0;
> +
> +	if (le32_to_cpu(mb->magic) != R5LOG_MAGIC ||
> +	    le64_to_cpu(mb->seq) != ctx->seq ||
> +	    mb->version != R5LOG_VERSION ||
> +	    le64_to_cpu(mb->position) != ctx->pos)
> +		return -EINVAL;
> +
> +	crc = r5l_calculate_checksum(log, log->uuid_checksum,
> +			mb, log->block_size);
> +	if (stored_crc != crc)
> +		return -EINVAL;
> +
> +	if (le32_to_cpu(mb->meta_size) > log->block_size)
> +		return -EINVAL;
> +
> +	ctx->meta_total_blocks = 1;
> +	offset = sizeof(struct r5l_meta_block);
> +	while (offset < le32_to_cpu(mb->meta_size)) {
> +		u16 type;
> +		header = page_address(page) + offset;
> +		type = le16_to_cpu(header->type);
> +
> +		if (next_type != -1 && type != next_type)
> +			return -EINVAL;
> +		if (type == R5LOG_PAYLOAD_DATA) {
> +			struct r5l_payload_data_parity *payload;
> +
> +			payload = (struct r5l_payload_data_parity *)header;
> +			if (le32_to_cpu(payload->blocks) != r5l_page_blocks(log, 1))
> +				return -EINVAL;
> +			if (last_type != -1) {
> +				if (r5l_sector_to_stripe_sector(log,
> +				    le64_to_cpu(payload->location)) !=
> +				    last_stripe_sector)
> +					return -EINVAL;
> +			} else
> +				last_stripe_sector =
> +					r5l_sector_to_stripe_sector(log,
> +						le64_to_cpu(payload->location));
> +
> +			ctx->meta_total_blocks += r5l_page_blocks(log, 1);
> +			next_type = -1;
> +			last_type = type;
> +			offset += sizeof(struct r5l_payload_data_parity) +
> +				sizeof(__le32);
> +		} else if (type == R5LOG_PAYLOAD_PARITY) {
> +			struct r5l_payload_data_parity *payload;
> +
> +			payload = (struct r5l_payload_data_parity *)header;
> +			if (last_type == -1)
> +				return -EINVAL;
> +
> +			if (le32_to_cpu(payload->blocks) !=
> +			    r5l_page_blocks(log, conf->max_degraded))
> +				return -EINVAL;
> +			if (le64_to_cpu(payload->location) != last_stripe_sector)
> +				return -EINVAL;
> +
> +			ctx->meta_total_blocks += r5l_page_blocks(log,
> +				conf->max_degraded);
> +			next_type = R5LOG_PAYLOAD_DATA;
> +			last_type = -1;
> +			offset += sizeof(struct r5l_payload_data_parity) +
> +				sizeof(__le32) * conf->max_degraded;
> +		} else
> +			return -EINVAL;
> +	}
> +	if (offset > le32_to_cpu(mb->meta_size))
> +		return -EINVAL;
> +
> +	return 0;
> +}

I'm not sure the next_type/last_type stuff really helps.  You are just
checking that there is at least one data block between pairs of parity
blocks, but that is a fairly weak test - there are plenty of other ways
that things could go wrong.
I think just trust that the data was written correctly, and that
checksum will detect the unlikely corruption.

> +
> +static int r5l_recovery_flush_one_stripe(struct r5l_log *log,
> +	struct r5l_recovery_ctx *ctx, sector_t stripe_sect,
> +	int *offset, r5blk_t *log_offset)
> +{
> +	struct r5conf *conf = log->mddev->private;
> +	struct stripe_head *dummy;
> +	struct r5l_payload_data_parity *payload;
> +	int disk_index;
> +
> +	dummy = get_active_stripe(conf, stripe_sect, 0, 0, 0);

Why is this called 'dummy'.  It is a real stripe and should be called
'sh'

> +	while (1) {
> +		payload = page_address(ctx->meta_page) + *offset;
> +
> +		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
> +			raid5_compute_sector(conf,
> +				le64_to_cpu(payload->location), 0,
> +				&disk_index, dummy);
> +
> +			sync_page_io(log->rdev, r5l_block_to_sector(log,
> +				*log_offset), PAGE_SIZE,
> +				dummy->dev[disk_index].page, READ, false);
> +			dummy->dev[disk_index].log_checksum =
> +				le32_to_cpu(payload->checksum[0]);
> +			set_bit(R5_Wantwrite, &dummy->dev[disk_index].flags);
> +		} else {
> +			disk_index = dummy->pd_idx;
> +			sync_page_io(log->rdev, r5l_block_to_sector(log,
> +				*log_offset), PAGE_SIZE,
> +				dummy->dev[disk_index].page, READ, false);
> +			dummy->dev[disk_index].log_checksum =
> +				le32_to_cpu(payload->checksum[0]);
> +			set_bit(R5_Wantwrite, &dummy->dev[disk_index].flags);
> +
> +			if (dummy->qd_idx >= 0) {
> +				disk_index = dummy->qd_idx;
> +				sync_page_io(log->rdev, r5l_block_to_sector(log,
> +					r5l_ring_add(log, *log_offset,
> +						r5l_page_blocks(log, 1))),
> +					PAGE_SIZE,
> +					dummy->dev[disk_index].page,
> +					READ, false);
> +				dummy->dev[disk_index].log_checksum =
> +					le32_to_cpu(payload->checksum[1]);
> +				set_bit(R5_Wantwrite,
> +					&dummy->dev[disk_index].flags);
> +			}
> +		}
> +
> +		*log_offset = r5l_ring_add(log, *log_offset,
> +			le32_to_cpu(payload->blocks));
> +		*offset += sizeof(struct r5l_payload_data_parity) +
> +			sizeof(__le32) * (le32_to_cpu(payload->blocks) >>
> +			log->page_block_shift);
> +		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY)
> +			break;
> +	}
> +
> +	for (disk_index = 0; disk_index < dummy->disks; disk_index++) {
> +		void *addr;
> +		u32 checksum;
> +
> +		if (!test_bit(R5_Wantwrite, &dummy->dev[disk_index].flags))
> +			continue;
> +		addr = kmap_atomic(dummy->dev[disk_index].page);
> +		checksum = r5l_calculate_checksum(log,
> +			log->uuid_checksum, addr, PAGE_SIZE);
> +		kunmap_atomic(addr);
> +		if (checksum != dummy->dev[disk_index].log_checksum)
> +			goto error;
> +	}
> +
> +	/* FIXME: let raid core to handle the stripe */
> +	for (disk_index = 0; disk_index < dummy->disks; disk_index++) {
> +		struct md_rdev *rdev, *rrdev;
> +		if (!test_and_clear_bit(R5_Wantwrite,
> +				&dummy->dev[disk_index].flags))
> +			continue;
> +
> +		rdev = rcu_dereference(conf->disks[disk_index].rdev);
> +		sync_page_io(rdev, stripe_sect, PAGE_SIZE,
> +			dummy->dev[disk_index].page, WRITE, false);
> +		rrdev = rcu_dereference(conf->disks[disk_index].replacement);
> +		if (rrdev)
> +			sync_page_io(rrdev, stripe_sect, PAGE_SIZE,
> +				dummy->dev[disk_index].page, WRITE, false);
> +	}
> +	release_stripe(dummy);
> +	return 0;
> +
> +error:
> +	for (disk_index = 0; disk_index < dummy->disks; disk_index++)
> +		dummy->dev[disk_index].flags = 0;
> +	release_stripe(dummy);
> +	return -EINVAL;
> +}
> +
> +static int r5l_recovery_flush_one_meta(struct r5l_log *log,
> +	struct r5l_recovery_ctx *ctx)
> +{
> +	struct r5l_payload_data_parity *payload;
> +	struct r5l_meta_block *mb;
> +	int offset;
> +	r5blk_t log_offset;
> +	sector_t stripe_sector;
> +
> +	mb = page_address(ctx->meta_page);
> +	offset = sizeof(struct r5l_meta_block);
> +	log_offset = r5l_ring_add(log, ctx->pos, 1);
> +
> +	while (offset < le32_to_cpu(mb->meta_size)) {
> +		payload = (void *)mb + offset;
> +		stripe_sector = r5l_sector_to_stripe_sector(log,
> +					le64_to_cpu(payload->location));
> +		if (r5l_recovery_flush_one_stripe(log, ctx, stripe_sector,
> +		    &offset, &log_offset))
> +			return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/* copy data/parity from log to raid disks */
> +static void r5l_recovery_flush_log(struct r5l_log *log,
> +	struct r5l_recovery_ctx *ctx)
> +{
> +	while (1) {
> +		if (r5l_read_meta_block(log, ctx))
> +			return;
> +		if (r5l_recovery_flush_one_meta(log, ctx))
> +			return;
> +		ctx->seq++;
> +		ctx->pos = r5l_ring_add(log, ctx->pos, ctx->meta_total_blocks);
> +	}
> +}
> +
> +static int r5l_log_write_empty_meta_block(struct r5l_log *log, r5blk_t pos,
> +	u64 seq)
> +{
> +	struct page *page;
> +	struct r5l_meta_block *mb;
> +	u32 crc;
> +
> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!page)
> +		return -ENOMEM;
> +	mb = page_address(page);
> +	mb->magic = cpu_to_le32(R5LOG_MAGIC);
> +	mb->version = R5LOG_VERSION;
> +	mb->block_size = cpu_to_le16(log->block_size);
> +	mb->meta_size = cpu_to_le32(sizeof(struct r5l_meta_block));
> +	mb->seq = cpu_to_le64(seq);
> +	mb->position = cpu_to_le64(pos);
> +	crc = r5l_calculate_checksum(log, log->uuid_checksum, mb,
> +			log->block_size);
> +	mb->checksum = cpu_to_le32(crc);
> +
> +	if (!sync_page_io(log->rdev, r5l_block_to_sector(log, pos),
> +	    log->block_size, page, WRITE_FUA, false)) {
> +		__free_page(page);
> +		return -EIO;
> +	}
> +	__free_page(page);
> +	return 0;
> +}
> +
>  static int r5l_recovery_log(struct r5l_log *log)
>  {
> -	/* fake recovery */
> -	log->seq = log->last_cp_seq + 1;
> -	log->log_start = r5l_ring_add(log, log->last_checkpoint, 1);
> +	struct r5l_recovery_ctx ctx;
> +
> +	ctx.pos = log->last_checkpoint;
> +	ctx.seq = log->last_cp_seq;
> +	ctx.meta_page = alloc_page(GFP_KERNEL);
> +	if (!ctx.meta_page)
> +		return -ENOMEM;
> +
> +	r5l_recovery_flush_log(log, &ctx);
> +	__free_page(ctx.meta_page);
> +
> +	/*
> +	 * we did a recovery. Now ctx.pos points to an invalid meta block. New
> +	 * log will start here. but we can't let superblock point to last valid
> +	 * meta block. The log might looks like:
> +	 * | meta 1| meta 2| meta 3|
> +	 * meta 1 is valid, meta 2 is invalid. meta 3 could be valid. If
> +	 * superblock points to meta 1, we write a new valid meta 2n.  if crash
> +	 * happens again, new recovery will start from meta 1. Since meta 2n is
> +	 * valid now, recovery will think meta 3 is valid, which is wrong.
> +	 * The solution is we create a new meta in meta2 with its seq == meta
> +	 * 1's seq + 2 and let superblock points to meta2. The same recovery will
> +	 * not think meta 3 is a valid meta, because its seq doesn't match
> +	 */
> +	if (ctx.seq > log->last_cp_seq + 1) {
> +		int ret;
> +		r5l_flush_all_disks(log);
> +
> +		ret = r5l_log_write_empty_meta_block(log, ctx.pos, ctx.seq + 1);
> +		if (ret)
> +			return ret;
> +		log->seq = ctx.seq + 2;
> +		log->log_start = r5l_ring_add(log, ctx.pos, 1);
> +		r5l_write_super(log, r5l_block_to_sector(log, ctx.pos));
> +	}
>  	return 0;
>  }
>  
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d1ddd31..77af7f0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -662,7 +662,7 @@ static int has_failed(struct r5conf *conf)
>  	return 0;
>  }
>  
> -static struct stripe_head *
> +struct stripe_head *
>  get_active_stripe(struct r5conf *conf, sector_t sector,
>  		  int previous, int noblock, int noquiesce)
>  {
> @@ -2527,7 +2527,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
>   * Input: a 'big' sector number,
>   * Output: index of the data and parity disk, and the sector # in them.
>   */
> -static sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
> +sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
>  				     int previous, int *dd_idx,
>  				     struct stripe_head *sh)
>  {
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 23cc9c3..fd10d29 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -618,4 +618,10 @@ extern int r5l_write_stripe(struct r5l_log *log, struct stripe_head *head_sh);
>  extern void r5l_write_stripe_run(struct r5l_log *log);
>  extern void r5l_flush_stripe_to_raid(struct r5l_log *log);
>  extern void r5l_stripe_write_finished(struct stripe_head *sh);
> +extern sector_t raid5_compute_sector(struct r5conf *conf, sector_t r_sector,
> +				     int previous, int *dd_idx,
> +				     struct stripe_head *sh);
> +extern struct stripe_head *
> +get_active_stripe(struct r5conf *conf, sector_t sector,
> +		  int previous, int noblock, int noquiesce);
>  #endif


Thanks,
NeilBrown

