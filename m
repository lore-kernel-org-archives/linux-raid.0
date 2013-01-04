From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Fri, 4 Jan 2013 23:43:14 +0000
Message-ID: <20711.26898.420204.483371@tree.ty.sabi.co.UK>
References: <20130104175458.GA3298@hellgate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130104175458.GA3298@hellgate>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> md124 : active raid10 sdg3[6] sdd3[0] sda3[7] sdh3[3] sdf3[2] sde3[1]
>       1914200064 blocks super 1.2 512K chunks 3 far-copies [6/6] [UUUUUU]
>       bitmap: 4/15 pages [16KB], 65536KB chunk

> [ ... ] writes blocks of 128k or less, using multiple threads,
> pretty randomly (but reads dominate, hence far-copies; large
> sequential reads are relatively frequent). I wonder whether
> re-creating the array with a chunksize of 128k (or maybe even
> just 64k) could be expected to improve write performance.

This is an amazingly underreported context in which to ask such
a loaded yet vague question.

It is one of the usual absurdist "contributions" to this mailing
list, even if not as comically misconceived as many others.

You have a complicated workload, with entirely different access
profiles at different times, on who-knows-what disks, host
adapter, memory, CPU, and you are not even reporting what is the
current "performance" that should be improved.

Nor even saying what "performance" matters (bandwidth or latency
or transactions/s? average or maximum? caches enabled? ...).

Never mind that rotating disks have rather different transfer
rates outer/inner tracks, something that can mean very different
tradeoffs depending on where the data lands. What about the
filesystem and the chances that large transactions happen on
logically contiguous block device sectors?

Just asking such a question is ridiculous.

The only way you are going to get something vaguely sensible is
to run the same load on two identical configurations with
different chunk sizes, and even that won't help you a lot if
your workload is rather variable, as it is very likely to be.

> I assume the RAID10 implementation doesn't read-modify-write
> if writes are not aligned to chunk boundaries, does it?

If you have to assume this, instead of knowing it, you shouldn't
ask absurd questions about complicated workloads and the fine
points of chunk sizes.

> I understand that small chunksizes favour single-threaded
> sequential workloads (because all disks can read/write
> simultaneously, thus adding their bandwidth together), whereas
> large(r) chunksizes favour multi-threaded random access
> (because a single disk may be enough to serve each request,
> while the other disks serve other requests).

That's a very peculiar way of looking at it.

Assuming that we are not talking about hw synchronized drives,
as in RAID3 variants, the main issue with chunk size is that
every IO large enough to involve more than one disk can incur
massive latency from the disks not being at the same rotational
position at the same time, and the worst case is that the IO
takes a full disks rotation to complete, if completion matters.

For example on a RAID0 of 2 disks capable of 7200RPM or 120RPS,
a transfer of 2x512B sectors can take 8 milliseconds, delivering
around 120KiB/s of throughput, thanks to an 8ms latency every
1KiB.

In case of _streaming_, with read ahead or write behind, with
very good elevator algorithms, the latency due to the disks
rotating independently can be somewhat hidden, and large chunk
size obviously helps.

Conversely with a mostly random workload larger chunk size can
restrict the maximum amount of parallelism, as the reduced
interleaving *may* result in a higher chance that accesses from
two threads will hit the same disk and thus the same disk arm.

Also note that chunk size does not matter for each RAID1 "pair"
in the RAID10, as there are no chunks, and for _reading_ the two
disks are fully uncoupled, while for writing they are fully
coupled. The chunk size that matters is solely that of the RAID0
"on top" of the RAID1 pairs, and that perhaps in many situations
does not matter a lot.

It is really complicated...

My usual refrain is to tell people who don't get most of the
subtle details of storage to just use RAID10 and not to worry
too much, because RAID0 works well in almost every case, and if
they have "performance" problems add more disks; usually as more
pairs (rather than turning 2-disk RAID1s into 3-disk RAID1s,
which can also be a good idea in several cases), as the number
of arms and thus IOPS per TB of *used* capacity often is a big
issue, as most storage "experts" eventually should figure out.

In this case the only vague details as to "performance" goals
are for writes of largish-block random multithreaded access, and
more pairs seems the first thing to consider, as the setup has
only got 3 pairs totaling something around 300-400 random IOPS,
or with 128kiB writes probably overall write rates of 30-40MB/s
even not considering the sequential read interference. Doubling
the number of pairs is probably something to start with.

So choosing RAID10 was a good idea, asking yourself whether
vaguely undefined "performance" can be positively affected by
some subtle detail of tuning is not.

Note:

  Long ago I used to prefer small chunk sizes (like 16KiB), but
  the sequential speed of disks has improved a lot in the
  meantime, while the rotational one(s) have been pretty much
  constant for decades once 3600RPM disks stopped being
  designed.

  To make a very crude argument, assuming a common 7200RPM disk,
  with a full rotation every 8ms, and presumably an average
  offset among the disks of half a rotation or 4ms, ideally the
  amount read or written in one go should be at least as such as
  can be read or written in 4ms across all disks.

  On a 10MB/s disk of several years ago one half rotation time
  means 40KB, on a 100MB/s disks that becomes 400KB, and the
  goal is ideally to minimize the time spent waiting for all the
  disks to complete their work which begins the same 4ms apart,
  so larger chunk sizes probably help, even if they may reduce
  the degree of multihreading available, and the contemporary
  disks that can do 100MB tend to be much bigger than the old
  disks that could do 10MB/s but they have got only one arm.

  But with a small chunk size largish IO transactions will involve
  as a rule contiguous chunks (if the filesystem is suitable), and
  suitable elevators can still turn a 1MiB IO to 4 disks in much
  the same pattern of transfers whether the chunk size if 16KiB or
  128KiB, as in the end on each disk one has to transfer 256KiB of
  physically contiguous sectors.

  Yes, it is complicated.
