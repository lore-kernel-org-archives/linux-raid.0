From: Matt Garman <matthew.garman@gmail.com>
Subject: sequential versus random I/O
Date: Wed, 29 Jan 2014 11:23:03 -0600
Message-ID: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is arguably off-topic for this list, but hopefully it's relevant
enough that no one gets upset...

I have a conceptual question regarding "sequential" versus "random"
I/O, reads in particular.

Say I have a simple case: one disk and exactly one program reading one
big file off the disk.  Clearly, that's a sequential read operation.
(And I assume that's basically a description of a sequential read disk
benchmark program.)

Now I have one disk with two large files on it.  By "large" I mean the
files are at least 2x bigger than any disk cache or system RAM, i.e.
for the sake of argument, ignore caching in the system.  I have
exactly two programs running, and each program constantly reads and
re-reads one of those two big files.

From the programs' perspective, this is clearly a sequential read.
But from the disk's perspective, it to me looks at least somewhat like
random I/O: for a spinning disk, the head will presumably be jumping
around quite a bit to fulfill both requests at the same time.

And then generalize that second example: one disk, one filesystem,
with some arbitrary number of large files, and an arbitrary number of
running programs, all doing sequential reads of the files.  Again,
looking at each program in isolation, it's a sequential read request.
But at the system level, all those programs in aggregate present more
of a random read I/O load... right?

So if a storage system (individual disk, RAID, NAS appliance, etc)
advertises X MB/s sequential read, that X is only meaningful if there
is exactly one reader.  Obviously I can't run two sequential read
benchmarks in parallel and expect to get the same result as running
one benchmark in isolation.  I would expect the two parallel
benchmarks to report roughly 1/2 the performance of the single
instance.  And as more benchmarks are run in parallel, I would expect
the performance report to eventually look like the result of a random
read benchmark.

The motivation from this question comes from my use case, which is
similar to running a bunch of sequential read benchmarks in parallel.
In particular, we have a big NFS server that houses a collection of
large files (average ~400 MB).  The server is read-only mounted by
dozens of compute nodes.  Each compute node in turn runs dozens of
processes that continually re-read those big files.  Generally
speaking, should the NFS server (including RAID subsystem) be tuned
for sequential I/O or random I/O?

Furthermore, how does this differ (if at all) between spinning drives
and SSDs?  For simplicity, assume a spinning drive and an SSD
advertise the same sequential read throughput.  (I know this is a
stretch, but assume the advertising is honest and accurate.)  The
difference, though, is that the spinning disk can do 200 IOPS, but the
SSD can do 10,000 IOPS... intuitively, it seems like the SSD ought to
have the edge in my multi-consumer example.  But, is my intuition
correct?  And if so, how can I quantify how much better the SSD is?

Thanks,
Matt
