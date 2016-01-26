From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is
 competing IO.
Date: Tue, 26 Jan 2016 15:27:31 -0800
Message-ID: <20160126232731.GA12721@kernel.org>
References: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com>
 <87si1k2do8.fsf@notabene.neil.brown.name>
 <20160126225222.GA29409@kernel.org>
 <87mvrs2b2a.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87mvrs2b2a.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Chien Lee <chienlee@qnap.com>, linux-raid@vger.kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 27, 2016 at 10:08:45AM +1100, Neil Brown wrote:
> On Wed, Jan 27 2016, Shaohua Li wrote:
> 
> > On Wed, Jan 27, 2016 at 09:12:23AM +1100, Neil Brown wrote:
> >> On Tue, Jan 26 2016, Chien Lee wrote:
> >> 
> >> > Hello,
> >> >
> >> > Recently we find a bug about this patch (commit No. is
> >> > ac8fa4196d205ac8fff3f8932bddbad4f16e4110 ).
> >> >
> >> > We know that this patch committed after Linux kernel 4.1.x is intended
> >> > to allowing resync to go faster when there is competing IO. However,
> >> > we find the performance of random read on syncing Raid6 will come up
> >> > with a huge drop in this case. The following is our testing detail.
> >> >
> >> > The OS what we choose in our test is CentOS Linux release 7.1.1503
> >> > (Core) and the kernel image will be replaced for testing. In our
> >> > testing result, the 4K random read performance on syncing raid6 in
> >> > Kernel 4.2.8 is much lower than in Kernel 3.19.8. In order to find out
> >> > the root cause, we try to rollback this patch in Kernel 4.2.8, and we
> >> > find the 4K random read performance on syncing Raid6 will be improved
> >> > and go back to as what it should be in Kernel 3.19.8.
> >> >
> >> > Nevertheless, it seems that it will not affect some other read/write
> >> > patterns. In our testing result, the 1M sequential read/write, 4K
> >> > random write performance in Kernel 4.2.8 is performed almost the same
> >> > as in Kernel 3.19.8.
> >> >
> >> > It seems that although this patch increases the resync speed, the
> >> > logic of !is_mddev_idle() cause the sync request wait too short and
> >> > reduce the chance for raid5d to handle the random read I/O.
> >> 
> >> This has been raised before.
> >> Can you please try the patch at the end of 
> >> 
> >>   http://permalink.gmane.org/gmane.linux.raid/51002
> >> 
> >> and let me know if it makes any difference.  If it isn't sufficient I
> >> will explore further.
> >
> > I'm curious why we don't calculate the wait time. Say the target resync speed
> > is speed_min. The wait time should be:
> >
> > (currspeed * SYNC_MARK_STEP - speed_min * SYNC_MARK_STEP) / speed_min
> > = (currspeed / speed_min - 1) * SYNC_MARK_STEP
> >
> > if SYNC_MARK_STEP is too big and sync speed has drift, we can make it smaller.
> 
> What do you hope this would achieve?

The whole point is to throttle sync speed to specific speed. If we know the
target speed, for any given time interval, we can calculate the sync IO size.
 
> If I understand correctly, this might allow the thread to sleep for
> longer instead of looping around every 500ms or so.  But we don't really
> want to do that.  As soon as filesystem IO pauses, we want resync IO to
> go back to full speed.
> 
> The "speed_min" isn't really a "target".  It is only a "target" for
> those times when there is no filesystem IO.

Yep, target is a little bit hard to determine. I think we can do:
if (curspeed > min) {
	if (!is_mddev_idle())
		targetspeed = minspeed;
	if (curspeed > max)
		targetspeed = maxspeed;
	sleep(max((currspeed / targetspeed - 1), 0) * SYNC_MARK_STEP)
}

This way we don't throttle if there is no filesystem IO. would this work?

Thanks,
Shaohua
