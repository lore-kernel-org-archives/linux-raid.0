From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: RAID5 made with assume-clean
Date: Wed, 6 Feb 2013 09:54:46 -0500
Message-ID: <20130206145446.GA14892@animx.eu.org>
References: <20130206115258.GA31466@animx.eu.org>
 <20130206130254.GA12118@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130206130254.GA12118@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please keep me in CC.

Robin Hill wrote:
> On Wed Feb 06, 2013 at 06:52:58AM -0500, Wakko Warner wrote:
> 
> > I was testing different parameters with --assume-clean to avoid the initial
> > rebuild.  When I decided on the parameters I wanted, I forgot to create the
> > array without --assume-clean.  I have 3 disks in the array.
> > 
> > I thought that I'd run a check on it by doing
> > echo check > /sys/block/md0/md/sync_action
> > 
> > /proc/mdstat is showing this:
> > Personalities : [raid1] [raid6] [raid5] [raid4] 
> > md0 : active raid5 sda1[0] sdb1[1] sdc1[2]
> >       488018688 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> >       [============>........]  check = 61.7% (150688512/244009344) finish=7.1min speed=216592K/sec
> > 
> > unused devices: <none>
> > 
> > The thing is, the drives can only do ~60mb/sec and there is no disk
> > activity.  The activity lights are not lit at all.  What would cause that?
> > 
> What disks are they? I would expect a modern SATA disk to be able to
> handle 120MB/s for sequential read, so 220 across the array would be
> pretty normal.

They are old WDC 250 disks.  I did a DD test on them, they are 60mb/sec.  A
DD test on the array gives me about 119mb/sec.  As I stated, the activity
lights did not even come on during the check.  Nothing was done.  This is
kernel 3.3.0.  

> > I was also wondering if the raid5 did RMW on the parity with 3 disks when
> > the array is written to.
> > 
> Not sure what the logic is on this. For a 3 disk array it'd need a
> single read and 2 writes for a single chunk, whether it's doing RMW or
> not. It will probably still do RMW though, as that avoids the
> complication of special-casing things. I've had a quick look at the code
> and I can't see any special casing (other than for a 2 disk array, where
> the same data is written to both).

I know there's 2 ways to update the parity.
1) Read the other data blocks, calculate parity, modify parity block.  Or
2) Read the parity, read the old data, calculate new parity, write parity.

Obviously, with many disks, #2 is the best option.  With 3 disks, #1 would
be the best option (IMO) especially when created with assume clean.

> > I can rebuild the array without assume-clean if that's the only way I can
> > get the parity to be correct, but I'd like to avoid doing that if possible.
> > 
> That's definitely the safest option. If you can verify the data then you
> could run a repair and a fsck before verifying/restoring the data, but
> that'd take far longer than a simple rebuild and restore.

The data I added was transfered from one LVM PV to this one with pvmove. 
One volume was DDd from the old disk that this array was replacing.  I saved
the raw volume image to another server incase I messed something up (and the
old disk was dying anyway)

I really wanted to know the answer to the problem where check didn't work.
If I recreate the array, I'll add another drive to the VG and move the
volumes off, recreate and move back.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
