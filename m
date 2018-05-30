From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: Introduce atomic_dec_and_lock_irqsave()
Date: Wed, 30 May 2018 11:26:14 +0200
Message-ID: <20180530092614.wch377xtjrjgovnl@linutronix.de>
References: <20180504154533.8833-1-bigeasy@linutronix.de>
 <20180523130241.GA12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180523130241.GA12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2018-05-23 15:02:41 [+0200], Peter Zijlstra wrote:
> 1,5-6:
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

I sucked them into my try tree an noticed this off by one, I applied the
tags to 1,4-5:
*┬─>[PATCH 1/5] spinlock: atomic_dec_and_lock: Add an irqsave variant
 ├─>[PATCH 2/5] mm/backing-dev: Use irqsave variant of atomic_dec_and_lock()
 ├─>[PATCH 3/5] kernel/user: Use irqsave variant of atomic_dec_and_lock()
*├─>[PATCH 4/5] drivers/md/raid5: Use irqsave variant of atomic_dec_and_lock()
*├─>[PATCH 5/5] drivers/md/raid5: Do not disable irq on release_inactive_stripe_list() call

as we talked about it.

Sebastian
