From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: LVM performance
Date: Fri, 7 Mar 2008 08:14:24 +0000
Message-ID: <18384.63840.605334.155518@tree.ty.sabi.co.UK>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
	<20080217074526.29d3c5c5@hardcode42.net>
	<20080218062604.05ae4821@szpak>
	<aebf5d970802180438w7a4d40ban3f66ee1dbc38d259@mail.gmail.com>
	<20080218154203.6e2d1483@szpak>
	<47BB30DF.1080006@student.tuwien.ac.at>
	<18364.6868.854623.613958@tree.ty.sabi.co.UK>
	<47BED119.4070000@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47BED119.4070000@student.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ .... ]

Sorry forn the long delay in replying...

om> $ hdparm -t /dev/md0

om> /dev/md0:
om>   Timing buffered disk reads:  148 MB in  3.01 seconds =  49.13 MB/sec

om> $ hdparm -t /dev/dm-0

om> /dev/dm-0:
om>   Timing buffered disk reads:  116 MB in  3.04 seconds = 38.20 MB/sec

om> [ ... ] but right now, I only have 500GB drives. [ ... ]

pg> Those are as such not very meaningful. What matters most is
pg> whether the starting physical address of each logical volume
pg> extent is stripe aligned (and whether the filesystem makes use
pg> of that) and then the stripe size of the parity RAID set, not
pg> the chunk sizes in themselves. [ ... ]

om> Am I right to assume that stripe alignment matters because
om> of the read-modify-write cycle needed for unaligned writes?

Sure, if you are writing as you say later. Note also that I was
commenting on the points made about chunk size and alignment:

  jk> [ ... ] This might be related to raid chunk positioning with
  jk> respect to LVM chunk positioning. If they interfere there
  jk> indeed may be some performance drop. Best to make sure that
  jk> those chunks are aligned together. [ ... ]

  om> I'm seeing a 20% performance drop too, with default RAID
  om> and LVM chunk sizes of 64K and 4M, respectively. Since 64K
  om> divides 4M evenly, I'd think there shouldn't be such a big
  om> performance penalty.

As I said, if there is an issue with "interference", it is about
stripes, not chunks, and both alignment and size, not just size.

But in your case as you point out the issue is not with that,
because when reading a RAID5 behaves like a slightly smaller
RAID0, as you point out, so the cause is different:

om> If so, how come a pure read benchmark (hdparm -t or plain
om> dd) is slower on the LVM device than on the md device?

Ahhh because the benchmark you are doing is not very meaningful
either, not just the speculation about chunk sizes.

Reading from the outer tracks of a RAID5 2+1 on contemporary
500GB drives should give you at least 100-120MB/s (as if it were
a 2x RAID0), and the numbers that you are reporting above seem
meaningless for a comparison between MD and DM, because there
must be something else that makes them both perform very badly.

Odds are that your test was afflicted by the page cache
read-ahead horror that several people have reported, and that I
have investigated in detail in a recent posting to this list,
with the conclusion that it is a particularly grave flaw in the
design and implementation of Linux IO.

Since the horror comes from poor scheduling of streaming read
sequences, there is wide variability among tests using the same
setup, and most likely DM and MD have a slightly different
interaction with the page cache.

PS: maybe you are getting 40-50MB/s only because of some other
    reason, e.g. a slow host adapter or host bus, but whatever
    it is, it results in an improper comparison between DM and
    MD.
