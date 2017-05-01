From: Adam Thompson <athompso@athompso.net>
Subject: Big-endian RAID5 recovery problem
Date: Mon, 01 May 2017 16:39:07 -0500
Message-ID: <5c6e6e5d93d4056839e4f370e00a8e08@mail.athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MUUG Roundtable <roundtable@muug.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So I've got 4 IDE HDDs, each with 3 RAID partitions on them, that were 
part of a RAID array in a now-very-dead NAS.

Of course, I need to get data off them that wasn't backed up anywhere 
else.

I've got a 4-port USB3 PCIe card, and 4 IDE/SATA USB adapters, and all 
the hardware seems to work.  So far, so good.

The problem is that the disks use the v0.90 metadata format, and they 
came from a big-endian system, not a little-endian system.  MD 
superblocks *since* v0.90 are endian-agnostic, but back in v0.90, the 
superblock was byte-order specific.

mdadm(8) on an Intel processor refuses to acknowledge the existence of 
the superblock.  Testdisk detects it and correctly identifies it as a 
Big-endian v0.90 superblock.

I'm reluctant to blindly do a forced --create on the four disks, because 
I'm not 100% certain of the RAID topology; there are at least two RAID 
devices, one of which was hidden from the user, so I have no a-priori 
knowledge of its RAID level or layout.

The filesystems on the md(4) devices are, AFAIK, all XFS, and so should 
(hopefully) not have any endianness issues.

I can't find any modern big-endian Linux systems... looks like all the 
ARM distros run in little-endian mode.

Any suggestions on the best way to move forward?

Thanks,
-Adam
