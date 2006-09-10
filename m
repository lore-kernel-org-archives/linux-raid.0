From: Bodo Thiesen <bothie@gmx.de>
Subject: Re: proactive-raid-disk-replacement
Date: Sun, 10 Sep 2006 02:02:03 +0200
Message-ID: <20060910020203.27d26886@30_bodo.rupinet>
References: <45012E73.5040900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45012E73.5040900@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:

> > mdadm -Gb internal --bitmap-chunk=1024 /dev/md4
> > mdadm /dev/md4 -r /dev/sdh1
> > mdadm /dev/md4 -f /dev/sde1 -r /dev/sde1
> > mdadm --build /dev/md5 -ayes --level=1 --raid-devices=2 /dev/sde1 missing
> > mdadm /dev/md4 --re-add /dev/md5
> > mdadm /dev/md5 -a /dev/sdh1
> >
> > ... wait a few hours for md5 resync...
> 
> And here's the problem.  While new disk, sdh1, are resynced from
> old, probably failing disk sde1, chances are high that there will
> be an unreadable block on sde1.

So, we need a way, to feedback the redundancy from the raid5 to the raid1.

Here is a short 5 minute brainstorm I did, to check, wether it's possible to 
manage this, and I think, it is:

Requirements:
	Any Raid with parity of any kind needs to provide so called "vitual 
	block devices", which carry the same data, as the underlaying block 
	devices, which the array is composed of. If the underlaying block 
	device can't read a block, that block will be calculated from the 
	other raid disks and hence is still readable using the virtual block 
	device.

	e.g. having the disks sda1 .. sde1 in a raid5 means, the raid 
	provides not one new block device (e.g. /dev/md4 as in the example 
	above), but six (the one just mentioned and maybe we call them 
	/dev/vsda1 .. /dev/vsde1 or /dev/mapper/vsda1 .. /dev/mapper/vsde1
	or even /dev/mapper/virtual/sda1 .. /dev/mapper/virtual/sde1). For 
	ease, I'll call them just vsdx1 here.
	
	Reading any block from vsda1 will yield the same data as reading 
	from sda1 at any time (except the case, that reading from sda1 
	fails, then vsda1 will still carry that data).

Now, construct the following nested raid structure:

	sda1 + vsda1 + missing = /dev/md10 RAID1 w/o super block
	sdb1 + vsdb1 + missing = /dev/md11 RAID1 w/o super block
	sdc1 + vsdc1 + missing = /dev/md12 RAID1 w/o super block
	sdd1 + vsdd1 + missing = /dev/md13 RAID1 w/o super block
	sde1 + vsde1 + missing = /dev/md14 RAID1 w/o super block

	md10 + md11 + md12 + md13 + md14 = /dev/md4 RAID5 optionally with sb

Problem:

	As long as md4 is not active, vsdx1 is not available. So the arrays 
	md1x need to be created with 1 disk out of 3. After md4 was 
	assembled, vsdx1 needs to be added. Now we get another problem: 
	There must be no sync between sdx1 and vsdx1 (they are more or less 
	the same device). So there should be an option to mdadm like 
	--assume-sync for hot-add.

What we get:

	As soon as we decide to replace a disk (like sde1 as above) we just 
	hot-add sdh1 to the sde1-raid1 array. That array will start 
	resyncing. If now a block can't be read from sde1, it's just taken 
	from vsde1 (and there that block will be reconstructed from the 
	raid5).
	
	After syncing to sdh1 was completed, sde1 may be removed from the 
	array.

We would loose redundancy at no time - the only lost redundancy is those of 
the already failed sde1 which we can't workaround anyways (except for using 
raid6 etc.).

This is only a brainstorm, and I don't know what internal effects could 
cause problems, like the resyncing process of the raid1 array reading a bad 
block from sde1 then triggering a reconstruction using vsde1 if in parallel 
the raid5 itself detects (e.g. as cause from a user space read) sde1 to have 
failed and tries to write back that block to the raid array for sde1 while 
in the raid1 the same rewrite is pending already ... problems over problems, 
but the evil is in detail as ever ...

Regards, Bodo
