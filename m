From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] md/r5cache: improve journal device efficiency
Date: Sat, 21 Jan 2017 10:54:00 -0800
Message-ID: <20170121185400.nreoq4wjcwfhvyzl@kernel.org>
References: <20170118235650.2430923-1-songliubraving@fb.com>
 <20170118235650.2430923-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170118235650.2430923-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Wed, Jan 18, 2017 at 03:56:50PM -0800, Song Liu wrote:
> It is important to be able to flush all stripes in raid5-cache.
> Therefore, we need reserve some space on the journal device for
> these flushes. If flush operation includes pending writes to the
> stripe, we need to reserve (conf->raid_disk + 1) pages per stripe
> for the flush out. This reduces the efficiency of journal space.
> If we exclude these pending writes from flush operation, we only
> need (conf->max_degraded + 1) pages per stripe.
> 
> With this patch, when log space is critical (R5C_LOG_CRITICAL=1),
> pending writes will be excluded from stripe flush out. Therefore,
> we can reduce reserved space for flush out and thus improve journal
> device efficiency.

So this improves space efficiency, but it harms performance. If we don't delay
'towrite', we only need flush the stripe once in reclaim. With this, we need
flush the stripe twice. This will create more IO.

> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 15 +++------------
>  drivers/md/raid5.c       | 42 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 35 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index b31ae41..c027f1b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -387,17 +387,8 @@ void r5c_check_cached_full_stripe(struct r5conf *conf)
>  /*
>   * Total log space (in sectors) needed to flush all data in cache
>   *
> - * Currently, writing-out phase automatically includes all pending writes
> - * to the same sector. So the reclaim of each stripe takes up to
> - * (conf->raid_disks + 1) pages of log space.
> - *
> - * To totally avoid deadlock due to log space, the code reserves
> - * (conf->raid_disks + 1) pages for each stripe in cache, which is not
> - * necessary in most cases.
> - *
> - * To improve this, we will need writing-out phase to be able to NOT include
> - * pending writes, which will reduce the requirement to
> - * (conf->max_degraded + 1) pages per stripe in cache.
> + * To flush all stripes in cache, we need (conf->max_degraded + 1)
> + * pages per stripe in cache.
>   */
>  static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
>  {
> @@ -406,7 +397,7 @@ static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
>  	if (!r5c_is_writeback(log))
>  		return 0;
>  
> -	return BLOCK_SECTORS * (conf->raid_disks + 1) *
> +	return BLOCK_SECTORS * (conf->max_degraded + 1) *
>  		atomic_read(&log->stripe_in_journal_count);
>  }

Is this really safe? The check of R5C_LOG_CRITICAL isn't synchronized with this
one. If R5C_LOG_CRITICAL isn't set at the begining, but it's set in the middle
of handling a stripe, could we run out of space?

I think we probably can calculate the reserved space by 'max_degraded + 1 +
pending_write_disks'. We can maintain a count for pending_write_disks, increase
it with new write and decrease after write data to journal. Don't think we
should worry about delaying the towrite, it should happen rarely.

Thanks,
Shaohua
