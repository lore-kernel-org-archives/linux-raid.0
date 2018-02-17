From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: simplify uninitialization of shrinker
Date: Sat, 17 Feb 2018 12:34:43 -0800
Message-ID: <20180217203443.gzfy3sazukewvps2@kernel.org>
References: <20171223182031.7513-1-akaraliou.dev@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171223182031.7513-1-akaraliou.dev@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 23, 2017 at 09:20:31PM +0300, Aliaksei Karaliou wrote:
> Don't use shrinker.nr_deferred to check whether shrinker was
> initialized or not. Now this check was integrated into
> unregister_shrinker(), so it is safe to call it against
> unregistered shrinker.
> 
> Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>

applied, thanks!
> ---
>  drivers/md/raid5.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5a2a29bd02dd..8f985831b832 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6764,9 +6764,7 @@ static void free_conf(struct r5conf *conf)
>  
>  	log_exit(conf);
>  
> -	if (conf->shrinker.nr_deferred)
> -		unregister_shrinker(&conf->shrinker);
> -
> +	unregister_shrinker(&conf->shrinker);
>  	free_thread_groups(conf);
>  	shrink_stripes(conf);
>  	raid5_free_percpu(conf);
> -- 
> 2.11.0
> 
