From: Joachim Otahal <Jou@gmx.net>
Subject: Swap on /dev/md1 always lost after reboot
Date: Mon, 29 Mar 2010 04:21:20 +0200
Message-ID: <4BB00EA0.8020907@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Machine is:
Debian Lenny, Linux version 2.6.26-2-686 (Debian 2.6.26-21lenny4)
mdadm - v2.6.7.2 - 14th November 2008
2 HD's
/dev/md1 = /, /dev/sda1 /dev/sdb1
/dev/md0 = /home/data, /dev/sda3 /dev/sdb3

They are numbered that way for "historical" reasons, I created /dev/md0 
as data partition first and converted root/boot to RAID1 later.

The problem is:
/dev/md2 = swap, /dev/sda2, /dev/sdb2

I set up md2 (/dev/md2 is already in fstab as swap, the partition type 
is fd on both drives):
mdadm --zero-superblock /dev/sda2
mdadm --zero-superblock /dev/sdb2
mdadm -C /dev/md2 -l 1 -n 2 /dev/sdb2 /dev/sda2
mkswap /dev/md2
swapon -a
free says: swap active, mdstat says:
md2 : active (auto-read-only) raid1 sda2[1] sdb2[0]
       979840 blocks [2/2] [UU]
(no resync=PENDING or other funny stuff)
mdadm --examine --scan shows the md2, /etc/mdadm/mdadm.conf gets updated 
by me.
reboot, and the free says: no swap.

cat /proc/mdstat says: no md2 !
mdadm --examine --scan shows md2, exactely as written in 
/etc/mdadm/mdadm.conf

the longer output:
mdadm --examine /dev/sda2
/dev/sda2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : d97bc68d:a6bd724d:b66f1fce:677f10ed (local to host 
nearyou)
   Creation Time : Mon Mar 29 03:43:06 2010
      Raid Level : raid1
   Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
      Array Size : 979840 (957.04 MiB 1003.36 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 2
     Update Time : Mon Mar 29 03:45:06 2010
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : dec1b89a - correct
          Events : 8
       Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2
    0     0       8       18        0      active sync   /dev/sdb2
    1     1       8        2        1      active sync   /dev/sda2

mdadm --examine /dev/sda2
/dev/sda2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : d97bc68d:a6bd724d:b66f1fce:677f10ed (local to host 
nearyou)
   Creation Time : Mon Mar 29 03:43:06 2010
      Raid Level : raid1
   Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
      Array Size : 979840 (957.04 MiB 1003.36 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 2
     Update Time : Mon Mar 29 03:45:06 2010
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0
        Checksum : dec1b89a - correct
          Events : 8
       Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2
    0     0       8       18        0      active sync   /dev/sdb2
    1     1       8        2        1      active sync   /dev/sda2

So the raid is there, it is on the HD, it is consistent and clean, it 
says it's preferred minor is 2 = md2.
It is simply not autodetected at boot time, or not activated, I tried 
that quite a few times now. I can recreate the raid with -C -f and issue 
a --rebuild, swapon -a, everything fine. The other RAID1's on the drives 
work as expected.

What is the trap I am running in here? I have other machines with 
/dev/md1 as swap without such problems. It there some kind of kernel 
option how high autodetect should count in md "Preferred Minor" devices?

kind regards,

Joachim Otahal

