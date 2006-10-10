From: Ingo Molnar <mingo@elte.hu>
Subject: Re: md deadlock (was Re: 2.6.18-mm2)
Date: Tue, 10 Oct 2006 08:42:28 +0200
Message-ID: <20061010064228.GA6311@elte.hu>
References: <20060928014623.ccc9b885.akpm@osdl.org> <6bffcb0e0609280454n34d40c0la8786e1eba6dcdf3@mail.gmail.com> <1159531923.28131.80.camel@taijtu> <17693.5913.393686.223172@cse.unsw.edu.au> <1159538597.28131.97.camel@taijtu> <1159796858.28131.149.camel@taijtu> <17707.6447.329255.930851@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17707.6447.329255.930851@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


* Neil Brown <neilb@suse.de> wrote:

> --- .prev/include/linux/mutex.h	2006-10-10 12:37:04.000000000 +1000
> +++ ./include/linux/mutex.h	2006-10-10 12:40:20.000000000 +1000
> @@ -125,8 +125,9 @@ extern int fastcall mutex_lock_interrupt
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  extern void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
> +extern int mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass);
>  #else
> -# define mutex_lock_nested(lock, subclass) mutex_lock(lock)
> +# define mutex_lock_interruptible_nested(lock, subclass) mutex_interruptible_lock(lock)
>  #endif

>  EXPORT_SYMBOL_GPL(mutex_lock_nested);
> +int __sched
> +mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
> +{
> +	might_sleep();
> +	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass);
> +}
> +
> +EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);

looks good to me. (small style nit: maybe insert a newline after the 
first EXPORT_SYMBOL_GPL line)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
