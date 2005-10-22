From: Juraj Holtak <juraj@proaut.org>
Subject: how to add third drive to RAID1 made of two drives without
	destroying data
Date: Sat, 22 Oct 2005 18:53:02 +0200
Message-ID: <1129999982.11518.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a working RAID1 with 2 large SATA drives and I`m using AHCI on
ICH6 chipset.
Three days ago, one drive just mysteriously failed

Oct 19 22:45:37 xaser kernel: ata1: error occurred, port reset
Oct 19 22:48:09 xaser kernel: ata2: status=0x01 { Error }
Oct 19 22:48:09 xaser kernel: ata2: error=0x40 { UncorrectableError }
Oct 19 22:48:09 xaser kernel: ata1: error occurred, port reset
Oct 19 22:48:09 xaser kernel: ata2: status=0x01 { Error }
Oct 19 22:48:09 xaser kernel: ata2: error=0x40 { UncorrectableError }
Oct 19 22:48:09 xaser kernel: SCSI error : <1 0 0 0> return code =
0x8000002
Oct 19 22:48:09 xaser kernel: sdb: Current: sense key: Medium Error
Oct 19 22:48:09 xaser kernel:     Additional sense: Unrecovered read
error - aut
o reallocate failed
Oct 19 22:48:09 xaser kernel: end_request: I/O error, dev sdb, sector
440990889
Oct 19 22:48:09 xaser kernel: raid1: Disk failure on sdb9, disabling
device.

The drive appeared dead to all my attempts to get it to work without
power cycle.
Today, the replacement drive was shipped, so I powercycled the machine
and *wonder wonder* the drive was back. So I `badblocks` and resynced
again and its working perfect.

I know I can use the "new" drive I bought today as spare, but I really
miss the point of a spare for raid1. I think, it makes much more sense,
to build in the drive as a live one, so instead of RAID1 made of 2
drives, I`ll get RAID1 made of 3 drives.

I use mdadm to manage the drives. If I use --manage --add and add the
drive(partition) to the array, it becomes a spare disk and this is not
what I want it to do.

Is there a way to upgrade my raid, without destroying data?

cheers,
juraj

