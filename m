From: "Mikael Chambon" <raid-ml@cronos.org>
Subject: raid partition crash
Date: Fri, 22 Aug 2003 16:30:52 -1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000201c36aac$37729080$1902a8c0@magnus>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear RAID users,

I  have a root raid 1 fileserver using 2 120 IDE disk and a standard Redhat
2.4.20 kernel
Two days ago I discovered that one of my raid partition failed:

====== From my logs ============
Aug 15 23:00:05 mekare kernel: hdc: dma_intr: status=0x51 { DriveReady
SeekComplete Error }
Aug 15 23:00:05 mekare kernel: hdc: dma_intr: error=0x40
 UncorrectableError }, LBAsect=73785359, sector=64487504
Aug 15 23:00:05 mekare kernel: end_request: I/O error, dev 16:06 (hdc),
sector 64487504
Aug 15 23:00:05 mekare kernel: raid1: Disk failure on hdc6, disabling
device.
Aug 15 23:00:05 mekare kernel: ^IOperation continuing on 1 devices
Aug 15 23:00:05 mekare kernel: raid1: hdc6: rescheduling block 64487504
Aug 15 23:00:05 mekare kernel: md: updating md0 RAID superblock on device
Aug 15 23:00:05 mekare kernel: md: hda6 [events: 0000001d]<6>(write) hda6's
sb offset: 115411840
Aug 15 23:00:05 mekare kernel: md: recovery thread got woken up ...
Aug 15 23:00:05 mekare kernel: md0: no spare disk to reconstruct array! --
continuing in degraded mode
Aug 15 23:00:05 mekare kernel: md: recovery thread finished ...
Aug 15 23:00:05 mekare kernel: md: (skipping faulty hdc6 )
Aug 15 23:00:05 mekare kernel: raid1: hda6: redirecting sector 64487504 to
another mirror
============================

hda6 and hdc6 are my fileserver partition using RAID1 as md0.
Others partitions on hdc seem to work fine.

====== From /etc/raidtab ==========
[.....skip....]

raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda6
    raid-disk     0
    device          /dev/hdc6
    raid-disk     1
[....skip.....]
=============================

========From /proc/mdstat=========
Personalities : [raid1]
read_ahead 1024 sectors
md0 : active raid1 hda6[0] hdc6[1](F)
      115411840 blocks [2/1] [U_]
md2 : active raid1 hda5[0] hdc5[1]
      532608 blocks [2/2] [UU]
md1 : active raid1 hda3[0] hdc3[1]
      2047680 blocks [2/2] [UU]
md3 : active raid1 hda2[0] hdc2[1]
      2047680 blocks [2/2] [UU]
md4 : active raid1 hda1[0] hdc1[1]
      20544 blocks [2/2] [UU]
unused devices: <none>
=============================



As others hdc partitions seem to work fine, I assume there is not hardware
problem with hdc.
So I tried to reinsert hdc6 to md0 with: raidhotadd -a /dev/md0 /dev/hdc6
but I get the following error:

/dev/md0: can not hot-add disk: disk busy!


What do you thing of this problem ? Is this an hardware problem ?
How can I reinsert hdc6 without stopping the raid array (the fileserver is
currently in production).

Thanks a lot for your answer and sorry for this long email.

--
Mikael Chambon


