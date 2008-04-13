From: Maurice Hilarius <maurice@harddata.com>
Subject: Question: how to identify failing disk in a RAID1
Date: Sun, 13 Apr 2008 13:14:21 -0600
Message-ID: <48025B8D.2030803@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there.

Recently I have been frequently seeing a damaged filesystem on a RAID1 
on boot.
a lengthy fsck does get it working, but I am seeing files disappearing 
as a result.

I am pretty sure that one of the drives has developed some issues and 
needs to be replaced.

How does one identify which of the 2 disks is the one that is failing?

The system has 2 identical disks, and  / is on md0

fstab:
/dev/md0                /                       ext3    defaults        1 1
LABEL=/boot1            /boot                   ext2    defaults        1 2
tmpfs                   /dev/shm                tmpfs   defaults        0 0
devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
sysfs                   /sys                    sysfs   defaults        0 0
proc                    /proc                   proc    defaults        0 0
LABEL=/boot11           /boot1                  ext2    defaults        1 2
LABEL=SWAP-sdb3         swap                    swap    defaults        0 0
LABEL=SWAP-sda2         swap                    swap    defaults        0 0

fdisk -l shows me:
Disk /dev/sda: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1          13      104391   83  Linux
/dev/sda2              14         535     4192965   82  Linux swap / Solaris
/dev/sda3             536       48641   386411445   fd  Linux raid 
autodetect

Disk /dev/sdb: 400.0 GB, 400088457216 bytes
255 heads, 63 sectors/track, 48641 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1          13      104391   83  Linux
/dev/sdb2              14       48118   386403412+  fd  Linux raid 
autodetect
/dev/sdb3           48119       48640     4192965   82  Linux swap / Solaris

Disk /dev/md0: 395.6 GB, 395677007872 bytes
2 heads, 4 sectors/track, 96600832 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

Anyone have a suggestion, please?
Responses off list are probably most appropriate.

Thanks for any help.

-- 
Regards, Maurice
mhilarius@gmail.com



