From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Date: Thu, 9 Sep 2010 17:14:43 +0200
Message-ID: <201009091714.44013.arnd@arndb.de>
References: <1283711539-7123-1-git-send-email-segooon@gmail.com> <201009072200.59509.arnd@arndb.de> <20100907205015.GJ2448@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100907205015.GJ2448@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 07 September 2010, Paul E. McKenney wrote:
> On Tue, Sep 07, 2010 at 10:00:58PM +0200, Arnd Bergmann wrote:
> > On Tuesday 07 September 2010 21:21:55 Kulikov Vasiliy wrote:
> > > #define __rcu_dereference_check(p, c, space) \
> > >         ({ \
> > >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> > >                                                                    ^
> > >                 rcu_lockdep_assert(c); \
> > >                 (void) (((typeof (*p) space *)p) == p); \
> > >                                       ^     ^
> > >                 smp_read_barrier_depends(); \
> > >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> > >         })
> > > 
> > > If I understand this, it is evaluated three times, right?
> > 
> > Yes, that looks like my own fault, I added that :(
> > 
> > This patch seems to fix it, but I need to think about it some more
> > to make sure it still does everything we need.
> 
> Let me know when you are satisfied with it, and then I will pick it up.

I guess it would be good to put it in now. I haven't had the time
to try out all cases, but the current code in -next is definitely
broken, so please put the fix in now.

	Arnd
