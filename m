From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: RAID10: how much does chunk size matter? Can partial chunks be
 written?
Date: Fri, 4 Jan 2013 18:54:59 +0100
Message-ID: <20130104175458.GA3298@hellgate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a RAID10 array with the default chunksize of 512k:

md124 : active raid10 sdg3[6] sdd3[0] sda3[7] sdh3[3] sdf3[2] sde3[1]
      1914200064 blocks super 1.2 512K chunks 3 far-copies [6/6] [UUUUUU]
      bitmap: 4/15 pages [16KB], 65536KB chunk

I have an application on top of it that writes blocks of 128k or less, using
multiple threads, pretty randomly (but reads dominate, hence far-copies;
large sequential reads are relatively frequent).

I wonder whether re-creating the array with a chunksize of 128k (or maybe
even just 64k) could be expected to improve write performance. I assume the
RAID10 implementation doesn't read-modify-write if writes are not aligned to
chunk boundaries, does it? In that case, reducing the chunk size would just
increase the likelihood of more than one disk (per copy) being necessary to
service each request, and thus decrease performance, right?

I understand that small chunksizes favour single-threaded sequential
workloads (because all disks can read/write simultaneously, thus adding
their bandwidth together), whereas large(r) chunksizes favour multi-threaded
random access (because a single disk may be enough to serve each request,
while the other disks serve other requests).

So: can RAID10 issue writes that start at some offset from a chunk boundary?

Thanks.

-- 
                     Andras Korn <korn at elan.rulez.org>
                 Visit the Soviet Union before it visits you.
