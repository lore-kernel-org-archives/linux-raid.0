From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Introduce atomic_dec_and_lock_irqsave()
Date: Fri, 4 May 2018 17:26:40 +0100
Message-ID: <20180504162640.GH30522@ZenIV.linux.org.uk>
References: <20180504154533.8833-1-bigeasy@linutronix.de>
 <20180504155446.GP12217@hirez.programming.kicks-ass.net>
 <20180504160726.ikotgmd5fbix7b6b@linutronix.de>
 <20180504162102.GQ12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504162102.GQ12217@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 04, 2018 at 06:21:02PM +0200, Peter Zijlstra wrote:
> On Fri, May 04, 2018 at 06:07:26PM +0200, Sebastian Andrzej Siewior wrote:
> 
> > do you intend to kill refcount_dec_and_lock() in the longterm?
> 
> You meant to say atomic_dec_and_lock() ? Dunno if we ever get there, but
> typically dec_and_lock is fairly refcounty, but I suppose it is possible
> to have !refcount users, in which case we're eternally stuck with it.

Yes, there are - consider e.g.

void iput(struct inode *inode)
{ 
        if (!inode)
                return;
        BUG_ON(inode->i_state & I_CLEAR);
retry:
        if (atomic_dec_and_lock(&inode->i_count, &inode->i_lock)) {

inode->i_count sure as hell isn't refcount_t fodder...
