From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: growing md2, do I need three reboots?
Date: Fri, 3 Dec 2010 10:39:26 +0100
Message-ID: <20101203103926.13ba9537@atak.bl.pg.gda.pl>
References: <20101202165203.4fbc240f@atak.bl.pg.gda.pl>
	<20101203122547.48637340@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101203122547.48637340@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown said:     (by the date of Fri, 3 Dec 2010 12:25:47 +1100)

> > I can afford reboots, no problem here, but isn't there some simpler way?
> 
> Yes, there is a simpler way, but no: it isn't going to work anyway.

Great! Thank you for your reply, I must remember this in case when
I'll want to grow a non-raid10 array :)

And now: LVM to the rescue!

best regards
Janek Kozicki


 
> You cannot 'grow' a RAID10 array at all - sorry.  It is sufficiently complex
> that it needs quite a bit of time to design, code, and test.  And I haven't
> had that time yet.
> 
> But if you could resize a RAID10 array, this is what I would do:
> 
> 1/ For each devices (sda, sdb, sdc)
>   - fail and remove each partition from the respective array.
>   - run 'kpartx -a /dev/sdX'.  This will create partitions in
>     /dev/mapper/ with the same names.
>   - --re-add these partitions to the arrays.  The presence of a
>     write-intent-bitmap will mean that resync is almost instant.
> 
> 2/ Use fdisk to change the partition tables.
> 
> 3/ run 'kpartx -a /dev/sdX' again on each device.  This will change the
>    partitions even while they are active.
> 
> 4/ For the partitions which have changed size, find the matching
>      /dev/md2/md/dev-dm0X/size
>   and
>      echo 0 > /dev/md2/md/dev-dm-X/size
> 
>    This will cause md to relocate the metadata to the new end of the device.
>    Not that these partitions (created by kpartx) are device-mapper partitions
>    so have names like 'dm-0' and 'dm-1'.
> 
> 5/ mdadm -G /dev/md2 --size max
>    This bit unfortunately won't work.
> 
> 
> NeilBrown
> 
> 
> 
> > 
> > 
> > below is my raid layout, I need to grow md2 by few spare gigabytes
> > left at the end of /dev/sd[abc].
> > 
> > kernel 2.6.29 (impossible to upgrade at the moment).
> > 
> > Personalities : [raid0] [raid1] [raid10] 
> > md2 : active raid10 sda2[0] sdc2[2] sdb2[1]
> >       185381376 blocks super 1.0 512K chunks 2 far-copies [3/3] [UUU]
> >       bitmap: 1/6 pages [4KB], 16384KB chunk
> > 
> > md1 : active raid1 sdc1[2](W) sdb1[3](W)
> >       9767416 blocks super 1.0 [2/2] [UU]
> >       bitmap: 1/150 pages [4KB], 32KB chunk
> > 
> > md0 : active raid1 sde1[0] sdd1[2] sda1[1]
> >       9767424 blocks [3/3] [UUU]
> >       bitmap: 1/150 pages [4KB], 32KB chunk
> > 
> > unused devices: <none>
> > atak:/home/janek# mdadm -D /dev/md2
> > /dev/md2:
> >         Version : 1.0
> >   Creation Time : Thu Sep  2 11:47:39 2010
> >      Raid Level : raid10
> >      Array Size : 185381376 (176.79 GiB 189.83 GB)
> >   Used Dev Size : 123587584 (117.86 GiB 126.55 GB)
> >    Raid Devices : 3
> >   Total Devices : 3
> >     Persistence : Superblock is persistent
> > 
> >   Intent Bitmap : Internal
> > 
> >     Update Time : Thu Dec  2 16:41:02 2010
> >           State : active
> >  Active Devices : 3
> > Working Devices : 3
> >  Failed Devices : 0
> >   Spare Devices : 0
> > 
> >          Layout : far=2
> >      Chunk Size : 512K
> > 
> >            Name : atak:2  (local to host atak)
> >            UUID : f2a75dbe:5ac91a1f:c09da3c0:f6f69c9c
> >          Events : 28
> > 
> >     Number   Major   Minor   RaidDevice State
> >        0       8        2        0      active sync   /dev/sda2
> >        1       8       18        1      active sync   /dev/sdb2
> >        2       8       34        2      active sync   /dev/sdc2
> > 
> > best regards
> 
> 


-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
