From: Alessio Palmero Aprosio <alessio@apnetwork.it>
Subject: Problem
Date: Sun, 21 Jan 2007 03:05:22 +0100
Message-ID: <45B2CA62.7050000@apnetwork.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all!

I have a strange problem with Raid. I admit I'm quite a newbie in RAID, 
because I usually used it but never had problems. Now I had one.

I have a server with a RAID1, in particular two 80gb SATA disks 
(/dev/sda and /dev/sdb). In each of them there are two partitions: a 
500mb swap partition and a 79 gb raid partition. I create /dev/md0 from 
the two and I have now the array working well. I had a problem with one 
of them (/dev/sda) and I decide to leave sdb alone during the time I 
need to change sda. So I installed grub in sdb (as in 
http://gentoo-wiki.com/HOWTO_Gentoo_Install_on_Software_RAID#Installing_Grub_onto_both_MBRs) 
and I put it alone. All works perfectly. After some time, I noticed that 
sdb too has the problem, and then I discovered that the problem wasn't 
in the disks, but in another place, and I solved it. I put sda again and 
I rebuild the array. Now, whenever I reboot the computer I have to 
rebuild the array. I tried 3 times and all the times the Raid only found 
a disk and I have to execute

mdadm --manage /dev/md0 -a /dev/sdb2

and then all works.

This is my mdadm -D /dev/md0
-----------------------------------------------------------
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Oct 20 19:07:57 2005
     Raid Level : raid1
     Array Size : 79505600 (75.82 GiB 81.41 GB)
    Device Size : 79505600 (75.82 GiB 81.41 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Jan 21 03:03:27 2007
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 224a5dd6:1f81f7c4:d8c8c9f1:08088420
         Events : 0.20140867

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8        2        1      active sync   /dev/sda2
-----------------------------------------------------------

and my /proc/mdstat
-----------------------------------------------------------
Personalities : [raid0] [raid1] [raid5]
md0 : active raid1 sdb2[0] sda2[1]
      79505600 blocks [2/2] [UU]

unused devices: <none>
-----------------------------------------------------------

How can I solve the problem?
Thans very much

Alessio Palmero (from Italy)
