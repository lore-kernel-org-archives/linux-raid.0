From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 1/3] wait: introduce wait_event_cmd_exclusive
Date: Wed, 29 Apr 2015 09:45:14 +0800
Message-ID: <20150429014514.GR17176@yliu-dev.sh.intel.com>
References: <1430110263-23977-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20150428141315.GD23123@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150428141315.GD23123@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
List-Id: linux-raid.ids

On Tue, Apr 28, 2015 at 04:13:15PM +0200, Peter Zijlstra wrote:
> On Mon, Apr 27, 2015 at 12:51:01PM +0800, Yuanhan Liu wrote:
> > It's just a variant of wait_event_cmd, with exclusive flag being set.
> > 
> > For cases like RAID5, which puts many processes to sleep until 1/4
> > resources are free, a wake_up wakes up all processes to run, but
> > there is one process being able to get the resource as it's protected
> > by a spin lock. That ends up introducing heavy lock contentions, and
> > hurts performance badly.
> > 
> > Here introduce wait_event_cmd_exclusive to relieve the lock contention
> > naturally by letting wake_up() just wake up one process.
> > 
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > ---
> >  include/linux/wait.h | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/linux/wait.h b/include/linux/wait.h
> > index 2db8334..6c3b4de 100644
> > --- a/include/linux/wait.h
> > +++ b/include/linux/wait.h
> > @@ -358,10 +358,18 @@ do {									\
> >  	__ret;								\
> >  })
> >  
> > -#define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
> > -	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
> > +#define __wait_event_cmd(wq, condition, cmd1, cmd2, exclusive)		\
> > +	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, exclusive, 0, \
> >  			    cmd1; schedule(); cmd2)
> >  
> > +
> > +#define wait_event_cmd_exclusive(wq, condition, cmd1, cmd2)			\
> > +do {									\
> > +	if (condition)							\
> > +		break;							\
> > +	__wait_event_cmd(wq, condition, cmd1, cmd2, 1);			\
> > +} while (0)
> > +
> >  /**
> >   * wait_event_cmd - sleep until a condition gets true
> >   * @wq: the waitqueue to wait on
> > @@ -380,7 +388,7 @@ do {									\
> >  do {									\
> >  	if (condition)							\
> >  		break;							\
> > -	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
> > +	__wait_event_cmd(wq, condition, cmd1, cmd2, 0);			\
> >  } while (0)
> >  
> 
> No, that's wrong, its assumed that wait*() and __wait*() have the same
> arguments.

Thanks. Will send an updated patch soon.


	--yliu
