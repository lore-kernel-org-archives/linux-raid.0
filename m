From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/6] drivers/md/raid5: Use irqsave variant of
 atomic_dec_and_lock()
Date: Mon, 16 Jul 2018 14:27:40 +0200
Message-ID: <20180716122740.q7oim7te5bybcniz@linutronix.de>
References: <20180703200141.28415-1-bigeasy@linutronix.de>
 <20180703200141.28415-2-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180703200141.28415-2-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2018-07-03 22:01:36 [+0200], To linux-kernel@vger.kernel.org wrote:
> From: Anna-Maria Gleixner <anna-maria@linutronix.de>
> 
> The irqsave variant of atomic_dec_and_lock handles irqsave/restore when
> taking/releasing the spin lock. With this variant the call of
> local_irq_save is no longer required.

Shaohua, are you with this?

> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/md/raid5.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2031506a0ecd..e933bff9459e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -409,16 +409,15 @@ void raid5_release_stripe(struct stripe_head *sh)
>  		md_wakeup_thread(conf->mddev->thread);
>  	return;
>  slow_path:
> -	local_irq_save(flags);
>  	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
> -	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
> +	if (atomic_dec_and_lock_irqsave(&sh->count, &conf->device_lock, flags)) {
>  		INIT_LIST_HEAD(&list);
>  		hash = sh->hash_lock_index;
>  		do_release_stripe(conf, sh, &list);
>  		spin_unlock(&conf->device_lock);
>  		release_inactive_stripe_list(conf, &list, hash);
> +		local_irq_restore(flags);
>  	}
> -	local_irq_restore(flags);
>  }
>  
>  static inline void remove_hash(struct stripe_head *sh)
> -- 
> 2.18.0
> 
