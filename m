From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Wed, 15 Jul 2015 14:06:41 +1000
Message-ID: <20150715140641.3c61cf78@noble>
References: <cover.1435094582.git.shli@fb.com>
	<20150708115636.6c972269@noble>
	<20150708054344.GA2709238@devbig257.prn2.facebook.com>
	<20150710092119.297fd9e1@noble>
	<20150710040847.GA1408097@devbig257.prn2.facebook.com>
	<20150710143656.4ee7e647@noble>
	<20150715004455.GA1024035@devbig257.prn2.facebook.com>
	<20150715121234.22803890@noble>
	<20150715031615.GA1292235@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150715031615.GA1292235@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Tue, 14 Jul 2015 20:16:17 -0700 Shaohua Li <shli@fb.com> wrote:

> On Wed, Jul 15, 2015 at 12:12:34PM +1000, NeilBrown wrote:
> > On Tue, 14 Jul 2015 17:45:04 -0700 Shaohua Li <shli@fb.com> wrote:
> > 
> > > On Fri, Jul 10, 2015 at 02:36:56PM +1000, NeilBrown wrote:
> > 
> > > > Yes it does.  Having a single sort of metadata block is an important
> > > > part of the goal.  How the code actually chooses to use these is a
> > > > separate issue that can change harmlessly.
> > > 
> > > Taking a close look to reuse MD superblock for caching. It turns out to
> > > be quite hacky. Suppose I use md_update_sb to update superblock when we
> > > checkpoint the log. So I update corresponding fields of mddev
> > > (resync_offset, recovery_offset). In md_update_sb, I must add a bunch of
> > > 'if (caching_disk) xxx' as raid disks shouldn't store the
> > > resync_offset/recovery_offset. Or I can add a new cache_update_sb, but I
> > > thought I must add the same hack code if we don't duplicate a lot of
> > > code.
> > 
> > in md_update_sb, in the loop:
> > 
> > 
> > 	/* First make sure individual recovery_offsets are correct */
> > 	rdev_for_each(rdev, mddev) {
> > 		if (rdev->raid_disk >= 0 &&
> > 		    mddev->delta_disks >= 0 &&
> > 		    !test_bit(In_sync, &rdev->flags) &&
> > 		    mddev->curr_resync_completed > rdev->recovery_offset)
> > 				rdev->recovery_offset = mddev->curr_resync_completed;
> > 
> > 	}
> > 
> > add something like:
> >                else if (rdev->is_cache)
> >                         rdev->recovery_offset =
> >                         mddev->cache->latest_checkpoint
> > 
> > 
> > In super_1_sync, where the code:
> > 
> > 	if (rdev->raid_disk >= 0 &&
> > 	    !test_bit(In_sync, &rdev->flags)) {
> > 		sb->feature_map |=
> > 			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
> > 		sb->recovery_offset =
> > 			cpu_to_le64(rdev->recovery_offset);
> > 		if (rdev->saved_raid_disk >= 0 && mddev->bitmap)
> > 			sb->feature_map |=
> > 				cpu_to_le32(MD_FEATURE_RECOVERY_BITMAP);
> > 	}
> > 
> > is, add something like
> > 	else if (rdev->is_a_cache_disk) {
> >               sb->feature_map |= MD_FEATURE_IMA_CACHE;
> >               sb->recovery_offset = cpu_to_le64(rdev->recovery_Offset);
> >         }
> > 
> > or just make the original code a little more general - I'm not sure
> > exactly how you flag the cache device.
> > 
> > You don't need to do this every time you checkpoint the log.  The
> > pointer just needs to point to somewhere in the log so that the
> > start/end can be found (each metadata block points to the next one).
> > You could leave it until the log wraps completely, though that probably
> > isn't ideal.
> > 
> > So when you checkpoint the log, if the ->recovery_offset of the cache
> > device is more than (say) 25% behind the new checkpoint location, just
> > set MD_CHANGE_PENDING and wake the md thread.
> > 
> > I don't see that as particularly hackish.
> 
> The policy above about when superblock should be written is fine with
> me, but I'd like to focus on where/how superblock should be written
> here. I'd say exporting a structure of cache (the
> cache->latest_checkpoint) to generic MD layer is very hackish.

OK, get the cache code to write the desired value into the
recovery_offset field, so the md code only has to look at that.
The core md code does still need to know there is a cache, and which is
the cache device - it cannot be completely unaware...

> md_update_sb writes all raid disks, that's bad since we just want to
> update cache disk.

How bad?  How often?  Would you really be able to notice?

And having a per-device "update superblock" flag is not completely out
of the question.  RAID10 could benefit from the clean/dirty state being
localized to the device which was actually dirty.

>                    Overloading some fields of MD superblock and using
> them with some 'if (cache)' stuff is not natural way too.

If we could foresee everything, we could assign everything its own
field.  But unfortunately I didn't.  That is why we have feature bits.
Different feature bits mean different fields have different meanings.


>                                                           I don't
> understand why you object adding a superblock for cache. The advantage
> is it's self contained. And there is nothing about
> complexity/maintaince, as we can store the most necessary fields into
> the superblock.

Because there is precisely 1 number that needs to be stored in the
superblock, and there seems no point having a superblock just to store
one number.
It isn't much extra complexity, but any extra thing is still an extra
thing.
Having the data section of the log device containing just a log is
elegant.  Elegant is good.
If we decided that keeping two copies for superblocks was a good idea
(which I think it is, I just haven't created a "v1.3" layout yet), then
re-using the main superblock for the head-of-log pointer would instantly
give us two copies of that as well.

NeilBrown
