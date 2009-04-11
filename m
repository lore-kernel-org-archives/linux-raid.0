From: Neil Brown <neilb@suse.de>
Subject: Re: Any benefity to write intent bitmaps on Raid1
Date: Sat, 11 Apr 2009 15:35:17 +1000
Message-ID: <18912.11285.266605.223182@notabene.brown>
References: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net>
	<18909.36541.447308.778177@notabene.brown>
	<87myaqfily.fsf@frosties.localdomain>
	<18911.2963.478861.845896@notabene.brown>
	<87y6u7sxsi.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Saturday April 11
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Steven Ellis <steven@openmedia.co.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday April 11, goswin-v-b@web.de wrote:
> Neil Brown <neilb@suse.de> writes:
> 
> > On Thursday April 9, goswin-v-b@web.de wrote:
> >> Neil Brown <neilb@suse.de> writes:
> >> 
> >> > (*) I've been wondering about adding another bitmap which would record
> >> > which sections of the array have valid data.  Initially nothing would
> >> > be valid and so wouldn't need recovery.  Every time we write to a new
> >> > section we add that section to the 'valid' sections and make sure that
> >> > section is in-sync.
> >> > When a device was replaced, we would only need to recover the parts of
> >> > the array that are known to be invalid.
> >> > As filesystem start using the new "invalidate" command for block
> >> > devices, we could clear bits for sections that the filesystem says are
> >> > not needed any more...
> >> > But currently it is just a vague idea.
> >> >
> >> > NeilBrown
> >> 
> >> If you are up for experimenting I would go for a completly new
> >> approach. Instead of working with physical blocks and marking where
> >> blocks are used and out of sync how about adding a mapping layer on
> >> the device and using virtual blocks. You reduce the reported disk size
> >> by maybe 1% to always have some spare blocks and initialy all blocks
> >> will be unmapped (unused). Then whenever there is a write you pick out
> >> an unused block, write to it and change the in memory mapping of the
> >> logical to physical block. Every X seconds, on a barrier or an sync
> >> you commit the mapping from memory to disk in such a way that it is
> >> synchronized between all disks in the raid. So every commited mapping
> >> represents a valid raid set. After the commit of the mapping all
> >> blocks changed between the mapping and the last can be marked as free
> >> again. Better use the second last so there are always 2 valid mappings
> >> to choose from after a crash.
> >> 
> >> This would obviously need a lot more space than a bitmap but space is
> >> (relatively) cheap. One benefit imho should be that sync/barrier would
> >> not have to stop all activity on the raid to wait for the sync/barrier
> >> to finish. It just has to finalize the mapping for the commit and then
> >> can start a new in memory mapping while the finalized one writes to
> >> disk.
> >
> > While there is obviously real value in this functionality, I can't
> > help thinking that it belongs in the file system, not the block
> > device.
> 
> I believe it is the only way to actualy remove the race conditions
> inherent in software raid and there are some uses that don't work well
> with a filesystem. E.g. creating a filesystem with only a swapfile on
> it instead of using a raid device seems a bit stupid. Or for databases
> that use block devices.

I agree that it would remove some races, make resync unnecessary, and
thus remove the small risk of data loss when a system with a degraded
raid5 crashes.  I doubt it is the only way, and may not even be a good
way, though I'm not certain.

Your mapping of logical to physical blocks - it would technically need
to map each sector independently, but let's be generous (and fairly
realistic) and map each 4K block independently.
Then with a 1TB device, you have 2**28 entries in the table, each 4
bytes, so 2**30 bytes, or 1 gigabyte.
You suggest this table is kept in memory.  While memory is cheap, I
don't think it is that cheap yet.
So you would need to make compromises, either not keeping it all in
memory, or having larger block sizes (and so needing to pre-read for
updates), or having a more complicated data structure.  Or, more
likely, all of the above.

You could make it work, but there would be a performance hit.

Now look at your cases where a filesystem doesn't work well:
 1/ Swap.  That is a non-issue.  After a crash, the contents of swap
    are irrelevant.  Without a crash, the races you refer to are
    irrelevant.
 2/ Database that use block devices directly.   Why do they use the
    block device directly rather than using O_DIRECT to a
    pre-allocated file?  Because they believe that the filesystem
    introduces a performance penalty.  What reason is there to believe
    that the performance penalty of your remapped-raid would
    necessarily be less than that of a filesystem?  I cannot see one.


BTW an alternate approach to closing those races (assuming that I am
understanding you correctly) is to journal all updates to a separate
device.  Possible an SSD or battery-backed RAM.  That could have the
added benefit of reducing latency, though it may impact throughput.
I'm not sure if that is an approach with a real future either.  But it
is a valid alternate.

> 
> > But then I've always seen logical volume management as an interim hack
> > until filesystems were able to span multiple volumes in a sensible
> > way.  As time goes on it seems less and less 'interim'.
> >
> > I may well implement a filesystem that has this sort of
> > functionality.  I'm very unlikely to implement it in the md layer.
> > But you never know what will happen...
> 
> Zfs already does this. btrfs does it but only with raid1. But I find
> that zfs doesn't really integrate the two, it just has the raid and
> filesystem layer in a single binary but still as 2 seperate layers.
> Makes changing the layout inflexible, e.g. you can't grow from 4 to 5
> disks per stripe.

I thought ZFS was more integrated than that, but I haven't looked
deeply.
My vague notion what that when ZFS wanted to write "some data" it
would break it into sets of N blocks. calculate a parity block for
each N, then write those N+1 blocks to N+1 different devices,
where-ever there happened to be unused space.  Then the addresses of
those N+1 block would be stored in the file metadata which would be
written a similar way, possibly with a different(smaller) N.

This idea (which might be completely wrong) implies very tight
integration between the layers.

With this setup you could conceivably change the default N at any
time.  Old data wouldn't be relocated, but new writes would be written
with the new N.  If you have a background defragmentation process, it
could, over a period of time, arrange for the whole filesystem to be
re-laid out with the new N.

Clearly data would still be recoverable after a single drive failure.

The problem I see with this approach is the cost of recovering to a
hot-spare after device failure.  Finding which blocks need to be
written where would require scanning all the metadata on the entire
filesystem.  And much of this would not be contiguous.  So much
seeking would be involved.  I wouldn't be surprised if recovering a
device in a nearly-full filesystem took an order of magnitude longer
with that approach than with md style raid.

Given that observation: maybe I am wrong about RAID-Z.  However it is
the only model I can come up with that matches the various snippets I
have heard about it.

(hmm... maybe a secondary indexing scheme could help... might get it
down to taking only twice as long, with could be acceptable ....
maybe I will try implementing that after all and see how it
works... in my spare time)

NeilBrown

