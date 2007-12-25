From: <pg_mh@mh.to.sabi.co.UK>
Subject: Re: Raid over 48 disks
Date: Tue, 25 Dec 2007 17:31:50 +0000
Message-ID: <18289.16006.856691.862471@base.ty.sabi.co.UK>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com>
	<18280.11620.381726.737353@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
In-Reply-To: <18280.11620.381726.737353@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Wed, 19 Dec 2007 07:28:20 +1100, Neil Brown
>>> <neilb@suse.de> said:

[ ... what to do with 48 drive Sun Thumpers ... ]

neilb> I wouldn't create a raid5 or raid6 on all 48 devices.
neilb> RAID5 only survives a single device failure and with that
neilb> many devices, the chance of a second failure before you
neilb> recover becomes appreciable.

That's just one of the many problems, other are:

* If a drive fails, rebuild traffic is going to hit hard, with
  reading in parallel 47 blocks to compute a new 48th.

* With a parity strip length of 48 it will be that much harder
  to avoid read-modify before write, as it will be avoidable
  only for writes of at least 48 blocks aligned on 48 block
  boundaries. And reading 47 blocks to write one is going to be
  quite painful.

[ ... ]

neilb> RAID10 would be a good option if you are happy wit 24
neilb> drives worth of space. [ ... ]

That sounds like the only feasible option (except for the 3
drive case in most cases). Parity RAID does not scale much
beyond 3-4 drives.

neilb> Alternately, 8 6drive RAID5s or 6 8raid RAID6s, and use
neilb> RAID0 to combine them together. This would give you
neilb> adequate reliability and performance and still a large
neilb> amount of storage space.

That sounds optimistic to me: the reason to do a RAID50 of
8x(5+1) can only be to have a single filesystem, else one could
have 8 distinct filesystems each with a subtree of the whole.
With a single filesystem the failure of any one of the 8 RAID5
components of the RAID0 will cause the loss of the whole lot.

So in the 47+1 case a loss of any two drives would lead to
complete loss; in the 8x(5+1) case only a loss of two drives in
the same RAID5 will.

It does not sound like a great improvement to me (especially
considering the thoroughly inane practice of building arrays out
of disks of the same make and model taken out of the same box).

There are also modest improvements in the RMW strip size and in
the cost of a rebuild after a single drive loss. Probably the
reduction in the RMW strip size is the best improvement.

Anyhow, let's assume 0.5TB drives; with a 47+1 we get a single
23.5TB filesystem, and with 8*(5+1) we get a 20TB filesystem.
With current filesystem technology either size is worrying, for
example as to time needed for an 'fsck'.

In practice RAID5 beyond 3-4 drives seems only useful for almost
read-only filesystems where restoring from backups is quick and
easy, never mind the 47+1 case or the 8x(5+1) one, and I think
that giving some credit even to the latter arrangement is not
quite right...
