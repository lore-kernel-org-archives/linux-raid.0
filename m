From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] raid5: avoid add sh->lru to different list
Date: Thu, 9 Jan 2020 15:02:05 +0800
Message-ID: <92b659f5-09ad-d241-90c0-5dfcb6aeda3c@redhat.com>
References: <20200108163023.9301-1-guoqing.jiang@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200108163023.9301-1-guoqing.jiang@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: jgq516@gmail.com, liu.song.a23@gmail.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids



On 01/09/2020 12:30 AM, jgq516@gmail.com wrote:
> From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>
> release_stripe_plug adds lru to unplug list, then raid5_unplug
> iterates unplug list and release the stripe in the list. But
> sh->lru could exist in another list as well since there is no
> protection of the race since release_stripe_plug is lock free.
>
> For example, the same sh could be handled by raid5_release_stripe
> which is lock free too, it does two things in case "sh->count == 1".
>
> 1. add sh to released_stripes.
>
> Or
>
> 2. go to slow path if sh is already set with ON_RELEASE_LIST.
>
> Either 1 or 2 could trigger do_release_stripe finally, and this
> function mainly move sh->lru to different lists such as delayed_list,
> handle_list or temp_inactive_list etc.

Hi Guoqing

The sh->count should be >= 1 before calling release_stripe_plug. Because 
the stripe is got
from raid5_get_active_stripe. In your example, if the same sh will be 
handled by raid5_release_stripe.
The sh->count should be >= 2, right? Because it should be added 1 when 
someone gets the same
sh. So the sh->count can't be zero and can't be released before/in/after 
release_stripe_plug. Could
you explain about this if sh->count can be zero when calling 
release_stripe_plug?

When it moves sh->lru to unplug list, it doesn't check sh->count and get 
any lock. The unplug method
is to avoid conf->device_lock. Is it enough to check sh->lru here? If 
it's not empty, it can call raid5_release_stripe
directly.
>
> Then the same node could be in different lists, which causes
What's the meaning of "node" here? It's stripe?
> raid5_unplug sticks with "while (!list_empty(&cb->list))", and
> since spin_lock_irq(&conf->device_lock) is called before, it
> causes:
You mean a dead loop? In the loop, stripe is moved from cb->list. The 
while loop
can finish successfully, right?

>
> 1. hard lock up in [1], [2] and [3] since irq is disabled.
>
> 2. raid5_get_active_stripe can't get device_lock and calltrace
> happens.
>
> [<ffffffff81598060>] _raw_spin_lock+0x20/0x30
> [<ffffffffa0230b0a>] raid5_get_active_stripe+0x1da/0x5250 [raid456]
> [<ffffffff8112d165>] ? mempool_alloc_slab+0x15/0x20
> [<ffffffffa0231174>] raid5_get_active_stripe+0x844/0x5250 [raid456]
> [<ffffffff812d5574>] ? generic_make_request+0x24/0x2b0
> [<ffffffff810938b0>] ? wait_woken+0x90/0x90
> [<ffffffff814a2adc>] md_make_request+0xfc/0x250
> [<ffffffff812d5867>] submit_bio+0x67/0x150
>
> So, this commit tries to avoid the issue by makes below change:
>
> 1. firstly we can't add sh->lru to cb->list if sh->count == 0.
>
> 2. check STRIPE_ON_UNPLUG_LIST too in do_release_stripe to avoid
> list corruption, and the lock version of test_and_set_bit/clear_bit
> are used (though it should not effective on x86).
>
> [1]. https://marc.info/?l=linux-raid&m=150348807422853&w=2
> [2]. https://marc.info/?l=linux-raid&m=146883211430999&w=2
> [3]. https://marc.info/?l=linux-raid&m=157434565331673&w=2
>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> ---
> As you can see, this version is different from previous one.
>
> The previous verison is made because I thought that ON_UNPLUG_LIST
> and ON_RELEASE_LIST are kind of exclusive, the sh should be
> only set with  either of the flag but not both, but perhaps
> it is not true ...
Yes. The stripe may be handled in other cases and it calls 
raid5_release_stripe after the job.
Now the stripe maybe is in conf->released_stripes and sh->count is 1.
>
> Instead, since the goal is to avoid put the same sh->lru in
> different list, or we can fix it from other side. Before
> do_release_stripe move sh->lru to another list (not cb->list),
> check if the sh is on unplug list yet, if it is true then wake
> up mddev->thread to trigger the plug path:
>
>    raid5d -> blk_finish_plug -> raid5_unplug ->
>    __release_stripe -> do_release_stripe
>
> Then raid5_unplug remove sh from cb->list one by one, clear
> ON_UNPLUG_LIST flag and release stripe. So we ensure sh on
> unplug list is actually handled by plug mechanism instead
> of other paths.
>
> Comments and tests are welcomed.
>
> The new changes are tested with "./test --raidtype=raid456",
> seems good.
>
> Thanks,
> Guoqing
>
>   drivers/md/raid5.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 223e97ab27e6..808b0bd18c8c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -218,6 +218,25 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>   	BUG_ON(!list_empty(&sh->lru));
>   	BUG_ON(atomic_read(&conf->active_stripes)==0);
>   
> +	/*
> +	 * If stripe is on unplug list then original caller of __release_stripe
> +	 * is not raid5_unplug, so sh->lru is still in cb->list, don't risk to
> +	 * add lru to another list in do_release_stripe.
> +	 */
> +	if (!test_and_set_bit_lock(STRIPE_ON_UNPLUG_LIST, &sh->state))
> +		clear_bit_unlock(STRIPE_ON_UNPLUG_LIST, &sh->state);
> +	else {
> +		/*
> +		 * The sh is on unplug list, so increase count (because count
> +		 * is decrease before enter do_release_stripe), then trigger
is decreased before entering
> +		 * raid5d -> plug -> raid5_unplug -> __release_stripe to handle
> +		 * this stripe.
> +		 */
> +		atomic_inc(&sh->count);
> +		md_wakeup_thread(conf->mddev->thread);
> +		return;
> +	}
> +
>   	if (r5c_is_writeback(conf->log))
>   		for (i = sh->disks; i--; )
>   			if (test_bit(R5_InJournal, &sh->dev[i].flags))
> @@ -5441,7 +5460,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
>   			 * is still in our list
>   			 */
>   			smp_mb__before_atomic();
> -			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
> +			clear_bit_unlock(STRIPE_ON_UNPLUG_LIST, &sh->state);
>   			/*
>   			 * STRIPE_ON_RELEASE_LIST could be set here. In that
>   			 * case, the count is always > 1 here
> @@ -5481,7 +5500,8 @@ static void release_stripe_plug(struct mddev *mddev,
>   			INIT_LIST_HEAD(cb->temp_inactive_list + i);
>   	}
>   
> -	if (!test_and_set_bit(STRIPE_ON_UNPLUG_LIST, &sh->state))
> +	if (!test_and_set_bit_lock(STRIPE_ON_UNPLUG_LIST, &sh->state) &&
> +	    (atomic_read(&sh->count) != 0))
>   		list_add_tail(&sh->lru, &cb->list);
>   	else
>   		raid5_release_stripe(sh);
