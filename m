From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] raid5: avoid add sh->lru to different list
Date: Thu, 9 Jan 2020 17:06:30 -0800
Message-ID: <CAPhsuW598WjeigzHPkAEO8YoHwBis8xO79UL8jfRfLUckkGCog@mail.gmail.com>
References: <20200108163023.9301-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200108163023.9301-1-guoqing.jiang@cloud.ionos.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <jgq516@gmail.com>, Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi Guoqing and Xiao,

Thanks for looking into this. I am still looking into this. Some
questions below...

On Wed, Jan 8, 2020 at 8:30 AM <jgq516@gmail.com> wrote:
[...]
>
>  drivers/md/raid5.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 223e97ab27e6..808b0bd18c8c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -218,6 +218,25 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>         BUG_ON(!list_empty(&sh->lru));
>         BUG_ON(atomic_read(&conf->active_stripes)==0);
>
> +       /*
> +        * If stripe is on unplug list then original caller of __release_stripe
> +        * is not raid5_unplug, so sh->lru is still in cb->list, don't risk to
> +        * add lru to another list in do_release_stripe.
> +        */

Can we do the check before calling into do_release_stripe()?

> +       if (!test_and_set_bit_lock(STRIPE_ON_UNPLUG_LIST, &sh->state))
> +               clear_bit_unlock(STRIPE_ON_UNPLUG_LIST, &sh->state);
> +       else {
> +               /*
> +                * The sh is on unplug list, so increase count (because count
> +                * is decrease before enter do_release_stripe), then trigger
> +                * raid5d -> plug -> raid5_unplug -> __release_stripe to handle
> +                * this stripe.
> +                */
> +               atomic_inc(&sh->count);
> +               md_wakeup_thread(conf->mddev->thread);
> +               return;
> +       }
> +
>         if (r5c_is_writeback(conf->log))
>                 for (i = sh->disks; i--; )
>                         if (test_bit(R5_InJournal, &sh->dev[i].flags))
> @@ -5441,7 +5460,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
>                          * is still in our list
>                          */
>                         smp_mb__before_atomic();
> -                       clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
> +                       clear_bit_unlock(STRIPE_ON_UNPLUG_LIST, &sh->state);
>                         /*
>                          * STRIPE_ON_RELEASE_LIST could be set here. In that
>                          * case, the count is always > 1 here
> @@ -5481,7 +5500,8 @@ static void release_stripe_plug(struct mddev *mddev,
>                         INIT_LIST_HEAD(cb->temp_inactive_list + i);
>         }
>
> -       if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
> +       if (!test_and_set_bit_lock(STRIPE_ON_UNPLUG_LIST, &sh->state) &&
> +           (atomic_read(&sh->count) != 0))

Do we really see sh->count == 0 here? If yes, I guess we should check
sh->count first,
so that we reduce the case where STRIPE_ON_UNPLUG_LIST is set, but the sh is
not really on the unplug_list.

>                 list_add_tail(&sh->lru, &cb->list);
>         else
>                 raid5_release_stripe(sh);
>

Overall, I think we should try our best to let STRIPE_ON_RELEASE_LIST
means it is
on release_list, and STRIPE_ON_UNPLUG_LIST means it is on unplug_list. I think
there will be some exceptions, but we should try to minimize those cases.

Does this make sense?

Thanks,
Song
