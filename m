From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: Write intent bitmaps
Date: Mon, 8 Jun 2009 10:51:54 -0300
Message-ID: <18989.6010.582386.812296@fisica.ufpr.br>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 21:10:
 >1. The write-intent bitmap seems to be rather similar to a file system
 >journal.  Are there any features of the bitmaps which distinguish them from
 >a journal, other than the fact they operate at the RAID layer, of course,
 >instead of the filesystem layer?

The bitmap doesn't have the info to be written, it's just a bit for
the whole region. The FS journal has the [journaled part of the] info,
which can be fully recovered later if necessary. Don't forget that
raid doesn't protect against unclean shutdowns; if the array is taken
down during a write, some disks may have the new version of the stripe
and others not. When it's resynced the parity will be recalculated
from what's on all disks, that is a mix of new and old versions of the
stripes. If later a disk fails before the blocks are re-written the
not-the-one-you-want parity will be used, and you'll have corruption.

 >2. On a RAID5 or RAID6 array, how much of a performance hit might I expect?

Depends on the chunk and where the bitmap is. With an internal one the
default chunk will cause a BIG hit. Fortunately it's very easy to try
different settings with the array live, so you can easily revert when
the world suddenly freezes around you... Our arrays are rather busy,
so performance is important and I gave up on it. If you can put it on
other disks I suppose it's possible to find a chunk size compatible
with performance.

 >3. The threads I have read all speak about the benefits during a power
 >failure.  Power failures are not the only source of dirty shutdowns,
 >however.  Are there any benefits to a bitmap for recovering a failed array
 >or a degraded array?  A resync can take more than a day, and the array is
 >vulnerable during that time.

That's the benefit and the purpose of the bitmap. Besides being
vulnerable during the resync, you also have a BIG performance hit if
your array is busy (or the resync takes forever), so it's worth trying.

 >4. How much space will be required for the bitmap on an external drive?

You decide it with the chunk size.

 >5. What happens if the bitmap is lost or the external drive fills up?

No idea.

 >6. Would it be best to allocate a small separate partition entirely for the
 >bitmap?

For performance what's important is to have the bitmap and array on
different disks. Having a filesystem exclusively for the bitmap might
avoid fragmentation but I suspect this is negligible in practice.
If the bitmap disks are being used for other things you'll have to
wait for the heads to come back, which may impact performance
noticeably.

 >If so, would ext2 probably be the best choice?

That's what the man page says. I find it strange since if it's a file
the filesystem shouldn't matter. Neil?

 >How does one guarantee the partition and filesystem will be
 >available prior to the assembly of the RAID array during boot?

Your boot process must guarantee it. If the bitmap is internal you get
it automatically from the kernel.
