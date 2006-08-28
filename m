From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Mon, 28 Aug 2006 13:46:02 +1000
Message-ID: <17650.26362.445865.67553@cse.unsw.edu.au>
References: <1155987607.7207.23.camel@localhost.localdomain>
	<17641.25141.373827.77279@cse.unsw.edu.au>
	<1156147425.4525.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lem on Monday August 21
Sender: linux-raid-owner@vger.kernel.org
To: Lem <l3mming@iinet.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 21, l3mming@iinet.net.au wrote:
> 
> This is where I'm having a problem - lilo fails due to the bogus
> partition table, here's the output:
> 
> # lilo
> part_nowrite: read:: Input/output error

I think maybe lilo needs to be fixed.  If you haven't explicitly told
it to look at sde, the worst it should do is give a warning.
Maybe you can put something in lilo.conf to tell it what sort of
partitions sde does (or doesn't) have so it won't bother looking
itself?

> 
> The above buffer I/O errors (logical block 1792+) occur as filesystems
> are being automounted. /dev/sde* doesn't exist in /etc/fstab of course.
> 

Do you mount-by-label at all.  In that case mount we look at each
partition, but it doesn't fail, so not-a-problem.

> 
> A few questions, searching for the best possible solution. I believe
> this is worth the effort, else I can't run lilo without disabling the
> array and removing /dev/sde from the system.
> 
> 1. Is it possible to have mdadm or another tool automatically convert
> the superblocks to v1.1/1.2 (and perhaps create proper partitions)?

No.  It would require moving all the data on the device.

> 
> 2. If number 1 isn't possible, is it possible to convert one drive at a
> time to have a proper partition table? Like this: Stop array;
> fdisk /dev/sde, create partition of type fd (entire disk), save
> partition table; Start array. (then I'd assume mdadm would notice
> that /dev/sde has changed and possibly start a resync? - if not, and it
> just works, then great!). If that works, then do every other drive, one
> at a time.

When you create a partition table, sde1 will be slightly smaller than
sde1.  But if it is less than 64K smaller you might be able to do
something.  mdadm won't notice by itself, but you could tell it.

 mdadm /dev/md0 --fail /dev/sde
 mdadm /dev/md0 --remove /dev/sde
 mdadm --zero-superb lock /dev/sde
 ##use fdisk to create a single partition
 mdadm /dev/md0 --add /dev/sde1
 ## if that works then wait for the resync to complete
 ## and do the same to other drives.  Then update any
 ## config files that might be relevant.

NeilBrown
