From: Dag Sverre Seljebotn <dss@fredtun.no>
Subject: Root on sw RAID 5 + LVM will only boot in degraded mode
Date: Fri, 19 Nov 2004 12:57:48 +0100
Message-ID: <1100865468.4390.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On reboot the last disk to be added to the array is kicked out of it and
the array starts in degraded mode.

Long story:

My setup is with six disks on a Promise TX4 serial ata controller. I
have a working system on one of them, and am trying to set up a working
RAID setup on the other five (leaving the first one as a spare).

The 5 disks are each partioned into two; a 50 MB boot partition and a
~200 GB RAID partition. The RAID partitions are then run in RAID 5, then
I run LVM on top of RAID.

As my root I would like to use a LVM root partition. I've sucessfully
used Debian's mkinitrd to create an initrd that has root-on-LVM support, and the
system boots fine.

However, the last disk that I added is never present in the array after
a boot. I know that it is not a disk failure because there are no log
messages about such a failure and also I've tried adding the disks in
different orders, and it is always the last one that fails. After
booting I can re-add the disk to the array, and after syncing it will
operate as part of the array until the next reboot, when the same disk
is kicked out again.

However, when booting with the root from the original disk that is not a
part of the array, it will recognize all five disks in the array without
any problems.

I'm running Debian testing, and the filesystem is ReiserFS. Relevant part
of /var/log/messages:

Nov 18 19:15:49 localhost kernel: SCSI device sda: 390721968 512-byte
hdwr sectors (200050 MB)
Nov 18 19:15:49 localhost kernel: Partition check:
Nov 18 19:15:49 localhost kernel:  /dev/scsi/host0/bus0/target0/lun0: p1
p2
Nov 18 19:15:49 localhost kernel: SCSI device sdb: 390721968 512-byte
hdwr sectors (200050 MB)
Nov 18 19:15:49 localhost kernel:  /dev/scsi/host1/bus0/target0/lun0: p1
p2
... the rest of the disks in the same manner
Nov 18 19:15:49 localhost kernel: md0: former device
scsi/host1/bus0/target0/lun0/part2 is unavailable, removing from array!
... starting to recover array, but no spare disks found

I appriciate any response!

// Dag Sverre


