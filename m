From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid0 and iscsi
Date: Tue, 14 Oct 2003 16:23:40 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16267.38508.484427.47316@notabene.cse.unsw.edu.au>
References: <200310130434.h9D4YU0n020486@bach.cs.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jayshankar Nair on Sunday October 12
To: Jayshankar Nair <jshankar@CS.ColoState.EDU>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 12, jshankar@CS.ColoState.EDU wrote:
> Hello,
> 
> 
> I was testing the raid0 configuration for the iscsi device ( /dev/sdb and 
> /dev/sdc).
> 
> For writing a 512MB in a LAN environment it was taking 24 hrs. i was going
> through the source code of raid0.c and certain things doesn't made sense to me.
> 
> 1> what role does the Hash bit play.

A raid0 array can be made of a number of drives of differing sizes.
To accomodate this we divide the address space into several blocks.
The first block is striped across all drives to the size of the
smallest.  The next block is striped across the remaining drives to
the size of the next smallest, etc.

Mapping from a virtual device address to block and thence a drive and
offset is not straight forward.  It requires a table search.  The hash
table helps accelerate this search.


> 2>If my chunk size is 8 byte. Does that mean it will write 8 byte into device 0 
> and then into device 1. Is the write request to the disk in synchronous or
> asynchronous mode. 
> 
You cannot have an 8byte chunk size.  4K is the minimum.
With an 8K chunk size and 2 devices,
 sectors between 0 and 8K, 16k and 24K, 32K and 40K, 48K and 56K etc
    are written to the first device.
 sectors between 8K and 16K, 28K and 32K, 40K and 48K etc
    are written to the second device.

raid0 does not impose any synchronisation.  Writes are only
synchronous if the filesystem waits for them.  raid0 never waits.

> 
> 3> Is wite_disk_sb in md.c responsible for writing into disk??. Is fsync_dev 
> responsible for synhronous write ??. If so can i change to asynchronous write.I 
> will really appreciate if somebody can tell me what all routines I need to go 
> through to figure out the functionality of raid0 behaviour.

write_disk_sb is for writing the raid superblock to disk.  It doesn't
happen often.
fsync_dev is fairly irrelevant. You can safely ignore it.

I hope that helps.

NeilBrown

> 
> Thanks
> Jayshankar
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
