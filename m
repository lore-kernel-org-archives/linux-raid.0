From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 10:42:30 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0211131012460.3877-100000@multivac.sdsc.edu>
References: <20021113122957.GE22407@unthought.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021113122957.GE22407@unthought.net>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jakob,

SNIP

> For a single reader/writer, it was pretty obvious from the above that
> "big is good" for reads (because of the fewer parity block skip seeks),
> and "small is good" for writes.
>
> So, by making a big chunk-sized array, and having it work on 4k
> sub-chunks for writes, was some idea I had which I felt would just give
> the best scenario in both cases.

Actually, the problem is worse than you describe.

Let's assume that we have a RAID-5 array of 5 disks, with a segment size
of 64KB.  In this instance, the optimum I/O size will be 256KB.
Furthermore, that will only be the optimum I/O when it is on a 256KB
boundary.

I have, in the past, performed I/O benchmarks on raw arrays (both using
the MD driver, and using 3Ware cards).  My results show that read speed
drops off when the segment size passes 128KB, but write speed stays stable
up to 2MB (the largest I/O size I tested).

This information, combined with the benchmarks you posted earlier, shows
that the write slowdown when writing large I/O sizes is caused by the
file-system structure.

Current Linux file-systems don't support block sizes larger than 4KB.
This means that even if you perform the optimum sized I/O, there is no
guarantee that the I/O will occur on the optimum boundary (it's actually
quite unlikely).  To make matters worse, there is no guarantee that when
you perform a large write, all the data will be placed in contiguous
blocks.

In order to maximize I/O throughput, it will be necessary to create a
Linux file-system that can effectively deal with large blocks (not
necessarily power of two in size).  The alternative would be to work with
the raw file-system, as many DBMS' do.

I have worked with a file-system structure that deals well with large
blocks, but it is not in the public domain, and I doubt that CRAY is
interested in porting the NC1FS structure to Linux.

				Peter Ashford

