From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 2/6] drivers/md/raid5: Do not disable irq on
 release_inactive_stripe_list() call
Date: Fri, 20 Jul 2018 10:29:25 +0200
Message-ID: <20180720082925.w5wncrkcaehniccm@linutronix.de>
References: <20180703200141.28415-1-bigeasy@linutronix.de>
 <20180703200141.28415-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180703200141.28415-3-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2018-07-03 22:01:37 [+0200], To linux-kernel@vger.kernel.org wrote:
> From: Anna-Maria Gleixner <anna-maria@linutronix.de>
> 
> There is no need to invoke release_inactive_stripe_list() with interrupts
> disabled. All call sites, except raid5_release_stripe(), unlock
> ->device_lock and enable interrupts before invoking the function.
> 
> Make it consistent.

Shaohua, I've seen that you already applied 1/6. Could you also please
apply this one? This is the only remaining raid5 patch :)

> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/md/raid5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e933bff9459e..ca1dd0cb04c5 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -414,9 +414,8 @@ void raid5_release_stripe(struct stripe_head *sh)
>  		INIT_LIST_HEAD(&list);
>  		hash = sh->hash_lock_index;
>  		do_release_stripe(conf, sh, &list);
> -		spin_unlock(&conf->device_lock);
> +		spin_unlock_irqrestore(&conf->device_lock, flags);
>  		release_inactive_stripe_list(conf, &list, hash);
> -		local_irq_restore(flags);
>  	}
>  }
>  

Sebastian
