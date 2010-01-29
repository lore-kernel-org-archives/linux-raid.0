From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Swapping a disk without degrading an array
Date: Fri, 29 Jan 2010 16:35:47 +0100
Message-ID: <87tyu4zzxo.fsf@frosties.localdomain>
References: <1264421475.30742.49.camel@test.apertos.eu>
	<20100129221904.439e2afe@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129221904.439e2afe@notabene> (Neil Brown's message of "Fri,
	29 Jan 2010 22:19:04 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> So time to start:  with a little design work.
>
> 1/ The start of the array *must* be recorded in the metadata.  It we try to
>    create a transparent whole-device copy then we could get confused later.
>    So let's (For now) decide not to support 0.90 metadata, and support this
>    in 1.x metadata with:
>      - a new feature_flag saying that live spares are present
>      - the high bit set in dev_roles[] means that this device is a live spare
>        and is only in_sync up to 'recovery_offset'

Could the bitmap be used here too?

> 2/ in sysfs we currently identify devices with a symlink
>      md/rd$N -> dev-$X
>    for live-spare devices, this would be
>      md/ls$N -> dev-$X
>
> 3/ We create a live spare by writing 'live-spare' to md/dev-$X/state
>    and an appropriate value to md/dev-$X/recovery_start before setting
>    md/dev-$X/slot
>
> 4/ When a device is failed, if there was a live spare is instantly takes
>    the place of the failed device.

Some cases:

1) the mirroring is still going and the error is in a in-sync region

I think setting the drive to write-mostly and keeping it is better than
kicking the drive and requireing a re-sync to get the live-spare active.

2) the mirroring is still going and the error is in a out-of-sync region

If the erorr is caused by the mirroring itself then the block can also
be restored from parity and then goto 1. But if it happens often fail
the drive anyway as the errors cost too much time. Otherwise, unless we
have bitmaps to first repair the region covered by the bit and then goto
1, there is not much we can do here. Fail the drive.

It would be good to note that the being mirrored disk had faults and
imediatly fail it when the mirroring is complete.

Also the "often" above should be configurable and include a "never"
option. Say you have 2 disks that are damaged at different locations. By
creating a live-spare with "never" the mirroring would eventualy succeed
and repair the raid while kicking a disk would cause data loss.

3) the mirroring is complete

No sense keeping the broken disk, fail it and use the live-spare
instead. Mdadm should probably have an option to automatically remove
the old disk once the mirroring is done for a live spare.

> 5/ This needs to be implemented separately in raid10 and raid456.
>    raid1 doesn't really need live spares  but I wouldn't be totally against
>    implementing them if it seemed helpful.

Raid1 would only need the "create new mirror without failing existing
disks" mode. The disks in a raid1 might all be damages but in different
locations.

> 6/ There is no dynamic read balancing between a device and its live-spare.
>    If the live spare is in-sync up to the end of the read, we read from the
>    live-spare, else from the main device.

So the old drive is write-mostly. That makes (1) above irelevant.

> 7/ writes transparently go to both the device and the live-spare, whether they
>    are normal data writes or resync writes or whatever.
>
> 8/ In raid5.h struct r5dev needs a second 'struct bio' and a second
>    'struct bio_vec'.
>    'struct disk_info' needs a second mdk_rdev_t.
>
> 9/ in raid10.h mirror_info needs another mdk_rdev_t and the anon struct in 
>    r10bio_s needs another 'struct bio *'.
>
> 10/ Both struct r5dev and r10bio_s need some counter or flag so we can know
>     when both writes have completed.
>
> 11/ For both r5 and r10, the 'recover' process need to be enhanced to just
>     read from the main device when a live-spare is being built.
>     Obviously if this fail there needs to be a fall-back to read from
>     elsewhere.

Shouldn't recover read from the live-spare where the live-spare already
is in-sync and the main drive otherwise?

> Probably lots more details, but that might be enough to get me (or someone)
> started one day.
>
> There would be lots of work to do in mdadm too of course to report on these
> extensions and to assemble arrays with live-spares..
>
> NeilBrown

MfG
        Goswin
