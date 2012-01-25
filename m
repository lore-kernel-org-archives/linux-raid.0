From: Seth Jennings <spartacus06@gmail.com>
Subject: Help please: 2-5 tps on write with 98% iowait
Date: Wed, 25 Jan 2012 12:15:56 -0600
Message-ID: <CAG-w=x54HyGxnjSHjBCpqYXvOOwpWd4dOHCJBYTTuvPHu_ViCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The write performance on my raid5 took a nose dive yesterday and I can't
figure out what is to blame. iostat is showing 98% iowait with 2-5 tps per
array disk (?!).  I'm including as much information as I can think to include
without overwhelming anyone inclined to help me debug this.

Also, I'm familiar with kernel internals/debugging so just let me know if you
need more information.

Thanks
--
Seth

======================
All disks are SATA and pass SMART health assessment. No errors in dmesg.

Setup:
/dev/sda: 250GB single part
/dev/sdb: 250GB single part
/dev/sdc: 500GB, 2x250GB parts
/dev/sdd: 320GB, 250GB and 70GB parts

/dev/sda:
 Timing cached reads:   2294 MB in  2.00 seconds = 1147.32 MB/sec
 Timing buffered disk reads: 186 MB in  3.02 seconds =  61.69 MB/sec
sjennings@cerebrum:~$ sudo hdparm -Tt /dev/sdb

/dev/sdb:
 Timing cached reads:   2250 MB in  2.00 seconds = 1125.59 MB/sec
 Timing buffered disk reads: 184 MB in  3.01 seconds =  61.05 MB/sec

/dev/sdc:
 Timing cached reads:   2172 MB in  2.00 seconds = 1086.00 MB/sec
 Timing buffered disk reads: 392 MB in  3.01 seconds = 130.36 MB/sec

/dev/sdd:
 Timing cached reads:   2220 MB in  2.00 seconds = 1110.60 MB/sec
 Timing buffered disk reads: 236 MB in  3.02 seconds =  78.15 MB/sec

/dev/md0:
        Version : 0.90
  Creation Time : Mon Jul 12 08:32:58 2010
     Raid Level : raid5
     Array Size : 732587712 (698.65 GiB 750.17 GB)
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jan 25 09:51:25 2012
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : cf70d928:8ad26aac:17383c13:03badee3
         Events : 0.2068

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       34        2      active sync   /dev/sdc2
       3       8       49        3      active sync   /dev/sdd1


--- Physical volume ---
  PV Name               /dev/md0
  VG Name               raid5vg
  PV Size               698.65 GiB / not usable 1.44 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              178854
  Free PE               57254
  Allocated PE          121600
  PV UUID               F038RQ-reR4-BSPy-43lA-UJI4-uoMY-XQk23n

  --- Volume group ---
  VG Name               raid5vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  47
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                6
  Open LV               3
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               698.65 GiB
  PE Size               4.00 MiB
  Total PE              178854
  Alloc PE / Size       121600 / 475.00 GiB
  Free  PE / Size       57254 / 223.65 GiB
  VG UUID               9KjnCN-l4gT-jUkR-gqt5-DyDR-GeGX-20DmJc

  --- Logical volume ---
  LV Name                /dev/raid5vg/home
  VG Name                raid5vg
  LV UUID                flP8gL-adJq-Ur0d-Nsl0-olZ8-tzpi-fjqGi6
  LV Write Access        read/write
  LV Status              available
  # open                 1
  LV Size                250.00 GiB
  Current LE             64000
  Segments               2
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     768
  Block device           252:0

/dev/mapper/raid5vg-home is mounted at /home type ext4 (rw,noatime)

read /home (dm-0 on md0):

dd if=ubuntu-11.04-alternate-i386.iso of=/dev/null (not in page cache)
1419416+0 records in
1419416+0 records out
726740992 bytes (727 MB) copied, 5.65182 s, 129 MB/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           2.99    0.00   27.36   21.39    0.00   48.26

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda             531.00     37632.00         0.00      37632          0
sdb             451.00     37648.00         0.00      37648          0
sdc             532.00     37760.00         0.00      37760          0
md0            2751.00    150912.00         0.00     150912          0
sdd             453.00     37712.00         0.00      37712          0
dm-0           2751.00    150912.00         0.00     150912          0

so reading is good.

write /home:

dd if=/dev/zero of=zeroes
<ctrl-c>
208385+0 records in
208384+0 records out
106692608 bytes (107 MB) copied, 27.6739 s, 3.9 MB/s

qavg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.52    0.00    1.55   97.94    0.00    0.00

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               2.00       192.00       444.00        192        444
sdb               5.00       192.00      1020.00        192       1020
sdc               3.00       192.00       444.00        192        444
md0              34.00       768.00      1344.00        768       1344
sdd               5.00       192.00      1020.00        192       1020
dm-0             34.00       768.00      1344.00        768       1344

so writing is aweful (2-5 tps per disk with 98% iowait?!).

write /dev/sdc1 (non-raid part in /dev/sdc)

dd if=/dev/zero of=zeroes bs=4096 count=100000
100000+0 records in
100000+0 records out
409600000 bytes (410 MB) copied, 2.64131 s, 155 MB/s

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1.50    0.00   32.00   57.00    0.00    9.50

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda               0.00         0.00         0.00          0          0
sdb               0.00         0.00         0.00          0          0
sdc             267.00         0.00    135680.00          0     135680
md0               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
dm-0              0.00         0.00         0.00          0          0

so writing to non-raid partition of one of the disks is good.
