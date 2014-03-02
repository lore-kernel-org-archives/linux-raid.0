From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: how to handle bad sectors in md control areas?
Date: Sun, 2 Mar 2014 13:25:53 +0000
Message-ID: <21267.12641.441629.980868@tree.ty.sabi.co.uk>
References: <530DA2DE.9030705@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530DA2DE.9030705@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> In another thread I investigated an issue with a pending
> sector, which now seems to be a bad sector [ ... ] The question
> now remaining: what is the correct approach to fixing this
> problem?

The correct approach is something like:

> The simple way that I see is to fail the member, remove it,
> [ ... ] and then add it.

Where the last "it" is a "known good" storage device.

> [ ... ] clear it (at least --zero-superblock and write to the
> bad sector) [ ... ]

Whether "write to the bad sector" effects a repair or not turning
a failed storage device into a "known good" one, and is dangerous
or not, is a matter of judgement, based on a large number of
factors, and the particulars of the situation leading to the error.

> However this will incur a full resync (about 10 hours).

If you have intentionally or not designed a RAID setup that has
very expensive resync, that's what you get, unless you can
guarantee that resync will never happen. Good luck! :-)

> Is there a faster, yet safe way?

Ah the eternal illusion that someone knows a "secret" way to do
things N times better than other people, at no cost of course.

For RAID, in the general case no. In some specific cases where
you know what you doing, including a deep understanding of both
RAID, MD RAID, and storage device error causes and handling,
perhaps there is.

> A bad sector in the data area should be fixed with a standard
> raid 'check' action.

That seems to me to be a fruit of your imagination; and that of
others, as I occasionally watch the usual threads, eagerly
"contributed" to by the usual clowns, about MD RAID "detecting"
errors and "repairing" bad sectors.

Let's repeat here for the Nth time: RAID is entirely based on the
assumption that the storage devices (disks, host adapters, buses,
...) below it are either entirely error free, or report every
error that occurs on them; that there are no undetected errors.

RAID is not required to perform any detection of errors
undetected by the underlying storage devices, and in the general
case is not able to do that either, as the RAID "levels" with
redundancy have that redundancy designed for reconstruction not
error detection, and even well design error detection is usually
very, very expensive.

Even more so, RAID cannot "fix" bad sectors, and it is not
designed to do so, because RAID subsystems are mere IO remappers
and multiplexers (IIRC NeilB sometimes reminds people of that),
and the way storage devices error happen and can be fixed is a
difficult subject that cannot be handled in the general case in a
general purpose RAID IO remapper and multiplexer.

MD RAID, as a side effect of its operation, merely does some weak
consistency checks and some weak attempts at making things
not-worse when errors are reported or inconsistencies are
discovered.

This is strictly speaking beyond its mission and a layering
nastiness, but while it is somewhat useful, it is very important
that remain a limited effort, because it is already very hard to
get an IO mapper and multiplexer to work reliably and with good
performance (tradeoff between speed and other qualities) in the
general case.

Writing and maintaining a *correct* RAID subsystem is difficult
enough, e.g. given the extreme cases of parallelism and timing
dependent issues it involves (and many proprietary RAID products
are nowhere as reliable as MD RAID, perhaps also because they try
to do too many things other than mapping and multiplexing IO).

Reliable, safe error detection is usually quite expensive as to
speed, and reliable, safe error correction is very difficult to
do because the code gets rarely exercised, and there are so many
subtle and tricky cases.

If you want an error detecting, error-correcting block device
abstraction layer, write one quite separate from MD RAID, or buy
one of several expensive proprietary efforts aimed at your
demographic.

Myself, like many users of RAID, and MD RAID, would rather MD to
remain a *reliable*, low overhead, IO remapper and multiplexer,
with code as simple as possible for ease of understanding and
maintenance, without "mission creep". The end-to-end argument
also applies here.
