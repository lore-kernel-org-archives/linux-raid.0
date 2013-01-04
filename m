From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Fri, 04 Jan 2013 16:51:14 -0600
Message-ID: <50E75CE2.8060105@hardwarefreak.com>
References: <20130104175458.GA3298@hellgate>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130104175458.GA3298@hellgate>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/4/2013 11:54 AM, Andras Korn wrote:

> I have a RAID10 array with the default chunksize of 512k:
> 
> md124 : active raid10 sdg3[6] sdd3[0] sda3[7] sdh3[3] sdf3[2] sde3[1]
>       1914200064 blocks super 1.2 512K chunks 3 far-copies [6/6] [UUUUUU]
>       bitmap: 4/15 pages [16KB], 65536KB chunk
> 
> I have an application on top of it that writes blocks of 128k or less, using
> multiple threads, pretty randomly (but reads dominate, hence far-copies;
> large sequential reads are relatively frequent).

You've left out critical details:

1.  What filesystem are you using?

2.  Does that app write to multiple files with these multiple threads,
or the same file?

3.  Is it creating new files or modifying/appending existing files?
I.e. is it metadata intensive?

4.  Why are you doing large sequential reads of files that are written
128KB at a time?

We need much more detail, because those details dictate how you need to
configure your 6 disk RAID10 for optimal performance.

> I wonder whether re-creating the array with a chunksize of 128k (or maybe
> even just 64k) could be expected to improve write performance. I assume the
> RAID10 implementation doesn't read-modify-write if writes are not aligned to
> chunk boundaries, does it? In that case, reducing the chunk size would just
> increase the likelihood of more than one disk (per copy) being necessary to
> service each request, and thus decrease performance, right?

RAID10 doesn't RMW because there is no parity, making chunk size less
critical than with RAID5/6 arrays.  To optimize this array you really
need to capture the IO traffic pattern of the application.  If your
chunk size is too large you may be creating IO hotspots on individual
disks, with the others idling to a degree.  It's actually really
difficult to use a chunk size that is "too small" that will decrease
performance.

> I understand that small chunksizes favour single-threaded sequential
> workloads (because all disks can read/write simultaneously, thus adding
> their bandwidth together), 

This simply isn't true.  Small chunk sizes are preferable for almost all
workloads.  Large chunks are only optimal for single thread long
duration streaming writes/reads.

> whereas large(r) chunksizes favour multi-threaded
> random access (because a single disk may be enough to serve each request,
> while the other disks serve other requests).

Again, not true.  Everything depends on your workload:  the file sizes
involved, and the read/write patterns from/to those files.  For
instance, with your current 512KB chunk, if you're writing/reading 128KB
files, you're putting 4 files on disk1 then 4 files on disk2, then 4
files on disk3.  If you read them back in write order, even with 4
threads, you'll read the first 4 files from disk1 while disks 2/3 sit
idle.  If you use a 128KB chunk, each file gets written to a different
disk.  So when your 4 threads read them back each thread is accessing a
different, all 3 disks in parallel.

Now, this ignores metadata write/reads to the filesystem journal.  With
a large chunk of 512KB, it's likely that most/all of your journal writes
will go to the first disk in the array.  If this is the case you've
doubled (or more) the IO load on disk1, such that file IO performance
will be half that of each of the other drives.

And, this is exactly why we recommend nothing larger than a 32KB chunk
size for XFS, and this is why the md metadata 1.2 default chunk of 512KB
is insane.  Using a "small" chunk size spreads both metadata and file IO
more evenly across the spindles and yields more predictable performance.

> So: can RAID10 issue writes that start at some offset from a chunk boundary?

The filesystem dictates where files are written, not md/RAID.  If you
have a 512KB chunk and you're writing 128KB or smaller files, 3 of your
4 file writes will not start on a chunk boundary.  If you use a 128KB
chunk and all your files are exactly 128KB then each will start on a
chunk boundary.

That said, I wouldn't use a 128KB chunk.  I'd use a 32KB chunk.  And
unless your application is doing some really funky stuff, going above
that mostly likely isn't going to give you any benefit, especially if
each of these 128KB writes is an individual file.  In that case you
definitely want a small chunk due to the metadata write load.

-- 
Stan

