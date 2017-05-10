From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v4 2/2] md/r5cache: gracefully handle journal device
 errors for writeback mode
Date: Wed, 10 May 2017 10:01:38 -0700
Message-ID: <20170510170043.4v4ijoxmfty6hndf@kernel.org>
References: <20170509003925.3480693-1-songliubraving@fb.com>
 <20170509003925.3480693-2-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170509003925.3480693-2-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Mon, May 08, 2017 at 05:39:25PM -0700, Song Liu wrote:
> For the raid456 with writeback cache, when journal device failed during
> normal operation, it is still possible to persist all data, as all
> pending data is still in stripe cache. However, it is necessary to handle
> journal failure gracefully.
> 
> During journal failures, this patch makes the follow changes to land data
> in cache to raid disks gracefully:
> 
> 1. In handle_stripe(), allow stripes with data in journal (s.injournal > 0)
>    to make progress;
> 2. In delay_towrite(), only process data in the cache (skip dev->towrite);
> 3. In __get_priority_stripe(), set try_loprio to true, so no stripe stuck
>    in loprio_list

Applied the first patch. For this patch, I don't have a clear picture about
what you are trying to do. Please describe the steps we are doing to do after
journal failure.
 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 13 ++++++++++---
>  drivers/md/raid5-log.h   |  3 ++-
>  drivers/md/raid5.c       | 29 +++++++++++++++++++++++------
>  3 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index dc1dba6..e6032f6 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -24,6 +24,7 @@
>  #include "md.h"
>  #include "raid5.h"
>  #include "bitmap.h"
> +#include "raid5-log.h"
>  
>  /*
>   * metadata/data stored in disk with 4k size unit (a block) regardless
> @@ -679,6 +680,7 @@ static void r5c_disable_writeback_async(struct work_struct *work)
>  		return;
>  	pr_info("md/raid:%s: Disabling writeback cache for degraded array.\n",
>  		mdname(mddev));
> +	md_update_sb(mddev, 1);

Why this? And md_update_sb must be called within mddev->reconfig_mutex locked.
>  	mddev_suspend(mddev);
>  	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
>  	mddev_resume(mddev);
> @@ -1557,6 +1559,8 @@ void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>  void r5l_quiesce(struct r5l_log *log, int state)
>  {
>  	struct mddev *mddev;
> +	struct r5conf *conf;
> +
>  	if (!log || state == 2)
>  		return;
>  	if (state == 0)
> @@ -1564,10 +1568,12 @@ void r5l_quiesce(struct r5l_log *log, int state)
>  	else if (state == 1) {
>  		/* make sure r5l_write_super_and_discard_space exits */
>  		mddev = log->rdev->mddev;
> +		conf = mddev->private;
>  		wake_up(&mddev->sb_wait);
>  		kthread_park(log->reclaim_thread->tsk);
>  		r5l_wake_reclaim(log, MaxSector);
> -		r5l_do_reclaim(log);
> +		if (!r5l_log_disk_error(conf))
> +			r5l_do_reclaim(log);

I think r5c_disable_writeback_async() will call into this, so we flush all
stripe cache out to raid disks, why skip the reclaim?

Thanks,
Shaohua
