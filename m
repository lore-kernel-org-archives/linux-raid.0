From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <csaba.toth@i3rendszerhaz.hu>
Subject: convert raid10 to raid0
Date: Wed, 07 Jul 2010 21:29:49 +0200
Message-ID: <4C34D5AD.5020305@i3rendszerhaz.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey List,

i have a serious problem: have a file server with 4 disk (4x750GB),
using them in a software RAID10 array. One of the HDDs have a bad sector
(because some administration problems, i cannot replace them), and the
motherboard sometimes drops the connection with two HDDs. Not with the
same as the bad sector has, but with a resync i always managed the
problem. But now 3 drive form the RAID10 array dropped.

In the past the sdc6 and the sdd6 partitions were the partitions i
resynced the others, so i know exactly where to look for the proper
datas. Can i use them as a RAID0 array somehow?
In past mdadm warning letters i saw the config:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md5 : active raid10 sdc6[0] sdd6[3] sdb6[1](F) sda6[2](F)
      1434619904 blocks super 1.1 512K chunks 2 near-copies [4/2] [U__U]

md1 : active raid1 sdb5[0] sdc5[1]
      14763635 blocks super 1.1 [2/2] [UU]

md0 : active raid1 sdd5[0] sda5[2](F)
      14659200 blocks [2/1] [U_]

unused devices: <none>


Now i have:

minerva ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath] [faulty]
md5 : inactive sdd6[3]
      717310119 blocks super 1.1

md1 : active raid1 sdc5[0] sdb5[1]
      14763635 blocks super 1.1 [2/2] [UU]

md0 : active raid1 sda5[1] sdd5[0]
      14659200 blocks [2/2] [UU]

unused devices: <none>
minerva ~ # mdadm --detail /dev/md5
/dev/md5:
        Version : 1.1
  Creation Time : Thu Nov 26 14:50:07 2009
     Raid Level : raid10
  Used Dev Size : 717309952 (684.08 GiB 734.53 GB)
   Raid Devices : 4
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Wed Jul  7 10:34:32 2010
          State : active, FAILED, Not Started
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 512K

           Name : minerva:5  (local to host minerva)
           UUID : a73f5902:accc2488:aecfdc14:05a6e2f4
         Events : 3981420

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       0        0        1      removed
       2       0        0        2      removed
       3       8       54        3      active sync   /dev/sdd6




If i try to add sdc6 to the md5 array it fails, because it tries to add
as a fifth device:

minerva ~ # mdadm /dev/md5 -a /dev/sdc6
mdadm: add new device failed for /dev/sdc6 as 4: Invalid argument



Please help, i don't want to destroy the datas, and i have never job
with RAID10 under linux.

thanks in advance,
regards,
Csaba
