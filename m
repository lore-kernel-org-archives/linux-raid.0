From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: release/flush io in raid5_do_work()
Date: Thu, 24 Aug 2017 10:02:12 -0700
Message-ID: <20170824170212.bfuydnvs3dq4nvfk@kernel.org>
References: <20170824165359.4065174-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170824165359.4065174-1-songliubraving@fb.com>
Sender: stable-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com, "4.4+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 24, 2017 at 09:53:59AM -0700, Song Liu wrote:
> In raid5, there are scenarios where some ios are deferred to a later
> time, and some IO need a flush to complete. To make sure we make
> progress with these IOs, we need to call the following functions:
> 
>     flush_deferred_bios(conf);
>     r5l_flush_stripe_to_raid(conf->log);
> 
> Both of these functions are called in raid5d(), but missing in
> raid5_do_work(). As a result, these functions are not called
> when multi-threading (group_thread_cnt > 0) is enabled. This patch
> adds calls to these function to raid5_do_work().
> 
> Note for stable branches:
> 
>   r5l_flush_stripe_to_raid(conf->log) is need for 4.4+
>   flush_deferred_bios(conf) is only needed for 4.11+
> 
> Cc: stable@vger.kernel.org (4.4+)
> Signed-off-by: Song Liu <songliubraving@fb.com>

Applied, thanks!
> ---
>  drivers/md/raid5.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f64ff32..6af57c6 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6226,6 +6226,10 @@ static void raid5_do_work(struct work_struct *work)
>  
>  	spin_unlock_irq(&conf->device_lock);
>  
> +	flush_deferred_bios(conf);
> +
> +	r5l_flush_stripe_to_raid(conf->log);
> +
>  	async_tx_issue_pending_all();
>  	blk_finish_plug(&plug);
>  
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
