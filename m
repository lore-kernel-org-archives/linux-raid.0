From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Serious performance issues with mdadm RAID-5 partition exported through LIO (iSCSI)
Date: Tue, 18 Sep 2012 21:06:15 +0100
Message-ID: <20568.54327.717927.127094@tree.ty.sabi.co.UK>
References: <50588731.5050502@bananateam.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50588731.5050502@bananateam.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> I noticed in iostat something I personally find very weird.
> All the disks in the RAID set (minus the spare) seem to read
> 6-7 times as much as they write. Since there is no other I/O
> (so there aren't really any reads issued besides some very
> occasional overhead for NTFS perhaps once in a while) I find
> this really weird. Note also that iostat doesn't show the
> reads in iostat on the md device (which is the case if the
> initiator issues reads) but only on the active disks in the
> RAID set, which to me (unknowingly as I am :)) indicates mdadm
> in the kernel is issuing those reads. [ ... ]

It is not at all weird. The performance of MD ('mdadm' is just
the user level tool to configure it) is pretty good in this case
even if the speed is pretty low. MD is working as expected when
read-modify-write (or some kind of resync or degraded operation)
is occurring. BTW I like your use of the term "RAID set" because
that's what I use myself (because "RAID array" is redundant
:->).

Apparently awareness of the effects of RMW )or resyncing or
degraded operation) is sort of (euphemism) unspecial RAID
knowledge, but only the very elite of sysadms seem to be aware
of it :-). A recent similar enquiry was the (euphemism) strange
concern about dire speed by someone who had (euphemism) bravely
setup RAID6 running deliberately in degraded mode.

My usual refrain is: if you don't know better, never use parity
RAID, only use RAID1 or RAID10 (if you want redundancy).

But while the performance of MD you report is good, the speed is
bad even for a mere RMW/resync/degraded issue, so this detail
matters:

> Do note - I'm running somewhat unorthodox. I've created a
> RAID-5 of 7 disks + hotspare

One could (euphemism) wonder how well a 6x stripe/stripelet size
is going to play with 4KiB aligned NTFS operations...

> (it was originally a RAID-6 w/o hotspare but converted it to
> RAID-5 in hopes of improving performance).

A rather (euphemism) audacious operation, especially because of
the expectation that reshaping a RAID set leaves the content in
an optimal stripe layout. I am guessing that you reshaped rather
than recreated because you did not want to dump/reload the
content, rather (euphemism) optimistically.

There are likely to be other (euphemism) peculiarities in your
setup, probably to do with network flow control, but the above
seems enough...

Sometimes it is difficult for me to find sufficiently mild yet
suggestive euphemisms to describe some of the stuff that gets
reported here. This is one of those cases.

Unless you are absolutely sure you know better:

* Never grow or reshape a RAID set or a filetree.
* Just use RAID1 or RAID10 (or a 3 member RAID5 in some cases
  where writes are rare).
* Don't partition the member or array devices or use GPT for
  both if you must.

If you are absolutely sure you know better then you will not
need to ask for help here :-).

> This disk is about 12TB. It's partitioned with GPT in ~9TB

At least you used GPT partitioning, which is commendable, even
if you regret it below...

> and ~2.5TB (there's huge rounding differences at these sizes
> 1000 vs 1024et al :)).

It is very nearly 5%/7% depending which way.

> With msdos partitions I could easily mess with it myself. [
> ... ]

MSDOS style labels are fraught with subtle problem that require
careful handling.

[ ... ]
