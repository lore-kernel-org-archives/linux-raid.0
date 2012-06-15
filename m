From: Roberto Leibman <roberto@leibman.net>
Subject: How to activate a spare?
Date: Fri, 15 Jun 2012 08:04:52 -0700
Message-ID: <4FDB4F14.3030609@leibman.net>
References: <S1756982Ab2FOO6f/20120615145835Z+98@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1756982Ab2FOO6f/20120615145835Z+98@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I must be missing something completely obvious, but I've read the man 
page, and went through the archive for this list.

One of the hard drives in my raid array failed... I have taken the hard 
drive out, replaced it with a new one, copied the partition table (using 
gdisk) and then added the drive to the raid array with:

mdadm --add /dev/md0 /dev/sdb3

I then monitor it with "mdadm --detail /dev/md0" or "cat /proc/mdstat" 
until it synchronizes
After an ungodly number of hours, the thing finishes synchronizing, but 
the new drive only shows up as a spare. So the RAID is still degraded....

I have not been able to get the new drive to become part of the array as 
active, web searches have proved useless (people with the same problem 
and no resolution). I've even failed/removed the active drive, at which 
point the spare becomes active, but when I add the original drive it 
still adds it as a spare)

So how do I make it active???

(it's in the middle of trying again, but here's what I have)
--------------
root@frogstar:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid1 sda3[2] sdb3[0]
       1943454796 blocks super 1.2 [2/1] [U_]
       [>....................]  recovery =  1.0% (20096128/1943454796) 
finish=737.0min speed=43493K/sec

unused devices: <none>
--------------
and
root@frogstar:~# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Apr 14 13:52:25 2012
      Raid Level : raid1
      Array Size : 1943454796 (1853.42 GiB 1990.10 GB)
   Used Dev Size : 1943454796 (1853.42 GiB 1990.10 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Thu Jun 14 13:13:54 2012
           State : clean, degraded, recovering
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1

  Rebuild Status : 1% complete

            Name : frogstar:0  (local to host frogstar)
            UUID : 88ed6cd4:de463005:31ed764c:2b23a266
          Events : 47610

     Number   Major   Minor   RaidDevice State
        0       8       19        0      active sync   /dev/sdb3
        2       8        3        1      spare rebuilding   /dev/sda3

The version of mdadm I'm using is the stock on ubuntu 10.10 (v3.1.4)
