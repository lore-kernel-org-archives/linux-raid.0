From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: mdadm / RAID, a few questions
Date: Fri, 29 Oct 2010 15:18:09 +0100
Message-ID: <AANLkTi=QRfQhNy5jDdtq2FsjENZk-ihNas=D4QrS2XMd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've a few questions in relation to mdadm and performance. System
details follow below:

Intel Atom 330 @ 1.6Ghz (dualcore, HT), 4GB RAM
05:00.0 SCSI storage controller: HighPoint Technologies, Inc.
RocketRAID 230x 4 Port SATA-II Controller (rev 02)
00:0b.0 SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
/dev/sda:
 Model=Corsair CSSD-F60GB2, FwRev=1.1, SerialNo=10326505580009990027
/dev/sdb:
 Model=WDC WD20EARS-00MVWB0, FwRev=51.0AB51, SerialNo=WD-WCAZA1022443
/dev/sdc:
 Model=WDC WD20EARS-00MVWB0, FwRev=50.0AB50, SerialNo=WD-WMAZ20152590
/dev/sdd:
 Model=WDC WD20EARS-00MVWB0, FwRev=50.0AB50, SerialNo=WD-WMAZ20188479
/dev/sde:
 Model=SAMSUNG HD204UI, FwRev=1AQ10001, SerialNo=S2HGJ1RZ800964
/dev/sdf:
 Model=WDC WD20EARS-00MVWB0, FwRev=51.0AB51, SerialNo=WD-WCAZA1000331
/dev/sdg:
 Model=SAMSUNG HD204UI, FwRev=1AQ10001, SerialNo=S2HGJ1RZ800850

mdadm -D /dev/md0:

/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid5
     Array Size : 5851054080 (5580.00 GiB 5991.48 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 6
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Fri Oct 29 15:42:42 2010
          State : active, recovering
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

 Reshape Status : 57% complete
  Delta Devices : 2, (4->6)

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 35293

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       65        4      active sync   /dev/sde1
       6       8       97        5      active sync   /dev/sdg1

Question 1: I saw that in Linux 2.6.36 (perhaps earlier versions as
well) you have the kernel config option CONFIG_MULTICORE_RAID456. I
tried enabling it, booted to 2.6.36 from 2.6.35, and rebuilding of the
array continued where it left off before reboot. However, the
performance was abysmal.. around 16MB/s compared to 70MB/s without the
option turned on. Is this a bug, or is it because the Atom has no
grunt to speak of?

Question 2: The array is now recovering since I've grown it to 6 from 4 devices:
$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdf1[0] sde1[5] sdg1[6] sdc1[3] sdd1[4] sdb1[1]
      5851054080 blocks super 1.2 level 5, 128k chunk, algorithm 2
[6/6] [UUUUUU]
      [===========>.........]  reshape = 57.7% (1126387328/1950351360)
finish=718.0min speed=19125K/sec

unused devices: <none>

Is there a way to speed it up? /proc/sys/dev/raid/speed_limit_min is
100000 (100k), /proc/sys/dev/raid/speed_limit_max is 1000000 (1000k).

Question 3: Before I created this RAID5 array I did a quick RAID0 test
array just for fun, using 2 full devices (not partitions). Now I have
this:

mdadm  --examine --verbose --scan
ARRAY /dev/md/raid0-test level=raid0 metadata=1.2 num-devices=2
UUID=b84cc081:1ae27b49:d5ae466c:377ba300 name=ion:raid0-test
   devices=/dev/sdf,/dev/sdb
ARRAY /dev/md/0 level=raid5 metadata=1.2 num-devices=6
UUID=e6595c64:b3ae90b3:f01133ac:3f402d20 name=ion:0
   devices=/dev/sdg1,/dev/sdf1,/dev/sde1,/dev/sdd1,/dev/sdc1,/dev/sdb1

Is it safe to erase the raid0-test superblocks on device /dev/sdb and
/dev/sdc or will it interfere with my RAID5 array (which is lying on
top of partitions) ?

Many thanks,
// Mathias
