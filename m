From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [RFC][PATCH 001 of 3] MD Acceleration: Base ADMA interface
Date: Fri, 3 Feb 2006 11:19:59 +0300
Message-ID: <20060203081958.GC3434@2ka.mipt.ru>
References: <1138929154.20036.43.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1138929154.20036.43.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Chris Leech <christopher.leech@intel.com>, "Grover, Andrew" <andrew.grover@intel.com>, Deepak Saxena <dsaxena@plexity.net>
List-Id: linux-raid.ids

Trivial locking comment.
Selected functions below (adma_queue_desc() and adma_run()) protects
list of descriptor manipulations by only simple lock.
If it is possible to queue descriptors from interrupt/bh context,
locking should be changed.

On Thu, Feb 02, 2006 at 06:12:34PM -0700, Dan Williams (dan.j.williams@intel.com) wrote:

> +/* add descriptor to the process list and conditionally initiate operations */
> +void adma_queue_desc(adma_desc_t *desc, int wake)
> +{
> +	adma_engine_t *eng = desc->engine;
> +
> +	spin_lock(&eng->lock);
> +	list_add_tail(&desc->chain, &eng->desc_chain);
> +	atomic_inc(&eng->ops_pending);

This counter is never used actually...

> +	spin_unlock(&eng->lock);
> +
> +	if (wake) adma_wakeup_thread(eng->thread);
> +
> +	dump_desc(desc);
> +}

...

> +
> +/*
> + * This thread churns through the descriptor chain
> + * Runs the command and if necessary calls the callback function.
> + * Note: This thread makes pio_adma_engine assumptions for now
> + */
> +void adma_run(adma_engine_t *eng)
> +{
> +	adma_desc_t *desc, *prev_desc;
> +	int op = 0;
> +
> +	while(1) {
> +		struct list_head *first;
> +
> +		spin_lock(&eng->lock);
> +		if (list_empty(&eng->desc_chain))
> +			break;
> +
> +		first = eng->desc_chain.next;
> +
> +		/* will be used to satisfy ordering requirements for adma
> +		 * engines that process copy and xor operatations on different
> +		 * channels 
> +		 */ 
> +		prev_desc = op++ ? desc : NULL;
> +		desc = list_entry(first, adma_desc_t, chain);
> +		dump_desc(desc);
> +
> +		list_del_init(first);
> +
> +		atomic_dec(&eng->ops_pending);
> +		spin_unlock(&eng->lock);


If ops_pending could be used as engine's reference counter, it should
not be dropped here, but it looks like it is unused.

> +		switch(desc->command) {
> +			case ADMA_COPY:
> +				eng->cpy_op(desc->buf[0], desc->buf[1], desc->len);
> +				break;
> +			case ADMA_SET:
> +				eng->set_block_op(desc->sources, desc->len, desc->buf, desc->pattern);
> +				break;
> +			case ADMA_COMPARE:
> +				if (eng->cmp_op(desc->buf[0], 
> +				    desc->buf[1], 
> +				    desc->len))
> +					set_bit(ADMA_STAT_CMP, &desc->flags);
> +				else
> +					clear_bit(ADMA_STAT_CMP, &desc->flags);
> +				break;
> +			case ADMA_XOR:
> +				eng->xor_block_op(desc->sources, desc->len, desc->buf);
> +				break;
> +			case ADMA_PQXOR:
> +				printk("%s: Error ADMA_PQXOR not yet implemented\n", __FUNCTION__);
> +				BUG();
> +				break;
> +		}
> +		adma_check_status(desc);
> +
> +		if(desc->callback)
> +			desc->callback(desc, desc->args);
> +		else if(test_bit(ADMA_AUTO_REAP, &desc->flags)) {
> +			BUG_ON(desc->args != NULL);
> +			adma_put_desc(desc);
> +		}
> +	}
> +	spin_unlock(&eng->lock);
> +}
> +
> +static int adma_thread(void * arg)
> +{
> +	adma_thread_t *thread = arg;
> +
> +	/*
> +	 * This thread handles:
> +	 *	> issuing descriptors to an adma engine
> +	 *	> maintaining order between dependent operations
> +	 *	> garbage collecting descriptor resources (upon request)
> +	 *	> running the pio version of an operation when underlying
> +	 *	  hardware support is not present
> +	 */
> +
> +	allow_signal(SIGKILL);
> +	while (!kthread_should_stop()) {
> +
> +		/* We need to wait INTERRUPTIBLE so that
> +		 * we don't add to the load-average.
> +		 * That means we need to be sure no signals are
> +		 * pending
> +		 */
> +		if (signal_pending(current))
> +			flush_signals(current);
> +
> +		wait_event_interruptible_timeout
> +			(thread->wqueue,
> +			 test_bit(THREAD_WAKEUP, &thread->flags)
> +			 || kthread_should_stop(),
> +			 thread->timeout);
> +		try_to_freeze();
> +
> +		clear_bit(THREAD_WAKEUP, &thread->flags);
> +
> +		thread->run(thread->eng);
> +	}
> +
> +	return 0;
> +}

-- 
	Evgeniy Polyakov
