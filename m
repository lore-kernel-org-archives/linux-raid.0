From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: setup safemode_timer before it's being used
Date: Mon, 27 Jul 2015 11:30:35 +1000
Message-ID: <20150727113035.40029611@noble>
References: <1437776398-31079-1-git-send-email-sasha.levin@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437776398-31079-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 24 Jul 2015 18:19:58 -0400 Sasha Levin <sasha.levin@oracle.com>
wrote:

> We used to set up the safemode_timer timer in md_run. If md_run
> would fail before the timer was set up we'd end up trying to modify
> a timer that doesn't have a callback function when we access safe_delay_store,
> which would trigger a BUG.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/md/md.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 80879dc..60fb47e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -502,6 +502,8 @@ static void mddev_put(struct mddev *mddev)
>  		bioset_free(bs);
>  }
>  
> +static void md_safemode_timeout(unsigned long data);
> +
>  void mddev_init(struct mddev *mddev)
>  {
>  	mutex_init(&mddev->open_mutex);
> @@ -510,6 +512,8 @@ void mddev_init(struct mddev *mddev)
>  	INIT_LIST_HEAD(&mddev->disks);
>  	INIT_LIST_HEAD(&mddev->all_mddevs);
>  	init_timer(&mddev->safemode_timer);
> +	setup_timer(&mddev->safemode_timer, md_safemode_timeout,
> +			(unsigned long) mddev);
>  	atomic_set(&mddev->active, 1);
>  	atomic_set(&mddev->openers, 0);
>  	atomic_set(&mddev->active_io, 0);
> @@ -3276,8 +3280,6 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
>  	return 0;
>  }
>  
> -static void md_safemode_timeout(unsigned long data);
> -
>  static ssize_t
>  safe_delay_show(struct mddev *mddev, char *page)
>  {
> @@ -5204,8 +5206,6 @@ int md_run(struct mddev *mddev)
>  	atomic_set(&mddev->max_corr_read_errors,
>  		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
>  	mddev->safemode = 0;
> -	mddev->safemode_timer.function = md_safemode_timeout;
> -	mddev->safemode_timer.data = (unsigned long) mddev;
>  	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
>  	mddev->in_sync = 1;
>  	smp_wmb();


Thanks.
I've applied that patch, and also removed the 'init_timer' call which
is now not needed as setup_timer does that.

Thanks,
NeilBrown
