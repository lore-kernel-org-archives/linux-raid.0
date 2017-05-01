From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: make use of spin_lock_irq over
 local_irq_disable + spin_lock
Date: Mon, 1 May 2017 16:11:32 -0700
Message-ID: <20170501231132.owb6rjgo3dujxh7b@kernel.org>
References: <20170427185719.708758b6@brick.gerasiov.net>
 <20170428174102.30003-1-julia@ni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170428174102.30003-1-julia@ni.com>
Sender: linux-raid-owner@vger.kernel.org
To: Julia Cartwright <julia@ni.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-raid@vger.kernel.org, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander GQ Gerasiov <gq@cs.msu.su>
List-Id: linux-raid.ids

On Fri, Apr 28, 2017 at 12:41:02PM -0500, Julia Cartwright wrote:
> On mainline, there is no functional difference, just less code, and
> symmetric lock/unlock paths.
> 
> On PREEMPT_RT builds, this fixes the following warning, seen by
> Alexander GQ Gerasiov, due to the sleeping nature of spinlocks.
> 
>    BUG: sleeping function called from invalid context at kernel/locking/rtmutex.c:993
>    in_atomic(): 0, irqs_disabled(): 1, pid: 58, name: kworker/u12:1
>    CPU: 5 PID: 58 Comm: kworker/u12:1 Tainted: G        W       4.9.20-rt16-stand6-686 #1
>    Hardware name: Supermicro SYS-5027R-WRF/X9SRW-F, BIOS 3.2a 10/28/2015
>    Workqueue: writeback wb_workfn (flush-253:0)
>    Call Trace:
>     dump_stack+0x47/0x68
>     ? migrate_enable+0x4a/0xf0
>     ___might_sleep+0x101/0x180
>     rt_spin_lock+0x17/0x40
>     add_stripe_bio+0x4e3/0x6c0 [raid456]
>     ? preempt_count_add+0x42/0xb0
>     raid5_make_request+0x737/0xdd0 [raid456]
> 
> Reported-by: Alexander GQ Gerasiov <gq@redlab-i.ru>
> Tested-by: Alexander GQ Gerasiov <gq@redlab-i.ru>
> Signed-off-by: Julia Cartwright <julia@ni.com>

applied, thanks!

> ---
> Hey All-
> 
> While this fixes a problem on RT primarily, the patch is equally applicable
> upstream, as such probably makes sense to be pulled through the md tree.  It
> may also make sense to be pulled directly into rt-devel.
> 
> Alexander-
> 
> I turned your "I confirm the fix" to a 'Tested-by', let me know if that's a problem.
> 
> Thanks,
> 
>    Julia
> 
>  drivers/md/raid5.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index fa2c4de32a64..54dc2995aeee 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -110,8 +110,7 @@ static inline void unlock_device_hash_lock(struct r5conf *conf, int hash)
>  static inline void lock_all_device_hash_locks_irq(struct r5conf *conf)
>  {
>  	int i;
> -	local_irq_disable();
> -	spin_lock(conf->hash_locks);
> +	spin_lock_irq(conf->hash_locks);
>  	for (i = 1; i < NR_STRIPE_HASH_LOCKS; i++)
>  		spin_lock_nest_lock(conf->hash_locks + i, conf->hash_locks);
>  	spin_lock(&conf->device_lock);
> @@ -121,9 +120,9 @@ static inline void unlock_all_device_hash_locks_irq(struct r5conf *conf)
>  {
>  	int i;
>  	spin_unlock(&conf->device_lock);
> -	for (i = NR_STRIPE_HASH_LOCKS; i; i--)
> -		spin_unlock(conf->hash_locks + i - 1);
> -	local_irq_enable();
> +	for (i = NR_STRIPE_HASH_LOCKS - 1; i; i--)
> +		spin_unlock(conf->hash_locks + i);
> +	spin_unlock_irq(conf->hash_locks);
>  }
>  
>  /* bio's attached to a stripe+device for I/O are linked together in bi_sector
> @@ -732,12 +731,11 @@ static bool is_full_stripe_write(struct stripe_head *sh)
>  
>  static void lock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
>  {
> -	local_irq_disable();
>  	if (sh1 > sh2) {
> -		spin_lock(&sh2->stripe_lock);
> +		spin_lock_irq(&sh2->stripe_lock);
>  		spin_lock_nested(&sh1->stripe_lock, 1);
>  	} else {
> -		spin_lock(&sh1->stripe_lock);
> +		spin_lock_irq(&sh1->stripe_lock);
>  		spin_lock_nested(&sh2->stripe_lock, 1);
>  	}
>  }
> @@ -745,8 +743,7 @@ static void lock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
>  static void unlock_two_stripes(struct stripe_head *sh1, struct stripe_head *sh2)
>  {
>  	spin_unlock(&sh1->stripe_lock);
> -	spin_unlock(&sh2->stripe_lock);
> -	local_irq_enable();
> +	spin_unlock_irq(&sh2->stripe_lock);
>  }
>  
>  /* Only freshly new full stripe normal write stripe can be added to a batch list */
> -- 
> 2.12.0
> 
