From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 002 of 2] md: Make sure bi_max_vecs is set properly in bio_split
Date: Mon, 22 May 2006 09:02:50 +0200
Message-ID: <20060522070249.GC4216@suse.de>
References: <20060522161259.2792.patches@notabene> <1060522061855.2861@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060522061855.2861@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Don Dupuis <dondster@gmail.com>
List-Id: linux-raid.ids

On Mon, May 22 2006, NeilBrown wrote:
> 
> Else a subsequence bio_clone might make a mess.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> Cc: "Don Dupuis" <dondster@gmail.com>
> Cc: Jens Axboe <axboe@suse.de>
> ### Diffstat output
>  ./fs/bio.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff ./fs/bio.c~current~ ./fs/bio.c
> --- ./fs/bio.c~current~	2006-05-22 16:12:46.000000000 +1000
> +++ ./fs/bio.c	2006-05-22 16:12:16.000000000 +1000
> @@ -1103,6 +1103,9 @@ struct bio_pair *bio_split(struct bio *b
>  	bp->bio1.bi_io_vec = &bp->bv1;
>  	bp->bio2.bi_io_vec = &bp->bv2;
>  
> +	bp->bio1.bi_max_vecs = 1;
> +	bp->bio2.bi_max_vecs = 1;
> +
>  	bp->bio1.bi_end_io = bio_pair_end_1;
>  	bp->bio2.bi_end_io = bio_pair_end_2;
>  

Obviously correct, thanks Neil.

-- 
Jens Axboe

