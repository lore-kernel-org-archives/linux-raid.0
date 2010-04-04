From: Brett King <king.br@gmail.com>
Subject: Update: mdadm 3.1.1 / 2.6.32 - trouble reducing active devices in
	13TB RAID6
Date: Sun, 4 Apr 2010 17:15:56 +1000
Message-ID: <n2j8cf253381004040015ga48536b2s204f3b622367b06a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,
Just an update for anyone following this; it's now working as expected
on mdadm v3.1.2 & kernel 2.6.34-rc3.

/dev/md0:
        Version : 0.91
  Creation Time : Fri Apr  4 21:17:09 2008
     Raid Level : raid6
     Array Size : 9767624960 (9315.13 GiB 10002.05 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 12
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Apr  4 17:14:25 2010
          State : clean, recovering
 Active Devices : 13
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 14% complete
  Delta Devices : -1, (12->11)

           UUID : 251f6c00:b15f5541:4eb0bc47:eeccb517
         Events : 0.6084463

    Number   Major   Minor   RaidDevice State
       0     259    557056        0      active sync   /dev/sdq
       1     259    294912        1      active sync   /dev/sdr
       2     259    819200        2      active sync   /dev/sds
       3     259    786432        3      active sync   /dev/sdd
       4     259    688128        4      active sync   /dev/sdu
       5     259    425984        5      active sync   /dev/sdv
       6     259    851968        6      active sync   /dev/sdl
       7     259    196608        7      active sync   /dev/sdm
       8     259    720896        8      active sync   /dev/sdn
       9     259    458752        9      active sync   /dev/sdo
      10     259        0       10      active sync   /dev/sda
      11     259    524288       11      active sync   /dev/sdb

      12     259    262144       12      active sync   /dev/sdc

md0 : active raid6 sdq[0] sdc[12] sdb[11] sda[10] sdo[9] sdn[8] sdm[7]
sdl[6] sdv[5] sdu[4] sdd[3] sds[2] sdr[1]
      9767624960 blocks super 0.91 level 6, 64k chunk, algorithm 2
[12/12] [UUUUUUUUUUUU]
      [==>..................]  reshape = 14.7% (143969472/976762496)
finish=1871.0min speed=7417K/sec

Cheers,
Brett.
