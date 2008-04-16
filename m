From: "David Lethe" <david@santools.com>
Subject: RE: Mapping physical disk block to logical block to selectively repair w/o forcing rescan
Date: Wed, 16 Apr 2008 09:32:04 -0500
Message-ID: <A49AB75A717185448F69082E969E536B03C26549@34093-EVS1C2.exchange.rackspace.com>
References: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com> <e9c3a7c20804151735n6793339dl764c0d57aedabc57@mail.gmail.com> <e9c3a7c20804151737k44b09572x484c7c41ff90e09d@mail.gmail.com> <A49AB75A717185448F69082E969E536B03C264CC@34093-EVS1C2.exchange.rackspace.com> <48060623.9030109@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-reply-to: <48060623.9030109@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
From: Bill Davidsen [mailto:davidsen@tmr.com] 
Sent: Wednesday, April 16, 2008 8:59 AM
To: David Lethe
Cc: Dan Williams; linux-raid@vger.kernel.org
Subject: Re: Mapping physical disk block to logical block to selectively
repair w/o forcing rescan

David Lethe wrote:
> I have the physical disk sector/drive, so I will have to go backwards.
> That means using compute_blocknr, factoring the chunk size, stripe
size,
> look at the raid5_private_data to get everything else, including
whether
> or not it is in a rebuild, what position the disk has in the stripe,
> among
> other things .. and repeat for RAID6.  Still all scriptable .. as long
> as I keep the block calculations in 64-bits when on 32-bit kernel. 
>
>   
Or use "bc" to do really long calculations. It works well with scripts.

> I can parse mdadm -Q -D  to get health and configuration, or get it
from
> sysfs, haven't decided.
>
> Now for recovery ... a change was made in 2.6.15 that affects how the
> /dev/md recalculates & corrects the error, but I don't think I have to
> worry about it. Just directly read the /dev/md block that corresponds
to
> the faulty physical disk/sector.  This should just repair the bad
block
> w/o enticing the md system to fail over the entire disk.  Exception
> would be if the disk with bad block can remap due to a catastrophic
> failure, or lack of spare sectors.  
>
> Even if the bad physical block lands on a parity block in the /dev/md
> space, it should get rebuilt because it has to read the entire stripe
to
> figure out if there is a parity error, which there will be because one
> disk will return the sense data indicating an unrecoverable read
error,
> so the md will repair the stripe to keep parity consistent for me.
>
>   
The problem I see with this is that using raid1 you can read and entire 
array end to end and never use one mirror of the data. So unless you 
perform the 'check' operation you won't really be sure that you have the

errors mapped. I suspect that running check fixes more errors than 
'repair' on most systems.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


===================================================================
So now it looks like I am back to using badblocks?   Will this force a
parity rebuild on RAID1?
I expect it would if I gave it a read/write or write flag, but I can't
do that because filesystems will be mounted.  It appears that 2.6.15
kernels and above at least have potential to do a parity rebuild on
reads, and prior kernels need a write to force a parity rebuild.

i.e,   badblocks -b 512 (KnownBadBlock-StripeSizeInBlocks)
StripeSizeInBlocks*3 /dev/mdN

(if known bad block is in first stripe then just start at block zero. If
I make total number of blocks 3 times the stripesize, and make it look
at the full stripes before and after the one that contains the parity
error, then is this a good strategy for 2.6.15 kernels an up?
Nice thing about badblocks is that it scans at starting location and it
accepts a range, so I just give it a large enough area to scan that will
catch errors on parity blocks and prevent me from having to worry about
the layout of the parity info on the stripe.  

Unfortunately I can't use badblocks with the read/write mode because
file system is mounted . Will the badblocks as used above force a
rebuild, or am I going to have to follow the badblocks with a fsck, or
fsck equivalent for whatever file system they used with the md driver?



