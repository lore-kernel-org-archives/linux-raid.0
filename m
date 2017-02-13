From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 2/5] md/raid1: use bio_clone_bioset_partial() in case
 of write behind
Date: Mon, 13 Feb 2017 05:48:22 -0800
Message-ID: <20170213134822.GC22818@infradead.org>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
 <1486724177-14817-3-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486724177-14817-3-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

> +		struct bio *mbio = NULL;
> +		int offset;
>  		if (!r1_bio->bios[i])
>  			continue;
>  
> -		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
> -		bio_trim(mbio, r1_bio->sector - bio->bi_iter.bi_sector,
> -			 max_sectors);
> +		offset = r1_bio->sector - bio->bi_iter.bi_sector;

I think offset should be a sector_t.

Otherwise this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
