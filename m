From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Introduce atomic_dec_and_lock_irqsave()
Date: Wed, 23 May 2018 15:02:41 +0200
Message-ID: <20180523130241.GA12217@hirez.programming.kicks-ass.net>
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

1,5-6:

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
