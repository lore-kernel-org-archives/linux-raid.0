From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID10 Performance
Date: Wed, 2 Mar 2011 16:02:46 +0100
Message-ID: <slrnimsn0n.iq7.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <4D6E0813.1070903@cendio.se>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Aaron Sowry <aaron@cendio.se> wrote:
> 1) As I understand it, a RAID10 'near' configuration using two disks is
> essentially equivalent to a RAID1 configuration. Is this correct?

Yes.

> 2) Does md RAID1 support 'striped' reads? If not, is RAID1 read

No.

RAID1 stores it's data like:
disk1: ABCDEF
disk2: ABCDEF

You cannot stripe there. You can read A from disk1 and B from disk2, C
from disk1 etc. (and linux md does that - for bigger chunks: have a look
at read balancing), but you have to seek on both disks to skip the data
which has already been read from the other disk. And seeking on current
disks is approximately as fast or slow as reading for short distances.

> performance in any way related to the number of disks in the array?

Yes. The more disks you have in the array the more read()s can be served
parallel: One process can read A, another process can read C and both
reads can be served parallel without interfering each other. The more
disks you have the more reads can be served parallel.

> 3) From what I have read so far, a RAID10 'far' configuration on 2 disks
> provides increased read performance over an equivalent 'near'
> configuration, however I am struggling to understand exactly why. I
> understand the difference between the 'near' and 'far' configurations,
> but not *why* this should provide any speed increases. What am I missing?

See 2)
The 'far' configuration stores data in the first half of the disk like
RAID0:
disk1: ACE
disk2: BDF

Hence you can read the stream ABCDEF without seeking inbetween on any of
the disks.

> 4) I have performed a(n admittedly fairly basic) benchmark on the same
> system under two different configurations - RAID10,n2 and RAID10,f2
> using tiobench with default settings. In short, the results showed a
> significant speed increase for single-threaded sequential reads (83Mb/s
> vs 166MB/s),

... as one would expect.

> some increase for single-threaded random reads (1.85Mb/s vs
> 2.25Mb/s), but a decrease for every other metric, including
> multi-threaded sequential and random reads. I was expecting write

This does heavily depend on the size of the data you read and the chunk
size of the RAID10,f, and the location(s) of the data on disk.
Note: as you can see in 3) reading the stream ABCDEF utilizes two disks,
i.e. keeps them busy. What benefits a single process here will hurt
multiple processes: no other parallel reads can be served and reading
other data semi-parallel requires both disks to seek which decreases
performance.


regards
   Mario
-- 
There is nothing more deceptive than an obvious fact.
             -- Sherlock Holmes by Arthur Conan Doyle

