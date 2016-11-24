From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] raid5-cache: suspend reclaim thread instead of
 shutdown
Date: Wed, 23 Nov 2016 16:56:09 -0800
Message-ID: <20161124005609.d7mrshcgxl4kvlas@kernel.org>
References: <598ff2610261ffa745b682c311d5300fefeb2fcc.1479751751.git.shli@fb.com>
 <87twayc3yu.fsf@notabene.neil.brown.name>
 <20161123063017.GA41488@shli-mbp.local>
 <87oa15bvcg.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oa15bvcg.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com
List-Id: linux-raid.ids

On Thu, Nov 24, 2016 at 11:00:15AM +1100, Neil Brown wrote:
> On Wed, Nov 23 2016, Shaohua Li wrote:
> 
> > On Wed, Nov 23, 2016 at 01:41:45PM +1100, NeilBrown wrote:
> >> On Tue, Nov 22 2016, Shaohua Li wrote:
> >> 
> >> > There is mechanism to suspend a kernel thread. Use it instead of playing
> >> > create/destroy game.
> >> 
> >> Good idea!
> >> 
> >> >
> >> > Signed-off-by: Shaohua Li <shli@fb.com>
> >> > ---
> >> >  drivers/md/md.c          |  4 +++-
> >> >  drivers/md/raid5-cache.c | 18 +++++-------------
> >> >  2 files changed, 8 insertions(+), 14 deletions(-)
> >> >
> >> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> > index d3cef77..f548469 100644
> >> > --- a/drivers/md/md.c
> >> > +++ b/drivers/md/md.c
> >> > @@ -7136,10 +7136,12 @@ static int md_thread(void *arg)
> >> >  		wait_event_interruptible_timeout
> >> >  			(thread->wqueue,
> >> >  			 test_bit(THREAD_WAKEUP, &thread->flags)
> >> > -			 || kthread_should_stop(),
> >> > +			 || kthread_should_stop() || kthread_should_park(),
> >> >  			 thread->timeout);
> >> >  
> >> >  		clear_bit(THREAD_WAKEUP, &thread->flags);
> >> > +		if (kthread_should_park())
> >> > +			kthread_parkme();
> >> >  		if (!kthread_should_stop())
> >> >  			thread->run(thread);
> >> >  	}
> >> > diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> >> > index 8cb79fc..5f817bd 100644
> >> > --- a/drivers/md/raid5-cache.c
> >> > +++ b/drivers/md/raid5-cache.c
> >> > @@ -19,6 +19,7 @@
> >> >  #include <linux/raid/md_p.h>
> >> >  #include <linux/crc32c.h>
> >> >  #include <linux/random.h>
> >> > +#include <linux/kthread.h>
> >> >  #include "md.h"
> >> >  #include "raid5.h"
> >> >  #include "bitmap.h"
> >> > @@ -1437,23 +1438,14 @@ void r5l_quiesce(struct r5l_log *log, int state)
> >> >  	struct mddev *mddev;
> >> >  	if (!log || state == 2)
> >> >  		return;
> >> > -	if (state == 0) {
> >> > -		/*
> >> > -		 * This is a special case for hotadd. In suspend, the array has
> >> > -		 * no journal. In resume, journal is initialized as well as the
> >> > -		 * reclaim thread.
> >> > -		 */
> >> > -		if (log->reclaim_thread)
> >> > -			return;
> >> > -		log->reclaim_thread = md_register_thread(r5l_reclaim_thread,
> >> > -					log->rdev->mddev, "reclaim");
> >> > -		log->reclaim_thread->timeout = R5C_RECLAIM_WAKEUP_INTERVAL;
> >> > -	} else if (state == 1) {
> >> > +	if (state == 0)
> >> > +		kthread_unpark(log->reclaim_thread->tsk);
> >> 
> >> The old code tested for log->reclaim_thread being NULL.  This new
> >> version will just crash.
> >
> > But the reclaim_thread couldn't be NULL if log != NULL. Am I missing anything?
> 
> Yes, you are right.  The old code had a test that the new code didn't,
> which rang warning bells for me.
> Both now that we don't de-register the thread in r5l_quiesce(),
> log->reclaim_thread will never be NULL, so the test isn't needed.
> 
> 
> >  
> >> > +	else if (state == 1) {
> >> >  		/* make sure r5l_write_super_and_discard_space exits */
> >> >  		mddev = log->rdev->mddev;
> >> >  		wake_up(&mddev->sb_wait);
> >> > +		kthread_park(log->reclaim_thread->tsk);
> >> 
> >> r5l_do_reclaim has a wait loop internally.  I think you need that to
> >> abort when kthread_should_park(), else this will block indefinitely.
> >
> > Sounds not harmful to me. The loop in r5l_do_reclaim will eventually end if all
> > data is reclaimed. Then the thread will be in the md_thread() loop. In that
> > loop, the thread will not sleep because the wait checks kthread_should_park().
> > Then the thread will get parked.
> 
> Maybe ... it just looks odd.
> what is that while(1) {} loop really waiting for?  It waits for there to
> be more than reclaim_target work to do, or for all the _ios lists to be
> empty. By the time r5l_quiesce() is called, all active stripes should
> have drained, so I guess that will abort quickly.
> Why is it waiting there, rather than in md_thread()?  Why do we need
> that loop?

The r5c_do_reclaim is called in normal reclaim thread too, eg, not just
quiesce. At that time the wait is necessary, because some stripes are waiting
for free space, who can only be waken up after there is enough free space. You
are correct, the loop will abort quickly in quiesce.

Thanks,
Shaohua
