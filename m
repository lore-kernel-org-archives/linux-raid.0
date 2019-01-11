From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH] drivers/md.c: Make bio_alloc_mddev return
 bio_alloc_bioset
Date: Fri, 11 Jan 2019 00:17:42 -0200
Message-ID: <20190111021740.GB1228567@bebop>
References: <20181222100845.566772-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181222100845.566772-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

ping?

On Sat, Dec 22, 2018 at 08:08:45AM -0200, Marcos Paulo de Souza wrote:
> bio_alloc_bioset return a bio pointer or NULL, so we can avoid storing
> the returned data into a new variable.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---
>  drivers/md/md.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fc488cb30a94..42e018f014cb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -207,15 +207,10 @@ static bool create_on_open = true;
>  struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
>  			    struct mddev *mddev)
>  {
> -	struct bio *b;
> -
>  	if (!mddev || !bioset_initialized(&mddev->bio_set))
>  		return bio_alloc(gfp_mask, nr_iovecs);
>  
> -	b = bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
> -	if (!b)
> -		return NULL;
> -	return b;
> +	return bio_alloc_bioset(gfp_mask, nr_iovecs, &mddev->bio_set);
>  }
>  EXPORT_SYMBOL_GPL(bio_alloc_mddev);
>  
> -- 
> 2.16.4
> 

-- 
Thanks,
Marcos
