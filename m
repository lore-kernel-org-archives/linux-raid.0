From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Introduce atomic_dec_and_lock_irqsave()
Date: Fri, 4 May 2018 18:21:02 +0200
Message-ID: <20180504162102.GQ12217@hirez.programming.kicks-ass.net>
References: <20180504154533.8833-1-bigeasy@linutronix.de>
 <20180504155446.GP12217@hirez.programming.kicks-ass.net>
 <20180504160726.ikotgmd5fbix7b6b@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504160726.ikotgmd5fbix7b6b@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 04, 2018 at 06:07:26PM +0200, Sebastian Andrzej Siewior wrote:

> do you intend to kill refcount_dec_and_lock() in the longterm?

You meant to say atomic_dec_and_lock() ? Dunno if we ever get there, but
typically dec_and_lock is fairly refcounty, but I suppose it is possible
to have !refcount users, in which case we're eternally stuck with it.

But a quick look at the sites you converted, they all appear to be true
refcounts, and would thus benefit from being converted to refcount_t.
