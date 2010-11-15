From: Neil Brown <neilb@suse.de>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Tue, 16 Nov 2010 06:53:25 +1100
Message-ID: <20101116065325.6dd5e8cf@notabene.brown>
References: <4CE00206.4000301@geograph.co.za>
	<20101115091326.42b38b84@notabene.brown>
	<4CE1758C.5080008@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE1758C.5080008@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Zoltan Szecsei <zoltans@geograph.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Nov 2010 20:01:48 +0200
Zoltan Szecsei <zoltans@geograph.co.za> wrote:

> Hi,
> One last quick question:
> 
> Neil Brown <neilb@suse.de> wrote:
> > Depending on which version of mdadm you are using, the default chunk size
> > will be 64K or 512K.  I would recommend using 512K even if you have an older
> > mdadm.  64K appears to be too small for modern hardware, particularly if you
> > are storing large files.
> >
> > For raid6 with the current implementation it is safe to use "--assume-clean"
> > to avoid the long recovery time.  It is certainly safe to use that if you
> > want to build a test array, do some performance measurement, and then scrap
> > it and try again.  If some time later you want to be sure that the array is
> > entirely in sync you can
> >    echo repair>  /sys/block/md0/md/sync_action
> > and wait a while.
> >    
> ****************************************************
> I have compiled the following mdadm on my Ubuntu 64 bit 10.04 Desktop 
> system:
> root@gs0:/home/geograph# uname -a
> Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2010 
> x86_64 GNU/Linux
> root@gs0:/home/geograph# mdadm -V
> mdadm - v3.1.4 - 31st August 2010
> root@gs0:/home/geograph#
> 
> ****************************************************
> I have deleted the partitions on all 8 drives, and done a mdadm -Ss
> 
> root@gs0:/home/geograph# fdisk -lu
> 
> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
> 
> Disk /dev/sda doesn't contain a valid partition table
> 
> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
> 
> ******************************************************
> Based on the above "assume-clean" comment, plus all the help you guys 
> have offered, I have just run:
> mdadm --create /dev/md0 --metadata=1.2 --auto=md --assume-clean 
> --bitmap=internal --bitmap-chunk=131072 --chunk=512 --level=6 
> --raid-devices=8 /dev/sd[abcdefgh]
> 
> It took a nano-second to complete!
> 
> The man-pages for assume-clean say that "the array pre-existed". Surely 
> as I have erased the HDs, and now have no partitions on them, this is 
> not true?
> Do I need to re-run the above mdadm command, or is it safe to proceed 
> with LVM then mkfs ext4?

It is safe to proceed.

The situation is that the two parity block are probably not correct on most
(or even any) stripes.  But you have no live data on them to protect, so it
doesn't really matter.

With the current implementation of RAID6, every time you write, the correct
parity blocks are computed and written.  So any live data that is written
will be accompanies by correct parity blocks to protect it.

This does *not* apply to RAID5 as it sometimes uses the old parity block to
compute the new parity block.  If the old was wrong, the new will be wrong
too.

It is conceivable that one day we might change the raid6 code to perform
similar updates if it ever turns out to be faster to do it that way, but it
seems unlikely at the moment.

NeilBrown


> 
> Thanks for all,
> Zoltan
> 
> ******************************************************
> root@gs0:/home/geograph# mdadm -E /dev/md0
> mdadm: No md superblock detected on /dev/md0.
> 
> 
> 
> root@gs0:/home/geograph# ls -la /dev/md*
> brw-rw---- 1 root disk 9, 0 2010-11-15 19:53 /dev/md0
> /dev/md:
> total 0
> drwxr-xr-x  2 root root   60 2010-11-15 19:53 .
> drwxr-xr-x 19 root root 4260 2010-11-15 19:53 ..
> lrwxrwxrwx  1 root root    6 2010-11-15 19:53 0 -> ../md0
> 
> 
> root@gs0:/home/geograph# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
> [raid4] [raid10]
> md0 : active raid6 sdc[2] sdf[5] sdh[7] sdd[3] sdb[1] sdg[6] sda[0] sde[4]
>        11721077760 blocks super 1.2 level 6, 512k chunk, algorithm 2 
> [8/8] [UUUUUUUU]
>        bitmap: 0/8 pages [0KB], 131072KB chunk
> 
> unused devices: <none>
> 
> 
> 
> 
> *******************************************************
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 

