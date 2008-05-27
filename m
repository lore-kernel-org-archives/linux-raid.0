From: "Jeff Breidenbach" <jeff@jab.org>
Subject: split off + mount a partitionless RAID1 device?
Date: Mon, 26 May 2008 21:00:15 -0700
Message-ID: <e03b90ae0805262100h9eb16cfq31fe9e0430154007@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>, Jeff Marshall <marshman@frozenbear.com>
List-Id: linux-raid.ids

Ok, let's say that a um... hypothetical friend of mine had a power
outage this morning. This many disk RAID1 happily assembled and
mounted (with only mild persuasion) but is now caught up in a
monumentally slow resync. The resync is slow because /dev/md0 is
getting hammered with read requests by a webserver. If I turn off
Apache then resysnc speed shoots up to a respectable level, but I'd
rather not do that.

I'd love to split one of the drives off of the RAID1 and mount it
directly. Then it can feed the ravenous Apache monster while the
other five drives resync in peace. But foolishly and somewhat
accidentally, this RAID is made up of devices (sdb, sdbf, etc..)
instead of paritions (sdb1, sdf1, etc...). And I don't know how to
mount a partitionless device. Do you?




==

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid1 sdb[1] sde[6] sdh[5] sdg[4] sdf[3] sdl[2]
      976762496 blocks [7/6] [_UUUUUU]
      [=>...................]  resync =  8.3% (81881280/976762496)
finish=32031.5min speed=464K/sec

# /proc/sys/dev/raid/speed_limit_min
30000

# cat /proc/version
Linux version 2.6.24-8-server (buildd@yellow) (gcc version 4.2.3
(Ubuntu 4.2.3-1ubuntu2)) #1 SMP Thu Feb 14 20:42:20 UTC 2008

# mount | grep md0
/dev/md0 on /data1 type xfs (rw,noatime,logbufs=8,logbsize=256k)

# mdadm --query --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Thu Jan 31 18:56:43 2008
     Raid Level : raid1
     Array Size : 976762496 (931.51 GiB 1000.20 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon May 26 18:45:10 2008
          State : active, degraded, resyncing
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

 Rebuild Status : 8% complete

           UUID : 9b7bc589:f34bfba0:72fed6b5:5ee48a3f
         Events : 0.3047399

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       16        1      active sync   /dev/sdb
       2       8      176        2      active sync   /dev/sdl
       3       8       80        3      active sync   /dev/sdf
       4       8       96        4      active sync   /dev/sdg
       5       8      112        5      active sync   /dev/sdh
       6       8       64        6      active sync   /dev/sde
