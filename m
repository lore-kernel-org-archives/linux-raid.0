From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Wed, 24 Jun 2009 13:07:11 -0400
Message-ID: <yq1vdmlsgqo.fsf@sermon.lab.mkp.net>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19009.50739.830769.821582@notabene.brown> (Neil Brown's message
	of "Wed, 24 Jun 2009 16:22:43 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil,

Neil> Are you saying that if you tried to write a 512byte sector to a
Neil> SATA drive with 4KB sectors it would corrupt the data?  Or it
Neil> would fail?  In either case, the reference to "read-modify-write"
Neil> in the documentation seems misplaced.

The next generation SATA drives will have 512-byte logical block size
but use a 4096-byte internal block size.

If you submit a 512-byte write to such a drive it will have to first
read the 4KB sector, add the 512 bytes of new data, and then write the
combined result.  This means you have to do an extra rotation for each
I/O.  I have some drives here and the performance impact is huge for
random I/O workloads.

Now, the reason I keep the physical_block_size around is because the
usual sector atomicity "guarantees" get tweaked with 4KB drives.  For
instance, assume that your filesystem is journaling in 512-byte
increments and rely on a 512-byte write being atomic.  On a 4KB drive
you could get an I/O error on logical block N within a 4KB physical
block.  That would cause the previous writes to that sector to
"disappear" despite having been acknowledged to the OS.  Consequently,
it is important that we know the actual atomicity of the underlying
storage for correctness reasons.  Hence the physical block size
parameter.


Neil> Now I don't get the difference between "preferred" and "optimal".

I don't think there is a difference.


Neil> Surely we would always prefer everything to be optimal.  The
Neil> definition of "optimal_io_size" from the doco says it is the
Neil> "preferred unit of receiving I/O".  Very confusing.

I think that comes out of the SCSI spec.  The knobs were driven by
hardware RAID arrays that prefer writing in multiples of full stripe
widths.

I like to think of things this way:

Hardware limitations (MUST):

 - logical_block_size is the smallest unit the device can address.

 - physical_block_size is the smallest I/O the device can perform
   atomically.  >= logical_block_size.

 - alignment_offset describes how much LBA 0 is offset from the natural
   (physical) block alignment.


Performance hints (SHOULD):

 - minimum_io_size is the preferred I/O size for random writes.  No
   R-M-W.  >= physical_block_size.

 - optimal_io_size is the preferred I/O size for large sustained writes.
   Best utilization of the spindles available (or whatever makes sense
   given the type of device).  Multiple of minimum_io_size.


Neil> Though reading further about the alignment, it seems that the
Neil> physical_block_size isn't really a 'MUST', as having a partition
Neil> that was not properly aligned to a MUST size would be totally
Neil> broken.

The main reason for exporting these values in sysfs is so that
fdisk/parted/dmsetup/mdadm can avoid creating block devices that will
cause misaligned I/O.

And then libdisk/mkfs.* might use the performance hints to make sure
things are aligned to stripe units etc.

It is true that we could use the knobs inside the kernel to adjust
things at runtime.  And we might.  But the main motivator here is to
make sure we lay out things correctly when creating block
devices/partitions/filesystems on top of these - ahem - quirky devices
coming out.


Neil> My current thought for raid0 for example is that the only way it
Neil> differs from the max of the underlying devices is that the
Neil> read-ahead size should be N times the max for N drives.  A
Neil> read_ahead related to optimal_io_size ??

Optimal I/O size is mainly aimed at making sure you write in multiples
of the stripe size so you can keep all drives equally busy in a RAID
setup.

The read-ahead size is somewhat orthogonal but I guess we could wire it
up to the optimal_io_size for RAID arrays.  I haven't done any real life
testing to see whether that would improve performance.


Neil> Who do I have to get on side for you to be comfortable moving the
Neil> various metrics to 'bdi' (leaving legacy duplicates in 'queue'
Neil> where that is necessary) ??  i.e. which people need to want it?

Jens at the very minimum :)

-- 
Martin K. Petersen	Oracle Linux Engineering
