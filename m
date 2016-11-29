From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 2/2] raid5-cache: don't set STRIPE_R5C_PARTIAL_STRIPE
 flag while load stripe into cache
Date: Tue, 29 Nov 2016 11:55:20 -0800
Message-ID: <20161129195520.p7b56glrupfpnw6j@kernel.org>
References: <1480129034-14700-1-git-send-email-liuzhengyuan@kylinos.cn>
 <1480129034-14700-2-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480129034-14700-2-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: shli@fb.com, songliubraving@fb.com, neilb@suse.com, linux-raid@vger.kernel.org, liuyun01@kylinos.cn
List-Id: linux-raid.ids

On Sat, Nov 26, 2016 at 10:57:14AM +0800, Zhengyuan Liu wrote:
> r5c_recovery_load_one_stripe should not set STRIPE_R5C_PARTIAL_STRIPE flag,as
> the data-only stripe may be STRIPE_R5C_FULL_STRIPE stripe. The state machine
> would release the stripe later and add it into neither r5c_cached_full_stripes
> list or r5c_cached_partial_stripes list and set correct flag. Also we should
> fix the counter corresponding.
> 
> Reviewed-by: JackieLiu <liuyun01@kylinos.cn>
> Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c |  3 +--
>  drivers/md/raid5.c       | 11 +++++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9911164..e0ac758 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1930,9 +1930,8 @@ static void r5c_recovery_load_one_stripe(struct r5l_log *log,
>  			set_bit(R5_UPTODATE, &dev->flags);
>  		}
>  	}
> -	set_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state);
> -	atomic_inc(&conf->r5c_cached_partial_stripes);
>  	list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
> +	atomic_inc(&log->stripe_in_journal_count);
>  }

Applied this part and discarded the latter. Thanks!
 
>  /*
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dbab8c7..8120ce4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -677,12 +677,23 @@ raid5_get_active_stripe(struct r5conf *conf, sector_t sector,
>  					atomic_inc(&conf->active_stripes);
>  				BUG_ON(list_empty(&sh->lru) &&
>  				       !test_bit(STRIPE_EXPANDING, &sh->state));
> +
>  				inc_empty_inactive_list_flag = 0;
>  				if (!list_empty(conf->inactive_list + hash))
>  					inc_empty_inactive_list_flag = 1;
>  				list_del_init(&sh->lru);
>  				if (list_empty(conf->inactive_list + hash) && inc_empty_inactive_list_flag)
>  					atomic_inc(&conf->empty_inactive_list_nr);
> +
> +				if (test_and_clear_bit(STRIPE_R5C_PARTIAL_STRIPE, &sh->state)) {
> +					WARN_ON(atomic_read(&conf->r5c_cached_partial_stripes) == 0);
> +					atomic_dec(&conf->r5c_cached_partial_stripes);
> +				}
> +				if (test_and_clear_bit(STRIPE_R5C_FULL_STRIPE, &sh->state)) {
> +					WARN_ON(atomic_read(&conf->r5c_cached_full_stripes) == 0);
> +					atomic_dec(&conf->r5c_cached_full_stripes);
> +				}
> +
>  				if (sh->group) {
>  					sh->group->stripes_cnt--;
>  					sh->group = NULL;
> -- 
> 2.7.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
