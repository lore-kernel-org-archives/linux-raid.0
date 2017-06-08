From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Thu, 8 Jun 2017 18:52:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1706081847150.3603@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com> <87h8zrart4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h8zrart4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids



On Thu, 8 Jun 2017, NeilBrown wrote:

> On Wed, Jun 07 2017, Mikulas Patocka wrote:
> 
> > The function flush_signals clears all pending signals for the process. It
> > may be used by kernel threads when we need to prepare a kernel thread for
> > responding to signals. However using this function for an userspaces
> > processes is incorrect - clearing signals without the program expecting it
> > can cause misbehavior.
> >
> > The raid1 and raid5 code uses flush_signals in its request routine because
> > it wants to prepare for an interruptible wait. This patch drops
> > flush_signals and uses sigprocmask instead to block all signals (including
> > SIGKILL) around the schedule() call. The signals are not lost, but the
> > schedule() call won't respond to them.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> 
> Thanks for catching that!
> 
> Acked-by: NeilBrown <neilb@suse.com>
> 
> NeilBrown

BTW. why does md_thread do "allow_signal(SIGKILL)" and then
"if (signal_pending(current)) flush_signals(current)"?

Does userspace really send SIGKILL to MD kernel threads? The SIGKILL will 
be lost when flush_signals is called, so it looks quite dubious.

Mikulas
