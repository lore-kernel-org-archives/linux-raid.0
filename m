From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/8] md: raid5: use refcount_t for reference counting
 instead atomic_t
Date: Wed, 23 May 2018 06:21:19 -0700
Message-ID: <20180523132119.GC19987@bombadil.infradead.org>
References: <20180509193645.830-1-bigeasy@linutronix.de>
 <20180509193645.830-4-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180509193645.830-4-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-raid.ids

On Wed, May 09, 2018 at 09:36:40PM +0200, Sebastian Andrzej Siewior wrote:
> refcount_t type and corresponding API should be used instead of atomic_t when
> the variable is used as a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free situations.
> 
> Most changes are 1:1 replacements except for
> 	BUG_ON(atomic_inc_return(&sh->count) != 1);
> 
> which has been turned into
>         refcount_inc(&sh->count);
>         BUG_ON(refcount_read(&sh->count) != 1);

@@ -5387,7 +5387,8 @@ static struct stripe_head *__get_priority_stripe(struct
+r5conf *conf, int group)
                sh->group = NULL;
        }
        list_del_init(&sh->lru);
-       BUG_ON(atomic_inc_return(&sh->count) != 1);
+       refcount_inc(&sh->count);
+	BUG_ON(refcount_read(&sh->count) != 1);
        return sh;
 }


That's the only problematic usage.  And I think what it's really saying is:

	BUG_ON(refcount_read(&sh->count) != 0);
	refcount_set(&sh->count, 1);

With that, this looks like a reasonable use of refcount_t to me.
