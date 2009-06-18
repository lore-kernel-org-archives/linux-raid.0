From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Write intent bitmaps
Date: Thu, 18 Jun 2009 10:17:54 +0200
Message-ID: <874oue9cr1.fsf@frosties.localdomain>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
	<18989.6010.582386.812296@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18989.6010.582386.812296@fisica.ufpr.br> (Carlos Carvalho's
	message of "Mon, 8 Jun 2009 10:51:54 -0300")
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

carlos@fisica.ufpr.br (Carlos Carvalho) writes:

> Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 21:10:
>  >1. The write-intent bitmap seems to be rather similar to a file system
>  >journal.  Are there any features of the bitmaps which distinguish them from
>  >a journal, other than the fact they operate at the RAID layer, of course,
>  >instead of the filesystem layer?
>
> The bitmap doesn't have the info to be written, it's just a bit for
> the whole region. The FS journal has the [journaled part of the] info,
> which can be fully recovered later if necessary. Don't forget that
> raid doesn't protect against unclean shutdowns; if the array is taken
> down during a write, some disks may have the new version of the stripe
> and others not. When it's resynced the parity will be recalculated
> from what's on all disks, that is a mix of new and old versions of the
> stripes. If later a disk fails before the blocks are re-written the
> not-the-one-you-want parity will be used, and you'll have corruption.

Can that actualy happen? I would think the raid should refuse to
reassemble automatically if any one stripe does not have enough blocks
in sync. Just like when not enough disks are in sync without bitmap.

>  >2. On a RAID5 or RAID6 array, how much of a performance hit might I expect?
>
> Depends on the chunk and where the bitmap is. With an internal one the
> default chunk will cause a BIG hit. Fortunately it's very easy to try
> different settings with the array live, so you can easily revert when
> the world suddenly freezes around you... Our arrays are rather busy,
> so performance is important and I gave up on it. If you can put it on
> other disks I suppose it's possible to find a chunk size compatible
> with performance.

Worst case every write to the raid requires a write to the bitmap. So
your speed will be ~half. It is not (much) less than half though. You
could think that the seek to and from the bitmap must slow things down
even more but worst case is random access, which means there already
is a seek between each write. The bitmap just adds one write and one
seek for each write and seek.

The critical part seems to be the size one bit in the bitmap
covers. If you have 2 writes that are covered by the same bit then the
bit is only changed once. So the bigger the covered size the less
bitmap writes. On the other hand the benefits (specifically resyncs)
decrease with the covered size. Find a balance that works for you.

>  >3. The threads I have read all speak about the benefits during a power
>  >failure.  Power failures are not the only source of dirty shutdowns,
>  >however.  Are there any benefits to a bitmap for recovering a failed array
>  >or a degraded array?  A resync can take more than a day, and the array is
>  >vulnerable during that time.
>
> That's the benefit and the purpose of the bitmap. Besides being
> vulnerable during the resync, you also have a BIG performance hit if
> your array is busy (or the resync takes forever), so it's worth trying.

As long as the drives work again during reassembly it doesn't matter
what the cause of the failure was. It will only sync the parts
indicated by the bitmap. On the other hand if a drive fails and is
replaced there is no alternative to rewriting all of that drive.

One benefit of the bitmap during a full resync though is (afaik) that
the bitmap (better) indicates the amount done already. If the system
crashes and reboots the resync will resume instead of restart.

>  >4. How much space will be required for the bitmap on an external drive?
>
> You decide it with the chunk size.
>
>  >5. What happens if the bitmap is lost or the external drive fills up?
>
> No idea.

Afaik you can always start the raid without bitmap. If it is unclean
that means a full resync though. As for the external drive filling up
I don't think that has any effect, not with ext2. The bitmap uses a
fixed space on the disk and will never need more space. Even with a
completly full ext2 there should be no problem writing the bitmap.

>  >6. Would it be best to allocate a small separate partition entirely for the
>  >bitmap?
>
> For performance what's important is to have the bitmap and array on
> different disks. Having a filesystem exclusively for the bitmap might
> avoid fragmentation but I suspect this is negligible in practice.

From test I've done with some external enclosures there was absolutely
no difference between internal bitmap and external bitmap on a
partition on the same drive. But test it for your use case and
hardware.

Since the bitmap is only written once and then only rewritten just
make sure it is not fragmented to start with. Although it probably
doesn't matter even if it is.

> If the bitmap disks are being used for other things you'll have to
> wait for the heads to come back, which may impact performance
> noticeably.
>
>  >If so, would ext2 probably be the best choice?
>
> That's what the man page says. I find it strange since if it's a file
> the filesystem shouldn't matter. Neil?
>
>  >How does one guarantee the partition and filesystem will be
>  >available prior to the assembly of the RAID array during boot?
>
> Your boot process must guarantee it. If the bitmap is internal you get
> it automatically from the kernel.

MfG
        Goswin
