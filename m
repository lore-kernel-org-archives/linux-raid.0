From: Neil Brown <neilb@suse.de>
Subject: Re: Resizing RAID-1 arrays - some possible bugs and problems
Date: Sat, 8 Jul 2006 08:12:01 +1000
Message-ID: <17582.56369.13427.473503@cse.unsw.edu.au>
References: <44AE644C.9090408@reub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Reuben Farrelly on Saturday July 8
Sender: linux-raid-owner@vger.kernel.org
To: Reuben Farrelly <reuben-lkml@reub.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 8, reuben-lkml@reub.net wrote:
> I'm just in the process of upgrading the RAID-1 disks in my server, and have 
> started to experiment with the RAID-1 --grow command.  The first phase of the 
> change went well, I added the new disks to the old arrays and then increased the 
> size of the arrays to include both the new and old disks.  This meant that I had 
> a full and clean transfer of all the data.  Then took the old disks out...it all 
> worked nicely.
> 
> However I've had two problems with the next phase which was the resizing of the 
> arrays.
> 
> Firstly, after moving the array, the kernel still seems to think that the raid 
> array is only as big as the older disks.  This is to be expected, however 
> looking at the output of this:
> 
> [root@tornado /]# mdadm --detail /dev/md0
> /dev/md0:
>          Version : 00.90.03
>    Creation Time : Sat Nov  5 14:02:50 2005
>       Raid Level : raid1
>       Array Size : 24410688 (23.28 GiB 25.00 GB)
>      Device Size : 24410688 (23.28 GiB 25.00 GB)
> 
> We note that the "Device Size" according to the system is still 25.0 GB.  Except 
> that the device size is REALLY 40Gb, as seen by the output of fdisk -l:

"Device Size" is a slight misnomer.  It actually means "the amount of
this device that will be used in the array".   Maybe I should make it
"Used Device Size".
> 
> Secondly, I understand that I need to use the --grow command to bring the array 
> up to the size of the device.
> How do I know what size I should specify? 

 --size=max

              This  value  can  be  set with --grow for RAID level 1/4/5/6. If the array was
              created with a size smaller than the currently active drives, the extra  space
              can  be  accessed  using  --grow.  The size can be given as max which means to
              choose the largest size that fits on all current drives.

> How much difference should there be?
> (Hint:  maybe this could be documented in the manpage (please), NeilB?)

man 4 md
       The  common  format - known as version 0.90 - has a superblock that is 4K long and is
       written into a 64K aligned block that starts at least 64K and less than 128K from the
       end  of  the  device (i.e. to get the address of the superblock round the size of the
       device down to a multiple of 64K and then subtract 64K).  The available size of  each
       device is the amount of space before the super block, so between 64K and 128K is lost
       when a device in incorporated into an MD array.  This  superblock  stores  multi-byte
       fields in a processor-dependant manner, so arrays cannot easily be moved between com-
       puters with different processors.


> 
> 
> And lastly, I felt brave and decided to plunge ahead, resize to 128 blocks 
> smaller than the device size.  mdadm --grow /dev/md1 --size=
> 
> The kernel then went like this:
> 
> md: couldn't update array info. -28
> VFS: busy inodes on changed media.
> md1: invalid bitmap page request: 150 (> 149)
> md1: invalid bitmap page request: 150 (> 149)
> md1: invalid bitmap page request: 150 (> 149)

Oh dear, that's bad.

I guess I didn't think through resizing of an array with an active
bitmap properly... :-(
That won't be fixed in a hurry I'm afraid.
You'll need to remove the bitmap before the grow and re-add it
afterwards, which isn't really ideal.  
I'll look at making this more robust when I return from vacation in a
week or so.

NeilBrown
