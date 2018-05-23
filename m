From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 0/8] Introduce refcount_dec_and_lock_irqsave()
Date: Wed, 23 May 2018 15:01:25 +0200
Message-ID: <20180523130125.GZ12217@hirez.programming.kicks-ass.net>
References: <20180509193645.830-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180509193645.830-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-raid.ids

On Wed, May 09, 2018 at 09:36:37PM +0200, Sebastian Andrzej Siewior wrote:
> This series is a v2 of the atomic_dec_and_lock_irqsave(). Now refcount_*
> is used instead of atomic_* as suggested by Peter Zijlstra.
> 
> Patch
> - 1-3 converts the user from atomic_* API to refcount_* API
> - 4 implements refcount_dec_and_lock_irqsave
> - 5-8 converts the local_irq_save() + refcount_dec_and_lock() users to
>   refcount_dec_and_lock_irqsave()
> 
> The whole series sits also at
>   git://git.kernel.org/pub/scm/linux/kernel/git/bigeasy/staging.git refcount_t_irqsave
> 

1-2, 4-6:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
