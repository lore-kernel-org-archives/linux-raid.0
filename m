From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: don't print the same repeated messages about delayed
 sync operation
Date: Wed, 17 Aug 2016 10:19:02 -0700
Message-ID: <20160817171902.GB35041@kernel.org>
References: <20160816122608.14435-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160816122608.14435-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 02:26:08PM +0200, Artur Paszkiewicz wrote:
> This fixes a long-standing bug that caused a flood of messages like:
> "md: delaying data-check of md1 until md2 has finished (they share one
> or more physical units)"
> 
> It can be reproduced like this:
> 1. Create at least 3 raid1 arrays on a pair of disks, each on different
>    partitions.
> 2. Request a sync operation like 'check' or 'repair' on 2 arrays by
>    writing to their md/sync_action attribute files. One operation should
>    start and one should be delayed and a message like the above will be
>    printed.
> 3. Issue a write to the third array. Each write will cause 2 copies of
>    the message to be printed.
> 
> This happens when wake_up(&resync_wait) is called, usually by
> md_check_recovery(). Then the delayed sync thread again prints the
> message and is put to sleep. This patch adds a check in md_do_sync() to
> prevent printing this message more than once for the same pair of
> devices.
> 
> Reported-by: Sven Koehler <sven.koehler@gmail.com>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=151801
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/md.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2c3ab6f..5096b48 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7862,6 +7862,7 @@ void md_do_sync(struct md_thread *thread)
>  	 */
>  
>  	do {
> +		int mddev2_minor = -1;
>  		mddev->curr_resync = 2;
>  
>  	try_again:
> @@ -7891,10 +7892,14 @@ void md_do_sync(struct md_thread *thread)
>  				prepare_to_wait(&resync_wait, &wq, TASK_INTERRUPTIBLE);
>  				if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>  				    mddev2->curr_resync >= mddev->curr_resync) {
> -					printk(KERN_INFO "md: delaying %s of %s"
> -					       " until %s has finished (they"
> -					       " share one or more physical units)\n",
> -					       desc, mdname(mddev), mdname(mddev2));
> +					if (mddev2_minor != mddev2->md_minor) {
> +						mddev2_minor = mddev2->md_minor;
> +						printk(KERN_INFO "md: delaying %s of %s"
> +						       " until %s has finished (they"
> +						       " share one or more physical units)\n",
> +						       desc, mdname(mddev),
> +						       mdname(mddev2));
> +					}
>  					mddev_put(mddev2);
>  					if (signal_pending(current))
>  						flush_signals(current);

applied, thanks!
