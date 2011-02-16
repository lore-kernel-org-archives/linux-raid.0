From: David Brown <david@westcontrol.com>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 16:42:26 +0100
Message-ID: <ijgr9p$7v8$1@dough.gmane.org>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/02/2011 11:27, NeilBrown wrote:
>
> I all,
>   I wrote this today and posted it at
> http://neil.brown.name/blog/20110216044002
>
> I thought it might be worth posting it here too...
>
> NeilBrown
>


The bad block log will be a huge step up for reliability by making 
failures fine-grained.  Occasional failures are a serious risk, 
especially with very large disks.  The bad block log, especially 
combined with the "hot replace" idea, will make md raid a lot safer 
because you avoid running the array in degraded mode (except for a few 
stripes).

When a block is marked as bad on a disk, is it possible to inform the 
file system that the whole stripe is considered bad?  Then the 
filesystem will (I hope) add that stripe to its own bad block list, move 
the data out to another stripe (or block, from the fs's viewpoint), thus 
restoring the raid redundancy for that data.

Can a "hot spare" automatically turn into a "hot replace" based on some 
criteria (such as a certain number of bad blocks)?  Can the replaced 
drive then become a "hot spare" again?  It may not be perfect, but it is 
still better than nothing, and useful if the admin can't replace the 
drive quickly.

It strikes me that "hot replace" is much like one of the original disks 
out of the array and replacing it with a RAID 1 pair using the original 
disk and a missing second.  The new disk is then added to the pair and 
they are sync'ed.  Finally, you remove the old disk from the RAID 1 
pair, then re-assign the drive from the RAID 1 "pair" to the original RAID.

I may be missing something, but if I think that using the bad-block list 
and the non-sync bitmaps, the only thing needed to support hot replace 
is a way to turn a member drive into a degraded RAID 1 set in an atomic 
action, and to reverse this action afterwards.  This may also give extra 
flexibility - it is conceivable that someone would want to keep the RAID 
1 set afterwards as a reshape (turning a RAID 5 into a RAID 1+0, for 
example).

For your non-sync bitmap, would it make sense to have a two-level 
bitmap?  Perhaps a coarse bitmap in blocks of 32 MB, with each entry 
showing a state of in sync, out of sync, partially synced, or never 
synced.  Partially synced coarse blocks would have their own fine bitmap 
at the 4K block size (or perhaps a bit bigger - maybe 32K or 64K would 
fit well with SSD block sizes).  Partially synced and out of sync blocks 
would be gradually brought into sync when the disks are otherwise free, 
while never synced blocks would not need to be synced at all.

This would let you efficiently store the state during initial builds 
(everything is marked "never synced" until it is used), and rebuilds are 
done by marking everything as "out of sync" on the new device.  The 
two-level structure would let you keep fine-grained sync information 
from file system discards without taking up unreasonable space.




