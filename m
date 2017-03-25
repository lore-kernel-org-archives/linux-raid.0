From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5-cache: fix payload endianness problem in
 raid5-cache
Date: Sat, 25 Mar 2017 09:27:08 -0700
Message-ID: <20170325162708.v2hwo2huat47es4c@kernel.org>
References: <1490406279-20453-1-git-send-email-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490406279-20453-1-git-send-email-yanaijie@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: linux-raid@vger.kernel.org, miaoxie@huawei.com, zhaohongjiang@huawei.com, songliubraving@fb.com
List-Id: linux-raid.ids

On Sat, Mar 25, 2017 at 09:44:39AM +0800, Jason Yan wrote:
> The payload->header.type and payload->size are little-endian, so just
> convert them to the right byte order.
Cc Song.

Applied, thanks!

 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/md/raid5-cache.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 25eb048..b6194e0 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2002,12 +2002,12 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
>  		payload = (void *)mb + mb_offset;
>  		payload_flush = (void *)mb + mb_offset;
>  
> -		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
> +		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
>  			if (r5l_recovery_verify_data_checksum(
>  				    log, ctx, page, log_offset,
>  				    payload->checksum[0]) < 0)
>  				goto mismatch;
> -		} else if (payload->header.type == R5LOG_PAYLOAD_PARITY) {
> +		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
>  			if (r5l_recovery_verify_data_checksum(
>  				    log, ctx, page, log_offset,
>  				    payload->checksum[0]) < 0)
> @@ -2019,12 +2019,12 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
>  						 BLOCK_SECTORS),
>  				    payload->checksum[1]) < 0)
>  				goto mismatch;
> -		} else if (payload->header.type == R5LOG_PAYLOAD_FLUSH) {
> +		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
>  			/* nothing to do for R5LOG_PAYLOAD_FLUSH here */
>  		} else /* not R5LOG_PAYLOAD_DATA/PARITY/FLUSH */
>  			goto mismatch;
>  
> -		if (payload->header.type == R5LOG_PAYLOAD_FLUSH) {
> +		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
>  			mb_offset += sizeof(struct r5l_payload_flush) +
>  				le32_to_cpu(payload_flush->size);
>  		} else {
> @@ -2091,7 +2091,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  		payload = (void *)mb + mb_offset;
>  		payload_flush = (void *)mb + mb_offset;
>  
> -		if (payload->header.type == R5LOG_PAYLOAD_FLUSH) {
> +		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
>  			int i, count;
>  
>  			count = le32_to_cpu(payload_flush->size) / sizeof(__le64);
> @@ -2113,7 +2113,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  		}
>  
>  		/* DATA or PARITY payload */
> -		stripe_sect = (payload->header.type == R5LOG_PAYLOAD_DATA) ?
> +		stripe_sect = (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) ?
>  			raid5_compute_sector(
>  				conf, le64_to_cpu(payload->location), 0, &dd,
>  				NULL)
> @@ -2151,7 +2151,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  			list_add_tail(&sh->lru, cached_stripe_list);
>  		}
>  
> -		if (payload->header.type == R5LOG_PAYLOAD_DATA) {
> +		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
>  			if (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
>  			    test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags)) {
>  				r5l_recovery_replay_one_stripe(conf, sh, ctx);
> @@ -2159,7 +2159,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  			}
>  			r5l_recovery_load_data(log, sh, ctx, payload,
>  					       log_offset);
> -		} else if (payload->header.type == R5LOG_PAYLOAD_PARITY)
> +		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY)
>  			r5l_recovery_load_parity(log, sh, ctx, payload,
>  						 log_offset);
>  		else
> @@ -2361,7 +2361,7 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
>  				payload = (void *)mb + offset;
>  				payload->header.type = cpu_to_le16(
>  					R5LOG_PAYLOAD_DATA);
> -				payload->size = BLOCK_SECTORS;
> +				payload->size = cpu_to_le32(BLOCK_SECTORS);
>  				payload->location = cpu_to_le64(
>  					raid5_compute_blocknr(sh, i, 0));
>  				addr = kmap_atomic(dev->page);
> -- 
> 2.5.0
> 
