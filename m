From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 with 1.2 superblock never marked healthy?
Date: Mon, 20 Feb 2006 09:30:22 +1100
Message-ID: <17400.61822.230666.23651@cse.unsw.edu.au>
References: <priv$1140364975.koan@shadow.banki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janos Farkas on Sunday February 19
Sender: linux-raid-owner@vger.kernel.org
To: Janos Farkas <jf-ml-k3-raid@lk8rp.mail.xeon.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 19, jf-ml-k3-raid@lk8rp.mail.xeon.eu.org wrote:
> Hi!
> 
> Recently, I've updated one raid1 array to version 1.2 superblocks, in
> the (apparently) misguided hope, that it's needed to use bitmaps for
> faster resync after failure.

Bitmaps work with any superblock version.  You only need 1.x for
v.large arrays, or if you want to use the 'name' field.
1.0, 1.1, 1.2 only differ in where they put the superblock.


> 
> In the process, I've stumbled across a few roadblocks.

It happens.... thanks for reporting them.

> 
> First, I've been unable to find out, how to specify the bitmap file
> without hardcoding its name in a startup file.  Up until now, there was
> only a generic "mdadm -As" doing all the work.  The other problem, even
> if I run this by hand, specifying the bitmap file, the array always
> comes up degraded, regardless of any bitmap specified.

If you use an 'internal' bitmap (which is mirrored across all drives
much like the superblock) then you don't need to specify a file name.
However if you want the bitmap on a separate file, you have to have
that name 'hard coded' in mdadm.conf (or similar).


> 
> Granted, on reboot, some of the times may be because of unclean
> shutdowns, other times one of the component is marked as failed (F) in
> /proc/mdstat.  After a remove/add, and waiting after the resync, all
> seems correct, but what irks me, is that mdadm -E always shows some
> components as failed even after a completely successful resync.

Don't worry too much about "mdadm -E" reporting that there are some
failed devices.  It is a bit confusing and something I should tidy up
at some stage...

> 
> I *think* that seeing "Array State : uu 1 failed" after the resync
> implies that I have to endure the resync after the next reboot.

This is actually a fairly odd thing to see.
A 'u' means that device is active (up?), but that it is some other
device.
A 'U' means that device is active, and it is this devices.  So you
should only see 'uu' on a spare.  But I assume this isn't a
spare... weird.


> 
> I remember stopping/starting the array correctly does a resync again,
> even without a reboot.

Hmm... it seems to work for me... How exactly to you start it again.

> 
> It also seems to me, mdadm does not really store the bitmap file in the
> superblock for some reason, and/or there is no way to update this
> field.

No.  mdadm does not record the name of the bitmap file in the
superblock.  Just like it does not record the names of component
devices in the superblock.

> 
> Details follow, sorry for the lengthy dump, I'm not sure if anything is
> useless from this.
> 
> Kernel is 2.6.16-rc3, mdadm is 2.3.1.
> 
> One time when it's started degraded for no apparent reason:
> 
> 10:21:20 lame kernel: md: md0 stopped.
> 10:21:20 lame kernel: md: bind<hda3>
> 10:21:20 lame kernel: md: bind<hdc3>
> 10:21:20 lame kernel: raid1: raid set md0 active with 1 out of 2 mirrors

It seems to think that one of these is a spare.  Any idea why?

> 
> Another time, which may result from a somehow unclean shutdown:
> 
> 10:11:44 lame kernel: md: raid1 personality registered for level 1
> 10:11:44 lame kernel: md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
> 10:11:44 lame kernel: md: bitmap version 4.39
> 10:11:44 lame kernel: md: Skipping autodetection of RAID arrays.  (raid=noautodetect)
> 10:11:44 lame kernel: md: md0 stopped.
> 10:11:44 lame kernel: md: bind<hda3>
> 10:11:44 lame kernel: md: bind<hdc3>
> 10:11:44 lame kernel: md: kicking non-fresh hda3 from array!
> 10:11:44 lame kernel: md: unbind<hda3>
> 10:11:44 lame kernel: md: export_rdev(hda3)
> 16:20:24 lame kernel: md: bind<hda3>
> 16:20:24 lame kernel: md: syncing RAID array md0
> 16:20:24 lame kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
> 16:20:24 lame kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
> 16:20:24 lame kernel: md: using 128k window, over a total of 17552232 blocks.
> 16:58:07 lame kernel: md: md0: sync done.
> 
> After the resync, however, the components do not get updated to show
> correctness?
> 
> ------------------------
> # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 hda3[2] hdc3[1]
>       17552232 blocks super 1.2 [2/2] [UU]
> 
> unused devices: <none>

Look correct to me.

> ------------------------
> # mdadm -D /dev/md0; mdadm -E /dev/hd[ac]3
> /dev/md0:
>         Version : 01.02.03
>   Creation Time : Wed Feb  8 21:24:33 2006
>      Raid Level : raid1
>      Array Size : 17552232 (16.74 GiB 17.97 GB)
>     Device Size : unknown
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sun Feb 19 17:12:09 2006
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
> 
>            Name :
>            UUID : 4dd4...
>          Events : 467156
> 
>     Number   Major   Minor   RaidDevice State
>        2       3        3        0      active sync   /dev/hda3
>        1      22        3        1      active sync   /dev/hdc3
> /dev/hda3:
>           Magic : a92b4efc
>         Version : 01
>     Feature Map : 0x0
>      Array UUID : 4dd4...
>            Name :
>   Creation Time : Wed Feb  8 21:24:33 2006
>      Raid Level : raid1
>    Raid Devices : 2
> 
>     Device Size : 35104472 (16.74 GiB 17.97 GB)
>      Array Size : 35104464 (16.74 GiB 17.97 GB)
>       Used Size : 35104464 (16.74 GiB 17.97 GB)
>     Data Offset : 136 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : aca9...
> 
>     Update Time : Sun Feb 19 17:12:09 2006
>        Checksum : dd1ac0a1 - correct
>          Events : 467156
> 
> 
>    Array State : uu 1 failed

Something is definitely wrong here... hda3 looks like a spare, but
isn't.... I'll have a look and see what I can find out.

NeilBrown
