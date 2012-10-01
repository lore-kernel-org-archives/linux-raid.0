From: Chris Murphy <lists@colorremedies.com>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Sun, 30 Sep 2012 23:56:20 -0600
Message-ID: <AB750CDA-9AC3-4BE9-B9B9-33CADA4843B5@colorremedies.com>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com> <20121001125510.6cc0c2be@notabene.brown> <0E52B34E-36DF-4F1C-90DA-EB793A209B95@thinkcomputer.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0E52B34E-36DF-4F1C-90DA-EB793A209B95@thinkcomputer.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Greenspan <aarong@thinkcomputer.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 30, 2012, at 11:12 PM, Aaron Greenspan wrote:
> 
> Sector size (logical/physical): 512 bytes / 4096 bytes
> 
> Partition 1 does not start on physical sector boundary.
> Partition 2 does not start on physical sector boundary.
> Partition 3 does not start on physical sector boundary.
> Partition 4 does not start on physical sector boundary.
> Partition 5 does not start on physical sector boundary.

These are 512e AF disks, and none of the partitions are aligned on either disk's 4K sectors. For mostly reads, the performance hit is probably not a big deal, but the penalty for writes for /, /home, and swap all on the same disk could be significant.

Let's see what other opinions there are on this. But I think you're better off doing things correctly from the start with these new disks: have them be properly aligned and use recent and consistent superblock formats for all md devices.

*shrug* but if the new kernel solves the problem, and you're up and running, and you're happy with the performance, it's hard to complain about that.

> Disk /dev/md0: 104 MB, 104845312 bytes
> Disk /dev/md1: 226.5 GB, 226491232256 bytes
> Disk /dev/md2: 1044 MB, 1044597760 bytes
> Disk /dev/md3: 886.4 GB, 886367970304 bytes

What is md2, it's not listed in df?

And it looks like / and /home aren't on LVM, so pvmove isn't an option unfortunately. That would make migrating root easier. Maybe someone else has an idea how to migrate root without LVM or syncing, I'm only thinking of using dd partition to partition copy, while booted from a LiveCD or something. Of course this would not update the superblock format.


Chris Murphy

