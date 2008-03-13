From: Nat Makarevitch <nat@makarevitch.org>
Subject: Re: the '--setra 65536' mistery, analysis and WTF?
Date: Thu, 13 Mar 2008 13:02:33 +0000 (UTC)
Message-ID: <loom.20080313T114451-80@post.gmane.org>
References: <18382.54925.354731.996508@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Disclaimer: I may not be "familiar with the vagaries of the block subsystem and
of the MD RAID code" than you :-)

> * The 'dd' block size had really little influence on the outcome.

Is it the classic 'dd', doing purely 'classic' (read/write) blocking I/O?

> * A read-ahead up to 64 (32Kib) on the disk block device reading
>   the individual disk resulted in an increasing transfer rate,
>   and then the transfer rate reached the nominal top one for the
>   disk with 64.

The optimal value is very context-dependent. The disk-integrated cache size, for
example, is AFAIK not neglectable.

> * A read head unless 65536 on '/dev/md0' resulted in increasing
>   but erratic performance

The 'erratic' part of your stance seems weird to me. You use different disks
models, it may be part of an explanation

Are you sure that your RAID was fully built and not in 'degraded' mode (check
with mdadm -D /dev/RAIDDeviceName)?

> (the read-ahead on the individual
>   disks seemed not to matter when reading from '/dev/md0').

Same here

> * In both disk and '/dev/md0' cases I watched instantaneous
>   transfer rates woith 'vmstat 1' and 'watch iostat 1 2'.

Various disk internal-housekeeping processes may distort a too short benchmark.
Let it run for at least 60 seconds then calculate the average (dd and sdd can
help). Moreover invoke them via 'time' to check the CPU load. Any hint on
checking the bus load will be welcome!

>   I noticed that interrupts/s seemed exactly inversely
>   proportional to read ahead, with lots of interrupts/s for
>   small read-head, and few with large read-ahead.

This seems normal to me: interrupts only occur upon controller
work, they don't occur when the requested block is in the buffercache. With
enough read-ahead each disk-read nurtures the buffercache with many blocks,
therefore reducing the 'interrupt pressure'

>   When reading from the '/dev/md0' the load was usually spread
>   equally between the 8 array disks with 65536, but rather
>   unevenly with the smaller values.

Maybe because a smaller value forbids parallelization (reading a single stripe
is sufficient)

> * Most revealingly, when I used values of read ahead which were
>   powers of 10, the numbers of block/s reported by 'vmstat 1'
>   was also a multiple of that power of 10.

Some weird assessments led me to think that vmstat may be somewhat inadequate

> * Quite astonishingly, the Linux block device subsystem does not
>   do mailboxing/queueing of IO requests, but turns the
>   read-ahead for the device into a blocking factor, and always
>   issues read requests to the device driver for a strip of N
>   blocks, where N is the read-ahead, then waits for completion
>   of each strip before issuing the next request.

On purely sequential I/O it seems OK to me. Is it also true on random? Is it
true with deadline and CFQ? Is it true when you saturate the system thanks to
async io (if each requests blocks there is no way for the kernel to further
optimize), to multiple (simultaneously requesting I/O) threads or to processes?

As you probably already know: upon requests parallelization involved parties
(CPU and libc + kernel) are able to generate and accept a huge amount of
requests and then to group them (at elevator level) before really sending them
to the controller. Try using the deadline ioscheduler and reducing its ability
to group, by playing with /sys/block/DeviceName/queue/iosched/read_expire,
please let us know the results
Try 'randomio' or 'tiobench' (see the URL below)

> * This half-duplex logic with dire implications for performance
>   is used even if the host adapter is capable of mailboxing and
>   tagged queueing (verified also on a 3ware host adapter).

3ware is no more on my list (see http://www.makarevitch.org/rant/raid/ )

>   For writes queueing and streaming seem to be happening
>   naturally as written pages accumulate in the page cache.

Writes are fundamentally different when they can be cached for write-back

> The read-ahead on the RAID10 has to be a lot larger (apparently
> 32MiB) to deliver the expected level of streaming read speed.
> This is very bad except for bulk streaming. It is hard to
> imagine why that is needed, unless the calculation is wrong.

Maybe because the adequate data ("next to be requested") is just under the
disk's head after read-ahead had kicked in and "extended" the read. Without any
read-ahead these data will not be in the buffercache, resulting in a cache
'miss' when the next request (from the same sequential read set of requests)
will arrive. System and disk logic induces very small latencies but the disk
platters revolves continuously, therefore the needed data is sometimes behind
the head when your code has received the previous data and request the next
blocks. The disk will be only able to read it after a near-complete platter
rotation. This is a huge delay by CPU and DMA standards. In other terms the
read-ahead reduces the ratio (platter rotations/useful data read).





