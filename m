From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Date: Wed, 21 Feb 2007 15:58:20 -0800
Message-ID: <20070221155820.de9f2f16.akpm@linux-foundation.org>
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
	<20070221144806.e6eed85c.akpm@linux-foundation.org>
	<E1HK10Y-0001MY-CB@flower>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1HK10Y-0001MY-CB@flower>
Sender: linux-raid-owner@vger.kernel.org
To: Oleg Verych <olecom@flower.upol.cz>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Feb 2007 00:36:22 +0100
Oleg Verych <olecom@flower.upol.cz> wrote:

> > From: Andrew Morton
> > Newsgroups: gmane.linux.raid,gmane.linux.kernel
> > Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
> > Date: Wed, 21 Feb 2007 14:48:06 -0800
> 
> Hallo.
> 
> > On Tue, 20 Feb 2007 17:35:16 +1100
> > NeilBrown <neilb@suse.de> wrote:
> >
> >> +		for (i = conf->raid_disks ; i-- ;  ) {
> >
> > That statement should be dragged out, shot, stomped on then ceremonially
> > incinerated.
> >
> > What's wrong with doing
> >
> > 	for (i = 0; i < conf->raid_disks; i++) {
> >
> > in a manner which can be understood without alcoholic fortification?
> >
> > ho hum.
> 
> In case someone likes to do job, GCC usually ought to do, i would
> suggest something like this instead:
> 
>        if (expanded && test_bit(STRIPE_EXPANDING, &sh->state)) {
>                /* Need to write out all blocks after computing P&Q */
> -               sh->disks = conf->raid_disks;
> +	       	i = conf->raid_disks;
> +		sh->disks = i;
> -               sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
> -                                            conf->raid_disks);
> +               sh->pd_idx = stripe_to_pdidx(sh->sector, conf, i);
> 
>                compute_parity6(sh, RECONSTRUCT_WRITE);
> -               for (i = conf->raid_disks ; i-- ;  ) {
> +		do {
>                        set_bit(R5_LOCKED, &sh->dev[i].flags);
>                        locked++;
>                        set_bit(R5_Wantwrite, &sh->dev[i].flags);
> -               }
> +		} while (--i);
> 
>                clear_bit(STRIPE_EXPANDING, &sh->state);
>        } else if (expanded) {
> 
> In any case this is subject of scripts/bloat-o-meter.

This:

--- a/drivers/md/raid5.c~a
+++ a/drivers/md/raid5.c
@@ -2364,7 +2364,7 @@ static void handle_stripe6(struct stripe
 		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
 					     conf->raid_disks);
 		compute_parity6(sh, RECONSTRUCT_WRITE);
-		for (i = conf->raid_disks ; i-- ;  ) {
+		for (i = 0; i < conf->raid_disks; ++) {
 			set_bit(R5_LOCKED, &sh->dev[i].flags);
 			locked++;
 			set_bit(R5_Wantwrite, &sh->dev[i].flags);
_

reduces the size of drivers/md/raid5.o's .text by two bytes.


