From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 3/8] md: raid5: use refcount_t for reference counting
 instead atomic_t
Date: Wed, 23 May 2018 14:50:07 +0200
Message-ID: <20180523125007.pbxcxef622cde3jz@linutronix.de>
References: <20180509193645.830-1-bigeasy@linutronix.de>
 <20180509193645.830-4-bigeasy@linutronix.de>
 <20180523123615.GY12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180523123615.GY12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-raid.ids

On 2018-05-23 14:36:15 [+0200], Peter Zijlstra wrote:
> > Most changes are 1:1 replacements except for
> > 	BUG_ON(atomic_inc_return(&sh->count) != 1);
> 
> That doesn't look right, 'inc_return == 1' implies inc-from-zero, which
> is not allowed by refcount.
> 
> > which has been turned into
> >         refcount_inc(&sh->count);
> >         BUG_ON(refcount_read(&sh->count) != 1);
> 
> And that is racy, you can have additional increments in between.

so do we stay with the atomic* API here or do we extend refcount* API?

Sebastian
