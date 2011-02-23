From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md road-map: 2011
Date: Wed, 23 Feb 2011 18:06:39 +1300
Message-ID: <1298437599.24479.6030.camel@localhost.localdomain>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Wed, 2011-02-16 at 21:27 +1100, NeilBrown wrote:

> Bitmap of non-sync regions.
> ---------------------------

> The granularity of the bit is probably quite hard to get right.
> Having it match the block size would mean that no resync would be
> needed and that every discard request could be handled exactly.
> However it could result in a very large bitmap - 30 Megabytes for a 1
> terabyte device with a 4K block size.  This would need to be kept in
> memory and looked up for every access, which could be problematic.
> 
Why not store the map as a list of regions defined by:
<start address><finish address>.  This may provide a better performance
vs (storage+memory) cost implementation when compared with a bitmap
which has a granularity vs storage problem.

It may well be more efficient to store a range list then a bitmap and
makes granularity a non-issue as granularity will be at blocksize.   The
limitation with this scheme is in choosing the size of the map, and the
larger the map the more regions that can be stored before no longer
being able to add new discards or splits (due to a write somewhere in
the middle of a non-sync region).  However this could be handled to
retain the best performance by ensuring that the largest non-sync
regions are always in the list

If we used full LBA48 addressing we could count on for each entry
in the map to 12bytes (2x48bit).  (Perhaps this could be reduced for
smaller devices that need less address bits.)  This would mean 85.3
entries per kB, or 87381.33 per Mb of map size on disk (excluding
possible headers).  In the case of a 1Tb raid volume a 1Mb map provide
roughly 1 entry for every 13Mb of disk space.  This sounds coarse but
when you consider you are setting regions based in units of the media's
block size it's not.  Furthermore once the filesystem is that fragmented
that you've exhausted the map space, the unhandled non-sync|discarded
regions would be so small that you'd gain little benefit from it.  A bit
of logic could ensure that large regions take precedence over smaller
regions, as this will provide the best performance for resync/check
passes.

Another benefit is that it makes it easy for md to be-able to pass
TRIM instructions down to media that support this feature whenever a
region/stripe is marked as non-sync.  In the case of raid levels
0 and linear there would be no need for a map and TRIM could be passed
through to the media.  For Raid1,10 a TRIM would be issued to the media
whenever a chunk is contained entirely within a non-sync region. With
raid456, a TRIM would only be issued when a whole stripe is contained
within a non-sync region.

The real beauty of this region map is that creation of a new raid volume
could (unless --assume-clean is set) mark the entire volume as non-sync
with a single entry in the list.

Of course this suggestion is only theoretical, and I might be way off on
the implementation cost vs benefits and feasability.

Regards,
-- 
Daniel Reurich.

Centurion Computer Technology (2005) Ltd
Mobile 021 797 722




