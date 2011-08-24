From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 5 to Raid 1 (half of the data not required)
Date: Wed, 24 Aug 2011 12:39:38 +1000
Message-ID: <20110824123938.6743e87c@notabene.brown>
References: <BAY148-W51F7F3A42E515F76BB76EFEF2E0@phx.gbl>
	<20110824104649.1c5696c3@notabene.brown>
	<BAY148-W29A568212EC52E4C4BC52EF110@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-W29A568212EC52E4C4BC52EF110@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 23 Aug 2011 22:18:12 -0400 Mike Viau <viaum@sheridanc.on.ca> wrote:

> 
> > On Wed, 24 Aug 2011 <neilb@suse.de> wrote:
> > > On Tue, 23 Aug 2011 19:41:11 -0400 Mike Viau <viaum@sheridanc.on.ca> wrote:
> > 
> > > 
> > > Hello,
> > > 
> > > I am trying to convert my currently running raid 5 array into a raid 1. All the guides I can see online are for the reverse direction in which one is converting/migrating a raid 1 to raid 5. I have intentionally only allocated exactly half of the total raid 5 size is. I would like to create the raid 1 over /dev/sdb1 and /dev/sdc1 with the data on the raid 5 running with the same drives plus /dev/sde1. Is this possible, I wish to have the data redundantly over two hard drive without the parity which is present in raid 5?
> > 
> > Yes this is possible, though you will need a fairly new kernel (late 30's at
> > least) and mdadm.
> > 
> 
> In your opinion is Debian 2.6.32-35 going to cut it? Not very late 30's, with mdadm - v3.1.4 - 31st August 2010

Should be OK.  The core functionality with in in 2.6.29.  There have been a
few bug fixes since then but they are for corner cases that you probably
won't hit.

> 
> > And you need to be running ext3 because I think it is the only one you can
> > shrink.
> > 
> > 1/ umount filesystem
> > 2/ resize2fs /dev/md0 490G
> >      This makes the array use definitely less than half the space.  It is 
> >      safest to leave a bit of slack for relocated metadata or something.
> >      If you don't make this small enough some later step will fail, and 
> >      you can then revert back to here and try again.
> > 
> 
> 
> The file system used was ext4 which is mounted off of a LVM logical volume inside of a virtual machine :P

Nice of you to keep it simple...

ext4 isn't a problem.  LVM shouldn't be, but it adds an extra step.  You
first shrink the fs, then the lv, then the pv, then the RAID...

> 
> I am still able to run the first two steps, but am considered about data loss on the underlying ext4 filesystem if I shrink the filesystem too much, 490G may not be possible. Other than that the following steps sound 'do-able' if the re-size works.
> 
> > 3/ mdadm --grow --array-size=490G /dev/md0
> >     This makes the array appear smaller without actually destroying any data.
> > 4/ fsck -f /dev/md0
> >     This makes sure the filesystem inside the shrunk array is still OK.
> >     If there is a problem you can "mdadm --grow" to a bigger size and check
> >     again. 
> > 
> > Only if the above all looks ok, continue.  You can remount the filesystem at
> > this stage if you want to.
> > 
> > 5/ mdadm --grow /dev/md0 --raid-disks=2
> > 
> >     If you didn't make the array-size small enough, this will fail.
> >     If you did it will start a 'reshape' which shuffles all the data around
> >     so it fits (With parity) on just two devices.
> > 
> > 6/ mdadm --wait /dev/md0
> > 7/ mdadm --grow /dev/md0 --level=1
> >     This instantly converts a 2-device RAID5 to a 2-device RAID1.
> > 8/ mdadm --grow /dev/md0 --array-size=max
> > 9/ resize2fs /dev/md0
> >      This will grow the filesystem up to fill the available space.
> > 
> > All done.
> > 
> > Please report success or failure or any interesting observations.
> > 
> 
> I am not sure how crack-pot of a solution this would be, but could I: 
> 
> 1/ mdadm -r /dev/md0 /dev/sde1
> Remove /dev/sde1 from the raid 5 array

Here you have lost your redundancy .... your choice I guess.

> 
> 2/ dd if=/dev/zero of=/dev/sde1 bs=512 count=1
> This clears the msdos mbr and clears the partitions
> 
> 3/ parted, fdisk or cfdisk to create a new 1TB (or less is possible as well) ext4 partition on /dev/sde
> 
> 4/ mkfs.ext4 /dev/sde1
> 
> 5/ cp -R {mounted location of degraded /dev/md0 partition} {mounted location of /dev/sde1 partition}
> Aka backup
> 
> 6/ mdadm --zero-superblock on /dev/sdb1 and /dev/sdc1
> Prep the two drive for new raid array

Probably want to stop the array (mdadm -S /dev/md0) before you do that.

> 
> 7/ mdadm create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
> Create new raid 1 array on drives
> 
> 8/ create LVM (pv,vg, and lv)
> 
> 9/ parted, fdisk or cfdisk to create a new 1TB ext4 partition on LVM
> 
> 10/ mkfs.ext4 on LV on /dev/md0
> 
> 11/ cp -R {mounted location of /dev/sde1 partition} {mounted location of new /dev/md0 partition} 
> 
> Any thought/suggestion/correction to this proposed idea?

Doing two copies seems a bit wasteful.

- fail/remove sdb1
- create a 1-device RAID1 on sdb1 (or a 2 device RAID1 with a missing device).
- do the lvm, mkfs
- copy from old filesystem to the new filesystem
- stop the old array.
- add sdc1 to the new RAID1.
- If you made it a 1-device RAID1, --grow it to 2 devices.

Only one copy operation needed.

NeilBrown



> 
> 
> Thanks again :)
> 
> > > 
> > > 
> > > # mdadm -D /dev/md0
> > > /dev/md0:
> > >         Version : 1.2
> > >   Creation Time : Mon Dec 20 09:48:07 2010
> > >      Raid Level : raid5
> > >      Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
> > >   Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
> > >    Raid Devices : 3
> > >   Total Devices : 3
> > >     Persistence : Superblock is persistent
> > > 
> > >     Update Time : Tue Aug 23 11:34:00 2011
> > >           State : clean
> > >  Active Devices : 3
> > > Working Devices : 3
> > >  Failed Devices : 0
> > >   Spare Devices : 0
> > > 
> > >          Layout : left-symmetric
> > >      Chunk Size : 512K
> > > 
> > >            Name : HOST:0  (local to host HOST)
> > >            UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> > >          Events : 55750
> > > 
> > >     Number   Major   Minor   RaidDevice State
> > >        0       8       17        0      active sync   /dev/sdb1
> > >        1       8       33        1      active sync   /dev/sdc1
> > >        3       8       65        2      active sync   /dev/sde1
> > > 
> > > 
> > > -M
> 
>  		 	   		  
