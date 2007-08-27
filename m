From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: Raid5 Reshape gone wrong, please help
Date: Mon, 27 Aug 2007 09:42:28 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E52025B0F20@azsmsx413.amr.corp.intel.com>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com><18118.46141.966406.577626@notabene.brown><c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com><18120.9950.578786.624453@notabene.brown><c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com><c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com><c92bcddf0708201909w2534c25du6282fd661ed838f5@mail.gmail.com><c92bcddf0708230804g2e3fb7ev4e5d1a13814d4d0f@mail.gmail.com> <18130.44566.69917.341927@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <18130.44566.69917.341927@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Greg Nicholson <d0gz.net@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: Neil Brown [mailto:neilb@suse.de]
> On Thursday August 23, d0gz.net@gmail.com wrote:
> > <Trimming tons of detail, but keeping the thread>
> >
> > OK.... I've reproduced the original issue on a seperate box.
> > 2.6.23-rc3 does not like to grow Raid 5 arrays.  MDadm 2.6.3
> 
> No, you are right. It doesn't.
> 
> Obviously insufficient testing and review - thanks for find it for us.
> 
Agreed - seconded.

> This patch seems to make it work - raid5 and raid6.
> 
> Dan: Could you check it for me, particularly the moving of
> +		async_tx_ack(tx);
> +		dma_wait_for_async_tx(tx);
> outside of the loop.
> 
Yes, this definitely needs to be outside the loop.

> Greg: could you pleas check it works for you too - it works for me,
> but double-testing never hurts.
> 
> Thanks again,
> 
> NeilBrown
> 
> 
> 
> ---------------------------------
> Fix some bugs with growing raid5/raid6 arrays.
> 
> 
> 
> ### Diffstat output
>  ./drivers/md/raid5.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
> --- .prev/drivers/md/raid5.c	2007-08-24 16:36:22.000000000 +1000
> +++ ./drivers/md/raid5.c	2007-08-27 20:50:57.000000000 +1000
> @@ -2541,7 +2541,7 @@ static void handle_stripe_expansion(raid
>  	struct dma_async_tx_descriptor *tx = NULL;
>  	clear_bit(STRIPE_EXPAND_SOURCE, &sh->state);
>  	for (i = 0; i < sh->disks; i++)
> -		if (i != sh->pd_idx && (r6s && i != r6s->qd_idx)) {
> +		if (i != sh->pd_idx && (!r6s || i != r6s->qd_idx)) {
>  			int dd_idx, pd_idx, j;
>  			struct stripe_head *sh2;
> 
> @@ -2574,7 +2574,8 @@ static void handle_stripe_expansion(raid
>  			set_bit(R5_UPTODATE, &sh2->dev[dd_idx].flags);
>  			for (j = 0; j < conf->raid_disks; j++)
>  				if (j != sh2->pd_idx &&
> -				    (r6s && j != r6s->qd_idx) &&
> +				    (!r6s || j !=
raid6_next_disk(sh2->pd_idx,
> +
sh2->disks)) &&
>  				    !test_bit(R5_Expanded,
&sh2->dev[j].flags))
>  					break;
>  			if (j == conf->raid_disks) {
> @@ -2583,12 +2584,12 @@ static void handle_stripe_expansion(raid
>  			}
>  			release_stripe(sh2);
> 
> -			/* done submitting copies, wait for them to
complete */
> -			if (i + 1 >= sh->disks) {
> -				async_tx_ack(tx);
> -				dma_wait_for_async_tx(tx);
> -			}
>  		}
> +	/* done submitting copies, wait for them to complete */
> +	if (tx) {
> +		async_tx_ack(tx);
> +		dma_wait_for_async_tx(tx);
> +	}
>  }
> 
>  /*
> @@ -2855,7 +2856,7 @@ static void handle_stripe5(struct stripe
>  		sh->disks = conf->raid_disks;
>  		sh->pd_idx = stripe_to_pdidx(sh->sector, conf,
>  			conf->raid_disks);
> -		s.locked += handle_write_operations5(sh, 0, 1);
> +		s.locked += handle_write_operations5(sh, 1, 1);
How about for clarity:
	s.locked += handle_write_operations5(sh, RECONSTRUCT_WRITE, 1);

>  	} else if (s.expanded &&
>  		!test_bit(STRIPE_OP_POSTXOR, &sh->ops.pending)) {
>  		clear_bit(STRIPE_EXPAND_READY, &sh->state);

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
