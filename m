From: Neil Brown <neilb@suse.de>
Subject: Re: Trouble increasing md component size
Date: Tue, 24 Jun 2008 12:40:48 +1000
Message-ID: <18528.24240.396666.354746@notabene.brown>
References: <18526.64462.687289.73717@notabene.brown>
	<20080623111821.GA9948@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Monday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 23, chris@arachsys.com wrote:
> > What I'd really like is for md to get a call-back when the device size
> > changes, so that the metadata can be relocated immediately.  However
> > that is a little way off, and I think this is a useful thing to have
> > now.
> 
> If it's easy to register for such a call-back (?), I think it would be
> sufficient for the call-back to run that new rdev_size_change superblock
> function as
> 
>   super_types[sb->major_version].rdev_size_change(rdev, 0)
> 
> to update the rdev->size & superblock, and move the metadata if necessary.
> For a shrink you probably want to resize before the block device changes
> size rather than afterwards, although that's presumably not going to be
> easy/possible to achieve for many block device changes.

I'd meant to respond to this bit in my first reply, but got
distracted.

There currently is no mechanism for registering callbacks.  One day I
would like to create one.

The approach I have in mind involves leveraging the bd_claim/bd_holder
stuff.
Current when someone "claim"s a block_device, they give a unique (void *)
to identify them.  My idea is to change that to be a struct with
defined contents.
e.g.
   struct bd_holder {
	struct block_dev_callback_operations *ops;
   };

Where
  struct block_dev_callback_operations {
	int (*size_change_request)(struct block_dev *bdev, sector_t newsize);
	void (*size_change_commit)(struct block_dev *bdev, sector_t newsize);
      ....
  }

so if a blockdev wants to change it's size, and someone has claimed
it, it first calls
     bdev->bd_holder->ops->size_change_request()
with the new size.  If that fails, it has to give up.
If it succeeds, it makes the change, the calls ->size_change_commit.


I think dm and md are currently the only devices which spontaneously
change size, so they would be the first place to make these calls.
Possibly we could then get the partition management code to
allow size changes of active partitions if there was a
size_change_request that could be called and would return success.

There are quite a lot of places where bd_claim is called.
Filesystems claim the block device they use, md and dm and swap do as
well.
In the first instance, we could make the "ops" pointer "NULL" and get
the calling code to cope with that.  Then one by one we could
introduce useful functionality.

I would then use these callbacks to also implement freeze_bdev.
It currently hunts through the mount table for a filesystem on the
bdev, and calls the s_op->write_super_lockfs method on that
filesystem.  This is somewhat ugly.  Doing a callback through the
bd_holder structure would be much more elegant.

The only difficult issue is locking.  Exactly what lock should be
required when calling various block_dev_callback_operations?
The easiest would be to hold the bdev_lock spinlock.  That would
be enough to make sure the holder doesn't disappear on us.  But
there isn't much you can do under a spinlock.  You certainly cannot
write new metadata to a device.
Maybe you could get by with ->trylock and ->unlock 
block_dev_callback_operations which could be called under the
spinlock, and all other operations much be called with that lock
held.  One would probably need to try writing code and see what falls
out.


And yes, with that in place, rdev_size_change(rdev, 0) would be very
close to what you want the size_change_commit to do.

NeilBrown
