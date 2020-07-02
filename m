From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 01/16] md/raid456: covert macro define of STRIPE_* as
 members of struct r5conf
Date: Thu, 2 Jul 2020 11:15:33 -0700
Message-ID: <CAPhsuW7cSue8BtWhmWMgOTjw42ChTm4cM+gApj_s02rq=YGRkQ@mail.gmail.com>
References: <20200702120628.777303-1-yuyufen@huawei.com> <20200702120628.777303-2-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-2-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> We covert STRIPE_SIZE, STRIPE_SHIFT and STRIPE_SECTORS to stripe_size,
> stripe_shift and stripe_sectors as members of struct r5conf. Then each
> raid456 array can config different stripe_size. This patch is prepared
> for following configurable stripe_size.
>
> Simply replace word STRIPE_ with conf->stripe_ and add 'conf' argument
> for function stripe_hash_locks_hash() and r5_next_bio() to get stripe_size.
> After that, we initialize stripe_size into setup_conf().
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

This patch looks good. Please fix the warning found by the kernel test bot.
Also a nitpick below.

[...]

> -
>  /* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
>   * This is because we sometimes take all the spinlocks
>   * and creating that much locking depth can cause
> @@ -574,6 +554,9 @@ struct r5conf {
>         int                     raid_disks;
>         int                     max_nr_stripes;
>         int                     min_nr_stripes;
> +       unsigned int    stripe_size;
> +       unsigned int    stripe_shift;
> +       unsigned int    stripe_sectors;

Are you using a different tab size (other than 8)? These 3 new lines are not
aligned with the rest with tab size of 8.

>
>         /* reshape_progress is the leading edge of a 'reshape'
>          * It has value MaxSector when no reshape is happening
> @@ -752,6 +735,24 @@ static inline int algorithm_is_DDF(int layout)
>         return layout >= 8 && layout <= 10;
>  }
>
> +/* bio's attached to a stripe+device for I/O are linked together in bi_sector
> + * order without overlap.  There may be several bio's per stripe+device, and
> + * a bio could span several devices.
> + * When walking this list for a particular stripe+device, we must never proceed
> + * beyond a bio that extends past this device, as the next bio might no longer
> + * be valid.
> + * This function is used to determine the 'next' bio in the list, given the
> + * sector of the current stripe+device
> + */
> +static inline struct bio *
> +r5_next_bio(struct r5conf *conf, struct bio *bio, sector_t sector)
> +{
> +       if (bio_end_sector(bio) < sector + conf->stripe_sectors)
> +               return bio->bi_next;
> +       else
> +               return NULL;
> +}
> +
>  extern void md_raid5_kick_device(struct r5conf *conf);
>  extern int raid5_set_cache_size(struct mddev *mddev, int size);
>  extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
> --
> 2.25.4
>
