From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] md: introduce bio_clone_slow_mddev_partial()
Date: Mon, 6 Feb 2017 00:52:59 -0800
Message-ID: <20170206085259.GA6411@infradead.org>
References: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
 <1486275733-7268-3-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486275733-7268-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

> +struct bio *bio_clone_slow_mddev_partial(struct bio *bio, gfp_t gfp_mask,
> +					 struct mddev *mddev, int offset,
> +					 int size)
> +{
> +	struct bio_set *bs;
> +
> +	if (!mddev || !mddev->bio_set)
> +		bs = fs_bio_set;
> +	else
> +		bs = mddev->bio_set;
> +
> +	return bio_clone_bioset_partial(bio, gfp_mask, bs, offset << 9,
> +					size << 9);
> +}
> +EXPORT_SYMBOL_GPL(bio_clone_slow_mddev_partial);

As far as I can tell the caller always has a mddev, and an active
mddev always has a bio_set.  So let's just skip this wrapper.
