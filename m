From: Matthew Carras <matthew.carras@gmail.com>
Subject: Problems with RAID1 mirrors after partition corruption and successful
	recovery. (DeviceDisappeared event?)
Date: Tue, 13 Oct 2009 18:11:59 -0400
Message-ID: <c895bf290910131511u1dfa7a2ak5c58a3674ebf837@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Version: mdadm - v2.6.7.2 - 14th November 2008
OS: Debian (Lenny/Stable)
Installation: debian package

My Debian Lenny router's mdadm software raid setup is only partially
working now after a partition corruption that I had to recover from
backups (unfortunately, right now my backups only contain the files,
not actual images).

The same RAID1 setup for swap space is working fine (/dev/md1) except
for being mounted auto-ready-only. I've been troubleshooting for days.
When I reboot and add in root=/dev/md0 (the new array), it'll
eventually drop me to initramfs, and a viewing of dmesg shows mdadm
thinks /dev/md0 has no devices. Yet mdadm --examine /dev/hda1 reports
the superblock correctly, and says it's clean. But the kernel only
auto-detects one raid device, and /proc/mdstat only shows one as well.
mdadm.conf has been properly updated for both raids. I've tried
kernels 2.6.18-4-686, 2.6.18-5-686, 2.6.18-6-686, and recently
2.6.30-bpo.2-686.

> ls /dev/md*
/dev/md1

> mdadm --query /dev/hda1
/dev/hda1: is not an md array
/dev/hda1: device 1 in 2 device undetected raid1 /dev/.tmp.md0.  Use
mdadm --examine for more detail.

> mdadm --run /dev/.tmp.md0
mdadm: error opening /dev/.tmp.md0: No such file or directory

> mdadm --examine /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 93419e79:9cbd9b5b:eaa0a77b:ba41beb2
  Creation Time : Tue Oct 13 13:13:47 2009
     Raid Level : raid1
  Used Dev Size : 3968384 (3.78 GiB 4.06 GB)
     Array Size : 3968384 (3.78 GiB 4.06 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Oct 13 13:58:25 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 13f2f504 - correct
         Events : 343


      Number   Major   Minor   RaidDevice State
this     1       3        1        1      active sync   /dev/hda1

   0     0       3       65        0      active sync   /dev/hdb1
   1     1       3        1        1      active sync   /dev/hda1

> cat /proc/mdstat
Personalities : [raid1]
md1 : active (auto-read-only) raid1 hdb2[0] hda2[1]
      228736 blocks [2/2] [UU]

unused devices: <none>

> grep md0 /var/log/syslog

Oct 13 11:06:11 debian-router kernel: [    7.896393] md: md0 stopped.
Oct 13 11:06:11 debian-router kernel: [   27.774204] md: md0 stopped.
Oct 13 11:06:21 debian-router mdadm[2514]: DeviceDisappeared event
detected on md device /dev/md0

Any help would be appreciated.

Matt
