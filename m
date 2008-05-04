From: Neil Brown <neilb@suse.de>
Subject: Re: Software RAID partitions not detected at boot time with linux 2.6.25.1.
Date: Sun, 4 May 2008 22:56:03 +1000
Message-ID: <18461.45667.588613.443564@notabene.brown>
References: <200805032245.57084.assirati@nonada.if.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Joao Luis Meloni Assirati on Saturday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Joao Luis Meloni Assirati <assirati@nonada.if.usp.br>, Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 3, assirati@nonada.if.usp.br wrote:
> Let's try again, this this time with a proper e-mail subject.
> 
> Hello,
> 
> The problem I reported in
> http://marc.info/?l=linux-kernel&m=120804001406787&w=2
> still persists at 2.6.25.1. (sorry for the repeated messages there; that was 
> my mail client's fault).
> 
> In my previous bug repor, I was using raid1; now, I am using raid5, as 
> follows.
> 
> I have three partitions /dev/sda2, /dev/sdb2 and /dev/sdc2 marked as raid 
> autodetect (FD). They are assembled as a partitionable raid 5 array, and my 
> root is in /dev/md_d0p1. With a 2.6.24.2 kernel with sata, ext3 and raid5 
> compiled in (I don't use initrd), the system boots fine. In fact, the raid 
> array and partitions are detected as show with dmesg:
> 
> md: Autodetecting RAID arrays.
> md: Scanned 3 and added 3 devices.
> md: autorun ...
> md: considering sdc2 ...
> md:  adding sdc2 ...
> md:  adding sdb2 ...
> md:  adding sda2 ...
> md: created md_d0
> md: bind<sda2>
> md: bind<sdb2>
> md: bind<sdc2>
> md: running: <sdc2><sdb2><sda2>
> raid5: device sdc2 operational as raid disk 2
> raid5: device sdb2 operational as raid disk 1
> raid5: device sda2 operational as raid disk 0
> raid5: allocated 3226kB for md_d0
> raid5: raid level 5 set md_d0 active with 3 out of 3 devices, algorithm 2
> RAID5 conf printout:
>  --- rd:3 wd:3
>  disk 0, o:1, dev:sda2
>  disk 1, o:1, dev:sdb2
>  disk 2, o:1, dev:sdc2
> md: ... autorun DONE.
>  md_d0: p1 p2 p3 p4 < p5 p6 p7 >
> 
> The last line shows my raid partitions are detected.
> 
> However, when I try kernel 2.6.25.1, again with sata, ext3 and raid5 compiled 
> in and no initrd, the kernel does not recognize the raid partitions at boot 
> time, nonetheless the array is dected. The output of dmesg is the same  until:
> 
> raid5: allocated 3224kB for md_d0
> raid5: raid level 5 set md_d0 active with 3 out of 3 devices, algorithm 2
> RAID5 conf printout:
>  --- rd:3 wd:3
>  disk 0, o:1, dev:sda2
>  disk 1, o:1, dev:sdb2
>  disk 2, o:1, dev:sdc2
> md: ... autorun DONE.
> VFS: Cannot open root device "md_d0p1" or unknown-block(0,0)
> Please append a coorect "root=" boot option; here are the available partitions:
> 0800  312571224 sda driver:sd
>   0801      96358 sda1
>   0802  312472282 sda2
> 0810  312571224 sdb driver:sd
>   0811      96358 sdb1
>   0812  312472282 sdb2
> 0820  312571224 sdc driver:sd
>   0821      96358 sdc1
>   0822  312472282 sdc2
> fe00  624944384 md_d0 (driver?)
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> 
> Note the absence of the line
>  md_d0: p1 p2 p3 p4 < p5 p6 p7 >
> showing partition detection.
> 

It appears this regression was introduced by commit
   edfaa7c36574f1bf09c65ad602412db9da5f96bf
   Driver core: convert block from raw kobjects to core devices

Previously, the device name "md_d0p1" would be parsed out as "md_d0"
and partition 1.
md_d0 would be found and the device number of the first partition
could then be deduced even though the partition table hadn't been
processed at this point, so 'p1' wasn't actually known.
The kernel would attempt to open 'p1', this would trigger a read of
the partition table and the open would be successful.

The new code is 'simpler'.  It doesn't try to parse the device name at
all.  It just compares the device name against the names of all known
devices.  As the partitions are not known at this time, md_d0p1 is not
found.

There seem to be two ways this could be fixed:
1/ restore the old behaviour of parsing out the partition information.
   This would be least likely to leave other regressions waiting to be
   found, but might be seen as somewhat ugly.

2/ Get md_d0 to read it's partition table earlier.  I've tried this
   before without much luck.
   There are three times that the partition table can be parsed.
   a/ When the device is opened if bd_invalidated is set.
   b/ When the device is first registered.  register_disk calls
      blkdev_get which effectively opens the device, thus triggering
      'a' above.
   c/ When the BLKRRPART ioctl is made on the device.

   When an md device is first registered, there are no disks attached
   to it, so no partition table can be read.  The way md devices get
   set up, they are registered as empty devices, the component devices
   are attached, then the array is 'started'.  Only at this point can
   data, such as the partition table, be read.  But this it too late
   for case 'b' above.  Case 'a' is the one that usually causes
   partitions to be read.  'mdadm' explicitly opens devices after
   creating them to trigger this.

   We could conceivably put a BLKRRPART call in at the end of
   autorun_array where the array has just been started, but that would
   be rather ugly.  We would need to open the device, and doing that
   inside the kernel is never clean.  The code in 'init/*.c' for that
   sort of thing creates nodes in /dev in a temporary root filesystem.
   We cannot do that for autorun_array as it can be call long after
   boot time (but the RAID_AUTODETECT ioctl) so there may not be 
   a temporary filesystem to play with.

So I currently think that restoring the old behaviour of not requiring
partitions to exist before trying to open them would be best.

Kay?


NeilBrown
