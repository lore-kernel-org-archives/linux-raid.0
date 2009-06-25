From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Thu, 25 Jun 2009 00:37:14 -0400
Message-ID: <yq163elrksl.fsf@sermon.lab.mkp.net>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
	<yq1vdmlsgqo.fsf@sermon.lab.mkp.net>
	<19010.57942.43011.108889@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19010.57942.43011.108889@notabene.brown> (Neil Brown's message
	of "Thu, 25 Jun 2009 12:35:02 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, jens.axboe@oracle.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

>>>>> "Neil" == Neil Brown <neilb@suse.de> writes:

Neil,

Neil> With RAID5, this definition would make the physical_block_size the
Neil> same as the stripe size because if the array is degraded (which is
Neil> the only time a write error can be visible), a write error will
Neil> potentially corrupt other blocks in the stripe.

But with MD RAID5 we know about it.  The problem with disk drives (and
even some arrays) is that the result is undefined.  But see below.


Neil> Well, the smallest write, 'O', but not 'I'.  I guess it is the
Neil> smallest atomic read is many cases, but I cannot see that being
Neil> relevant.  Is it OK to just talk about he 'write' path here?

As I said earlier, these values are write centric.  People didn't see
much value in providing a similar set of knobs for reads so I removed
them.


>> - minimum_io_size is the preferred I/O size for random writes.  No
>> R-M-W.  >= physical_block_size.

Neil> Presumably this is not simply >= physical_block_size, but is an
Neil> integer multiple of physical_block_size ??

Yep.


Neil> This is assumed to be aligned the same as physical_block_size and
Neil> no further alignment added? i.e. the address should be
Neil>    alignment_offset + N * minimum_io_size ???

Yep.


Neil> Maybe we really want physical_block_size_A and
Neil> physical_block_size_B.  Where B is preferred, but A is better than
Neil> nothing.  You could even add that A must be a power of 2, but B
Neil> doesn't need to be.

The way I view it is that physical_block_size is tied to the low-level
hardware.  It is called physical_block_size to match the definition in
the ATA and SCSI specs.  That's also where logical_block_size comes
from.

Applications that care about the write block size should look at
minimum_io_size.  Regardless of whether they are sitting on top of the
raw disk or MD or DM.  Above the physical disk layer pbs mostly has
meaning as housekeeping.  I.e. it records the max pbs of the component
devices.  For instance a RAID1 using a 512-byte drive and a 4KB drive
will have a pbs of 4KB.

There are a few special cases where something may want to look directly
at physical_block_size.  But that's in the journal padding/cluster
heartbeat department.


Neil> In the email Mike forwarded, you said:

Neil> 	- optimal_io_size = the biggest I/O we can submit without
Neil> 	  incurring a penalty (stall, cache or queue full).  A multiple
Neil> 	  of minimum_io_size.

I believe I corrected that description later in the thread.  But
anyway...


Neil> Which has a subtly different implication.  If the queue and cache
Neil> are configurable (as is the case for e.g. md/raid5) then this is a
Neil> dynamic value (contrasting with 'spindles' which are much less
Neil> likely to be dynamic) and so is really of interest only to the VM
Neil> and filesystem while the device is being accessed.

The SCSI spec says:

"The OPTIMAL TRANSFER LENGTH GRANULARITY field indicates the optimal
transfer length granularity in blocks for a single [...]
command. Transfers with transfer lengths not equal to a multiple of this
value may incur significant delays in processing."


I tried to provide a set of hints that could:

1. Be seeded by the knobs actually provided in the hardware specs

2. Help filesystems lay out things optimally for the underlying storage
   using a single interface regardless of whether it was disk, array, MD
   or LVM

3. Make sense when allowing essentially arbitrary stacking of MD and LVM
   devices (for fun add virtualization to the mix)

4. Allow us to make sure we did not submit misaligned requests

And consequently I am deliberately being vague.  What makes sense for an
spinning disk doesn't make sense for an SSD.  Or for a Symmetrix.  Or
for LVM on top of MD on top of 10 Compact Flash devices.  So min and opt
are hints that are supposed to make some sort of sense regardless of
what your actual storage stack looks like.

I'm happy to take a stab at making the documentation clearer.  But I am
against making it so explicit that the terminology only makes sense in
an "MD RAID5 on top of three raw disks" universe.

I think "Please don't submit writes smaller than this" and "I prefer big
writes in multiples of this" are fairly universal.


Neil> As an aside, I can easily imagine devices where the
Neil> minimum_io_size varies across the address-space of the device -
Neil> RAID-X being one interesting example.  Regular hard drives being
Neil> another if it helped to make minimum_io_size line up with the
Neil> track or cylinder size.  So maybe it would be best not to export
Neil> this, but to provide a way for the VM and filesystem do discover
Neil> it dynamically on a per-address basic??

This is what I presented at the Storage & Filesystems workshop.  And
people hated the "list of topologies" thing.  General consensus was that
it was too complex.  The original code had:

    /sys/block/topology/nr_regions
    /sys/block/topology/0/{offset,length,min_io,opt_io,etc.}
    /sys/block/topology/1/{offset,length,min_io,opt_io,etc.}

Aside from the nightmare of splitting and merging topologies when
stacking there were also obvious problems with providing an exact
representation.

For instance a RAID1 with drives with different topologies.  How do you
describe that?  Or a RAID0 with similar mismatched drives where each -
say - 64KB chunk in the stripe has a different topology.  That becomes a
really long list.  And if you make it a mapping function callback then
what's mkfs supposed to do?  Walk the entire block device to get the
picture?

There was a long discussion about this at the workshop.  My code started
out last summer as a tiny patch kit called "I/O hints" and the resulting
topology patch series as of this spring had turned into a big, bloated
monster thanks to arbitrary stacking.

So I was not sad to see heterogeneous topology code go at the workshop.
It was complex despite my best efforts to keep things simple.

The intent with the changes that are now in the kernel is to:

1. Make sure we align properly by way of the hardware metrics
   (physical_block_size, alignment_offset)

2. Provide some hints that filesystems may or may not use to lay out
   things (minimum_io_size, optimal_io_size)

We already do (2) and have been for ages by way of libdisk which queries
LVM or MD but only understands the top device.  So part of fixing (2)
involved making stacking do the right thing and making a unified
interface for a block device to kill the

        if (this_is_an_md_dev(foo))
           /* Go poke MD with ioctls */
        else if (this_is_a_dm_dev(foo)
           /* Go fork LVM utilities and parse cmd line output */

Everybody agreed that it would be better to have a unified set of hints
in /sys/block.  So that's why things were done this way.


Neil> This clearly justifies logical_block_size, physical_block_size,
Neil> alignment_offset.  And it justifies minimum_io_size as a
Neil> hint. (Which is really minimum_write_size).  I'm not so sure about
Neil> optimal_io_size.. I guess it is just another hint.

Absolutely.


Neil> There is a bit of a pattern there.  We have a number (2) of
Neil> different write sizes where going below that size risks integrity,
Neil> and a number (2) where going below that size risks performance.
Neil> So maybe we should be explicit about that and provide some lists
Neil> of sizes:

Neil> safe_write_size: 512 4096 327680 optimal_write_size: 65536 327680
Neil> 10485760

Violates the one-value-per-sysfs file rule :)

I understand your point but I think it's too much information.

-- 
Martin K. Petersen	Oracle Linux Engineering
