From: "Janos Haar" <djani22@netcenter.hu>
Subject: A log of thanks, and some question. :)
Date: Wed, 14 Jun 2006 00:27:10 +0200
Message-ID: <01b801c68f38$c1992ea0$1800a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list, Neil,

First i want to thanks, to Neil, for the mdadm! :-)

On the last week, i have successfully recover my 12 disk raid4 array with
mdadm, from 10 good, 2 failed, and +1 disk with one day older parity infos.
I have saved about 14TB data, and only lost about 40-50GB! (Raid0-stripped
4x3.3TB and XFS)

Thanks, Neil!

Anyway, i have some questions too:

After i more times re-create the full raid4 array, i cannot add back the
bitmap!

[root@st-0003 ~]# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid5] [raid4] [raid6]
[multi
path] [faulty]
md0 : active raid4 hda1[0] sde1[11] sdi1[10] sdd1[9] sdj1[8] sdh1[7] sdg1[6]
sdf
1[5] sdc1[4] sda1[3] sdb1[2] hdb1[1]
      3223457600 blocks level 4, 4k chunk, algorithm 0 [12/12]
[UUUUUUUUUUUU]

unused devices: <none>
[root@st-0003 ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Fri Jun  9 08:27:26 2006
     Raid Level : raid4
     Array Size : 3223457600 (3074.13 GiB 3300.82 GB)
    Device Size : 293041600 (279.47 GiB 300.07 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jun 14 00:10:23 2006
          State : clean
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 4K

           UUID : 3eec5a2c:812deda6:1219fc67:edc77e6e
         Events : 0.153457

    Number   Major   Minor   RaidDevice State
       0       3        1        0      active sync   /dev/hda1
       1       3       65        1      active sync   /dev/hdb1
       2       8       17        2      active sync   /dev/sdb1
       3       8        1        3      active sync   /dev/sda1
       4       8       33        4      active sync   /dev/sdc1
       5       8       81        5      active sync   /dev/sdf1
       6       8       97        6      active sync   /dev/sdg1
       7       8      113        7      active sync   /dev/sdh1
       8       8      145        8      active sync   /dev/sdj1
       9       8       49        9      active sync   /dev/sdd1
      10       8      129       10      active sync   /dev/sdi1
      11       8       65       11      active sync   /dev/sde1
[root@st-0003 ~]# time mdadm -G /dev/md0 --bitmap=internal
mdadm: failed to set internal bitmap.

real    0m8.645s
user    0m0.070s
sys     0m1.600s
[root@st-0003 ~]#

Why? :-)

And another one question:
Why are the bitmap support disabled in the latest kernels for raid4?
It works really good, i have tested it a lot of times! ;-)

(Neil sent me a little patch to enable it before...)

Thanks
Janos

