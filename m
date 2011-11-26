From: Bart Kus <me@bartk.us>
Subject: Online RAID1 -> RAID10 migration?
Date: Fri, 25 Nov 2011 23:48:47 -0800
Message-ID: <4ED099DF.2010007@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'd like to know if it's possible to do online RAID1 -> RAID10 migration 
with md.  I ran a little experiment and it seems my approach doesn't work:

jo test # mdadm --detail /dev/md7
/dev/md7:
         Version : 1.0
   Creation Time : Fri Nov 25 23:29:37 2011
      Raid Level : raid1
      Array Size : 51188 (50.00 MiB 52.42 MB)
   Used Dev Size : 51188 (50.00 MiB 52.42 MB)
    Raid Devices : 2
   Total Devices : 4
     Persistence : Superblock is persistent

     Update Time : Fri Nov 25 23:33:55 2011
           State : clean
  Active Devices : 2
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 2

            Name : jo.bartk.us:TEST  (local to host jo.bartk.us)
            UUID : 5c6e806a:d91b8007:dce490aa:1442d468
          Events : 19

     Number   Major   Minor   RaidDevice State
        0       7        0        0      active sync   /dev/loop0
        1       7        1        1      active sync   /dev/loop1

        2       7        2        -      spare   /dev/loop2
        3       7        3        -      spare   /dev/loop3
jo test # mdadm -G /dev/md7 -n 4 -l 10
mdadm: /dev/md7: could not set level to raid10
jo test # dmesg | tail -1
md: md7: raid10 would not accept array

Any advice on how to pull this off?  Is it even possible?  Can it be 
implemented?  My root device is on RAID1 and I'd like to move it to 
RAID10 to get some write/read speed benefit.

Thanks,

--Bart

