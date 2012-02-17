From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 17 Feb 2012 19:30:49 +0000
Message-ID: <20286.43753.55416.715662@tree.ty.sabi.co.UK>
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
	<4F3E6ADB.2040005@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3E6ADB.2040005@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> To my mind, stripe width applies to reads and writes.  For
> reads, it is the number of spindles that are used in parallel
> while reading larger blocks of data.  For writes, it is in
> addition the width of a parity stripe for raid5 or raid6.

In the XFS case that's completely wrong, and irrelevant: in the
XFS case it is the number of sectors/blocks that IO has to be
_aligned_ to avoid read-modify-write, if there is the risk for
that.

The stripe width per se matters less than aligned writes as to
avoiding read-modify-write impact: if one does IO in stripe
width units but they are not aligned, performance will be
terrible as double read-modify-write will not be prevented.

What is the stripe width does not matter to applications like a
filesystem other than for read-modify-write avoidance because
how many sectors/blocks are/can be read in parallel depends
primarily on application access patterns, and secondarily on how
good is the IO subsystem scheduling.

> [ ... ] Some filesystems care a /little/ about stripe width in
> that they align certain structures to stripe boundaries to
> make accesses more efficient.

That in the case where read-modify-write cannot happen, if
read-modify write can happen, unaligned or non-full-width writes
are very costly, and not just for arrays; it happens in RAM too,
and for 4KiB physical sector drives simulating 512B logical
sectors.
