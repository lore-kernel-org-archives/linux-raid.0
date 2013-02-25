From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Re: BUG  - raid 1 deadlock on handle_read_error / wait_barrier
Date: Mon, 25 Feb 2013 09:11:02 -0700
Message-ID: <1361808662.20264.4.camel@148>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	 <20130225094350.4b8ef084@notabene.brown>
	 <20130225110458.2b1b1e2d@notabene.brown>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130225110458.2b1b1e2d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Actually  don't bother.  I think I've found the problem.  It is related to
> pending_count and is easy to fix.
> Could you try this patch please?
> 
> Thanks.
> NeilBrown
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6e5d5a5..fd86b37 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -967,6 +967,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>  		conf->pending_count += plug->pending_cnt;
>  		spin_unlock_irq(&conf->device_lock);
> +		wake_up(&conf->wait_barrier);
>  		md_wakeup_thread(mddev->thread);
>  		kfree(plug);
>  		return;

Running 15 hours now and no sign of the problem, which is 12 hours
longer than it took to trigger the bug in the past.  I'll continue
testing to be sure but I think this patch is a fix.

Thanks for the fast response!

Tregaron Bayly

