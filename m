From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: converting to raid - Error 2
Date: Fri, 30 Apr 2010 13:41:26 -0700
Message-ID: <4BDB4076.7010909@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is something I've been trying to do for some time and there are 2 
older threads, but the last post got no responce, so starting a new 
thread. The old ones are:

Converting system to raid
Removing drives

The computer with 2 sata drives switched over fine a long time ago, but 
I have yet to get the one with 3 sata drives to boot with raid. Raid 
support is built into the kernel, partitions are type fd.

fdisk -l shows:
-----------------------------------------------------------------------
Disk /dev/hda: 40.0 GB, 40020664320 bytes
255 heads, 63 sectors/track, 4865 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x6b381dfe

    Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1        4660    37431418+  83  Linux
/dev/hda2            4661        4865     1646662+   5  Extended
/dev/hda5            4661        4865     1646631   82  Linux swap / Solaris

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x94140963

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        3040    24418768+  fd  Linux raid 
autodetect
/dev/sda2            3041        3649     4891792+  fd  Linux raid 
autodetect
/dev/sda3            3650       60801   459073440   fd  Linux raid 
autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xf1814421

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1        3040    24418768+  fd  Linux raid 
autodetect
/dev/sdb2            3041        3649     4891792+  fd  Linux raid 
autodetect
/dev/sdb3            3650       60801   459073440   fd  Linux raid 
autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x371b6063

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc3            3650       60801   459073440   fd  Linux raid 
autodetect

Disk /dev/md0: 25.0 GB, 25004736512 bytes
2 heads, 4 sectors/track, 6104672 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/md2: 940.1 GB, 940182208512 bytes
2 heads, 4 sectors/track, 229536672 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md2 doesn't contain a valid partition table

Disk /dev/md1: 5009 MB, 5009113088 bytes
2 heads, 4 sectors/track, 1222928 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md1 doesn't contain a valid partition table
-----------------------------------------------------------------------

Orginaly I had made both md0 and md1 2-way mirrors with a spare. But 
when it wouldn't boot, I was told it might be because of the spare and 
to grow them in. That also didn't work. I change md0 and md1 to 2-way 
mirrors, and removed the boot flag for sdc1 and zeroed superblock And I 
corrected the mdadm.conf file to reflect the changes to md0/1. Still 
would not boot from raid. I removed the two partitions sdc1 and sdc2 
leaving just sdc3 which is part of md2 raid5. Also re-ran grub on md0 
using:

  sudo grub
  grub>device (hd0) /dev/sda
  grub>root (hd0,0)
  grub>setup (hd0)

  grub>device (hd0) /dev/sdb
  grub>root (hd0,0)
  grub>setup (hd0)

To copy the current boot drive hda1 over to md0, I use a GRML boot disk, 
mount /dev/md0 to /mnt/md0 and /dev/sdd1 (/dev/hda1) to /mnt/sdd1, then do:

rsync -caHh --progress --delete /mnt/sdd1/ /mnt/md0.

Then I reboot normally. I have 2 copies of /boot/grub/device.map, 
/boot/grub/menu.lst and /etc/fstab. one for normal boot and one for 
raid. On /mnt/md0 I swap the normal boot files for the raid files by 
adding .old to the names of normal boot and removing .raid from the raid 
versions. Then reboot again and in cmos move the pata drive to the 
bottom of the list so cmos tries the sata drives first. That worked for 
the 32bit linux 2 drive system. But on this 64bit 3 drive I get:

Grub loading stage 1.5
Grub loading, please wait
Error 2

I can't remove the 3rd drive because it has part of md2 and I shouldn't 
need to anyway. Copies of the above mentioned files I put at: 
http://24.255.17.209:2400/vdr/local/raid/
