From: John McMonagle <johnm@advocap.org>
Subject: grow problem
Date: Tue, 10 May 2005 16:58:15 -0500
Message-ID: <42812E77.9060503@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Having a problem changing my number of mirrors on a raid1 from 3 to 2.

Did it about a week ago on another system so I'm a bit perplexed.

mdadm --grow /dev/md0 --raid-disks 2
mdadm: Cannot set device size/shape for /dev/md0: Device or resource busy

 cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sda1[0] hda1[2]
      976640 blocks [3/2] [U_U]

mdadm -E /dev/md0
mdadm: No super block found on /dev/md0 (Expected magic a92b4efc, got
aaaaaaaa)
debiantest:~# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Mon Dec  6 13:59:46 2004
     Raid Level : raid1
     Array Size : 976640 (953.75 MiB 1000.08 MB)
    Device Size : 976640 (953.75 MiB 1000.08 MB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue May 10 13:23:29 2005
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 223c18cc:247c58f8:0d9b9e90:25271587
         Events : 0.950834

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0        -      removed
       2       3        1        2      active sync   /dev/hda1

Debian Sarge

mdadm -V
mdadm - v1.9.0 - 04 February 2005

John
