From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC][PATCH 002 of 3] MD Acceleration: md_adma driver for raid5 offload
Date: Fri, 3 Feb 2006 11:15:22 +0300
Message-ID: <20060203081521.GB3434@2ka.mipt.ru>
References: <1138929179.20036.44.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1138929179.20036.44.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Hello, Dan.

Couple of comments.

On Thu, Feb 02, 2006 at 06:12:59PM -0700, Dan Williams (dan.j.williams@intel.com) wrote:

...
> +/*
> + * Issue a copy data operation between a page in the stripe cache, and a bio.
> + * There are no alignment or size guarantees between the page or the
> + * bio except that there is some overlap.
> + * All iovecs in the bio must be considered.
> + *
> + * Assumes being called under sh->lock
> + * 
> + * @dev_idx: the raid device index that is being modified
> + * 
> + * Returns true if the copy is complete, returns false if copy is asynchronous
> + */
> +int md_issue_copy_data(int frombio, struct bio *bio,
> +		     struct page *page, sector_t sector,
> +		     struct stripe_head *sh, int dev_idx)
> +{
> +	char *pa = page_address(page);
> +	struct bio_vec *bvl;
> +	int i, desc_cnt = 0, pio = 0;
> +	int page_offset;
> +	void *buf[2];
> +	adma_engine_t *eng = sh->raid_conf->adma_engine;
> +	adma_desc_t *desc = adma_get_desc(eng), *next_desc = 0;
> +
> +	if(!test_bit(ADMA_ENG_CAP_COPY, &eng->flags))
> +		pio++;
> +
> +	if (bio->bi_sector >= sector)
> +		page_offset = (signed)(bio->bi_sector - sector) * 512;
> +	else
> +		page_offset = (signed)(sector - bio->bi_sector) * -512;
> +	bio_for_each_segment(bvl, bio, i) {
> +		int len = bio_iovec_idx(bio,i)->bv_len;
> +		int clen;
> +		int b_offset = 0;
> +
> +		if (page_offset < 0) {
> +			b_offset = -page_offset;
> +			page_offset += b_offset;
> +			len -= b_offset;
> +		}
> +
> +		if (len > 0 && page_offset + len > STRIPE_SIZE)
> +			clen = STRIPE_SIZE - page_offset;
> +		else clen = len;
> +			
> +		if (clen > 0) {
> +			char *ba = __bio_kmap_atomic(bio, i, KM_USER0);
> +
> +			if (desc_cnt) {
> +				eng->queue_desc(desc, MD_ADMA_QUEUE);
> +				next_desc = adma_get_desc(eng);
> +				if (next_desc) adma_set_desc_flags(desc, ADMA_AUTO_REAP);
> +			}
> +
> +			if (frombio) {
> +				buf[0] = pa+page_offset;
> +				buf[1] = ba+b_offset;
> +			} else {
> +				buf[0] = ba+b_offset;
> +				buf[1] = pa+page_offset;
> +			}
> +
> +			if (pio) goto pio_memcpy;
> +
> +			/* if the adma engine can not access the bio page directly
> +			 * (pio_adma on highmem platforms or dma address restrictions) 
> +			 * then we must copy synchronously.
> +			 * i.e. we can't / shouldn't hold a true atomic mapping while the
> +			 * adma_engine performs an asynchronous memcpy
> +			 */
> +			#ifdef CONFIG_HIGHMEM
> +			if(!test_bit(ADMA_ENG_CAP_HIGHMEM, &eng->flags))
> +				goto pio_memcpy;
> +			#endif
> +
> +
> +			/* handle memory allocation failures:
> +			 * if we fail to allocate the necessary structures then
> +			 * (re)do everything as a pio memcpy.  If some descriptors have
> +			 * already been successfully queued then we need to run
> +			 * the adma thread to get them cleaned up
> +			 */
> +			if (unlikely(!desc || (desc_cnt && !next_desc))) {
> +				if (desc_cnt) {
> +					/* we run the thread directly since we are not 
> +					 * preemptible
> +					 */
> +					adma_run(eng);
> +					/* we busy wait on prev_desc so
> +					 * that the pio operation does not
> +					 * conflict with the engine.
> +					 */
> +					adma_spin_wait_desc(desc);
> +					adma_put_desc(desc);
> +					desc_cnt = 0;
> +				} else if (desc) /* we don't have args, and never will */
> +					adma_put_desc(desc);
> +				 
> +				goto pio_memcpy;
> +			}
> +
> +			if (desc_cnt) {
> +				desc = next_desc;
> +				next_desc = NULL;
> +			}
> +
> +			eng->build_desc(desc, ADMA_COPY, buf, ARRAY_SIZE(buf), clen, 0);
> +			desc_cnt++;
> +			continue;

It looks like if pio mode is not enabled and memory allocation
succeds bio mapping is leaked?

> +
> +pio_memcpy:		pio++;
> +			memcpy(buf[0], buf[1], clen);
> +			__bio_kunmap_atomic(ba, KM_USER0);
> +
> +		}
> +		if (clen < len) /* hit end of page */
> +			break;
> +		page_offset +=  len;
> +	}
> +	
> +	if (desc) { /* queue and run the final descriptor */
> +		adma_set_desc_flags(desc, 0);
> +		adma_set_callback(desc, md_adma_copy_data_callback, sh, dev_idx);
> +		eng->queue_desc(desc, MD_ADMA_QUEUE);
> +		if(!frombio) { /* we are reading so client expects data immediately */
> +			adma_run(eng);
> +			adma_spin_wait_desc(desc);
> +		} else adma_wakeup_thread(eng->thread);
> +	} else if (pio) 
> +		__md_adma_copy_data_callback(sh, dev_idx);
> +
> +	return pio;
> +}
> +
> +#define check_xor() do {						    \
> +if (likely(desc))							    \
> +	 max_sources = adma_get_source_count(eng);			    \
> +else									    \
> +	 max_sources = MAX_XOR_BLOCKS;					    \
> +if (count == max_sources || last || mid) {				    \
> +	if (desc) {							    \
> +		eng->build_desc(desc, ADMA_XOR, ptr, count, STRIPE_SIZE, 0);\
> +		if (last) {						    \
> +			adma_set_callback(desc, raid5_adma_xor_callback, sh, method);\
> +			next_desc = NULL;				    \
> +		} else {						    \
> +			next_desc = adma_get_desc(eng);			    \
> +			if (likely(next_desc))				    \
> +				adma_set_desc_flags(desc, ADMA_AUTO_REAP);  \
> +		}							    \
> +		eng->queue_desc(desc, last ? 1 : MD_ADMA_QUEUE);	    \
> +		if (likely(!last) && unlikely(!next_desc)) {		    \
> +			adma_run(eng);					    \
> +			adma_spin_wait_desc(desc);			    \
> +			adma_put_desc(desc);				    \
> +      		}							    \
> +      		desc = last ? desc : next_desc;				    \
> +	} else xor_block(count, STRIPE_SIZE, ptr);			    \
> +	count = 1;							    \
> +}									    \
> +} while(0)


Ugh...
Maybe better to place such a macro into inline function?

-- 
	Evgeniy Polyakov
