From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Sun, 2 Dec 2007 18:09:19 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

root      2206     1  4 Dec02 ?        00:10:37 dd if /dev/zero of 1.out 
bs 1M
root      2207     1  4 Dec02 ?        00:10:38 dd if /dev/zero of 2.out 
bs 1M
root      2208     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 3.out 
bs 1M
root      2209     1  4 Dec02 ?        00:10:45 dd if /dev/zero of 4.out 
bs 1M
root      2210     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 5.out 
bs 1M
root      2211     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 6.out 
bs 1M
root      2212     1  4 Dec02 ?        00:10:30 dd if /dev/zero of 7.out 
bs 1M
root      2213     1  4 Dec02 ?        00:10:42 dd if /dev/zero of 8.out 
bs 1M
root      2214     1  4 Dec02 ?        00:10:35 dd if /dev/zero of 9.out 
bs 1M
root      2215     1  4 Dec02 ?        00:10:37 dd if /dev/zero of 10.out 
bs 1M
root      3080 24.6  0.0  10356  1672 ?        D    01:22   5:51 dd if 
/dev/md3 of /dev/null bs 1M

Was curious if when running 10 DD's (which are writing to the RAID 5) 
fine, no issues, suddenly all go into D-state and let the read/give it 
100% priority?

Is this normal?

# du -sb . ; sleep 300; du -sb .
1115590287487   .
1115590287487   .

Here my my raid5 config:

# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Sun Dec  2 12:15:20 2007
      Raid Level : raid5
      Array Size : 1465143296 (1397.27 GiB 1500.31 GB)
   Used Dev Size : 732571648 (698.63 GiB 750.15 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Sun Dec  2 22:00:54 2007
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 1024K

            UUID : fea48e85:ddd2c33f:d19da839:74e9c858 (local to host box1)
          Events : 0.15

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1

