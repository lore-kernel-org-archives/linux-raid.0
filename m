From: Tommy Apel Hansen <tommyapeldk@gmail.com>
Subject: RAID5 performace issue
Date: Thu, 22 Nov 2012 21:53:54 +0100
Message-ID: <1767331.K4nRMCSJWv@workstation-home>
Reply-To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,
I'm experiencing some issus with RAID5 and 5 or more disks, while doign 
sequencial 4k writes to and array with 5 or more disks I'm only getting 
~279IOPs where when using 4 disks yields ~2752IOPs, it's a 1/10 in IOPs but 
with more disks so the result should actually be better the more disks there 
is, see results and test below.

Regards
/Tommy

RAID5 5 disks:
echo 16384 > /sys/block/md0/md/stripe_cache_size
mkfs.xfs -l su=32k -d su=512k,sw=4 -f /dev/md0
mdadm -D /dev/md0:
        Version : 1.2
  Creation Time : Wed Nov 21 20:36:46 2012
     Raid Level : raid5
     Array Size : 7814051840 (7452.06 GiB 8001.59 GB)
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Thu Nov 22 20:59:27 2012
          State : clean 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : right-asymmetric
     Chunk Size : 512K
fio sequential write ioengine=sync, iodepth=1 :
-- 512b bw=2207.3KB/s, iops=4414
-- 1k      bw=3586.4KB/s, iops=3586
-- 2k      bw=5584.7KB/s, iops=2792
-- 4k      bw=1119.6KB/s, iops=279
-- 8k      bw=2107.4KB/s, iops=263
-- 16k    bw=4438.3KB/s, iops=277
-- 32k    bw=6826.7KB/s, iops=213
-- 64k    bw=9167.5KB/s, iops=143
-- 128k  bw=16580KB/s, iops=129

fio sequential read ioengine=sync, iodepth=1:
-- 512b bw=14069KB/s, iops=28137
-- 1k      bw=20511KB/s, iops=20511
-- 2k      bw=25173KB/s, iops=12586
-- 4k      bw=30654KB/s, iops=7663
-- 8k      bw=47503KB/s, iops=5937
-- 16k    bw=59487KB/s, iops=3717
-- 32k    bw=72496KB/s, iops=2265
-- 64k    bw=80117KB/s, iops=1251
-- 128k  bw=88286KB/s, iops=689

RAID5 4 disks:
mkfs.xfs -l su=32k -d su=512k,sw=3 -f /dev/md0
mdadm -D /dev/md0
        Version : 1.2
  Creation Time : Thu Nov 22 21:29:45 2012
     Raid Level : raid5
     Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Thu Nov 22 21:35:28 2012
          State : clean 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : right-asymmetric
     Chunk Size : 512K
fio sequential write ioengine=sync, iodepth=1 :
-- 512b bw=2553.2KB/s, iops=5107
-- 1k      bw=5486.9KB/s, iops=5486
-- 2k      bw=10785KB/s, iops=5392
-- 4k      bw=11012KB/s, iops=2752
-- 8k      bw=15316KB/s, iops=1914
-- 16k    bw=15933KB/s, iops=995
-- 32k    bw=17368KB/s, iops=542
-- 64k    bw=20633KB/s, iops=322
-- 128k  bw=26263KB/s, iops=205

fio sequential read ioengine=sync, iodepth=1:
-- 512b bw=14112KB/s, iops=28224
-- 1k      bw=20512KB/s, iops=20512
-- 2k      bw=25199KB/s, iops=12599
-- 4k      bw=30438KB/s, iops=7609
-- 8k      bw=48065KB/s, iops=6008
-- 16k    bw=68692KB/s, iops=4293
-- 32k    bw=82708KB/s, iops=2584
-- 64k    bw=96403KB/s, iops=1506
-- 128k bw=111824KB/s, iops=873

