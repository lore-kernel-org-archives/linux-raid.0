From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Mon, 19 Nov 2012 18:23:57 -0800
Message-ID: <1353378237.26735.11.camel@localhost.localdomain>
References: <20121119120632.1c97e306@notabene.brown>
	 <84A937D219C2B44EB8EA44831ACA1E49166C741F@SC-MBX02-3.TheFacebook.com>
	 <20121120091824.58ed4565@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121120091824.58ed4565@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
List-Id: linux-raid.ids

On Tue, 2012-11-20 at 09:18 +1100, NeilBrown wrote:
> On Mon, 19 Nov 2012 05:22:25 +0000 Dan Williams <djbw@fb.com> wrote:
> 
> > 
> > 
> > On 11/18/12 5:06 PM, "NeilBrown" <neilb@suse.de> wrote:
> > 
> > >
> > >Hi Dan,
> > > could you comment on this please?  Would it make sense to arrange for
> > >errors
> > > to propagate up?  Or should we arrange to do a software-fallback in the
> > >dma
> > > engine is a problem?  What sort of things can cause error here anyway?
> > 
> > Propagating up is missing reliable "dma abort" operation.
> > 
> > In these cases the engine failed to complete due to hardware hang / driver
> > bug, or has hit a memory error (uncorrectable even with software
> > fallback).  This originally should have been using async_tx_quiesce()
> > which also does the panic.
> > 
> > The engines that I have worked with have either lacked support for
> > aborting, or were otherwise unable to recover from a hardware hang.
> > However, for engines that do support error recovery they should be able to
> > hide the failure from the upper layers.
> >
> 
> So maybe I could:
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ac09fa4..ffbf0ca 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3268,7 +3268,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
>  	/* done submitting copies, wait for them to complete */
>  	if (tx) {
>  		async_tx_ack(tx);
> -		dma_wait_for_async_tx(tx);
> +		async_tx_quiesce(&tx);
>  	}
>  }
>  
> 
> 
> and then the panic would be somebody else's problem?
> 
> I note that handle_stripe_expansion has:
> 
>  		async_tx_ack(tx);
> 		dma_wait_for_async_tx(tx);
> 
> while async_tx_quiesce() has:
> 
> 		if (dma_wait_for_async_tx(*tx) == DMA_ERROR)
> 			panic("DMA_ERROR waiting for transaction\n");
> 		async_tx_ack(*tx);
> 
> 
> i.e. the same two functions called in the reverse order.  Is the order
> important?  Is handle_stripe_expansion wrong?   Should the patch I apply
> actually be:
> 
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ac09fa4..e51d903 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3266,10 +3266,7 @@ static void handle_stripe_expansion(struct r5conf *conf, struct stripe_head *sh)
>  
>  		}
>  	/* done submitting copies, wait for them to complete */
> -	if (tx) {
> -		async_tx_ack(tx);
> -		dma_wait_for_async_tx(tx);
> -	}
> +	async_tx_quiesce(&tx);
>  }
>  

Yes, this one, handles it like the other cases of needing to do a
synchronous wait and does not care if tx is NULL.

--
Dan
