From: NeilBrown <neilb@suse.de>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Fri, 1 Jul 2011 23:02:19 +1000
Message-ID: <20110701230219.51604317@notabene.brown>
References: <4E0C5539.4030000@gmx.de>
	<4E0C5E47.5090604@anonymous.org.uk>
	<4E0C6CC4.3030506@turmel.org>
	<4E0C7196.1070307@gmx.de>
	<4E0C7B4B.7090404@turmel.org>
	<4E0C8685.3020806@gmx.de>
	<20110701072855.69ee763b@notabene.brown>
	<iujspj$jgg$1@dough.gmane.org>
	<20110701085044.GA22611@cthulhu.home.robinhill.me.uk>
	<iuk70t$emh$1@dough.gmane.org>
	<20110701112915.GB22611@cthulhu.home.robinhill.me.uk>
	<iukfjs$34e$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iukfjs$34e$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 01 Jul 2011 14:45:00 +0200 David Brown <david@westcontrol.com> wrote:

> On 01/07/2011 13:29, Robin Hill wrote:
> > On Fri Jul 01, 2011 at 12:18:22PM +0200, David Brown wrote:
> >
> >> On 01/07/2011 10:50, Robin Hill wrote:
> >>> On Fri Jul 01, 2011 at 09:23:43 +0200, David Brown wrote:
> >>>
> >>>> What's the difference between a "resync" and a "recovery"?  Is it that a
> >>>> "resync" will read the whole stripe, check if it is valid, and if it is
> >>>> not it then generates the parity, while a "recovery" will always
> >>>> generate the parity?
> >>>>
> >>>    From the names, recovery would mean that it's reading from N-1 disks,
> >>> and recreating data/parity to rebuild the final disk (as when it
> >>> recovers from a drive failure), whereas resync will be reading from all
> >>> N disks and checking/recreating the parity (as when you're running a
> >>> repair on the array).
> >>>
> >>> The main reason I can see for doing a resync on RAID6 rather than a
> >>> recovery is if the data reconstruction from the Q parity is far slower
> >>> that the construction of the Q parity itself (I've no idea how the
> >>> mathematics works out for this).
> >>>
> >>
> >> Well, data reconstruction from Q parity /is/ more demanding than
> >> constructing the Q parity in the first place (the mathematics is the
> >> part that I know about).  That's why a two-disk degraded raid6 array is
> >> significantly slower (or, more accurately, significantly more
> >> cpu-intensive) than a one-disk degraded raid6 array.
> >>
> >> But that doesn't make a difference here - you are rebuilding one or two
> >> disks, so you have to use the data you've got whether you are doing a
> >> resync or a recovery.
> >>
> > Yes, but in a resync all the data you have available is the data
> > blocks, and you're reconstructing all the P and Q parity blocks. With a
> > recovery, the data you have available is some of the data blocks and some
> > of the P&  Q parity blocks, so for some stripes you'll be reconstructing
> > the parity and for others you'll be regenerating the data using the
> > parity (and for some you'll be doing one of each).
> >
> 
> If were that simple, then the resync (as used by RAID6 creates) would 
> not be so much slower the recovery used in a RAID5 build...
> 
> With a resync, you first check if the parity blocks are correct (by 
> generating them from the data blocks and comparing them to the read 
> parity blocks).  If they are not correct, you write out the parity 
> blocks.  With a recovery, you /know/ that one block is incorrect and 
> re-generate that (from the data blocks if it is a parity block, or using 
> the parities if it is a data block).
> 
> Consider the two cases raid5 and raid6 separately.
> 
> When you build your raid5 array, there is nothing worth keeping in the 
> data - the aim is simply to make the stripes consistent.  There are two 
> possible routes - consider the data blocks to be "correct" and do a 
> resync to make sure the parity blocks match, or consider the first n-1 
> disks to be "correct" and do a recovery to make sure the n'th disk 
> matches.  For recovery, that means reading n-1 blocks in a stripe, doing 
> a big xor, and writing out the remaining block (whether it is data or 
> parity).  For rsync, it means reading all n blocks, and checking the 
> xor.  If there is no match (which will be the norm when building an 
> array), then the correct parity is calculated and written out.  Thus an 
> rsync takes longer than a recovery, and a recovery is used.
> 
> When you build your raid6 array, you have the same two choices.  For an 
> rsync, you have to read all n blocks, calculate P and Q, compare them, 
> then (as there will be no match) write out P and Q.  In comparison to 
> the raid5 recovery, you've done a couple of unnecessary block reads and 
> compares, and the time-consuming Q calculation and write.  But if you 
> chose recovery, then you'd be assuming thve first n-2 blocks are correct 
> and re-calculating the last two blocks.  This avoids the extra reads and 
> compares, but if the two parity blocks are within the first n-2 blocks 
> read, then the recovery calculations will be much slower.  Hence an 
> rsync is faster for raid6.
> 
> I suppose the raid6 build could be optimised a little by skipping the 
> extra reads when you know in advance that they will not match.  But 
> either that is already being done, or it is considered a small issue 
> that is not worth changing (since it only has an effect during the 
> initial build).
> 

Almost everything you say is correct.
However I'm not convinced that a raid6 resync is faster than a raid6 recovery
(on devices where P and Q are not mostly correct).  I suspect it is just an
historical oversight that RAID6 doesn't force a recovery for the initial
create.

In any one would like to test it is easy to force a recovery by specifying
missing devices:

   mdadm -C /dev/md0 -l6 -n6 /dev/sd[abcd] missing missing -x2 /dev/sd[ef]

and easy to force a resync by using --force

   mdadm -C /dev/md0 -l5 -n5 /dev/sd[abcde] --force

It is only really a valid test if you know that the P and Q that resync will
read are not going to be correct most of the time.

NeilBrown
