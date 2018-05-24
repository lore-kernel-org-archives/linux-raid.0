From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/8] md: raid5: use refcount_t for reference counting
 instead atomic_t
Date: Thu, 24 May 2018 09:14:13 +0200
Message-ID: <20180524071413.GC12198@hirez.programming.kicks-ass.net>
References: <20180509193645.830-1-bigeasy@linutronix.de>
 <20180509193645.830-4-bigeasy@linutronix.de>
 <20180523132119.GC19987@bombadil.infradead.org>
 <20180523174904.GY12198@hirez.programming.kicks-ass.net>
 <20180523192239.GA59657@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180523192239.GA59657@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-kernel@vger.kernel.org, tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>
List-Id: linux-raid.ids

On Wed, May 23, 2018 at 12:22:39PM -0700, Shaohua Li wrote:
> I don't know what is changed in the refcount, such raid5 change has attempted
> before and didn't work. 0 for the stripe count is a valid usage and we do
> inc-from-zero in several places.

Nothing much has changed with refcount; and the above does indeed still
appear to be an issue. Thanks for confirming.
