From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] A caching layer for RAID5/6
Date: Thu, 7 May 2015 09:52:26 -0700
Message-ID: <20150507165226.GA5281@infradead.org>
References: <cover.1430954848.git.shli@fb.com>
 <e41752e8440e1b73e12240b86609b1bee73d7443.1430954848.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e41752e8440e1b73e12240b86609b1bee73d7443.1430954848.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

Just a few comments from looking over the code, this isn't a technical
review of the concepts yet:

> +
> +typedef u64 r5blk_t; /* log blocks */

Please explain how this is different from a sector_t.  CAn it be a
different granularity?

> +#define STRIPE_INDEX_OFFSET(c, sect, index, offset) \
> +({ \
> +	sector_t tmp = sect; \
> +	offset = sector_div(tmp, (c)->stripe_data_size); \
> +	index = tmp; \
> +})

This macros is almost impossible to understand.  Please turn it
into a inline function with proper typing and add some comments.

> +
> +#define STRIPE_RAID_SECTOR(cache, stripe) \
> +	((stripe)->raid_index * (cache)->stripe_data_size)
> +
> +#define PAGE_SECTOR_SHIFT (PAGE_SHIFT - 9)
> +
> +#define STRIPE_DATA_PAGES(c) ((c)->stripe_data_size >> PAGE_SECTOR_SHIFT)
> +#define STRIPE_PARITY_PAGES(c) \
> +	(((c)->stripe_size - (c)->stripe_data_size) >> PAGE_SECTOR_SHIFT)
> +#define BLOCK_SECTOR(log, b) ((b) << (log)->block_sector_shift)
> +#define SECTOR_BLOCK(log, s) ((s) >> (log)->block_sector_shift)
> +#define PAGE_BLOCKS(log, p) ((p) << (log)->page_block_shift)

And turn all these other function like macros into inlines as well.

> +#define UUID_CHECKSUM(log, data) \
> +	(data ? log->uuid_checksum_data : log->uuid_checksum_meta)

This one is always called with a constant second argument, so just open
code it.

> +static u32 r5l_calculate_checksum(struct r5l_log *log, u32 crc,
> +	void *buf, size_t size, bool data)
> +{
> +	if (log->data_checksum_type != R5LOG_CHECKSUM_CRC32)
> +		BUG();
> +	if (log->meta_checksum_type != R5LOG_CHECKSUM_CRC32)
> +		BUG();

BUG_ON?  But if the checksum type only has a single allow value
why even bother with it?

> +	if (!log->do_discard)
> +		return;
> +	if (start < end) {
> +		blkdev_issue_discard(log->bdev,
> +			BLOCK_SECTOR(log, start) + log->rdev->data_offset,
> +			BLOCK_SECTOR(log, end - start), GFP_NOIO, 0);
> +	} else {
> +		blkdev_issue_discard(log->bdev,
> +			BLOCK_SECTOR(log, start) + log->rdev->data_offset,
> +			BLOCK_SECTOR(log, log->last_block - start),
> +			GFP_NOIO, 0);
> +		blkdev_issue_discard(log->bdev,
> +			BLOCK_SECTOR(log, log->first_block) +
> +			log->rdev->data_offset,
> +			BLOCK_SECTOR(log, end - log->first_block),
> +			GFP_NOIO, 0);
> +	}

Submittin synchronous I/O in a block driver doesn't seem like a very
good idea.  If you actually enable discards (which seem disabled at the
moment) please submit these bios asynchronously.

