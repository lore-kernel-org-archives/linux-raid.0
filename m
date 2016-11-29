From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH] md/raid5-cache: do not need to set STRIPE_PREREAD_ACTIVE
 repeatedly
Date: Tue, 29 Nov 2016 13:59:03 -0800
Message-ID: <20161129215755.GA69066@songliubrav-mbp.dhcp.thefacebook.com>
References: <20161129035730.12822-1-liuyun01@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161129035730.12822-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: liuzhengyuan@kylinos.cn, linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

On Tue, Nov 29, 2016 at 11:57:30AM +0800, JackieLiu wrote:
> R5c_make_stripe_write_out has set this flag, do not need to set again.
> 
> Signed-off-by: JackieLiu <liuyun01@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 95bd51e..aa89de0 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1247,8 +1247,6 @@ static void r5c_flush_stripe(struct r5conf *conf, struct stripe_head *sh)
>  	atomic_inc(&conf->active_stripes);
>  	r5c_make_stripe_write_out(sh);
>  
> -	if (!test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> -		atomic_inc(&conf->preread_active_stripes);
>  	raid5_release_stripe(sh);
>  }
>  
> -- 
> 2.10.2
> 
> 
> 
Reviewed-by: Song Liu <songliubraving@fb.com>

Thanks for the fix!
Song
