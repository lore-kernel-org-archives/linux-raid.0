From: Tim Moore <linux-raid@nsr500.net>
Subject: raid5 performance - 2.4.28
Date: Sat, 08 Jan 2005 21:28:35 -0800
Message-ID: <41E0C103.4060600@nsr500.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's a data point in favor of raw horsepower when considering
software raid performance.  I recently upgraded an Athlon Slot-A/SDRAM
system to an Athlon XP/DDR system without changing OS, disks,
disk controller or filesystems.

Athlon K7 (18u) @ 840MHz, 1GB PC133, Abit KA7
---------------------------------------------
abit,1500M:4k,,,12862,36,11132,18,,,44953,32,284.0,1,,,,,,,,,,,,,
abit,1500M:4k,,,13132,36,10231,17,,,57147,40,278.2,1,,,,,,,,,,,,,
abit,1500M:4k,,,12595,36,11039,18,,,51269,36,281.6,1,,,,,,,,,,,,,

Athlon XP 2800 @ 2075MHz, 1GB PC2700, Asus A7V400-MX
----------------------------------------------------
abit,1500M:4k,,,41065,52,14636,15,,,49355,23,429.3,1,,,,,,,,,,,,,
abit,1500M:4k,,,41330,58,15932,16,,,47045,22,415.7,2,,,,,,,,,,,,,
abit,1500M:4k,,,43364,73,15395,17,,,52025,25,418.0,1,,,,,,,,,,,,,

test: bonnie++ v1.03 (-q -s 1500:4k -r 0 -n 0 -f -u root -x 3)
array: RAID 5 (2xIBM-DTLA-307020, 1xMAXTOR 6L020J1)
md partition: 3x10GB (last 1/2 of each 20GB disk)
controller: 3ware 6400, PATA, 66MHz (JBOD)
filesystem: ext3, 4k block size, stride=16, noatime,data=ordered
OS: RedHat 7.3, stock 2.4.28, raidtools 1.00.2, glibc 2.2.5, gcc 2.96

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdc5[2] sdb5[0] sda5[1]
       4192768 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md1 : active raid5 sdc6[2] sdb6[0] sda6[1]
       2425600 blocks level 5, 32k chunk, algorithm 2 [3/3] [UUU]

md2 : active raid5 sdc7[2] sdb7[0] sda7[1]
       12707200 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md3 : active raid5 sdc8[2] sdb8[0] sda8[1]
       20113152 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

# fdisk -l

Disk /dev/sda: 255 heads, 63 sectors, 2501 cylinders
Units = cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sda1   *         1        13    104391   83  Linux
/dev/sda2            14        45    257040   82  Linux swap
/dev/sda3            46      2500  19719787+   5  Extended
/dev/sda5            46       306   2096451   fd  Linux raid autodetect
/dev/sda6           307       457   1212876   fd  Linux raid autodetect
/dev/sda7           458      1248   6353676   fd  Linux raid autodetect
/dev/sda8          1249      2500  10056658+  fd  Linux raid autodetect

Disk /dev/sdb: 255 heads, 63 sectors, 2501 cylinders
Units = cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sdb1   *         1        13    104391   83  Linux
/dev/sdb2            14        45    257040   82  Linux swap
/dev/sdb3            46      2500  19719787+   5  Extended
/dev/sdb5            46       306   2096451   fd  Linux raid autodetect
/dev/sdb6           307       457   1212876   fd  Linux raid autodetect
/dev/sdb7           458      1248   6353676   fd  Linux raid autodetect
/dev/sdb8          1249      2500  10056658+  fd  Linux raid autodetect

Disk /dev/sdc: 255 heads, 63 sectors, 2498 cylinders
Units = cylinders of 16065 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sdc1   *         1        13    104391   83  Linux
/dev/sdc2            14        43    240975   82  Linux swap
/dev/sdc3            44      2498  19719787+   5  Extended
/dev/sdc5            44       304   2096451   fd  Linux raid autodetect
/dev/sdc6           305       455   1212876   fd  Linux raid autodetect
/dev/sdc7           456      1246   6353676   fd  Linux raid autodetect
/dev/sdc8          1247      2498  10056658+  fd  Linux raid autodetect

Cheers,
-- 

