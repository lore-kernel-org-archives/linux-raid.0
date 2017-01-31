From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v1] md/r5cache: improve journal device efficiency
Date: Mon, 30 Jan 2017 16:11:43 -0800
Message-ID: <20170131001143.di5frsq3s4amxdw2@kernel.org>
References: <20170124220823.1481119-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124220823.1481119-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, jsorensen@fb.com
List-Id: linux-raid.ids

On Tue, Jan 24, 2017 at 02:08:23PM -0800, Song Liu wrote:
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

Applied, thanks! 
> - * To improve this, we will need writing-out phase to be able to NOT include
> - * pending writes, which will reduce the requirement to
> - * (conf->max_degraded + 1) pages per stripe in cache.
> + * In cache flush, the stripe goes through 1 and then 2. For a stripe that
> + * already passed 1, flushing it requires at most (conf->raid_disks + 1)
                                                      ^ I changed it to conf->max_degraded
> + * pages of journal space. For stripes that has not passed 1, flushing it
> + * requires (conf->max_degraded + 1) pages of journal space. There are at
                ^ I changed it to conf->raid_disks


> + * most (conf->group_cnt + 1) stripe that passed 1. So total journal space
> + * required to flush all cached stripes (in pages) is:
> + *
> + *     (stripe_in_journal_count - group_cnt - 1) * (max_degraded + 1) +
> + *     (group_cnt + 1) * (raid_disks + 1)
> + * or
> + *     (stripe_in_journal_count) * (max_degraded + 1) +
> + *     (group_cnt + 1) * (raid_disks - max_degraded)
>   */
>  static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
>  {
> @@ -408,8 +421,9 @@ static sector_t r5c_log_required_to_flush_cache(struct r5conf *conf)
>  	if (!r5c_is_writeback(log))
>  		return 0;
>  
> -	return BLOCK_SECTORS * (conf->raid_disks + 1) *
> -		atomic_read(&log->stripe_in_journal_count);
> +	return BLOCK_SECTORS *
> +		((conf->max_degraded + 1) * atomic_read(&log->stripe_in_journal_count) +
> +		 (conf->raid_disks - conf->max_degraded) * (conf->group_cnt + 1));
>  }
