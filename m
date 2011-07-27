From: keld@keldix.com
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 10:17:29 +0200
Message-ID: <20110727081729.GA12505@www5.open-std.org>
References: <20110727141652.7511fc51@notabene.brown> <20110727062110.GA9801@www5.open-std.org> <20110727164959.3352c5a3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110727164959.3352c5a3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 27, 2011 at 04:49:59PM +1000, NeilBrown wrote:
> On Wed, 27 Jul 2011 08:21:10 +0200 keld@keldix.com wrote:
> 
> > On Wed, Jul 27, 2011 at 02:16:52PM +1000, NeilBrown wrote:
> > > 
> > > As mentioned earlier, Linux 3.1 will contain support for recording and
> > > avoiding bad blocks on devices in md arrays.
> > > 
> > How is it implemented? Does the bad block get duplicated in a reserve area?
> 
> No duplication - I expect the underlying device to be doing that, and doing
> it again at another level seems pointless.

My understanding is that most modern disk devices have their own bad blocks
management with replacement blocks. But many disks have an inadequate number of replacement 
blocks, and when that buffer of blocks runs out, you get a bad block reported 
to the IO system in the kernel.

So because of the sometimes low number of intrinsic disk reserve blocks,
there would be a point in having this facility replicated in the md layer.

I have for instance two 1 TB disks with some bad sectors on them,
which I have saved to test MD bad blocks handeling (when I get the time)
and do some other bad blocks work on. The errors there are stable, the bad blocks
list has not evolved for about a year.  And it is only about 100 blocks out of 1 TB.
I can still use most of the disk on my home server, and I would like to use it
in a fully functioning md array. IMHO there should not be much work in doing
a simple implementation that would guarantee full recovery of all valid data,
should one drive have a fatal error.

> The easiest way to think about it is that the strip containing a bad block is
> treated as 'degraded'.  You can have an array where only some strips are
> degraded, and they are each missing different devices.
> 
> > Or are also corresponding good blocks on other sound devices also excluded?
> 
> Not sure what you mean.  A bad block is just on one device.  Each device has
> its own independent table of bad blocks.

I was thinking that for example a raid1 or raid10 device, if there be 2 copies, then
declaring both copies bad, or marking that specific raid block as half-bad,
then you do not need a reserve area for bad blocks. Or maybe you could report
to the file system - eg. ext3/ext4 that this is a bad or half-bad block,
and then the file system could treat it accordingly.

There could be some process periodically going thru the md bad blocks list -
which would probably be quite short - a few thousands in bad cases, 
and compare it to the ext3/ext4 badblocks list, if a new bad block was found, then 
try to retrieve the good data, and reallocate the block. 
This scheme would only need access to the md badblocks buffer, no
specific APIs needed I think.

For file systems with no intrinsic bad block handling, such as xfs, 
one could have a similar periodic process finding new  half-bad blocks,
then reallocate the good data, and then mark the good data on the good disk as 
unusable - so it will not be used again. That would probably mean
an API to mark or query a block as bad - or virtually bad - in the md badblocks list.
This solution is general and still rather simple.

Both schemes scale well, given an adquate bad block md buffer.

> > How big a device can it handle?
> 
> 2^54 sectors which with 512byte sectors is 8 exbibytes.
> With larger sectors, larger devices.

And how many bad blocks can it handle? 4 KB is not much.
Is it just a simple list of 64 bit entries?

> > 
> > If a device fails totally and the remaining devices contain devices with
> > bad blocks, will there then be lost data?
> 
> Yes.  You shouldn't aim to run an array with bad blocks any more than you
> should run an array degraded.

This is of cause true, but I think you could add some more security
if you could handle more incidents occurring almost at the same time.

And in the case with my home server I think it would be OK to run with
a partly damaged disk.

> The purpose of bad block management is to provide a more graceful failure
> path, not to encourage you to run an array with bad drives (except for
> testing).

Yes, that is a great advantage.

> In particular this lays the ground work to implement hot-replace.  If you
> have a drive that is failing it can stay in the array and hobble along for a
> bit longer.  Meanwhile you add a fresh new drive as a hot-replace and let it
> rebuilt.  If there is a bad block elsewhere in the array the hot-replace
> drive might still rebuild completely.  And even if there is a failure, you
> will only lose some blocks, not the whole array.
> 
> This all makes is very hard to build confidence in the code - most of the
> time it is not used at all and I would rather it that way.  But when things
> start going wrong, you really want it to be 100% bug free.

Yes, I appreciate that the code should be simple.

Best regards
keld
