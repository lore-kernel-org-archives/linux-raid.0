From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/r5cache: flush data in memory during journal device
 failure
Date: Tue, 14 Mar 2017 10:50:48 -0700
Message-ID: <20170314175048.rjyaufwgaclsmhdz@kernel.org>
References: <20170313233626.2109293-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170313233626.2109293-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org
List-Id: linux-raid.ids

On Mon, Mar 13, 2017 at 04:36:26PM -0700, Song Liu wrote:
> For the raid456 with writeback cache, when journal device failed during
> normal operation, it is still possible to persist all data, as all
> pending data is still in stripe cache. However, the stripe will be
> marked as fail with s.log_failed. Thus, the write out from stripe cache
> cannot make progress.
> 
> To unblock the write out in journal failures, this patch allows stripes
> with data injournal to make progress.

what about the parity part? if log failed, we should skip journaling the parity.

Thanks,
Shaohua
 
> The array should be read-only in journal failures. Therefore, pending
> writes (in dev->towrite) are excluded in this write (in delay_towrite).
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 3233975..447d9dd 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3069,6 +3069,10 @@ sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous)
>   *      When LOG_CRITICAL, stripes with injournal == 0 will be sent to
>   *      no_space_stripes list.
>   *
> + *   3. during journal failure
> + *      In journal failure, we try to flush all cached data to raid disks
> + *      based on data in stripe cache. The array is read-only to upper
> + *      layers, so we would skip all pending writes.
>   */
>  static inline bool delay_towrite(struct r5conf *conf,
>  				 struct r5dev *dev,
> @@ -3082,6 +3086,9 @@ static inline bool delay_towrite(struct r5conf *conf,
>  	if (test_bit(R5C_LOG_CRITICAL, &conf->cache_state) &&
>  	    s->injournal > 0)
>  		return true;
> +	/* case 3 above */
> +	if (s->log_failed && s->injournal)
> +		return true;
>  	return false;
>  }
>  
> @@ -4721,7 +4728,8 @@ static void handle_stripe(struct stripe_head *sh)
>  	/* check if the array has lost more than max_degraded devices and,
>  	 * if so, some requests might need to be failed.
>  	 */
> -	if (s.failed > conf->max_degraded || s.log_failed) {
> +	if (s.failed > conf->max_degraded ||
> +	    (s.log_failed && s.injournal == 0)) {
>  		sh->check_state = 0;
>  		sh->reconstruct_state = 0;
>  		break_stripe_batch_list(sh, 0);
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
