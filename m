From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Introduce atomic_dec_and_lock_irqsave()
Date: Fri, 4 May 2018 17:54:46 +0200
Message-ID: <20180504155446.GP12217@hirez.programming.kicks-ass.net>
References: <20180504154533.8833-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504154533.8833-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 04, 2018 at 05:45:28PM +0200, Sebastian Andrzej Siewior wrote:
> This series introduces atomic_dec_and_lock_irqsave() and converts a few
> users to use it. They were using local_irq_save() +
> atomic_dec_and_lock() before that series.

Should not all these users be converted to refcount_t, and thus, should
we not introduce refcount_dec_and_lock_irqsave() instead?
