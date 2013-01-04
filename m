From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Sat, 5 Jan 2013 00:41:13 +0100
Message-ID: <20130104234113.GA14799@hellgate>
References: <20130104175458.GA3298@hellgate>
 <50E75CE2.8060105@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50E75CE2.8060105@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 04, 2013 at 04:51:14PM -0600, Stan Hoeppner wrote:

Hi,

> > I have a RAID10 array with the default chunksize of 512k:
> > 
> > md124 : active raid10 sdg3[6] sdd3[0] sda3[7] sdh3[3] sdf3[2] sde3[1]
> >       1914200064 blocks super 1.2 512K chunks 3 far-copies [6/6] [UUUUUU]
> >       bitmap: 4/15 pages [16KB], 65536KB chunk
> > 
> > I have an application on top of it that writes blocks of 128k or less, using
> > multiple threads, pretty randomly (but reads dominate, hence far-copies;
> > large sequential reads are relatively frequent).
> 
> You've left out critical details:
> 
> 1.  What filesystem are you using?

The filesystem is the "application": it's zfsonlinux. I'm putting it on
RAID10 instead of using the disks natively because I want to encrypt it
using LUKS, and encrypting each disk separately seemed wasteful of CPU (I
only have 3 cores).

I realize that I forsake some of the advantages of zfs by putting it on an
mdraid array.

I think this answers your other questions.

> > I wonder whether re-creating the array with a chunksize of 128k (or
> > maybe even just 64k) could be expected to improve write performance. I
> > assume the RAID10 implementation doesn't read-modify-write if writes are
> > not aligned to chunk boundaries, does it? In that case, reducing the
> > chunk size would just increase the likelihood of more than one disk (per
> > copy) being necessary to service each request, and thus decrease
> > performance, right?
> 
> RAID10 doesn't RMW because there is no parity, making chunk size less
> critical than with RAID5/6 arrays.  To optimize this array you really
> need to capture the IO traffic pattern of the application.  If your
> chunk size is too large you may be creating IO hotspots on individual
> disks, with the others idling to a degree.  It's actually really
> difficult to use a chunk size that is "too small" that will decrease
> performance.

I'm not sure I follow, as far as the last sentence is concerned. If, ad
absurdum, you use a chunksize of 512 bytes, then several disks will need to
operate in lock-step to service any reasonably sized read request. If, on
the other hand, the chunk size is large, there is a good chance that all of
the data you're trying to read is in a single chunk, and therefore on a
single disk. This leaves the other spindles free to seek elsewhere
(servicing other requests).

The drawback of the large chunksize is that, as one thread only reads from
one disk at a time, the read bandwidth of any one thread is limited to the
throughput of a single disk.

So, for reads, the large chunk sizes favour multi-threaded random access
time, whereas small chunk sizes favour single-threaded sequential
throughput. If there's a flaw in this chain of thought, plese point it out.
:)

Writes are not much different: all copies of a chunk must be updated when it
is written. If chunks are small, they are spread across more disks; thus a
single write causes more disks to seek.

> > I understand that small chunksizes favour single-threaded sequential
> > workloads (because all disks can read/write simultaneously, thus adding
> > their bandwidth together), 
> 
> This simply isn't true.  Small chunk sizes are preferable for almost all
> workloads.  Large chunks are only optimal for single thread long
> duration streaming writes/reads.

I think you have this backwards; see above. Imagine, for the sake of
simplicity, a RAID0 array with a chunksize of 1 bit. For single thread
sequential reads, the bandwidth of all disks is added together because they
can all read at the same time. With a large chunksize, you only get this if
you also read-ahead agressively.

> > whereas large(r) chunksizes favour multi-threaded
> > random access (because a single disk may be enough to serve each request,
> > while the other disks serve other requests).
> 
> Again, not true.  Everything depends on your workload:  the file sizes
> involved, and the read/write patterns from/to those files.  For
> instance, with your current 512KB chunk, if you're writing/reading 128KB
> files, you're putting 4 files on disk1 then 4 files on disk2, then 4
> files on disk3.  If you read them back in write order, even with 4
> threads, you'll read the first 4 files from disk1 while disks 2/3 sit
> idle.  If you use a 128KB chunk, each file gets written to a different
> disk.  So when your 4 threads read them back each thread is accessing a
> different, all 3 disks in parallel.

This is a specific bad case but not the average. Of course, if you know
the access pattern with sufficient specificity, then you can optimise for
it, but I don't. Many different applications will run on top of ZFS, with
occasional peaks in utilisation. This includes a mailserver that normally
has very little traffic but there are some mailing lists with low mail rates
but many subscribers; there is a mediawiki instance with mysql that has
seasonal as well as trending changes in its traffic etc. etc.

I can't anticipate the exact access pattern; I'm looking for something
that'll work well in some abstract average sense.

> And, this is exactly why we recommend nothing larger than a 32KB chunk
> size for XFS, and this is why the md metadata 1.2 default chunk of 512KB
> is insane.

I think the problem of the xfs journal is much smaller since delaylog became
default; for highly metadata intensive workloads I'd recommend an external
journal (it doesn't even need to be on a SSD because it's written
sequentially).

> Using a "small" chunk size spreads both metadata and file IO more evenly
> across the spindles and yields more predictable performance.

... but sucks for multithreaded random reads.

> > So: can RAID10 issue writes that start at some offset from a chunk boundary?
> 
> The filesystem dictates where files are written, not md/RAID.

Of course. What I meant was: "If the filesystem issues a write request that
is not chunk-aligned, will RAID10 resort to read-modify-write, or just
perform the write at the requested offset within the chunk?"

> That said, I wouldn't use a 128KB chunk.  I'd use a 32KB chunk.  And
> unless your application is doing some really funky stuff, going above
> that mostly likely isn't going to give you any benefit, especially if
> each of these 128KB writes is an individual file.  In that case you
> definitely want a small chunk due to the metadata write load.

I still believe going much below 128k would require more seeking and thus
hurt multithreaded random access performance.

If I use 32k chunks, every 128k block zfs writes will be spread across 4
disks (and that's assuming the 128k write was 32k-aligned); as I'm using 6
disks with 3 copies, evey disk will end up holding 2 chunks of a 128k write,
a bit like this:

disk1 | disk2 | disk3 | disk4 | disk5 | disk6
  1       2       3       4       1       2
  3       4       1       2       3       4

Thus all disks will have to seek twice to serve this write, and four disks
will have to seek to read this 128k block.

With 128k chunks, it'd look like this:

disk1 | disk2 | disk3 | disk4 | disk5 | disk6
  1       1       1

Three disks would have to seek to serve the write (meanwhile, the other
three can serve other writes), and any one of three can serve a read,
leaving the others to seek in order to serve other requests.

How is this reasoning flawed?

Andras

-- 
                     Andras Korn <korn at elan.rulez.org>
 Getting information from the Internet is like taking a drink from a hydrant.
