From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: sequential versus random I/O
Date: Wed, 29 Jan 2014 22:41:09 -0200
Message-ID: <CAH3kUhHM-dKXX3z2mo-512=ZL52AM_F547h58nsWRe7LogwbNA@mail.gmail.com>
References: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BbRMXvwwbVvstGPUV7xQpVBqVXLNvTHhYf_wv8=Ws9uw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2014-01-29 Matt Garman <matthew.garman@gmail.com>:
> This is arguably off-topic for this list, but hopefully it's relevant
> enough that no one gets upset...
>
> I have a conceptual question regarding "sequential" versus "random"
> I/O, reads in particular.
>
> Say I have a simple case: one disk and exactly one program reading one
> big file off the disk.  Clearly, that's a sequential read operation.
> (And I assume that's basically a description of a sequential read disk
> benchmark program.)

no, if forgot that kernel is "another program", and filesystem is
"another program" too
if your 'exactly one program' read and write to block device, you will
get "exactly" only one program using disk (ok your program and linux
kernel...)

some filesystem can divide a file in many parts and fragment, but
considering that disk is new and clean many filesystem will not
fragment


>
> Now I have one disk with two large files on it.  By "large" I mean the
> files are at least 2x bigger than any disk cache or system RAM, i.e.
> for the sake of argument, ignore caching in the system.  I have
> exactly two programs running, and each program constantly reads and
> re-reads one of those two big files.

ok i will not forget that it's over a filesystem, since you have two
large 'files'

>
> From the programs' perspective, this is clearly a sequential read.
> But from the disk's perspective, it to me looks at least somewhat like
> random I/O: for a spinning disk, the head will presumably be jumping
> around quite a bit to fulfill both requests at the same time.

hum, you must check the linux i/o scheduler
http://en.wikipedia.org/wiki/I/O_scheduling
this can do a very very nice job :)

the random and the continous is a block device feature, i don't know
if i'm wrong but, filesystem send command to block device, and block
devices group it and 'create' disk commands to get data, a level down,
you have sata/scsi and others protocols that contact block device i/o
and tell about hardware errors and others stuffs
i'm a bit old in source code of linux, but if you check read balance
function of raid1, you will see an example of how continous read is
considered
read balance try to send continous read to same disk, this speed up a
lot, leaving more disks to other tasks/thread/programs/etc

>
> And then generalize that second example: one disk, one filesystem,
> with some arbitrary number of large files, and an arbitrary number of
> running programs, all doing sequential reads of the files.  Again,
> looking at each program in isolation, it's a sequential read request.
> But at the system level, all those programs in aggregate present more
> of a random read I/O load... right?

hum, block device do this, check scheduler/elevators again, there's a
time gap between hard disks command, even "noop" scheduler(elevator)
wait a bit to send continous reads more often

>
> So if a storage system (individual disk, RAID, NAS appliance, etc)
> advertises X MB/s sequential read, that X is only meaningful if there
> is exactly one reader.
the read speed is the "super pro master top ultrablaster" speed you
can read a disk without cache and with a good sas/scsi/sata card

> Obviously I can't run two sequential read
> benchmarks in parallel and expect to get the same result as running
> one benchmark in isolation.

yes :)

> I would expect the two parallel
> benchmarks to report roughly 1/2 the performance of the single
> instance.  And as more benchmarks are run in parallel, I would expect
> the performance report to eventually look like the result of a random
> read benchmark.

hum... you forgot elevators, the 1/2 could be more or less, and
sometimes 1/n where n=number of tests, isn't a good math, there's more
things we could forget (cache, bus problems, disk problems, irq
problems, dma problems, etc)

>
> The motivation from this question comes from my use case, which is
> similar to running a bunch of sequential read benchmarks in parallel.
> In particular, we have a big NFS server that houses a collection of
> large files (average ~400 MB).  The server is read-only mounted by
> dozens of compute nodes.  Each compute node in turn runs dozens of
> processes that continually re-read those big files.  Generally
> speaking, should the NFS server (including RAID subsystem) be tuned
> for sequential I/O or random I/O?
hum, when i have many thread, i use raid1, i only use raid0 or other
stripe/linear solution when i have only big files (like a dvr) this
give a better speed than raid1 in some cases (but you should check
yourself)
another nice feature is hardware raid cards with cache (flash memory),
this do a nice cache job

>
> Furthermore, how does this differ (if at all) between spinning drives
> and SSDs?  For simplicity, assume a spinning drive and an SSD
> advertise the same sequential read throughput.  (I know this is a
> stretch, but assume the advertising is honest and accurate.)  The
> difference, though, is that the spinning disk can do 200 IOPS, but the
> SSD can do 10,000 IOPS... intuitively, it seems like the SSD ought to
> have the edge in my multi-consumer example.  But, is my intuition
> correct?  And if so, how can I quantify how much better the SSD is?

hummm if your problem is cost, consider using ssd as a cache, and hdd
as main storage, this kind of setup facebook use a lot check bcache,
flashcache, dmcache:
https://github.com/facebook/flashcache/
http://en.wikipedia.org/wiki/Bcache
http://en.wikipedia.org/wiki/Dm-cache


>
> Thanks,
> Matt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

:)

-- 
Roberto Spadim
