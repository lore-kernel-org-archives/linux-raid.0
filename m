From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and I/O  sizes
Date: Thu, 25 Jun 2009 16:16:59 +1000
Message-ID: <19011.5723.905426.951624@notabene.brown>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
	<yq1vdmlsgqo.fsf@sermon.lab.mkp.net>
	<19010.57942.43011.108889@notabene.brown>
	<yq163elrksl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin K. Petersen on Thursday June 25
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, snitzer@redhat.com, jens.axboe@oracle.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Thursday June 25, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == Neil Brown <neilb@suse.de> writes:
> Neil> Well, the smallest write, 'O', but not 'I'.  I guess it is the
> Neil> smallest atomic read is many cases, but I cannot see that being
> Neil> relevant.  Is it OK to just talk about he 'write' path here?
> 
> As I said earlier, these values are write centric.  People didn't see
> much value in providing a similar set of knobs for reads so I removed
> them.

Agreed.  All I'm asking here is to change the names to reflect this truth.
  minimum_write_size, optimum_write_size

> Neil> Maybe we really want physical_block_size_A and
> Neil> physical_block_size_B.  Where B is preferred, but A is better than
> Neil> nothing.  You could even add that A must be a power of 2, but B
> Neil> doesn't need to be.
> 
> The way I view it is that physical_block_size is tied to the low-level
> hardware.  It is called physical_block_size to match the definition in
> the ATA and SCSI specs.  That's also where logical_block_size comes
> from.
> 
> Applications that care about the write block size should look at
> minimum_io_size.  Regardless of whether they are sitting on top of the
> raw disk or MD or DM.  Above the physical disk layer pbs mostly has
> meaning as housekeeping.  I.e. it records the max pbs of the component
> devices.  For instance a RAID1 using a 512-byte drive and a 4KB drive
> will have a pbs of 4KB.
> 
> There are a few special cases where something may want to look directly
> at physical_block_size.  But that's in the journal padding/cluster
> heartbeat department.

Here you're thinking seems be very specific.
This value comes from that spec.  That value is used for this
particular application.
Yet....
> 
> And consequently I am deliberately being vague.  What makes sense for an
> spinning disk doesn't make sense for an SSD.  Or for a Symmetrix.  Or
> for LVM on top of MD on top of 10 Compact Flash devices.  So min and opt
> are hints that are supposed to make some sort of sense regardless of
> what your actual storage stack looks like.

...here you are being deliberately vague.  But with the exact same
values.   I find this confusing.

I think that we need to have values that have very strong and well
defined meanings.  I read your comments above as saying something
like:

  When writing use at least minimum_io_size unless you are journal
  or heartbeat or similar code, then use physical_block_size.

I don't like that definition at all.
Conversely: "use the largest of these values that is practical for
             you, each is better than the previous"
does work nicely.  It actually reflects reality of devices, gives
strong guidance to filesystems and doesn't carry any baggage.

> 
> I'm happy to take a stab at making the documentation clearer.  But I am
> against making it so explicit that the terminology only makes sense in
> an "MD RAID5 on top of three raw disks" universe.
> 

I often find that when it is hard to document something clearly, it is
because that something itself is not well defined...

My target for this or any similar interface documentation, is that the
provider must be guided by the documentation to know exactly what
value to present, and the consumer must be guided by the documentation
to know exactly which value to use.

> 
> Neil> There is a bit of a pattern there.  We have a number (2) of
> Neil> different write sizes where going below that size risks integrity,
> Neil> and a number (2) where going below that size risks performance.
> Neil> So maybe we should be explicit about that and provide some lists
> Neil> of sizes:
> 
> Neil> safe_write_size: 512 4096 327680 optimal_write_size: 65536 327680
> Neil> 10485760
> 
> Violates the one-value-per-sysfs file rule :)

Since when are array values not values?  It *is* only one value per
file!

> 
> I understand your point but I think it's too much information.

I think that it is exactly the same information that you are
presenting, but in a more meaningful and less confusing (to me) way.

safe_write_size: logical_block_size physical_block_size minimum_io_size
optimal_write_size: physical_block_size minimum_io_size optimal_io_size

And it is more flexible if someone has a more complex hierarchy.

The 'alignment' value applies equally to any size value which is
larger than it.  (I wonder if 'alignment' could benefit from being an
array value.....probably not).

Just for completeness, I tried to write documentation for the above
two array values to fit my guidelines described earlier.
I found that I couldn't find a really convincing case for the
distinction.   A filesystem wants all of it's data to be safe, and
wants all of its writes to be fast.
And in all the examples we can think of, a safer write is faster than a
less-safe write.
What that leaves us with is a simple increasing list of sizes, each a
multiple of the previous.  Each safer and/or faster, but also larger.

So I seem to now be suggesting a single array value:

 preferred_write_size: logical_block_size physical_block_size \
          minimum_io_size optimal_io_size

It would be documented as:

preferred_write_size:
  A list of sizes (in bytes) such that a write of that size, aligned
  to a multiple of that size (plus alignment_offset) is strongly
  preferred over an smaller write for reasons of safety and/or
  performance.  All writes *must* be a multiple of the smallest listed
  size.  Due to the hierarchical nature of some storage systems, there
  may be a list of values, each safer and/or faster than the previous,
  but also larger.  Subsequent values will normally be multiples of
  previous values.  Sizes other than the first are not constrained to
  be powers of 2.
  A filesystem or other client should choose the largest listed size
  (or a multiple-thereof) which fits within any other constraint
  it is working under.

  Note: the 'safety' aspect only applies to cases where a device error
  or system crash occurs.  In such cases there may be a chance that
  data outside the target area of a write gets corrupted.  When there
  is no such error, all writes are equally safe.

NeilBrown
