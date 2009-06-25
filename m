From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Thu, 25 Jun 2009 12:35:02 +1000
Message-ID: <19010.57942.43011.108889@notabene.brown>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
	<yq1vdmlsgqo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin K. Petersen on Wednesday June 24
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, jens.axboe@oracle.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Wednesday June 24, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == Neil Brown <neilb@suse.de> writes:
> 
> Neil,
> 
> Neil> Are you saying that if you tried to write a 512byte sector to a
> Neil> SATA drive with 4KB sectors it would corrupt the data?  Or it
> Neil> would fail?  In either case, the reference to "read-modify-write"
> Neil> in the documentation seems misplaced.
> 
> The next generation SATA drives will have 512-byte logical block size
> but use a 4096-byte internal block size.
> 
> If you submit a 512-byte write to such a drive it will have to first
> read the 4KB sector, add the 512 bytes of new data, and then write the
> combined result.  This means you have to do an extra rotation for each
> I/O.  I have some drives here and the performance impact is huge for
> random I/O workloads.
> 
> Now, the reason I keep the physical_block_size around is because the
> usual sector atomicity "guarantees" get tweaked with 4KB drives.  For
> instance, assume that your filesystem is journaling in 512-byte
> increments and rely on a 512-byte write being atomic.  On a 4KB drive
> you could get an I/O error on logical block N within a 4KB physical
> block.  That would cause the previous writes to that sector to
> "disappear" despite having been acknowledged to the OS.  Consequently,
> it is important that we know the actual atomicity of the underlying
> storage for correctness reasons.  Hence the physical block size
> parameter.

"atomicity".  That is a very useful word that is completely missing
from the documentation.  I guess is it very similar to "no R-M-W" but
the observation about leaking write errors is a very useful one I think
that shouldn't be left out.
So:
  physical_block_size : the smallest unit of atomic writes.  A write error
     in one physical block will never corrupt data in a different
     physical block.

That starts to make sense.

With RAID5, this definition would make the physical_block_size the
same as the stripe size because if the array is degraded (which is the
only time a write error can be visible), a write error will
potentially corrupt other blocks in the stripe.

Does the physical_block_size have to be a power of 2??


> 
> 
> Neil> Now I don't get the difference between "preferred" and "optimal".
> 
> I don't think there is a difference.

Good.  Let's just choose one and clean up the documentation.

> 
> 
> Neil> Surely we would always prefer everything to be optimal.  The
> Neil> definition of "optimal_io_size" from the doco says it is the
> Neil> "preferred unit of receiving I/O".  Very confusing.
> 
> I think that comes out of the SCSI spec.  The knobs were driven by
> hardware RAID arrays that prefer writing in multiples of full stripe
> widths.
> 
> I like to think of things this way:
> 
> Hardware limitations (MUST):
> 
>  - logical_block_size is the smallest unit the device can address.

This is one definition I have no quibble with at all.

> 
>  - physical_block_size is the smallest I/O the device can perform
>    atomically.  >= logical_block_size.

Well, the smallest write, 'O', but not 'I'.
I guess it is the smallest atomic read is many cases, but I cannot see
that being relevant.  Is it OK to just talk about he 'write' path here?


> 
>  - alignment_offset describes how much LBA 0 is offset from the natural
>    (physical) block alignment.
> 
> 
> Performance hints (SHOULD):
> 
>  - minimum_io_size is the preferred I/O size for random writes.  No
>    R-M-W.  >= physical_block_size.

Presumably this is not simply >= physical_block_size, but is an
integer multiple of physical_block_size ??
This is assumed to be aligned the same as physical_block_size and no
further alignment added? i.e. the address should be
   alignment_offset + N * minimum_io_size ???
I think that is reasonable, but should be documented.

And again, as it is for 'writes', let's drop the 'I'.

And I'm still not seeing a clear distinction between this and
physical_block_size.  The difference seems to be simply that there are
two different R-M-W scenarios happening: one in the drive and one in a
RAID4/5/6 array.  Each can cause atomicity problems.

Maybe we really want physical_block_size_A and physical_block_size_B.
Where B is preferred, but A is better than nothing.
You could even add that A must be a power of 2, but B doesn't need to
be.


> 
>  - optimal_io_size is the preferred I/O size for large sustained writes.
>    Best utilization of the spindles available (or whatever makes sense
>    given the type of device).  Multiple of minimum_io_size.

In the email Mike forwarded, you said:

	- optimal_io_size = the biggest I/O we can submit without
	  incurring a penalty (stall, cache or queue full).  A multiple
	  of minimum_io_size.

Which has a subtly different implication.  If the queue and cache are
configurable (as is the case for e.g. md/raid5) then this is a dynamic
value (contrasting with 'spindles' which are much less likely to be
dynamic) and so is really of interest only to the VM and filesystem
while the device is being accessed.

I'm not even sure it is interesting to them.
Surely the VM should just throw writes at the device in
minimum_io_size chunks until the device sets it's "congested" flag -
then the VM backs off.  Knowing in advance what that size will be
doesn't seem very useful (but if it is, it would be good to have that
explained in the documentation).

This is in strong contrast to minimum_io_size which I think could be
very useful.  The VM tries to gather writes in chunks of this size,
and the filesystem tries to lay out blocks with this sort of
alignment.

I think it would be a substantial improvement to the documentation to
give examples of how the values would be used.

As an aside, I can easily imagine devices where the minimum_io_size
varies across the address-space of the device - RAID-X being one
interesting example.  Regular hard drives being another if it helped
to make minimum_io_size line up with the track or cylinder size.
So maybe it would be best not to export this, but to provide a way for
the VM and filesystem do discover it dynamically on a per-address
basic??  I guess that is not good for mkfs on a filesystem that is
designed to expect a static layout.

> 
> 
> Neil> Though reading further about the alignment, it seems that the
> Neil> physical_block_size isn't really a 'MUST', as having a partition
> Neil> that was not properly aligned to a MUST size would be totally
> Neil> broken.
> 
> The main reason for exporting these values in sysfs is so that
> fdisk/parted/dmsetup/mdadm can avoid creating block devices that will
> cause misaligned I/O.
> 
> And then libdisk/mkfs.* might use the performance hints to make sure
> things are aligned to stripe units etc.
> 
> It is true that we could use the knobs inside the kernel to adjust
> things at runtime.  And we might.  But the main motivator here is to
> make sure we lay out things correctly when creating block
> devices/partitions/filesystems on top of these - ahem - quirky devices
> coming out.

This clearly justifies logical_block_size, physical_block_size,
alignment_offset.
And it justifies minimum_io_size as a hint. (Which is really
minimum_write_size).
I'm not so sure about optimal_io_size.. I guess it is just another
hint.

There is a bit of a pattern there.
We have a number (2) of different write sizes where going below that
size risks integrity, and a number (2) where going below that size
risks performance.
So maybe we should be explicit about that and provide some lists of
sizes:

safe_write_size:  512 4096 327680
optimal_write_size: 65536 327680 10485760

(which is for a raid5 with 6 drives, 64k chunk size, 4K blocks on
underlying device, and a cache which comfortably holds 32 stripes).

In each case, the implication is to use the biggest size possible, but
if you cannot, use a multiple of the largest size you can reach.
safe_write size is for the filesystem to lay out data correctly,
optimal_write_size is for the filesystem and the VM to maximise speed.



> 
> 
> Neil> My current thought for raid0 for example is that the only way it
> Neil> differs from the max of the underlying devices is that the
> Neil> read-ahead size should be N times the max for N drives.  A
> Neil> read_ahead related to optimal_io_size ??
> 
> Optimal I/O size is mainly aimed at making sure you write in multiples
> of the stripe size so you can keep all drives equally busy in a RAID
> setup.
> 
> The read-ahead size is somewhat orthogonal but I guess we could wire it
> up to the optimal_io_size for RAID arrays.  I haven't done any real life
> testing to see whether that would improve performance.

md raid arrays already set the read ahead to a multiple of the stripe
size (though possibly not a large enough multiple in some cases as it
happens).

In some sense it is orthogonal, but in another sense it is part of the
same set of data: metrics of the device that improve performance.


> 
> 
> Neil> Who do I have to get on side for you to be comfortable moving the
> Neil> various metrics to 'bdi' (leaving legacy duplicates in 'queue'
> Neil> where that is necessary) ??  i.e. which people need to want it?
> 
> Jens at the very minimum :)

I'll prepare a missive, though I've already included Jens in the CC on
this as you (separately) suggest.

Thanks,

NeilBrown
