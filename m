From: pg@lxraid2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10 offset distance
Date: Fri, 27 Dec 2013 13:08:29 +0000
Message-ID: <21181.31693.202522.551426@tree.ty.sabi.co.uk>
References: <52BCE7E1.9050904@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52BCE7E1.9050904@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> md(4) hints that you can get sequential read performance near
> that of the far layout with the offset layout and a large
> chunk size.

Tradeoffs of course apply.

> That sounded nice and I thought that chunk size was just the
> number of stripes to write before the backup copy.  It turns
> out that "chunk size" is really just the stripe factor,

That's a rather peculiar choice of terminology, quite unlike
that used by the MD documentation. In particular in MD RAID1 in
the general case there is no "backup copy"; all replicas of a
given page have the same status. 'man 4 md' uses correctly the
term "multiple copies of a given chunk".

Perhaps only with '--write-mostly' one could think of a chunk
on the indicated device as being "backup copy".

> and so using a very large stripe factor hurts performance
> since even a relatively large IO doesn't span disks.

"performance" is a long word and perhaps should be used more
rarely... Large chunks may result in a lower *transfer rate* of
short non-streaming non-threaded IO, but benefit other types of
IO. I personally prefer smaller chunk in most cases, but I am
aware of the tradeoffs involved.

> Is there a way to keep a sane stripe factor, but have the
> offset copy stored further away to reduce seeking during
> sequential reads?

It is not clear to me what you are imagining here; with all
layouts each copy of a chunk are on different MD member devices
so "further away" sounds rather strange to me.

The difference between the layouts is the offsets where the
different copies are stored on each MD member device ('n': same,
'o2': a chunk, 'f2': half a disk). This makes a difference with
rotating disk devices that have very different transfer rates on
outer and inner tracks.

Whatever it is, there is no miraculous RAID10 layout that will
give both awesome read and write transfer rates or IOPS, each
layout comes with pretty sharp trsdeoffs between the various
aspects of the performance envelope.

There is an interesting section here:

  http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

with layout diagrams that might help you figure out what is
possible and what the tradeoffs area.
