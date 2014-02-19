From: Lars Ellenberg <lars@linbit.com>
Subject: Re: [PATCH] bcache: fix NULL pointer deref in blk_add_request_payload
Date: Wed, 19 Feb 2014 14:18:58 +0100
Message-ID: <20140219131857.GC32062@soda.linbit>
References: <1392815234-27015-1-git-send-email-lars@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392815234-27015-1-git-send-email-lars@linbit.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: Neil Brown <neilb@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 19, 2014 at 01:07:14PM +0000, Lars Ellenberg wrote:
> bch_generic_make_request_hack() tries to be smart,
> and fake a bi_max_bvecs = bi_vcnt.

I meant to include a cover letter with the Oops backtrace,
and this:

Note that this patch is relevant for 3.13 and before.

With 3.14,
this whole bch_generic_make_request_hack() function has been dropped already.

Thanks,

	Lars

> If those bios have been REQ_DISCARD, and get submitted to a driver
> (md raid) that uses bio_clone, the clone will end up with bi_io_vec == NULL,
> passed down the stack, end up in sd_prep_fn and blk_add_request_payload,
> which then tries to use bio->bi_io_vec->page.
> 
> Fix: try to be even smarter in bch_generic_make_request_hack(),
> and always pretend to have at least bi_max_vecs of 1,
> unless the incoming bio was already created without a single bvec.
> 
> Signed-off-by: Lars Ellenberg <lars@linbit.com>
> ---
>  drivers/md/bcache/io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> index 9056632..a638ac6 100644
> --- a/drivers/md/bcache/io.c
> +++ b/drivers/md/bcache/io.c
> @@ -47,7 +47,7 @@ static void bch_generic_make_request_hack(struct bio *bio)
>  	 *
>  	 * To be taken out once immutable bvec stuff is in.
>  	 */
> -	bio->bi_max_vecs = bio->bi_vcnt;
> +	bio->bi_max_vecs = bio->bi_vcnt ?: (bio->bi_io_vec ? 1 : 0);
>  
>  	generic_make_request(bio);
>  }
> -- 
> 1.7.10.4
