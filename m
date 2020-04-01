From: pg@mdraid.list.sabi.co.UK (Peter Grandi)
Subject: Re: mdcheck: slow system issues
Date: Wed, 1 Apr 2020 20:50:03 +0100
Message-ID: <24196.61547.646152.522241@base.ty.sabi.co.uk>
References: <2933dddc-8728-51ac-1c60-8a47874966e4@molgen.mpg.de>
        <24195.8467.378436.7747@base.ty.sabi.co.uk>
        <dbbd010e-3648-c72c-ce44-ed570f6eb8be@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dbbd010e-3648-c72c-ce44-ed570f6eb8be@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> Unsurprisingly it is a 16-wide RAID6 of 8TB HDDs.

> With a 512k chunk.  Definitely not suitable for anything but
> large media file streaming. [...] The random/streaming
> threshold is proportional to the address stride on one
> device--the raid sector number gap between one chunk and the
> next chunk on that (approximately). [...] I configure any
> raid6 that might have some random loads with a 16k or 32k
> chunk size.

That is actually rather controversial: I have read both
arguments like this and the opposite argument that sequential
performance is much better with small chunk sizes because then
sequential access is striped:

* Consider a 512KiB chunk size with 64KiB reads: 8 successive
  reads will be sequentially from the same disk, so top speed
  will be that of a single disk.

* Consider a 16KiB chunk size with 4 data disks with 64KiB
  reads: each read will be spread in parallel over all 4 disks.

The rationale for large chunk sizes is that it minimizes time
wasted on rotational latency: if reading 64KiB from 4 drives
with a 16KiB chunk size, the 64KiB block will only become
available when all four chunks have finished reading, and
because in most RAID types the drives are not synchronized, on
average each chunk will be at a different rotational position,
potentially one full rotation apart, but often half a rotation
apart, that is each read will have an overhead of 8ms of extra
rotational latency, and that's pretty huge. Some more detailed
discussion here:

  http://www.sabi.co.uk/blog/12-thr.html?120310#120310

Multihreading, block device read-ahead, various types of
alternative RAID layouts etc.  complicate things, and in some
small experiments I have done over the years results were
inconclusive, except that really large chunk sizes seemed worse
than smaller ones.

> Finally, the stripe cache size should be optimized on the
> system in question.  More is generally better, unless it
> starves the OS of buffers.

Indeed the stripe cache size matters a great deal to a 16-wide
RAID6, and that's a good point, but it is secondary to the
storage system having designed for high latency during mixed
read-write workloads with even a minimal degree of "random"
access or multithreading.

As to other secondary palliatives, the "unable to open files in
a reasonable time" case often can be made less bad in two other
ways:

* Often the (terrible) Linux block layer has default settings
  that result in enormous amounts of unsynced data in memory,
  and when that eventually is synced to disk, it can create huge
  congestion. This can also happen with hw RAID host adapters
  with onboard caches (in many cases very badly managed by their
  firmware).

* The default disk schedulers (in particular 'cfq') tend to
  prefer reads to writes, and this can result in large delays
  especially if 'atime' if set impacting 'open's, or 'mtime' on
  directories when 'creat'ing files. Using 'deadline' with
  tighter settings for "write_expire" and/or "writes_starved"
  might help.

But nothing other than a simple, quick replacement of the
storage system can work around a storage system designed to
minimize the IOPS-per-TB rate below the combined requirements of
the workload of 'mdcheck' (or backup) and the live workloads.
