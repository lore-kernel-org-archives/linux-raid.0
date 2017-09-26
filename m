From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v4 1/7] md: Make md resync and reshape threads freezable
Date: Tue, 26 Sep 2017 19:17:54 +0800
Message-ID: <20170926111747.GA16794@ming.t460p>
References: <20170925202924.16603-1-bart.vanassche@wdc.com>
 <20170925202924.16603-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170925202924.16603-2-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On Mon, Sep 25, 2017 at 01:29:18PM -0700, Bart Van Assche wrote:
> Some people use the md driver on laptops and use the suspend and
> resume functionality. Since it is essential that submitting of
> new I/O requests stops before device quiescing starts, make the
> md resync and reshape threads freezable.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/md/md.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 08fcaebc61bd..26a12bd0db65 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -66,6 +66,7 @@
>  #include <linux/raid/md_u.h>
>  #include <linux/slab.h>
>  #include <linux/percpu-refcount.h>
> +#include <linux/freezer.h>
>  
>  #include <trace/events/block.h>
>  #include "md.h"
> @@ -7424,6 +7425,7 @@ static int md_thread(void *arg)
>  	 */
>  
>  	allow_signal(SIGKILL);
> +	set_freezable();
>  	while (!kthread_should_stop()) {
>  
>  		/* We need to wait INTERRUPTIBLE so that
> @@ -7434,7 +7436,7 @@ static int md_thread(void *arg)
>  		if (signal_pending(current))
>  			flush_signals(current);
>  
> -		wait_event_interruptible_timeout
> +		wait_event_freezable_timeout
>  			(thread->wqueue,
>  			 test_bit(THREAD_WAKEUP, &thread->flags)
>  			 || kthread_should_stop() || kthread_should_park(),
> @@ -8133,6 +8135,8 @@ void md_do_sync(struct md_thread *thread)
>  		return;
>  	}
>  
> +	set_freezable();
> +
>  	if (mddev_is_clustered(mddev)) {
>  		ret = md_cluster_ops->resync_start(mddev);
>  		if (ret)
> @@ -8324,7 +8328,7 @@ void md_do_sync(struct md_thread *thread)
>  		     mddev->curr_resync_completed > mddev->resync_max
>  			    )) {
>  			/* time to update curr_resync_completed */
> -			wait_event(mddev->recovery_wait,
> +			wait_event_freezable(mddev->recovery_wait,
>  				   atomic_read(&mddev->recovery_active) == 0);
>  			mddev->curr_resync_completed = j;
>  			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> @@ -8342,10 +8346,10 @@ void md_do_sync(struct md_thread *thread)
>  			 * to avoid triggering warnings.
>  			 */
>  			flush_signals(current); /* just in case */
> -			wait_event_interruptible(mddev->recovery_wait,
> -						 mddev->resync_max > j
> -						 || test_bit(MD_RECOVERY_INTR,
> -							     &mddev->recovery));
> +			wait_event_freezable(mddev->recovery_wait,
> +					     mddev->resync_max > j ||
> +					     test_bit(MD_RECOVERY_INTR,
> +						      &mddev->recovery));
>  		}
>  
>  		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
> @@ -8421,7 +8425,7 @@ void md_do_sync(struct md_thread *thread)
>  				 * Give other IO more of a chance.
>  				 * The faster the devices, the less we wait.
>  				 */
> -				wait_event(mddev->recovery_wait,
> +				wait_event_freezable(mddev->recovery_wait,
>  					   !atomic_read(&mddev->recovery_active));
>  			}
>  		}
> @@ -8433,7 +8437,8 @@ void md_do_sync(struct md_thread *thread)
>  	 * this also signals 'finished resyncing' to md_stop
>  	 */
>  	blk_finish_plug(&plug);
> -	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
> +	wait_event_freezable(mddev->recovery_wait,
> +			     !atomic_read(&mddev->recovery_active));
>  
>  	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>  	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
> -- 
> 2.14.1
> 

Just test this patch a bit and the following failure of freezing task
is triggered during suspend:

[   38.903513] PM: suspend entry (deep)
[   38.904443] PM: Syncing filesystems ... done.
[   38.983591] Freezing user space processes ... (elapsed 0.002 seconds) done.
[   38.987522] OOM killer disabled.
[   38.987962] Freezing remaining freezable tasks ...
[   58.998872] Freezing of tasks failed after 20.008 seconds (1 tasks refusing to freeze, wq_busy=0):
[   59.002539] md127_resync    D    0  1618      2 0x80000000
[   59.004954] Call Trace:
[   59.006162]  __schedule+0x41f/0xa50
[   59.007704]  schedule+0x3d/0x90
[   59.009305]  raid1_sync_request+0x2da/0xd10 [raid1]
[   59.011505]  ? remove_wait_queue+0x70/0x70
[   59.013352]  md_do_sync+0xdfa/0x12c0
[   59.014955]  ? remove_wait_queue+0x70/0x70
[   59.016336]  md_thread+0x1a8/0x1e0
[   59.016770]  ? md_thread+0x1a8/0x1e0
[   59.017250]  kthread+0x155/0x190
[   59.017662]  ? sync_speed_show+0xa0/0xa0
[   59.018217]  ? kthread_create_on_node+0x70/0x70
[   59.018858]  ret_from_fork+0x2a/0x40
[   59.019403] Restarting kernel threads ... done.
[   59.024586] OOM killer enabled.
[   59.025124] Restarting tasks ... done.
[   59.045906] PM: suspend exit
[   97.919428] systemd-journald[227]: Sent WATCHDOG=1 notification.
[  101.002695] md: md127: data-check done.



-- 
Ming
