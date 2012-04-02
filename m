From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Linux 3.3.1 resync speed
Date: Mon, 2 Apr 2012 22:21:20 +0100
Message-ID: <CADNH=7H3ejuJSLymMoxiFtnY90Ur5_e8D71UK5eDWqXRX1-oHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi mailing list,

On my old

model name	: Intel(R) Atom(TM) CPU  330   @ 1.60GHz

I'm currently seeing a resync speed of around 200MB/s!

~ $ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdg1[0] sde1[7] sdh1[8] sdf1[5] sdc1[3] sdd1[4] sdb1[9]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/7] [UUUUUUU]
      [======>..............]  check = 32.6% (636923520/1950351360)
finish=111.2min speed=196740K/sec

unused devices: <none>

This ia almost 10 times higher than what I used to see on 3.2 and
earlier. What's that about? The array is a 7 drive RAID6:

$ sudo mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Mon Apr  2 22:18:14 2012
          State : clean, checking
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

   Check Status : 32% complete

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 6773811

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       9       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       81        4      active sync   /dev/sdf1
       8       8      113        5      active sync   /dev/sdh1
       7       8       65        6      active sync   /dev/sde1

Best regards,
Mathias
