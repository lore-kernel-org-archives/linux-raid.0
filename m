From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 17 Feb 2012 19:03:31 +0000
Message-ID: <20286.42115.949782.471398@tree.ty.sabi.co.UK>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3E5325.3060001@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> Back to the original issue.  Coolcold and I were trying to
> figure out what the XFS write stripe alignment should be for a
> 7 disk mdraid10 near layout array. After multiple posts from
> David, Robin, and Keld attempting to 'educate' me WRT the
> mdraid driver read tricks which yield an "effective RAID0
> stripe", nobody has yet answered my question:

> What is the  stripe spindle width of a 7 drive mdraid near array?

As I have repeated many many many times to you in past XFS
discussions, and please take note, stripe alignment matters ONLY
AND SOLELY IF READ-MODIFY-WRITE is involved, and RADI10 never
requires read-modify-write.

> Do note that stripe width is specific to writes.  It has
> nothing to do with reads, from the filesystem perspective
> anyway. For internal array operations it will.

Again, stripe alignment only matters for writes ONLY AND SOLELY
IF READ-MODIFY-WRITE is involved. This never happens for RAID0,
RAID1 or RAID10, because there is no parity to update; chunks
within a stripe are wholly independent of each other.

Not all parity RAID involves read-modify-write either, for
example RAID2 and RAID3 (bit and byte parallel parity RAID under
the SNIA taxonomy) never do read-modify-write either, so stripe
alignment does not matter for those either. Note: this is
because RAID setups where the physical sector (bit or byte) is
smaller than the logical sector always do whole-stripe reads or
writes, which is a special case.

Disclaimer: using stripe alignment even when it is not required
may help a bit with scheduling, it being slightly akin to a
larger block size, but not quite, but that is a secondary
effect.
