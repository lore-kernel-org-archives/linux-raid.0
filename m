From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: don't use flush_signals in userspace processes
Date: Thu, 8 Jun 2017 15:58:58 -0700
Message-ID: <20170608225858.z23vabbkzsf3lgl5@kernel.org>
References: <alpine.LRH.2.02.1706071834250.22850@file01.intranet.prod.int.rdu2.redhat.com>
 <87h8zrart4.fsf@notabene.neil.brown.name>
 <20170608171551.ytxk3yz6xxsfbqma@kernel.org>
 <alpine.LRH.2.02.1706081641160.12323@file01.intranet.prod.int.rdu2.redhat.com>
 <877f0mb2b6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f0mb2b6.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

On Fri, Jun 09, 2017 at 07:24:29AM +1000, Neil Brown wrote:
> On Thu, Jun 08 2017, Mikulas Patocka wrote:
> 
> > On Thu, 8 Jun 2017, Shaohua Li wrote:
> >
> >> On Thu, Jun 08, 2017 at 04:59:03PM +1000, Neil Brown wrote:
> >> > On Wed, Jun 07 2017, Mikulas Patocka wrote:
> >> > 
> >> > > The function flush_signals clears all pending signals for the process. It
> >> > > may be used by kernel threads when we need to prepare a kernel thread for
> >> > > responding to signals. However using this function for an userspaces
> >> > > processes is incorrect - clearing signals without the program expecting it
> >> > > can cause misbehavior.
> >> > >
> >> > > The raid1 and raid5 code uses flush_signals in its request routine because
> >> > > it wants to prepare for an interruptible wait. This patch drops
> >> > > flush_signals and uses sigprocmask instead to block all signals (including
> >> > > SIGKILL) around the schedule() call. The signals are not lost, but the
> >> > > schedule() call won't respond to them.
> >> > >
> >> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >> > > Cc: stable@vger.kernel.org
> >> > 
> >> > Thanks for catching that!
> >> > 
> >> > Acked-by: NeilBrown <neilb@suse.com>
> >> 
> >> Applied, thanks!
> >> 
> >> Neil,
> >> Not about the patch itself. I had question about that part of code. Dropped
> >> others since this is raid related. I didn't get the point why it's a
> >> TASK_INTERRUPTIBLE sleep. It seems suggesting the thread will bail out if a
> >> signal is sent. But I didn't see we check the signal and exit the loop. What's
> >> the correct behavior here? Since the suspend range is controlled by userspace,
> >
> > As I understand the code - the purpose is to have an UNINTERRUPTIBLE sleep 
> > that isn't accounted in load average and that doesn't trigger the hung 
> > task warning.
> 
> Exactly my reason - yes.
> 
> >
> > There should really be something like TASK_UNINTERRUPTIBLE_LONG for this 
> > purpose.
> 
> That would be nice.
> 
> >
> >> I think the correct behavior is if user kills the thread, we exit the loop. So
> >> it seems like to be we check if there is fatal signal pending, exit the loop,
> >> and return IO error. Not sure if we should return IO error though.
> >
> > No, this is not correct - if we report an I/O error for the affected bio, 
> > it could corrupt filesystem or confuse other device mapper targets that 
> > could be on the top of MD. It is not right to corrupt filesystem if the 
> > user kills a process.
> 
> Yes, we are too deep to even return something like ERESTARTSYS.
> Blocking is the only option.

My concern is if the app controlling the suspend range dies, other threads
will block in the kernel side forever. We can't even force kill them.  This
is an unfortunate behavior. Would adding a timeout here make sense? The app
controlling the suspend range looks part of the disk firmware now. If the
firmware doesn't respond, returning IO timeout is normal.

Thanks,
Shaohua
