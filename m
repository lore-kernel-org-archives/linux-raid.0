From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 06/13] async_tx: add support for asynchronous GF
 multiplication
Date: Mon, 30 Mar 2009 15:30:12 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8BF23@irsmsx504.ger.corp.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> +		if (unlikely(!tx))
> +			async_tx_quiesce(&depend_tx);
> +
> +		/* spin wait for the preceeding transactions to complete */
> +		while (unlikely(!tx)) {
> +			dma_async_issue_pending(chan);
> +			tx = dma->device_prep_dma_pq(chan, dma_dest,
> +					&dma_src[src_off], pq_src_cnt,
> +					scf, len, dma_flags);
> +		}

I guess the while loop here should be a part of the "if (unlikely(!tx))" section
(just like it is in async_pq_zero_sum() and async_syndrome_zero_sum()).

BTW, how long can we wait for successful device_prep_dma_pq?
Shouldn't there be a timeout breaking the loop if we wait too long?

> +struct dma_async_tx_descriptor *
> +async_pq_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
> +		  unsigned char *scfs, size_t len, enum sum_check_flags *pqres,
> +		  enum async_tx_flags flags,
> +		  struct dma_async_tx_descriptor *depend_tx,
> +		  dma_async_tx_callback cb_fn, void *cb_param)
> +{
> +	struct dma_chan *chan = async_tx_find_channel(depend_tx,
> +						      DMA_PQ_ZERO_SUM,
> +						      &blocks[src_cnt], 2,
> +						      blocks, src_cnt, len);
> +	struct dma_device *device = chan ? chan->device : NULL;
> +	struct dma_async_tx_descriptor *tx = NULL;
> +	enum dma_ctrl_flags dma_flags = cb_fn ? DMA_PREP_INTERRUPT : 0;
> +
> +	BUG_ON(src_cnt < 2);
> +
> +	if (device && src_cnt <= dma_maxpq(device, 0) - 2) {
> +		dma_addr_t dma_src[src_cnt + 2];
> +
> +		dma_flags |= __pq_zero_sum_map_pages(dma_src, src_cnt,
> +						     device->dev, blocks,
> +						     offset, len);
> +		tx = device->device_prep_dma_pqzero_sum(chan, dma_src, src_cnt,
> +							scfs, len, pqres,
> +							dma_flags);
> +
> +		if (unlikely(!tx)) {
> +			async_tx_quiesce(&depend_tx);
> +
> +			while (unlikely(!tx)) {
> +				dma_async_issue_pending(chan);
> +				tx = device->device_prep_dma_pqzero_sum(chan,
> +						dma_src, src_cnt, scfs, len,
> +						pqres, dma_flags);
> +			}
> +		}
> +
> +		async_tx_submit(chan, tx, flags, depend_tx, cb_fn, cb_param);
> +	} else {
> +		struct page *pdest = blocks[src_cnt];
> +		struct page *qdest = blocks[src_cnt + 1];
> +		void *p, *q, *s;
> +
> +		flags &= ~ASYNC_TX_ACK;
> +
> +		spin_lock(&spare_lock);
> +		blocks[src_cnt] = spare_pages[0];
> +		blocks[src_cnt + 1] = spare_pages[1];
> +		tx = async_pq(blocks, offset, src_cnt, scfs, len, flags,
> +			      depend_tx, NULL, NULL);
> +		async_tx_quiesce(&tx);
> +
> +		*pqres = 0;
> +		if (pdest) {
> +			p = page_address(pdest) + offset;
> +			s = page_address(spare_pages[0]) + offset;
> +			*pqres |= !!memcmp(p, s, len) << SUM_CHECK_P;
> +		}
> +
> +		if (qdest) {
> +			q = page_address(qdest) + offset;
> +			s = page_address(spare_pages[1]) + offset;
> +			*pqres |= !!memcmp(q, s, len) << SUM_CHECK_Q;
> +		}
> +		spin_unlock(&spare_lock);
> +
> +		async_tx_sync_epilog(cb_fn, cb_param);
> +	}

Some comments describing asynchronous and synchronous parts division would be good
(just like it is in other functions in this file).

> +struct dma_async_tx_descriptor *
> +async_syndrome_zero_sum(struct page **blocks, unsigned int offset, int src_cnt,
> +			size_t len, enum sum_check_flags *pqres,
> +			enum async_tx_flags flags,
> +			struct dma_async_tx_descriptor *depend_tx,
> +			dma_async_tx_callback cb_fn, void *cb_param)

Most of the code in async_syndrome_zero_sum() is the same as in async_pq_zero_sum().
What about putting it in one common function?

Regards,
Maciej