From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] md: Make flush bios explicitely sync
Date: Wed, 31 May 2017 09:23:46 -0700
Message-ID: <20170531162346.iwdkhp6cdr5y2uvn@kernel.org>
References: <20170531074433.14298-1-jack@suse.cz>
 <20170531074433.14298-3-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170531074433.14298-3-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 31, 2017 at 09:44:33AM +0200, Jan Kara wrote:
> Commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as
> synchronous" removed REQ_SYNC flag from WRITE_{FUA|PREFLUSH|...}
> definitions.  generic_make_request_checks() however strips REQ_FUA and
> REQ_PREFLUSH flags from a bio when the storage doesn't report volatile
> write cache and thus write effectively becomes asynchronous which can
> lead to performance regressions
> 
> Fix the problem by making sure all bios which are synchronous are
> properly marked with REQ_SYNC.

Applied, thanks!
 
> CC: linux-raid@vger.kernel.org
> CC: Shaohua Li <shli@kernel.org>
> Fixes: b685d3d65ac791406e0dfd8779cc9b3707fea5a3
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/md/md.c          | 2 +-
>  drivers/md/raid5-cache.c | 4 ++--
>  drivers/md/raid5-ppl.c   | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 10367ffe92e3..212a6777ff31 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -765,7 +765,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
>  	    test_bit(FailFast, &rdev->flags) &&
>  	    !test_bit(LastDev, &rdev->flags))
>  		ff = MD_FAILFAST;
> -	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_FUA | ff;
> +	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH | REQ_FUA | ff;
>  
>  	atomic_inc(&mddev->pending_writes);
>  	submit_bio(bio);
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 4c00bc248287..0a7af8b0a80a 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1782,7 +1782,7 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
>  	mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
>  					     mb, PAGE_SIZE));
>  	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE,
> -			  REQ_FUA, false)) {
> +			  REQ_SYNC | REQ_FUA, false)) {
>  		__free_page(page);
>  		return -EIO;
>  	}
> @@ -2388,7 +2388,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  		mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
>  						     mb, PAGE_SIZE));
>  		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
> -			     REQ_OP_WRITE, REQ_FUA, false);
> +			     REQ_OP_WRITE, REQ_SYNC | REQ_FUA, false);
>  		sh->log_start = ctx->pos;
>  		list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
>  		atomic_inc(&log->stripe_in_journal_count);
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 5d25bebf3328..ccce92e68d7f 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -907,8 +907,8 @@ static int ppl_write_empty_header(struct ppl_log *log)
>  	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PAGE_SIZE));
>  
>  	if (!sync_page_io(rdev, rdev->ppl.sector - rdev->data_offset,
> -			  PPL_HEADER_SIZE, page, REQ_OP_WRITE | REQ_FUA, 0,
> -			  false)) {
> +			  PPL_HEADER_SIZE, page, REQ_OP_WRITE | REQ_SYNC |
> +			  REQ_FUA, 0, false)) {
>  		md_error(rdev->mddev, rdev);
>  		ret = -EIO;
>  	}
> -- 
> 2.12.3
> 
