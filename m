From: "Glen Whittenberg" <glenewhittenberg@gmail.com>
Subject: Failed drive in RAID10 using Intel IHC
Date: Thu, 28 Aug 2014 22:08:58 -0700
Message-ID: <00ed01cfc347$5851bd80$08f53880$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What to do... I have a SUPERMICRO SuperServer 5017R-MTF server with 4
Western Digital WDE SATA drives in it. This was setup in the BIOS as a
RAID10 Array then OpenSUSE dropped on it. It appears one of the drives is
off line now. Here is the good part, like the BIOS RAID thing is not enough.
This is a single volume and it also boots off of it. What can I do to repair
this? Some info is below. Please let me know what else is needed. Thanks!

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md125 : inactive sdc[0](S)
      1105 blocks super external:imsm

md126 : active raid10 sda[2] sdb[1] sdd[0]
      3711641600 blocks super external:/md127/0 64K chunks 2 near-copies
[4/3] [UU_U]
      [=============>.......]  resync = 68.7% (2550717632/3711641856)
finish=157.5min speed=122779K/sec

md127 : inactive sda[2](S) sdd[1](S) sdb[0](S)
      9459 blocks super external:imsm

unused devices: <none>

# mdadm --version
mdadm - v3.3 - 3rd September 2013

# mdadm --detail /dev/md126
/dev/md126:
      Container : /dev/md/RAID_0, member 0
     Raid Level : raid10
     Array Size : 3711641600 (3539.70 GiB 3800.72 GB)
  Used Dev Size : 1855820928 (1769.85 GiB 1900.36 GB)
   Raid Devices : 4
  Total Devices : 3

          State : active, degraded, resyncing
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

  Resync Status : 69% complete


           UUID : dd2ab43b:37dd6ee2:8d78e0a9:ba8c4eec
    Number   Major   Minor   RaidDevice State
       2       8        0        0      active sync set-A   /dev/sda
       1       8       16        1      active sync set-B   /dev/sdb
       4       0        0        4      removed
       0       8       48        3      active sync set-B   /dev/sdd


