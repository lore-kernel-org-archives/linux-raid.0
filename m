From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: RAID1 Mirroring question.
Date: Tue, 6 Apr 2004 09:16:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <FA095C015271B64E99B197937712FD020B02A5@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> afaikt, MD raid1 assumes that any data-corrupting errors are reported.
> if the device corrupts data and lies to the driver/kernel/md, then you
> are in trouble.  this applies to both reads and writes.
> 
> it's easy to imagine a ckraid1 tool that somehow forces reads of all
> copies of each block. but with two mirrors, there would presumably
> be no way to decide which to use...
> 
> all that said, I've never seen this happen.

Unfortunately, I've seen things like this not just but quite a few
times: Sometimes it seems to happen that over time sectors on a harddisk
can become unreadable. As long as  you don't actually access that sector
there's no way to detect this kind of failure.

Later, either a read/write error or an unclean shutdown causes the OTHER
disk to be kicked out of a raid array. Now, during resync, the bad
sector is noticed and causes the resync to fail. Recovery from this
situation is fairly aggravating.

A chraid functuon / tool would greatly help by detecting faild / bad
sectors while there still is a good copy of those sectors available.

> then again, raid1 is a sort of ugly niche feature, IMO.  how many 
> systems can afford two but not three disks?  raid5 is not scary!

Urr, I don't agree at all here: If you've got lots of small random
writes (in practice: a database) raid 5 performance really sucks, raid1
is much better here.

Also, 3 disks may not be physically feasible in all configurations. 

Bye, Martin

