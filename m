From: Neil Brown <neilb@suse.de>
Subject: Re: questions about softraid limitations
Date: Fri, 16 May 2008 11:39:36 +1000
Message-ID: <18476.58840.602946.872085@notabene.brown>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs>
	<482AC2BB.5010602@dgreaves.com>
	<01be01c8b61a$6e616260$9300a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janos Haar on Thursday May 15
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <djani22@netcenter.hu>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 15, djani22@netcenter.hu wrote:
> Hello David,
> 
> ----- Original Message ----- 
> From: "David Greaves" <david@dgreaves.com>
> To: "Janos Haar" <djani22@netcenter.hu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Wednesday, May 14, 2008 12:45 PM
> Subject: Re: questions about softraid limitations
> 
> 
> > Janos Haar wrote:
> >> Hello list, Neil,
> >
> > Hi Janos
> >
> >> I have worked on a faulty hw raid card data recovery some days before.
> >> The project is already successfully done, but i run into some 
> >> limitations.
> >
> > Firstly, are you aware that Linux SW raid will not understand disks 
> > written by
> > hardware raid.
> 
> Yes, i know, but the linux raid is a great tool to try it, and if the user 
> know what he is doing, it is safe too. :-)

As long as the user also knows what the kernel is doing .....

If you build an md array on top of a read-only device, the array is
still writable, and the device gets written too!!

Yes, it is a bug.  I hadn't thought about that case before.  I will
look into it.

> 
> >
> >> Than try to build an "old fashion" linear arrays from each disks + 64k
> >> another blockdevice. (for store the superblock)
> >> But the mdadm refused to _build_ the array, because the source scsi
> >> drive is jumpered to readonly. Why? :-)
> > This will not allow md to write superblocks to the disks.
> 
> I think exactly for this steps:
> 
> dd if=/dev/zero of=suberblock.bin bs=64k count=1
                       ^p
> losetup /dev/loop0 superblock.bin
> blockdev --setro /dev/sda
> mdadm --build -l linear /dev/md0 /dev/sda /dev/loop0
                         ^ --raid-disks=2

> 
> The superblock area is writable.
> And this is enough to try to assemble the array to do the recovery, but this 
> step is refused.

What error message do you get?  It worked for me (once I added
--raid-disks=2).

You probably want superblock.bin to be more than 64K.  The superblock
is located between 64K and 128K from the end of the device, depending
on device size.  It is always a multiple of 64K from the start of the
device.

> 
> >
> >>
> >> I try to build the array with --readonly option, but the mdadm still
> >> dont understand what i want. (yes, i know, rtfm...)
> > This will start the array in readonly mode - you've not created an array 
> > yet
> > because you haven't written any superblocks...
> 
> Yes, i only want to build, not to create.
> 
> >
> >
> >> Its OK, but what about building a readonly raid 5 array for recovery
> >> usage only? :-)
> > That's fine. If they are md raid disks. Yours aren't yet since you haven't
> > written the superblocks.
> 
> I only want to help for some people to get back the data.
> I only need to build, not to create.

And this you can do ... but not with mdadm at the moment
unfortunately.

What carefully :-)
--------------------------------------------------------------
/tmp# cd /sys/block/md0/md
/sys/block/md0/md# echo 65536 > chunk_size 
/sys/block/md0/md# echo 2 > layout 
/sys/block/md0/md# echo raid5  > level 
/sys/block/md0/md# echo none > metadata_version 
/sys/block/md0/md# echo 5 > raid_disks 
/sys/block/md0/md# ls -l /dev/sdb
brw-rw---- 1 root disk 8, 16 2008-05-16 11:13 /dev/sdb
/sys/block/md0/md# ls -l /dev/sdc
brw-rw---- 1 root disk 8, 32 2008-05-16 11:13 /dev/sdc
/sys/block/md0/md# echo 8:16 > new_dev 
/sys/block/md0/md# echo 8:32 > new_dev 
/sys/block/md0/md# echo 8:48 > new_dev 
/sys/block/md0/md# echo 8:64 > new_dev 
/sys/block/md0/md# echo 8:80 > new_dev 
/sys/block/md0/md# echo 0 > dev-sdb/slot 
/sys/block/md0/md# echo 1 > dev-sdc/slot 
/sys/block/md0/md# echo 2 > dev-sdd/slot 
/sys/block/md0/md# echo 3 > dev-sde/slot 
/sys/block/md0/md# echo 4 > dev-sdf/slot 
/sys/block/md0/md# echo 156250000 > dev-sdb/size 
/sys/block/md0/md# echo 156250000 > dev-sdc/size 
/sys/block/md0/md# echo 156250000 > dev-sdd/size 
/sys/block/md0/md# echo 156250000 > dev-sde/size 
/sys/block/md0/md# echo 156250000 > dev-sdf/size 
/sys/block/md0/md# echo readonly > array_state 
/sys/block/md0/md# cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty] 
md0 : active (read-only) raid5 sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      624999936 blocks super non-persistent level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      
unused devices: <none>
----------------------------------------------------------

Did you catch all of that?

The per-device 'size' is in K - I took it straight from
  /proc/partitions.
The chunk_size is in bytes.

Have fun.

NeilBrown
