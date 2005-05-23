From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] bio: set bi_idx after bio cloning
Date: Mon, 23 May 2005 09:31:32 +0200
Message-ID: <20050523073131.GD9855@suse.de>
References: <1116020307.6557.34.camel@langvan2.homenetwork> <17029.13146.794856.708018@cse.unsw.edu.au> <1116257122.15450.6.camel@langvan2.homenetwork>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1116257122.15450.6.camel@langvan2.homenetwork>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Tran <mhtran@us.ibm.com>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 16 2005, Mike Tran wrote:
> 
> Hi Jens,
> 
> Unless you have specific reason for not doing in __bio_clone(), I agree
> with Neil's suggestion.  Please consider the following patch:
> 
> --- linux-2.6.12-rc4-orig/fs/bio.c   2005-05-16 10:13:27.000000000 -0500
> +++ linux-2.6.12-rc4-patch/fs/bio.c   2005-05-16 10:15:06.000000000 -0500
> @@ -255,10 +255,7 @@
>         bio->bi_flags |= 1 << BIO_CLONED;
>         bio->bi_rw = bio_src->bi_rw;
> 
> -       /*
> -        * notes -- maybe just leave bi_idx alone. assume identical mapping
> -        * for the clone
> -        */
> +       bio->bi_idx = bio_src->bi_idx;
>         bio->bi_vcnt = bio_src->bi_vcnt;
>         bio->bi_size = bio_src->bi_size;
>         bio_phys_segments(q, bio);

That patch is fine with me, I'll add it. Thanks.

-- 
Jens Axboe

