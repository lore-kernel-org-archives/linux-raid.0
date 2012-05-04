From: wilsonjonathan <piercing_male@hotmail.com>
Subject: Moving drives from different PC's advice please.
Date: Fri, 4 May 2012 02:02:22 +0100
Message-ID: <BLU0-SMTP170BC0E264A4F4CFB014791982C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My current set-up is 1 PC that has 6 drives (1TB each) set up as a
server (BigData). The partitions are gpt, and all the drives are
partitioned as...

BiosBoot (1Mg-mirror) root (8Meg-mirror) swap (16Gb) download
(50Gb-raid10) data (raid6)

the setup is that the 50Gb is seen as 100Gb, and the data is seen as the
rest.

Each drive is partitioned exactly the same... on disk 3-6 the space is
partitioned exactly the same, but unused in the case of "boot, root,
swap, download"

I also have a PC that has 2 drives (BorgCube), that are non-specific
(I'm moving things around) but will eventually have BiosBoot, root,
swap, download, and home... set up as mirror, mirror, mirror, raid10,
and mirror.

The BorgCube, once re-set up, will have its drives on a PCI Sata card
and assuming it works I will then need to move the hard drives from
BigData to its (borgCube) on board sata connections.

My questions are... 

1. what is the best logical steps to do this, things like sequence of
events (get pc working on sata card, attach all additional drives, run
mdadm -scan, etc.)

2. Once all running (assuming it works) how do I then remove the
partitions that were originally on the BigData that are no longer
required such as BigDrive-BiosBoot, BigDrive-root, BigDrive-swap.
BigDrive-dowload.

3. After removing the partitions (that are lower in the order, data is
the 6th partition) how do I then recover that space into a disk
partition and then recover that space as and ext4 partition... as I
believe that you first have to do something with the physical disk
partitions then do something with the mdadm raid partitions, then
something with the file system on top of the raid partition.

So removing disk and raid partitions 1-5 (boot, root, etc.) and finally
having a mdadm raid of 6 disks, with just one partition... set up as
disk (1-6) partitions, mdadm on 6 disks, ext4 on mdadm raid set up.



