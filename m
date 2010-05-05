From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH v2 1/1] md/raid6: Fix raid-6 read-error correction in
 degraded state
Date: Thu, 6 May 2010 07:02:56 +1000
Message-ID: <20100506070256.11f2dcda@notabene.brown>
References: <4BE1C461.6000503@logicschema.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE1C461.6000503@logicschema.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Gabriele A. Trombetti" <g.trombetti.lkrnl1213@logicschema.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Janos Haar <janos.haar@netcenter.hu>
List-Id: linux-raid.ids


Thanks.  This is now in my queue.
I may even submit it for .34 as that doesn't seem as close as I thought.

NeilBrown


On Wed, 05 May 2010 21:17:53 +0200
"Gabriele A. Trombetti" <g.trombetti.lkrnl1213@logicschema.com> wrote:

> Fix: md raid-6 was not trying to correct a read-error when in 
> singly-degraded state and was instead dropping one more device, going to 
> doubly-degraded state. This patch fixes this behaviour.
> 
> Tested-by: Janos Haar <janos.haar@netcenter.hu>
> Signed-off-by: Gabriele A. Trombetti <g.trombetti.lkrnl1213@logicschema.com>
> Reported-by: Janos Haar <janos.haar@netcenter.hu>
> --------
> --- linux-2.6.34-rc5-git8-vanilla/drivers/md/raid5.c    2010-04-28 
> 13:05:03.000000000 +0200
> +++ linux-2.6.34-rc5-git8/drivers/md/raid5.c    2010-04-28 
> 13:08:15.000000000 +0200
> @@ -1527,7 +1527,7 @@ static void raid5_end_read_request(struc
> 
>                  clear_bit(R5_UPTODATE, &sh->dev[i].flags);
>                  atomic_inc(&rdev->read_errors);
> -               if (conf->mddev->degraded)
> +               if (conf->mddev->degraded >= conf->max_degraded)
>                          printk_rl(KERN_WARNING
>                                    "raid5:%s: read error not correctable "
>                                    "(sector %llu on %s).\n",
> 
> ---------------------------------------------------------------
> 
> Resending patch:
> v2: added "Tested-by" line, subsystem mentioned in summary line, body 
> explanation mentions "md"
> 
> Thanks,
> Gabriele A. Trombetti

