From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: introduce polling on bio level
Date: Thu, 30 Jan 2020 22:34:07 -0800
Message-ID: <20200131063407.GB6267@infradead.org>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Sat, Jan 25, 2020 at 09:41:37PM -0700, Andrzej Jakowski wrote:
>  	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
> -		goto not_supported;
> +		if (!(bio->bi_opf & REQ_HIPRI))
> +			goto not_supported;

Can you explain this check?  This looks weird to me  I think we need
a generalized check if a make_request based driver supports REQ_NOWAIT
instead (and as a separate patch / patchset).

> +	if (q->bio_poll_fn != NULL) {
> +		state = current->state;
> +		do {
> +			int ret;
> +
> +			ret = q->bio_poll_fn(q, cookie);
> +			if (ret > 0) {
> +				__set_current_state(TASK_RUNNING);
> +				return ret;
> +			}
> +
> +			if (signal_pending_state(state, current))
> +				__set_current_state(TASK_RUNNING);
> +
> +			if (current->state == TASK_RUNNING)
> +				return 1;
> +			if (ret < 0 || !spin)
> +				break;
> +			cpu_relax();
> +		} while (!need_resched());
> +
> +		__set_current_state(TASK_RUNNING);
> +
> +		return 0;
> +	}

This needs to be factored out into a helper at least.
