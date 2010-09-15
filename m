From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Wed, 15 Sep 2010 14:28:32 +0200
Message-ID: <201009151428.32348.arnd@arndb.de>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com> <20100910034603.GA2612@linux.vnet.ibm.com> <20100914003351.GA8300@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100914003351.GA8300@linux.vnet.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 14 September 2010, Paul E. McKenney wrote:
>    The current version of the __rcu_access_pointer(),
> __rcu_dereference_check(), and __rcu_dereference_protected() macros
> evaluate their "p" argument three times, not counting typeof()s.  This is
> bad news if that argument contains a side effect.  This commit therefore
> evaluates this argument only once in normal kernel builds.  However, the
> straightforward approach defeats sparse's RCU-pointer checking, so this
> commit also adds a KBUILD_CHECKSRC symbol defined when running a checker. 
> Therefore, when this new KBUILD_CHECKSRC symbol is defined, the additional
> pair of evaluations of the "p" argument are performed in order to permit
> sparse to detect misuse of RCU-protected pointers.

In general, I don't like the idea much because that means we're passing
semantically different code into sparse and gcc. Of course if my other
patch doesn't work, we might need to do it after all.

> diff --git a/Makefile b/Makefile
> index f3bdff8..1c4984d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -330,7 +330,7 @@ PERL                = perl
>  CHECK          = sparse
>  
>  CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
> -                 -Wbitwise -Wno-return-void $(CF)
> +                 -Wbitwise -Wno-return-void -DKBUILD_CHECKSRC $(CF)
>  CFLAGS_MODULE   =
>  AFLAGS_MODULE   =
>  LDFLAGS_MODULE  =

sparse already define __CHECKER__ itself, no need to define another symbol.

> +#ifdef KBUILD_CHECKSRC
> +#define rcu_dereference_sparse(p, space) \
> +       ((void)(((typeof(*p) space *)p) == p))
> +#else /* #ifdef KBUILD_CHECKSRC */
> +#define rcu_dereference_sparse(p, space)
> +#endif /* #else #ifdef KBUILD_CHECKSRC */

Did you see a problem with my macro?

#define rcu_dereference_sparse(p, space) \
       ((void)(((typeof(*p) space *)NULL) == ((typeof(p))NULL)))

I think this should warn in all the cases we want it to, but have no side-effects.

>  #define __rcu_access_pointer(p, space) \
>         ({ \
>                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> -               (void) (((typeof (*p) space *)p) == p); \
> +               rcu_dereference_sparse(p, space); \
>                 ((typeof(*p) __force __kernel *)(_________p1)); \
>         })
>  #define __rcu_dereference_check(p, c, space) \
>         ({ \
>                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
>                 rcu_lockdep_assert(c); \
> -               (void) (((typeof (*p) space *)p) == p); \
> +               rcu_dereference_sparse(p, space); \
>                 smp_read_barrier_depends(); \
>                 ((typeof(*p) __force __kernel *)(_________p1)); \
>         })
>  #define __rcu_dereference_protected(p, c, space) \
>         ({ \
>                 rcu_lockdep_assert(c); \
> -               (void) (((typeof (*p) space *)p) == p); \
> +               rcu_dereference_sparse(p, space); \
>                 ((typeof(*p) __force __kernel *)(p)); \
>         })
>  

This part might be useful in any case, to better document what the cast and
compare does, and to prevent the three users from diverging.

>diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
>index 439ddab..adb09cb 100644
>--- a/kernel/rcutorture.c
>+++ b/kernel/rcutorture.c

This didn't seem to belong here.

	Arnd
