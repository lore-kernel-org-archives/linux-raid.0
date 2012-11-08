From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Thu, 8 Nov 2012 11:15:26 +0000
Message-ID: <20121108111526.40c705a0@pyramind.ukuu.org.uk>
References: <201211081106.29980.b.zolnierkie@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211081106.29980.b.zolnierkie@samsung.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
List-Id: linux-raid.ids

On Thu, 08 Nov 2012 11:06:29 +0100
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:

> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
> 
> There is not much we can do on dma_wait_for_async_tx() error
> so just panic() for now.
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/md/raid5.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/md/raid5.c
> ===================================================================
> --- a/drivers/md/raid5.c	2012-11-07 16:25:19.480876012 +0100
> +++ b/drivers/md/raid5.c	2012-11-07 16:27:46.244875992 +0100
> @@ -3223,7 +3223,9 @@ static void handle_stripe_expansion(stru
>  	/* done submitting copies, wait for them to complete */
>  	if (tx) {
>  		async_tx_ack(tx);
> -		dma_wait_for_async_tx(tx);
> +		if (dma_wait_for_async_tx(tx) != DMA_SUCCESS)
> +			panic("%s: DMA error waiting for transaction\n",
> +			      __func__);

Thats a really horrible place to panic.

Alan
