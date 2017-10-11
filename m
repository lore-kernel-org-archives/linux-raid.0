From: Joseba Ibarra <wajalotnet@gmail.com>
Subject: Can't mount /dev/md0 Raid5
Date: Wed, 11 Oct 2017 12:25:14 +0200
Message-ID: <59DDF18A.9060800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The md0 is ext4 formated. But now, I can even start the SO when all the 
disk are pluged. One of them is corrupt. It makes an odd sound at the 
starting. However if I unplug that disk the system start fine, however 
no RAID is detected and after assemble it says:


root@grafico:/home/jose# mdadm --detail /dev/md0
/dev/md0:
                  Version : 1.2
       Creation Time : Sat Aug 5 23:10:50 2017
             Raid Level : raid5
      Used Dev Size : 976629760 (931.39 GiB 1000.07 GB)
         Raid Devices : 4
         Total Devices : 3
           Persistence : Superblock is persistent

          Update Time : Thu Sep 21 13:34:35 2017
                      State : active, degraded, Not Started
       Active Devices : 3
    Working Devices : 3
       Failed Devices : 0
       Spare Devices : 0

                   Layout : left-symmetric
           Chunk Size : 512K

                    Name : servidor:0
                     UUID : 0b44a3b8:83eafabc:644afc87:bdb5b1f3
                   Events : 3109

     Number   Major   Minor   RaidDevice State
-       0        0        0      removed
1       8       17        1      active sync   /dev/sdb1
2       8       33        2      active sync   /dev/sdc1
3       8       49        3      active sync   /dev/sdd1


I'm not sure how to continue, since i don't see the RAID. GParted see 
the disks, however doesn't see the md0 and I'm bit scared if I lost the 
data content.


Joseba Ibarra
