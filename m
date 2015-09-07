From: =?UTF-8?B?0K7RgNC40Lkg0JHRg9C60LjQvQ==?= <yury@smsio.ru>
Subject: Disk failed on grow process and missing backup-file
Date: Mon, 7 Sep 2015 15:15:40 +0500
Message-ID: <CAMsNsNO-gWsHmO=dVYg2g=TA11BbrjdiMUC833oT4uRC6dUQ_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I run grow raid5 from 4 to 5 devices:

# mdadm --grow /dev/md5 -n5 --backup-file /root/md5-grow.backup

All OK. Process started. After sometime I receive message about problem:

-----------
TEMA:Fail event on /dev/md5
TEKCT:This is an automatically generated mail message from mdadm

A Fail event had been detected on md device /dev/md5.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid1] [raid6] [raid5] [raid4]
md5 : active raid5 sda3[7] sdc3[5] sde3[3] sdb3[4] sdf3[6](F)
      5847406080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [U_UUU]
      [===================>.]  reshape = 98.0% (1911492608/1949135360)
finish=522.1min speed=1201K/sec

md6 : active raid6 sda2[3] sdb2[0] sdf2[4](F) sde2[1]
      7486080 blocks level 6, 64k chunk, algorithm 2 [4/3] [UU_U]

md2 : active raid1 sda1[3](S) sde1[0] sdb1[2] sdf1[1]
      160512 blocks [3/3] [UUU]
  --------
and server become offline.

Today I reboot server after crash but md5 can not started.
Then I run command:

# mdadm -A /dev/md5 --force
mdadm: /dev/md5 has been started with 4 drives (out of 5)

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md5 : active (auto-read-only) raid5 sdc3[5] sda3[7] sde3[3] sdb3[4]
      5847406080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [U_UUU]

# mdadm --detail /dev/md5
/dev/md5:
        Version : 1.2
  Creation Time : Tue Apr 10 11:46:42 2012
     Raid Level : raid5
     Array Size : 5847406080 (5576.52 GiB 5987.74 GB)
  Used Dev Size : 1949135360 (1858.84 GiB 1995.91 GB)
   Raid Devices : 5
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sat Sep  5 01:54:48 2015
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

  Delta Devices : 1, (4->5)

           Name : tmn-rec1.tmn.teleartel.ru:5  (local to host
tmn-rec1.tmn.teleartel.ru)
           UUID : f77e074e:5b74a964:073b9c49:8dcbe5cd
         Events : 936072

    Number   Major   Minor   RaidDevice State
       5       8       35        0      active sync   /dev/sdc3
       1       0        0        1      removed
       4       8       19        2      active sync   /dev/sdb3
       3       8       67        3      active sync   /dev/sde3
       7       8        3        4      active sync   /dev/sda3

# mdadm --examine /dev/sdc3
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : f77e074e:5b74a964:073b9c49:8dcbe5cd
           Name : tmn-rec1.tmn.teleartel.ru:5  (local to host
tmn-rec1.tmn.teleartel.ru)
  Creation Time : Tue Apr 10 11:46:42 2012
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3898271744 (1858.84 GiB 1995.92 GB)
     Array Size : 7796541440 (7435.36 GiB 7983.66 GB)
  Used Dev Size : 3898270720 (1858.84 GiB 1995.91 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9020ef29:6c9ee6b1:76a80389:c3d1a1e8

  Reshape pos'n : 7645890560 (7291.69 GiB 7829.39 GB)
  Delta Devices : 1 (4->5)

    Update Time : Sat Sep  5 01:54:48 2015
       Checksum : e648496d - correct
         Events : 936072

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AAA ('A' == active, '.' == missing)

I try check fs on raid in read-only mode:

# fsck -C0 -fn /dev/vg_r5/archive
fsck from util-linux 2.20.1
e2fsck 1.42.5 (29-Jul-2012)
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong (72425382, counted=72416375).
Fix? no

Free inodes count wrong (330815912, counted=330815899).
Fix? no

/dev/mapper/vg_r5-archive: 443992/331259904 files (49.0%
non-contiguous), 1252586586/1325011968 blocks

Probably all right. But:

# mount /dev/vg_r5/archive /mnt/tmp -o ro

stale and i get messages infinity:

INFO: task mount:9872 blocked for more than 120 seconds.
