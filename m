From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 2/6] md: convert to kvmalloc
Date: Fri, 7 Sep 2018 14:16:10 -0400
Message-ID: <20180907181610.GB29485@kmo-pixel>
References: <20180907165635.8469-1-kent.overstreet@gmail.com>
 <20180907165635.8469-3-kent.overstreet@gmail.com>
 <20180907174942.GB3425@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180907174942.GB3425@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 07, 2018 at 10:49:42AM -0700, Matthew Wilcox wrote:
> On Fri, Sep 07, 2018 at 12:56:31PM -0400, Kent Overstreet wrote:
> > @@ -165,7 +164,7 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
> >  		       struct dma_async_tx_descriptor *tx)
> >  {
> >  	int disks = sh->disks;
> > -	struct page **srcs = flex_array_get(percpu->scribble, 0);
> > +	struct page **srcs = percpu->scribble;
> >  	int count = 0, pd_idx = sh->pd_idx, i;
> >  	struct async_submit_ctl submit;
> >  
> > @@ -196,8 +195,8 @@ ops_run_partial_parity(struct stripe_head *sh, struct raid5_percpu *percpu,
> >  	}
> >  
> >  	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
> > -			  NULL, sh, flex_array_get(percpu->scribble, 0)
> > -			  + sizeof(struct page *) * (sh->disks + 2));
> > +			  NULL, sh, percpu->scribble +
> > +			  sizeof(struct page *) * (sh->disks + 2));
> 
> I think this would read better written as:
> 
> 	init_async_submit(&submit, ASYNC_TX_FENCE|ASYNC_TX_XOR_ZERO_DST, tx,
> 			  NULL, sh, srcs + sh->disks + 2);
> 
> >  static addr_conv_t *to_addr_conv(struct stripe_head *sh,
> >  				 struct raid5_percpu *percpu, int i)
> >  {
> > -	void *addr;
> > -
> > -	addr = flex_array_get(percpu->scribble, i);
> > -	return addr + sizeof(struct page *) * (sh->disks + 2);
> > +	return percpu->scribble + i * percpu->scribble_obj_size +
> > +		sizeof(struct page *) * (sh->disks + 2);
> >  }
> >  
> >  /* return a pointer to the address conversion region of the scribble buffer */
> >  static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
> >  {
> > -	void *addr;
> > -
> > -	addr = flex_array_get(percpu->scribble, i);
> > -	return addr;
> > +	return percpu->scribble + i * percpu->scribble_obj_size;
> >  }
> 
> Perhaps this would be better as ...
> 
>  static struct page **to_addr_page(struct raid5_percpu *percpu, int i)
>  {
> -	void *addr;
> -
> -	addr = flex_array_get(percpu->scribble, i);
> -	return addr;
> +	return percpu->scribble + i * percpu->scribble_obj_size;
>  }
> 
>  static addr_conv_t *to_addr_conv(struct stripe_head *sh,
>  				 struct raid5_percpu *percpu, int i)
>  {
> -	void *addr;
> -
> -	addr = flex_array_get(percpu->scribble, i);
> -	return addr + sizeof(struct page *) * (sh->disks + 2);
> +	return to_addr_page(percpu, i) + sh->disks + 2;
>  }
> 
> 
> The rest looks good.

Need some casts (to void * or addr_conv_t *) but yeah, I suppose that's a bit
cleaner.
