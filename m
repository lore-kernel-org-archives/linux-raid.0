From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: RAID 5: low sequential write performance?
Date: Sun, 16 Jun 2013 23:39:14 -0700
Message-ID: <51BEAF12.10909@fatooh.org>
References: <51BCF46B.40704@fatooh.org> <20926.11718.556180.928129@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20926.11718.556180.928129@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2013-06-16 14:27, Peter Grandi wrote:
>> I know this doesn't have anything to do with the filesystem--
>> I was able to reproduce the behavior on a test system, writing
>> directly to an otherwise unused array, using a single 768 MB
>> write() call.
> 
> Usually writes via a filesystem are more likely to avoid RMW
> issues, as suitabky chosen filesystem designs take into account
> stripe alignment.

Yeah.... but if I issue a single write() directly to the array without
seeking anywhere, it should be aligned, at least I would expect.

> Some time ago I did some tests and I was also writing to a
> '/dev/md' device, but I found I got RMW only if using
> 'O_DIRECT', while buffered writes ended up being aligned.
> Without going into details, it looked like that the Linux IO
> subsystem does significant reordering of requests, sometimes
> surprisingly, when directly accessing the block device, but not
> when writing files after creating a filesystem in that block
> device. Perhaps currently MD expects to be fronted by a
> filesystem.

Hmm. I tried some more simple tests with dd right now, for chunk size
512 (I'm only reporting single runs here, but I ran them a few times to
make sure they were representative).

Without O_DIRECT:

icebox:~# dd if=/dev/zero bs=768M count=1 of=/dev/md3 conv=fdatasync

1+0 records in
1+0 records out
805306368 bytes (805 MB) copied, 16.1938 s, 49.7 MB/s

With O_DIRECT:

icebox:~# dd if=/dev/zero bs=768M count=1 of=/dev/md3 oflag=direct
conv=fdatasync
1+0 records in
1+0 records out
805306368 bytes (805 MB) copied, 18.1964 s, 44.3 MB/s

So, that doesn't seem to help. Interestingly, it did help when I tested
with 16384 KB chunk size (34 MB/s --> 39 MB/s); but, I'll stick with 512
KB chunks for now.

>> I measured chunk sizes at each power of 2 from 2^2 to 2^14
>> KB. The results of this are that smaller chunks performed the
>> best, [ ... ]
> 
> Your Perl script is a bit convoluted. I prefer to keep it simple
> and use 'dd' advisedly to get upper boundaries.

Yeah... I had used dd for the early testing, but I wanted to try random
data and /dev/urandom was so slow it added a large baseline to each test
unless I read it into memory before starting the time measurements.

The rest of the script is just for the setup, reporting, etc.

> Anyhow, try using a stripe-aware filesystem like XFS, and also
> perhaps increase significantly the size of the stripe cache.
> That seems to help scheduling too. Changing the elevator on the
> member devices sometimes helps too (but is not necessarily
> related to RMW issues).

The underlying devices were using cfq. noop and deadline were available,
but they didn't make a noticeable difference.

The stripe cache, however, made a huge difference. It was 256 (KB,
right?) by default. Here are some average-of-three dd results (without
O_DIRECT, as above).

  256 KB: 50.2 MB/s
  512 KB: 61.0 MB/s
 1024 KB: 72.7 MB/s
 2048 KB: 79.6 MB/s
 4096 KB: 87.5 MB/s
 8192 KB: 87.3 MB/s
16384 KB: 89.8 MB/s
32768 KB: 91.3 MB/s

...then I tried O_DIRECT again with 32768 KB stripe cache, and it
consistently gets slightly better results: 92.7 MB/s.

This is just on some old dissimilar drives I stuffed into my old
desktop, so I'm not expecting stellar performance. sdd is the slowest,
and it only writes at 54.6 MB/s on its own, so 92.7 MB/s is not too
shabby for the RAID, especially compared to the 49.7 MB/s I was getting
before.

I've been watching a dstat run this whole time, and increasing stripe
cache sizes do indeed result in fewer reads, until they go away entirely
at 32768 KB (except for a few reads at the end, which appear to be
unrelated to RAID).

32768 seems to be the maximum for the stripe cache. I'm quite happy to
spend 32 MB for this. 256 KB seems quite low, especially since it's only
half the default chunk size.


Out of curiosity, I did some tests with xfs vs. ext4 on an empty
filesystem. I'm not familiar with xfs, so I may be missing out on some
tuning. This isn't really meant to be a comprehensive benchmark, but for
a single sequential write with dd:

mkfs.xfs /dev/m3
direct: 89.8 MB/s  not direct: 90.0 MB/s

mkfs.ext4 /dev/md3 -E lazy_itable_init=0
direct: 86.2 MB/s  not direct: 85.4 MB/s

mkfs.ext4 /dev/md3 -E lazy_itable_init=0,stride=128,stripe_width=256
direct: 89.0 MB/s  not direct: 85.6 MB/s

Anyway, xfs indeed did slightly better, so I may evaluate it further
next time I rebuild my main array (the one that actually matters for all
this testing. :) As far as that array goes, write performance went from
30.2 MB/s to 53.1 MB/s. Not that great, unfortunately, but I'm using
dm-crypt and that may be the bottleneck now. Reads are still present
during a write (due to fragmentation, perhaps?), but they are minimal.


Thanks Peter, your email was a great help to me. I'm still interested if
you or anyone else has anything to comment on here, but I'm satisfied
that I've managed to eliminate unnecessary read-modify-write as a source
of slowness.

Thanks,
Corey
