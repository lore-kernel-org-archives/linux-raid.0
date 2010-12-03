From: Neil Brown <neilb@suse.de>
Subject: Re: growing md2, do I need three reboots?
Date: Fri, 3 Dec 2010 12:25:47 +1100
Message-ID: <20101203122547.48637340@notabene.brown>
References: <20101202165203.4fbc240f@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101202165203.4fbc240f@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2 Dec 2010 16:52:03 +0100 Janek Kozicki <janek_listy@wp.pl> wrote:

> Hello,
> 
> my /dev/md2 uses superblock 1.0, which is stored at the end of
> device. Therefore I suppose that this approach of growing it isn't
> going to work:
> 
>   #Alter the partition tables, to make /dev/sd[abc]2 have new size:
>   fdisk /dev/sda
>   fdisk /dev/sdb
>   fdisk /dev/sdc
> 
>   #reboot (make kernel read new partition table)
> 
>   #then, grow the raid1 /dev/md1
>   mdadm --grow /dev/md2 --size=max
> 
>   #and finaly, grow the ext2 (or ext3) fs on /dev/md1
>   resize2fs /dev/md1
> 
> Because in this way, after rebooting, /dev/md2 won't be found - the
> superblock won't be in the correct place.
> 
> So, I would need to remove each of them from the array, resize
> partition, then add it back. Thus needing three reboots, since I can
> remove only one device at a time (the same HDDs have also partitions
> belonging to root raid1 array), which must be always up & running.
> 
> I can afford reboots, no problem here, but isn't there some simpler way?

Yes, there is a simpler way, but no: it isn't going to work anyway.

You cannot 'grow' a RAID10 array at all - sorry.  It is sufficiently complex
that it needs quite a bit of time to design, code, and test.  And I haven't
had that time yet.

But if you could resize a RAID10 array, this is what I would do:

1/ For each devices (sda, sdb, sdc)
  - fail and remove each partition from the respective array.
  - run 'kpartx -a /dev/sdX'.  This will create partitions in
    /dev/mapper/ with the same names.
  - --re-add these partitions to the arrays.  The presence of a
    write-intent-bitmap will mean that resync is almost instant.

2/ Use fdisk to change the partition tables.

3/ run 'kpartx -a /dev/sdX' again on each device.  This will change the
   partitions even while they are active.

4/ For the partitions which have changed size, find the matching
     /dev/md2/md/dev-dm0X/size
  and
     echo 0 > /dev/md2/md/dev-dm-X/size

   This will cause md to relocate the metadata to the new end of the device.
   Not that these partitions (created by kpartx) are device-mapper partitions
   so have names like 'dm-0' and 'dm-1'.

5/ mdadm -G /dev/md2 --size max
   This bit unfortunately won't work.


NeilBrown



> 
> 
> below is my raid layout, I need to grow md2 by few spare gigabytes
> left at the end of /dev/sd[abc].
> 
> kernel 2.6.29 (impossible to upgrade at the moment).
> 
> Personalities : [raid0] [raid1] [raid10] 
> md2 : active raid10 sda2[0] sdc2[2] sdb2[1]
>       185381376 blocks super 1.0 512K chunks 2 far-copies [3/3] [UUU]
>       bitmap: 1/6 pages [4KB], 16384KB chunk
> 
> md1 : active raid1 sdc1[2](W) sdb1[3](W)
>       9767416 blocks super 1.0 [2/2] [UU]
>       bitmap: 1/150 pages [4KB], 32KB chunk
> 
> md0 : active raid1 sde1[0] sdd1[2] sda1[1]
>       9767424 blocks [3/3] [UUU]
>       bitmap: 1/150 pages [4KB], 32KB chunk
> 
> unused devices: <none>
> atak:/home/janek# mdadm -D /dev/md2
> /dev/md2:
>         Version : 1.0
>   Creation Time : Thu Sep  2 11:47:39 2010
>      Raid Level : raid10
>      Array Size : 185381376 (176.79 GiB 189.83 GB)
>   Used Dev Size : 123587584 (117.86 GiB 126.55 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
> 
>   Intent Bitmap : Internal
> 
>     Update Time : Thu Dec  2 16:41:02 2010
>           State : active
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : far=2
>      Chunk Size : 512K
> 
>            Name : atak:2  (local to host atak)
>            UUID : f2a75dbe:5ac91a1f:c09da3c0:f6f69c9c
>          Events : 28
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
> 
> best regards

