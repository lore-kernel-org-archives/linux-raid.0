From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Thu, 30 Apr 2009 14:41:37 +1200
Message-ID: <1241059297.18303.4447.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <18935.35883.181289.739254@notabene.brown>  <49F79331.1050007@zytor.com>
	 <1240963507.18303.866.camel@ezra>  <49F79A0B.1000805@zytor.com>
	 <1240965373.18303.929.camel@ezra>  <49F7A2E3.4000908@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F7A2E3.4000908@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> We already have the technology to splitting the disk between the boot
> region and the array region (partition tables) and making sure that the
> boot region is fully replicated (RAID-1).  That is what we should be
> deploying, and if it somehow is too hard to deploy, that is what should
> be fixed.

Can we do this using containers like intels matrix raid.  I believe
mdadm v3 will support assembling intel-matrix raid, but I haven't seen
anything that says it will allow us to create raid volumes like this.

Could this be used to allocate the first piece of the disks as a raid1
disk, and the rest of the disk as a data area as whatever raid level
does the job?

This solution allows the for the replication of the first raid volume
from block zero for thus including the boot loader with /boot (assuming
that the superblock is at the end of the disk), and raid 4|5|6|10 for
the rest of the disk.  And we shouldn't actually need a partition table
at all anywhere if the data volume is overlaid with lvm, and the
bootloader will work regardless of whether it knows about raid.

And best of all adding member disks becomes as simple as mdadm -add ...
which is what I really want.
 
-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

