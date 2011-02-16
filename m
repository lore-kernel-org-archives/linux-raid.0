From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 23:50:28 +0100
Message-ID: <20110216225028.GA11472@www2.open-std.org>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 16, 2011 at 09:27:51PM +1100, NeilBrown wrote:
> 
> RAID1, RAID10 and RAID456 should all support bad blocks.  Every read
> or write should perform a lookup of the bad block list.  If a read
> finds a bad block, that device should be treated as failed for that
> read.  This includes reads that are part of resync or recovery.
> 
> If a write finds a bad block there are two possible responses.  Either
> the block can be ignored as with reads, or we can try to write the
> data in the hope that it will fix the error.  Always taking the second
> action would seem best as it allows blocks to be removed from the
> bad-block list, but as a failing write can take a long time, there are
> plenty of cases where it would not be good.

I was thinking of a further refinement, namely that if there is a bad
block on one drive, then the corresponding good block of another drive
should be read, and written to a bad block recovery area on the
erroneous drive. In that way the erroneous dive would still hold
the complete data. The bad block list would then hold both  the bad
block and then the corresponding good block in the bad block recovery
area. Given that the number of bad blocks would be small,
this would not really hurt performance.

the bad block recovery area could be handled as other metadata on the
drive. I think this reflects much what is currently done in most disk
hardware, except that the corresponding good block is copied from another
drive.

> Support reshape of RAID10 arrays.
> ---------------------------------
> 
> 6/ changing layout to or from 'far' is nearly impossible...
>    With a change in data_offset it might be possible to move one
>    stripe at a time, always into the place just vacated.
>    However keeping track of where we are and were it is safe to read
>    from would be a major headache - unless it feel out with some
>    really neat maths, which I don't think it does.
>    So this option will be left out.

I think this can easily be done for some of the more common cases of
"far", eg a 2 or 4-drive raid10 - possibly all layouts involving an
even number of drives. You can just have say one set of complete data 
intact and then rewrite the whole other set of data in the new layout. 
Please note that there may be two versions of the layout of "near" and
"far", one looking like a raid 1+0 and one loking as a raid 0+1, giving
distinct different survival characteristics with failure of more than
one drive. In a 4-drive raid0, the one layout will have a 66 % chance of
surviving a 2 drive crash, while the other version will have a 33 %
chance of surviving 2 disks crashing.

I am not sure this can be generalized to all combinations of drives and
layouts. However, the simple cases are common enough and simple enough
to do to warrant the implementation, IMHO.

> So the only 'instant' conversion possible is to increase the device
> size for 'near' and 'offset' array.
> 
> 'reshape' conversions can modify chunk size, increase/decrease number of
> devices and swap between 'near' and 'offset' layout providing a
> suitable number of chunks of backup space is available.
> 
> The device-size of a 'far' layout can also be changed by a reshape
> providing the number of devices in not increased.

given that most configurations of "far" can be reshaped into "near" -
then the additin of drives should be possible by: reshape far to near,
extend near, reshape near to far.

Other improvements
------------------

I would like to hear if you are considering other improvements:

1.  a layout version of raid10,far and raid10,near thathas a better
survival ratio for failure fo 2 disks or more. The current layout only
have properties of raid 0+1.

2. better performance of resync etc, by using bigger buffers say 20 MB.

best regards
keld
