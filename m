From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 1 of 2 - Use "shedule_timeout(2)" instead of
 yield() as it seems to wait for less time.
Date: Wed, 10 Mar 2004 13:26:35 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16462.31963.71512.109872@notabene.cse.unsw.edu.au>
References: <20040305164342.7205.patches@notabene>
	<E1Az89R-0001su-00@notabene>
	<20040304221621.47dd459f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Thursday March 4
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 4, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > +		schedule_timeout(2);
> 
> Are you sure we want to sleep for 20-30 milliseconds on a 100 Hz
> machine?

I'm not sure it really matters.  This bit of code doesn't trigger very
often.

I'm not unhappy with your version, but I suspect that just
	schedule_timeout(1)
would be ok.  I think I used '2' because there is no lower bound on
how long schedule_timeout(1) will sleep (until the next tick, which
could be anytime - right?).
But on reflection, that doesn't really matter.  As long as it pauses
for a little while at least once in a while, it will give any non-sync
IO a chance, that once that starts happening, resync will
automatically wind back and there won't be a problem anymore.

So I think (and some testing seems to demonstrate) that it doesn't
really matter.  So leave it as it is I guess.

Thank,
NeilBrown


> 
> Wouldn't it be better to do
> 
> diff -puN drivers/md/raid5.c~md-use-schedule_timeout drivers/md/raid5.c
> --- 25/drivers/md/raid5.c~md-use-schedule_timeout	2004-03-04 22:15:14.000000000 -0800
> +++ 25-akpm/drivers/md/raid5.c	2004-03-04 22:15:41.000000000 -0800
> @@ -1409,7 +1409,8 @@ static int sync_request (mddev_t *mddev,
>  		/* make sure we don't swamp the stripe cache if someone else
>  		 * is trying to get access 
>  		 */
> -		yield();
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule_timeout(max(HZ/500, 1));
>  	}
>  	spin_lock(&sh->lock);	
>  	set_bit(STRIPE_SYNCING, &sh->state);
> diff -puN drivers/md/raid6main.c~md-use-schedule_timeout drivers/md/raid6main.c
> --- 25/drivers/md/raid6main.c~md-use-schedule_timeout	2004-03-04 22:15:14.000000000 -0800
> +++ 25-akpm/drivers/md/raid6main.c	2004-03-04 22:15:50.000000000 -0800
> @@ -1571,7 +1571,8 @@ static int sync_request (mddev_t *mddev,
>  		/* make sure we don't swamp the stripe cache if someone else
>  		 * is trying to get access
>  		 */
> -		yield();
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		schedule_timeout(max(HZ/500, 1));
>  	}
>  	spin_lock(&sh->lock);
>  	set_bit(STRIPE_SYNCING, &sh->state);
> 
> _
> 
> ?
