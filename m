From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/3] MD: hold mddev lock for .quiesce in md_do_sync
Date: Fri, 5 Aug 2016 21:14:28 -0700
Message-ID: <20160806041428.GB9281@kernel.org>
References: <515fa68e5c4784b08f2ce99c082c923f6b02a3c9.1469922791.git.shli@fb.com>
 <87y44epwb5.fsf@notabene.neil.brown.name>
 <87y44dnrz2.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y44dnrz2.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Thu, Aug 04, 2016 at 01:16:49PM +1000, Neil Brown wrote:
> On Wed, Aug 03 2016, NeilBrown wrote:
> 
> > [ Unknown signature status ]
> > On Sun, Jul 31 2016, shli@kernel.org wrote:
> >
> >> From: Shaohua Li <shli@fb.com>
> >>
> >> .quiesce is called with mddev lock hold at most places. There are few
> >> exceptions. Calling .quesce without the lock hold could create races. For
> >> example, the .quesce of raid1 can't be recursively. The purpose of the patches
> >> is to fix a race in raid5-cache. The raid5-cache .quesce will write md
> >> superblock and should be called with mddev lock hold.
> >>
> >> Cc: NeilBrown <neilb@suse.com>
> >> Signed-off-by: Shaohua Li <shli@fb.com>
> >
> > Acked-by: NeilBrown <neilb@suse.com>
> >
> > This should be safe but I'm not sure I really like it.
> > The raid1 quiesce could be changed so that it can be called recursively.
> > The raid5-cache situation would be harder to get right and maybe this is
> > the best solution... It's just that 'quiesce' should be a fairly
> > light-weight operation, just waiting for pending requests to flush.  It
> > shouldn't really *need* a lock.
> 
> Actually, the more I think about this, the less I like it.
> 
> I would much rather make .quiesce lighter weight so that no locking was
> needed.
> 
> For r5l_quiesce, that probable means removed the "r5l_do_reclaim()".
> Stopping and restarting the reclaim thread seems reasonable, but calling
> r5l_do_reclaim() should not be needed.  It should be done periodically
> by the thread, and at 'stop' time, but otherwise isn't needed.
> You would need to hold some mutex while calling md_register_thread, but
> that could be probably be log->io_mutex, or maybe even some other new
> mutex

We will have the same deadlock issue with just stopping/restarting the reclaim
thread. As stopping the thread will wait for the thread, which probably is
doing r5l_do_reclaim and writting the superblock. Since we are writting the
superblock, we must hold the reconfig_mutex.

Letting raid5_quiesce call r5l_do_reclaim gives us a clean log. Just
stop/restart the reclaim thread can't guarantee this, as it's possible some
space aren't reclaimed yet. A clean log will simplify a lot of things, for
example we change the layout of the array. The log doesn't need to remember
which part is for the old layout and which part is the new layout.

I think we can add a new parameter for .quiesce to indicate if reconfig_mutex
is hold. raid5_quiesce can check the parameter and hold reconfig_mutex if
necessary.

Thanks,
Shaohua
