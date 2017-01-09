From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/1] md/raid5: Use correct IS_ERR() variation on pointer
 check
Date: Mon, 9 Jan 2017 13:34:12 -0800
Message-ID: <20170109213412.we7sxcivzbaiyb3i@kernel.org>
References: <20170107003135.8276-1-Jes.Sorensen@redhat.com>
 <20170107003135.8276-2-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170107003135.8276-2-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 06, 2017 at 07:31:35PM -0500, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This fixes a build error on certain architectures, such as ppc64.

Yep, we should use IS_ERR here, applied this. I'm curious why there is a
compile error. The IS_ERR_VALUE casts the pointer to 'unsigned long'.

Thanks,
Shaohua
> Fixes: 6995f0b247e("md: takeover should clear unrelated bits")
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 06d7279..0e0646b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7829,7 +7829,7 @@ static void *raid5_takeover_raid1(struct mddev *mddev)
>  	mddev->new_chunk_sectors = chunksect;
>  
>  	ret = setup_conf(mddev);
> -	if (!IS_ERR_VALUE(ret))
> +	if (!IS_ERR(ret))
>  		clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
>  	return ret;
>  }
> -- 
> 2.9.3
> 
