From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH 3/3 v2] md: unblock array if bad blocks have been
 acknowledged
Date: Fri, 21 Oct 2016 16:33:11 +0200
Message-ID: <20161021143311.GA8376@proton.igk.intel.com>
References: <1476799824-6498-1-git-send-email-tomasz.majchrzak@intel.com>
 <20161020052818.GA17974@kernel.org>
 <20161020120915.GA8711@proton.igk.intel.com>
 <20161020215515.GA97678@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161020215515.GA97678@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 20, 2016 at 02:55:15PM -0700, Shaohua Li wrote:
> On Thu, Oct 20, 2016 at 02:09:15PM +0200, Tomasz Majchrzak wrote:
> > On Wed, Oct 19, 2016 at 10:28:18PM -0700, Shaohua Li wrote:
> > > On Tue, Oct 18, 2016 at 04:10:24PM +0200, Tomasz Majchrzak wrote:
> > > > Once external metadata handler acknowledges all bad blocks (by writing
> > > > to rdev 'bad_blocks' sysfs file), it requests to unblock the array.
> > > > Check if all bad blocks are actually acknowledged as there might be a
> > > > race if new bad blocks are notified at the same time. If all bad blocks
> > > > are acknowledged, just unblock the array and continue. If not, ignore
> > > > the request to unblock (do not fail an array). External metadata handler
> > > > is expected to either process remaining bad blocks and try to unblock
> > > > again or remove bad block support for a disk (which will cause disk to
> > > > fail as in no-support case).
> > > > 
> > > > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> > > > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > > > ---
> > > >  drivers/md/md.c | 24 +++++++++++++++++-------
> > > >  1 file changed, 17 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > index cc05236..ce585b7 100644
> > > > --- a/drivers/md/md.c
> > > > +++ b/drivers/md/md.c
> > > > @@ -2612,19 +2612,29 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
> > > >  		set_bit(Blocked, &rdev->flags);
> > > >  		err = 0;
> > > >  	} else if (cmd_match(buf, "-blocked")) {
> > > > -		if (!test_bit(Faulty, &rdev->flags) &&
> > > > +		int unblock = 1;
> > > > +		int acked = !rdev->badblocks.unacked_exist;
> > > > +
> > > > +		if ((test_bit(ExternalBbl, &rdev->flags) &&
> > > > +		     rdev->badblocks.changed))
> > > > +			acked = check_if_badblocks_acked(&rdev->badblocks);
> > > > +
> > > > +		if (test_bit(ExternalBbl, &rdev->flags) && !acked) {
> > > > +			unblock = 0;
> > > > +		} else if (!test_bit(Faulty, &rdev->flags) &&
> > > 
> > > I missed one thing in last review. writing to bad_blocks sysfs file already
> > > clears the BlockedBadBlocks bit and wakeup the thread sleeping at blocked_wait,
> > > so the array can continue. Why do we need to fix state_store here?
> > 
> > We cannot unblock the rdev until all bad blocks are acknowledged. The problem is
> > mdadm cannot be sure it has stored all bad blocks in the first pass (read of
> > unacknowledged_bad_blocks sysfs file). When bad block is encountered, rdev
> > enters Blocked, Faulty state (unacked_exists is non-zero in state_show). Then
> > mdadm reads the bad block, stores it in metadata and acknowledges it to the
> > kernel. Initially I have tried to call ack_all_badblocks in bb_store or in
> > state_store("-blocked") but there was a race. If other requests (the ones that
> > had started before array got into blocked state) notified bad blocks after sysfs
> > file was read by mdadm but before ack_all_badblocks call, ack_all_badblocks call
> > was also acknowledging bad blocks not stored (and never to be as a result) in
> > metadata. That's why I have introduced a new function
> > check_if_all_badblocks_acked to close this race.
> > 
> > I'm not sure if native bad block support is not prone to the similar problem -
> > bad block structure modified between metadata sync and ack_all_badblocks call.
> > 
> 
> Yep, we always have the race here. Fortunately we don't need to wait all
> badblocks acknowledged, the user of md_wait_for_blocked_rdev will retry. In the
> retry, we will check if the badblock is acknowledged.
> 
> The native bad block support doesn't have the race. We copy badblocks to a new
> page, clear badblocks->changed and then write the new page to disks.
> ack_all_badblocks will check the ->changed, and do nothing if it's set. So if
> something happens in between, ack_all_badblocks will do nothing.
> 
> While the external metadata array hasn't such mechanism to avoid race, I still
> thought changing state_store isn't a good idea.
> 
> I just sent a patch to fix badblocks_set() and make it clear unacked_exists.
> bb_store shouldn't call ack_all_badblocks in your case, but we don't need to.
> As long as mdadm uses bb_store to acknowledge the ranges, the array can
> continue. And if badblocks_set() can clear unacked_exists, the array will not
> be reported as Blocked.
> 
> > As for BlockedBadBlocks flag cleared in bb_store, commit de393cdea66c ("md: make
> > it easier to wait for bad blocks to be acknowledged") explains this flag is only
> > an advisory. All awaiting requests are woken up and check if bad block that
> > interests them is already acknowledged. If so, then can continue, and if not,
> > they set the flag again to check in a while. It is just a useful optimization.
> 
> I think 'advisory' means the driver should retry
>  
> > Please note that rdev with unacknowledged bad block is reported as Blocked via
> > sysfs state (non-zero unacked_exists), even though the corresponding rdev kernel
> > flag is not set. It is the reason why mdadm calls state_store("-blocked").
> 
> If badblocks_set() can clear unacked_exists, this isn't required.

Thank you for your hints. I have resent my patches. They come on top of your patch.

Tomek
