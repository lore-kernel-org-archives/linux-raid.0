From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10 performance question
Date: Tue, 25 Dec 2007 19:08:15 +0000
Message-ID: <18289.21791.151719.625145@base.ty.sabi.co.UK>
References: <cccedfc60712230626t2db70cfcl5b0b49390cd6e609@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60712230626t2db70cfcl5b0b49390cd6e609@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sun, 23 Dec 2007 08:26:55 -0600, "Jon Nelson"
>>> <jnelson-linux-raid@jamponi.net> said:

> I've found in some tests that raid10,f2 gives me the best I/O
> of any raid5 or raid10 format.

Mostly, depending on type of workload. Anyhow in general most
forms of RAID10 are cool, and handle disk losses better and so
on.

> However, the performance of raid10,o2 and raid10,n2 in
> degraded mode is nearly identical to the non-degraded mode
> performance (for me, this hovers around 100MB/s).

You don't say how many drives you got, but may suggest that your
array transfers are limited by the PCI host bus speed.

> raid10,f2 has degraded mode performance, writing, that is
> indistinguishable from it's non-degraded mode performance

> It's the raid10,f2 *read* performance in degraded mode that is
> strange - I get almost exactly 50% of the non-degraded mode
> read performance. Why is that?

Well, the best description I found of the odd Linux RAID10 modes
is here:

  http://en.Wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

The key here is:

   "The driver also supports a "far" layout where all the drives
    are divided into f sections."

Now when there are two sections as in 'f2', each block will be
written to a block in the first half of the first disk and to
the second half of the "next" disk.

Consider this layout for the first 4 blocks on 2x2 layout
compared to the standard layout:

   DISK		 DISK
  A B C D       A B C D

  1 2 3 4	1 1 2 2
  . . . .	3 3 4 4
  . . . .
  . . . .
  -------
  4 1 2 3       
  . . . .
  . . . .
  . . . .


This means that with the far layout one can read blocks 1,2,3,4
at the same speed as a RAID0 on the outer cylinders of each
disk; but if one of the disks fails, the mirror blocks have to
be read from the inner cylinders of the next disk, which are
usually a lot slower than the outer ones.

Now, there is a very interesting detail here: one idea about
getting a fast array is to take make it out of large high
density drives and just use the outer cylinders of each drive,
thus at the same time having a much smaller range of arm travel
and higher transfer rates.

The 'f2' layout means that (until a drive fails) for all reads
and for "short" writes MD is effectively using just the outer
half of each drive, *as well as* what is effectively a RAID0
layout.

  Note that the sustained writing speed of 'f2' is going to be
  same *across the whole capacity* of the RAID. While the
  sustained write speed of a 'n2' layout will be higher at the
  beginning and slower at the end just like for a single disk.

Interesting, I hadn't realized that, even if I am keenly aware
of the non uniform speeds of disks across cylinders.
