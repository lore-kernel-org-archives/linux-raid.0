From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: RAID5 made with assume-clean
Date: Thu, 7 Feb 2013 13:14:25 -0500
Message-ID: <20130207181425.GA27682@animx.eu.org>
References: <20130206115258.GA31466@animx.eu.org>
 <20130206130254.GA12118@cthulhu.home.robinhill.me.uk>
 <20130206145446.GA14892@animx.eu.org>
 <20130207142933.GB16690@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130207142933.GB16690@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Wed Feb 06, 2013 at 09:54:46AM -0500, Wakko Warner wrote:
> 
> > Please keep me in CC.
> > 
> Then don't set the Mail-Followup-To header to point to the list,
> otherwise you're strongly suggesting that you don't want to be CCed in
> the replies.

It wasn't supposed to be set.  I never configured mutt to do so.  I've set
the follow up to my address.  I didn't know it was doing that.  Thanks for
letting me know.

> > Robin Hill wrote:
> > > What disks are they? I would expect a modern SATA disk to be able to
> > > handle 120MB/s for sequential read, so 220 across the array would be
> > > pretty normal.
> > 
> > They are old WDC 250 disks.  I did a DD test on them, they are 60mb/sec.  A
> > DD test on the array gives me about 119mb/sec.  As I stated, the activity
> > lights did not even come on during the check.  Nothing was done.  This is
> > kernel 3.3.0.  
> > 
> That does seem odd then. I've never seen that happen before. Has the
> array been stopped & restarted since the initial creation? It may be
> that having created it with --assume-clean is setting something which
> short-circuits the check process.

I'm not sure.  Since the array (md0) is an LVM PV, I added another PV
yesterday.  I moved the LVs to the new PV and recreated the array.  It did
do the resync process.  All 3 activity lights were active.

> > > Not sure what the logic is on this. For a 3 disk array it'd need a
> > > single read and 2 writes for a single chunk, whether it's doing RMW or
> > > not. It will probably still do RMW though, as that avoids the
> > > complication of special-casing things. I've had a quick look at the code
> > > and I can't see any special casing (other than for a 2 disk array, where
> > > the same data is written to both).
> > 
> > I know there's 2 ways to update the parity.
> > 1) Read the other data blocks, calculate parity, modify parity block.  Or
> > 2) Read the parity, read the old data, calculate new parity, write parity.
> > 
> > Obviously, with many disks, #2 is the best option.  With 3 disks, #1 would
> > be the best option (IMO) especially when created with assume clean.
> > 
> Performance-wise there's little difference (though #2 may be slightly
> quicker as it avoids a seek on one disk), but #1 makes the code more
> complex and will only help in really obscure situations.

I guess that depends.  On a 3 drive array, it wouldn't make a difference in
performance, but #1 would always keep the parity accurate (barring disk
errors).  #2 would make a difference in performance if there were more
disks.  Say 10 and there were multiple writes.

> > > That's definitely the safest option. If you can verify the data then you
> > > could run a repair and a fsck before verifying/restoring the data, but
> > > that'd take far longer than a simple rebuild and restore.
> > 
> > The data I added was transfered from one LVM PV to this one with pvmove. 
> > One volume was DDd from the old disk that this array was replacing.  I saved
> > the raw volume image to another server incase I messed something up (and the
> > old disk was dying anyway)
> > 
> > I really wanted to know the answer to the problem where check didn't work.
> > If I recreate the array, I'll add another drive to the VG and move the
> > volumes off, recreate and move back.
> > 
> I'd suggest stopping & restarting the array (if this hasn't been done)
> and rerunning the check (or just running a repair straightaway).

As stated above, I just rebuilt the array.  The speed was expected at around
60mb/sec.  Interestingly, if I issue a check on it, it still won't touch the
disks the entire time it's checking the array.  I have another array in this
machine and it does the same thing.  It may be a kernel bug with 3.3.0, not
sure.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
