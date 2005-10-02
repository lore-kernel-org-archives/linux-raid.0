From: Hank Barta <hbarta@gmail.com>
Subject: non-fresh drive?
Date: Sun, 2 Oct 2005 10:10:48 -0500
Message-ID: <750072490510020810v72a97793m32e4835c36bb0289@mail.gmail.com>
Reply-To: Hank Barta <hbarta@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5 disk raid that is currently using only 4 disks. On startup,
it rejects an apparently good drive with the message that it is
non-fresh. I don;t understand what non-fresh means nor how to resolve
this.

I start the raid using the command:
oak:~# mdadm -A /dev/md0 -f /dev/sd[abcd]1 /dev/hd[eg]1
mdadm: /dev/md0 has been started with 4 drives (out of 5).

and I see:
oak:~# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sdb1[1] hde1[4] sdd1[3] sdc1[2]
      781433344 blocks level 5, 32k chunk, algorithm 2 [5/4] [_UUUU]

unused devices: <none>

(It does not start automatically and at the moment, /dev/hdg1 is not
installed, but at the time that /dev/hdg1 failed, this command worked
and had all 5 drives working.)

dmesg reports:
md: md0 stopped.
md: unbind<hde1>
md: export_rdev(hde1)
md: bind<sda1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<hde1>
md: bind<sdb1>
md: kicking non-fresh sda1 from array!
md: unbind<sda1>
md: export_rdev(sda1)
raid5: measuring checksumming speed
   8regs     :  1072.000 MB/sec
   8regs_prefetch:  1012.000 MB/sec
   32regs    :   784.000 MB/sec
   32regs_prefetch:   732.000 MB/sec
   pII_mmx   :  2172.000 MB/sec
   p5_mmx    :  2888.000 MB/sec
raid5: using function: p5_mmx (2888.000 MB/sec)
md: raid5 personality registered as nr 4
raid5: device sdb1 operational as raid disk 1
raid5: device hde1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: allocated 5242kB for md0
raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
RAID5 conf printout:
  --- rd:5 wd:4 fd:1
  disk 1, o:1, dev:sdb1
  disk 2, o:1, dev:sdc1
  disk 3, o:1, dev:sdd1
  disk 4, o:1, dev:hde1


I see no indication of a problem with /dev/sda1. I can open it with
fdisk and it seems to report the correct partition table:
oak:~# echo p |fdisk /dev/sda

The number of cylinders for this disk is set to 24321.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help):
Disk /dev/sda: 200.0 GB, 200049647616 bytes
255 heads, 63 sectors/track, 24321 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1       24321   195358401   fd  Linux raid autodetect

Command (m for help): Command (m for help): Command (m for help):
got EOF thrice - exiting..
oak:~#

and I can 'dd' from /dev/sda1 without any reported errors.

looking back in the logs, the only thing I find is:
Sep 21 21:20:10 localhost -- MARK --
Sep 21 21:40:10 localhost -- MARK --
Sep 21 21:46:22 localhost kernel: device-mapper: device /dev/sda1 too
small for target
Sep 21 21:46:22 localhost kernel: device-mapper: error adding target to table
Sep 21 21:46:22 localhost kernel: device-mapper: device /dev/sda1 too
small for target
Sep 21 21:46:22 localhost kernel: device-mapper: error adding target to table
Sep 21 21:47:30 localhost kernel: device-mapper: device /dev/sda1 too
small for target
Sep 21 21:47:30 localhost kernel: device-mapper: error adding target to table
Sep 21 21:47:30 localhost kernel: device-mapper: device /dev/sda1 too
small for target
Sep 21 21:47:30 localhost kernel: device-mapper: error adding target to table
Sep 21 21:47:47 localhost kernel: ReiserFS: dm-0: warning: sh-2021:
reiserfs_fill_super: can not find reiserfs on dm-0
Sep 21 21:49:02 localhost kernel: md: md0 stopped.
Sep 21 21:49:02 localhost kernel: md: unbind<hde1>
Sep 21 21:49:02 localhost kernel: md: export_rdev(hde1)
Sep 21 21:49:03 localhost kernel: md: bind<sdb1>
Sep 21 21:49:03 localhost kernel: md: bind<sdc1>
Sep 21 21:49:03 localhost kernel: md: bind<sdd1>
Sep 21 21:49:03 localhost kernel: md: bind<hde1>
Sep 21 21:49:03 localhost kernel: md: md_import_device returned -16
Sep 21 21:49:03 localhost kernel: raid5: measuring checksumming speed
Sep 21 21:49:03 localhost kernel:    8regs     :  1072.000 MB/sec
Sep 21 21:49:03 localhost kernel:    8regs_prefetch:  1012.000 MB/sec
Sep 21 21:49:03 localhost kernel:    32regs    :   784.000 MB/sec
Sep 21 21:49:03 localhost kernel:    32regs_prefetch:   732.000 MB/sec
Sep 21 21:49:03 localhost kernel:    pII_mmx   :  2168.000 MB/sec
Sep 21 21:49:03 localhost kernel:    p5_mmx    :  2892.000 MB/sec
Sep 21 21:49:03 localhost kernel: raid5: using function: p5_mmx
(2892.000 MB/sec)
Sep 21 21:49:03 localhost kernel: md: raid5 personality registered as nr 4
Sep 21 21:49:03 localhost kernel: raid5: device hde1 operational as raid disk 4
Sep 21 21:49:03 localhost kernel: raid5: device sdd1 operational as raid disk 3
Sep 21 21:49:03 localhost kernel: raid5: device sdc1 operational as raid disk 2
Sep 21 21:49:03 localhost kernel: raid5: device sdb1 operational as raid disk 1
Sep 21 21:49:03 localhost kernel: raid5: allocated 5242kB for md0
Sep 21 21:49:03 localhost kernel: RAID5 conf printout:
Sep 21 21:49:03 localhost kernel:  --- rd:5 wd:4 fd:1
Sep 21 21:49:03 localhost kernel:  disk 1, o:1, dev:sdb1
Sep 21 21:49:03 localhost kernel:  disk 2, o:1, dev:sdc1
Sep 21 21:49:03 localhost kernel:  disk 3, o:1, dev:sdd1
Sep 21 21:49:03 localhost kernel:  disk 4, o:1, dev:hde1

This happened when I was starting up md and lvm and perhaps I tried to
start lvm before starting the raid.

Could the device-mapper have written something to the partition that
has caused md (mdadm?) to reject it?

My inclination is to delete and recreate the partition on the device
and try again, but I thought I'd ask here first since I don;t
understand how I got into this situation in the first place.

thanks,
hank

--
Beautiful Sunny Winfield, Illinois
