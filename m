From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Sat, 18 Feb 2012 17:09:11 +0000
Message-ID: <20287.56119.827444.504884@tree.ty.sabi.co.UK>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com>
	<4F35E925.6000003@hardwarefreak.com>
	<CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com>
	<4F38FD5D.1010201@hardwarefreak.com>
	<CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
	<20120213230228.GA5822@www5.open-std.org>
	<4F39D9B2.3050305@hardwarefreak.com>
	<20120214113832.GA6157@www5.open-std.org>
	<4F3AEDEF.2000608@hardwarefreak.com>
	<20120215083058.GA8821@cthulhu.home.robinhill.me.uk>
	<4F3BB385.4000608@hardwarefreak.com>
	<4F3BD1F6.8080309@westcontrol.com>
	<4F3E5325.3060001@hardwarefreak.com>
	<20286.42115.949782.471398@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20286.42115.949782.471398@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> [ ... ] XFS write stripe alignment should be for a 7 disk
>> mdraid10 near layout array.

> [ ... ] stripe alignment matters ONLY AND SOLELY IF
> READ-MODIFY-WRITE is involved, and RADI10 never requires
> read-modify-write.

>> Do note that stripe width is specific to writes.  It has
>> nothing to do with reads, from the filesystem perspective
>> anyway. For internal array operations it will.

> Again, stripe alignment only matters for writes ONLY AND SOLELY
> IF READ-MODIFY-WRITE is involved. This never happens for RAID0,
> RAID1 or RAID10, because there is no parity to update; chunks
> within a stripe are wholly independent of each other.

There is a subtlety here... and at times I am excessively precise
in my wording :-) but also because it matters.

XFS requires specifying stripe geometry as 'su'/'sunit' which is
the MD chunk size, and as 'sw'/'swidth' which is the logical
stripe size, and similarly for 'ext3' and 'ext4'.

The reason is that while the *stripe* alignment (and size) don't
matter if there is no risk of RMW in the underlying storage
system, with XFS like 'ext3' and 'ext4' the *chunk* alignment
(and size) matters in all cases where there is parallelism in the
underlying storage system; it matters for both reads and writes,
and on all RAID layouts.

Because then filesystem will try to allocate _metadata_ to be
chunk aligned, so that reading/writing metadata can take
advantage of the parallelism of the array. From 'man mke2fs':

  "stride=stride-size
    Configure the filesystem for a RAID array with stride-size
    filesystem blocks. This is the number of blocks read or
    written to disk before moving to the next disk, which is
    sometimes referred to as the chunk size.
    This mostly affects placement of filesystem meta-data like
    bitmaps at mke2fs time to avoid placing them on a single
    disk, which can hurt performance. It may also be used by
    the block allocator."

But note that this is a different discussion from one about
*stripes*, and IO from applications above the filesystem. This is
the filesystem as an application itself optimizing its own data
given a hint about device geometry.
