From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Thu, 08 Nov 2012 12:20:55 +0100
Message-ID: <201211081220.55281.b.zolnierkie@samsung.com>
References: <201211081106.29980.b.zolnierkie@samsung.com>
 <20121108111526.40c705a0@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20121108111526.40c705a0@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
List-Id: linux-raid.ids

On Thursday 08 November 2012 12:15:26 Alan Cox wrote:
> On Thu, 08 Nov 2012 11:06:29 +0100
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
> > 
> > There is not much we can do on dma_wait_for_async_tx() error
> > so just panic() for now.
> > 
> > Cc: Neil Brown <neilb@suse.de>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Tomasz Figa <t.figa@samsung.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/md/raid5.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: b/drivers/md/raid5.c
> > ===================================================================
> > --- a/drivers/md/raid5.c	2012-11-07 16:25:19.480876012 +0100
> > +++ b/drivers/md/raid5.c	2012-11-07 16:27:46.244875992 +0100
> > @@ -3223,7 +3223,9 @@ static void handle_stripe_expansion(stru
> >  	/* done submitting copies, wait for them to complete */
> >  	if (tx) {
> >  		async_tx_ack(tx);
> > -		dma_wait_for_async_tx(tx);
> > +		if (dma_wait_for_async_tx(tx) != DMA_SUCCESS)
> > +			panic("%s: DMA error waiting for transaction\n",
> > +			      __func__);
> 
> Thats a really horrible place to panic.

Still it seems better thing to do than silently ignoring errors
and trying to continue operations with inconsistent data.

Unfortunately higher-layers don't support error conditions and
fixing them seems to be non-trivial task.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
