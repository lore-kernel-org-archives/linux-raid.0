From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v2 2/2] md: enable io polling
Date: Wed, 12 Feb 2020 06:13:34 +0900
Message-ID: <20200211211334.GB3837@redsun51.ssa.fujisawa.hgst.com>
References: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
 <20200211191729.4745-3-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200211191729.4745-3-andrzej.jakowski@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Tue, Feb 11, 2020 at 12:17:29PM -0700, Andrzej Jakowski wrote:
> +static int md_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> +{
> +	struct mddev *mddev = q->queuedata;
> +	struct md_rdev *rdev;
> +	int ret = 0;
> +	int rv;
> +
> +	rdev_for_each(rdev, mddev) {
> +		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
> +			continue;
> +
> +		rv = blk_poll(bdev_get_queue(rdev->bdev), cookie, false);
> +		if (rv < 0) {
> +			ret = rv;
> +			break;
> +		}
> +		ret += rv;
> +	}
> +
> +	return ret;
> +}

I must be missing something: md's make_request_fn always returns
BLK_QC_T_NONE for the cookie, and that couldn't get past blk_poll's
blk_qc_t_valid(cookie) check. How does the initial blk_poll() caller get
a valid cookie for an md backing device's request_queue? And how is the
same cookie valid for more than one request_queue?

Since this is using the same cookie with different request_queues, I'm
really concerned about what happens if you managed to successfully poll
an nvme queue that wasn't designated for polling: blk_qc_t_to_queue_num()
may return a valid poll hctx for one nvme request_queue, but the same
queue_num for a different nvme device may be an IRQ driven context. That
could lead to douple completions and corrupted queues.
