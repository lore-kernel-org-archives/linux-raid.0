From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Wed, 15 Jul 2015 12:12:34 +1000
Message-ID: <20150715121234.22803890@noble>
References: <cover.1435094582.git.shli@fb.com>
	<20150708115636.6c972269@noble>
	<20150708054344.GA2709238@devbig257.prn2.facebook.com>
	<20150710092119.297fd9e1@noble>
	<20150710040847.GA1408097@devbig257.prn2.facebook.com>
	<20150710143656.4ee7e647@noble>
	<20150715004455.GA1024035@devbig257.prn2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150715004455.GA1024035@devbig257.prn2.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Tue, 14 Jul 2015 17:45:04 -0700 Shaohua Li <shli@fb.com> wrote:

> On Fri, Jul 10, 2015 at 02:36:56PM +1000, NeilBrown wrote:

> > Yes it does.  Having a single sort of metadata block is an important
> > part of the goal.  How the code actually chooses to use these is a
> > separate issue that can change harmlessly.
> 
> Taking a close look to reuse MD superblock for caching. It turns out to
> be quite hacky. Suppose I use md_update_sb to update superblock when we
> checkpoint the log. So I update corresponding fields of mddev
> (resync_offset, recovery_offset). In md_update_sb, I must add a bunch of
> 'if (caching_disk) xxx' as raid disks shouldn't store the
> resync_offset/recovery_offset. Or I can add a new cache_update_sb, but I
> thought I must add the same hack code if we don't duplicate a lot of
> code.

in md_update_sb, in the loop:


	/* First make sure individual recovery_offsets are correct */
	rdev_for_each(rdev, mddev) {
		if (rdev->raid_disk >= 0 &&
		    mddev->delta_disks >= 0 &&
		    !test_bit(In_sync, &rdev->flags) &&
		    mddev->curr_resync_completed > rdev->recovery_offset)
				rdev->recovery_offset = mddev->curr_resync_completed;

	}

add something like:
               else if (rdev->is_cache)
                        rdev->recovery_offset =
                        mddev->cache->latest_checkpoint


In super_1_sync, where the code:

	if (rdev->raid_disk >= 0 &&
	    !test_bit(In_sync, &rdev->flags)) {
		sb->feature_map |=
			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
		sb->recovery_offset =
			cpu_to_le64(rdev->recovery_offset);
		if (rdev->saved_raid_disk >= 0 && mddev->bitmap)
			sb->feature_map |=
				cpu_to_le32(MD_FEATURE_RECOVERY_BITMAP);
	}

is, add something like
	else if (rdev->is_a_cache_disk) {
              sb->feature_map |= MD_FEATURE_IMA_CACHE;
              sb->recovery_offset = cpu_to_le64(rdev->recovery_Offset);
        }

or just make the original code a little more general - I'm not sure
exactly how you flag the cache device.

You don't need to do this every time you checkpoint the log.  The
pointer just needs to point to somewhere in the log so that the
start/end can be found (each metadata block points to the next one).
You could leave it until the log wraps completely, though that probably
isn't ideal.

So when you checkpoint the log, if the ->recovery_offset of the cache
device is more than (say) 25% behind the new checkpoint location, just
set MD_CHANGE_PENDING and wake the md thread.

I don't see that as particularly hackish.

Thanks,
NeilBrown


> 
> Adding a superblock for caching looks better. A 4k page data doesn't
> increase any complexity. If you think we shouldn't duplicate too fileds
> of md superblock to the cache superblock, we can store the most
> necessary data in cache superblock.
> 
> Thanks,
> Shaohua

