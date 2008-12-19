From: "Chris Worley" <worleys@gmail.com>
Subject: Re: Roadmap for md/raid ???
Date: Fri, 19 Dec 2008 08:44:57 -0700
Message-ID: <f3177b9e0812190744g5bfd6341le87a30588ccee714@mail.gmail.com>
References: <18763.7881.300921.177207@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18763.7881.300921.177207@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How about "parallelized parity calculation"... given SSD I/O
performance, parity calculations are now the performance bottleneck.
Most systems have plenty of CPU's to do parity calculations in
parallel.  Parity calculations are embarrassingly parallel (no
dependence between the domains in a domain distribution).

Chris
On Thu, Dec 18, 2008 at 9:10 PM, Neil Brown <neilb@suse.de> wrote:
>
>
> Not really a roadmap, more a few tourist attractions that you might
> see on the way if you stick around (and if I stick around)...
>
> Comments welcome.
>
> NeilBrown
>
>
> - Bad block list
>  The idea here is to maintain and store on each device a list of
>  blocks that are known to be 'bad'.  This effectively allows us to
>  fail a single block rather than a whole device when we get a media
>  write error.  Of course if updating the bad-block-list gives an
>  error we then have to fail the device.
>
>  We would also record a bad block if we get a read error on a degraded
>  array.  This would e.g. allow recovery for a degraded raid1 where the
>  sole remaining device has a bad block.
>
>  An array could have multiple errors on different devices and just
>  those stripes would be considered to be "degraded".  As long a no
>  single stripe had too many bad blocks, the data would still be safe.
>  Naturally as soon as you get one bad block, the array becomes
>  susceptible to data loss on a single device failure, so it wouldn't
>  be advisable to run with non-empty badblock lists for an extended
>  length of time,  However it might provide breathing space until
>  drive replacement can be achieved.
>
> - hot-device-replace
>  This is probably the most asked for feature of late.  It would allow
>  a device to be 'recovered' while the original was still in service.
>  So instead of failing out a device and adding a spare, you can add
>  the spare, build the data onto it, then fail out the device.
>
>  This meshes well with the bad block list.  When we find a bad block,
>  we start a hot-replace onto a spare (if one exists).  If sleeping
>  bad blocks are discovered during the hot-replace process, we don't
>  lose the data unless we find two bad blocks in the same stripe.
>  And then we just lose data in that stripe.
>
>  Recording in the metadata that a hot-replace was happening might be
>  a little tricky, so it could be that if you reboot in the middle,
>  you would have to restart from the beginning.  Similarly there would
>  be no 'intent' bitmap involved for this resync.
>
>  Each personality would have to implement much of this independently,
>  effectively providing a mini raid1 implementation.  It would be very
>  minimal without e.g. read balancing or write-behind etc.
>
>  There would be no point implementing this in raid1.  Just
>  raid456 and raid10.
>  It could conceivably make sense for raid0 and linear, but that is
>  very unlikely to be implemented.
>
> - split-mirror
>  This is really a function of mdadm rather than md.  It is already
>  quite possible to break a mirror into two separate single-device
>  arrays.  However it is a sufficiently common operation that it is
>  probably making it very easy to do with mdadm.
>  I'm thinking something like
>      mdadm --create /dev/md/new --split /dev/md/old
>
>  will create a new raid1 by taking one device off /dev/md/old (which
>  must be a raid1) and making an array with exactly the right metadata
>  and size.
>
> - raid5->raid6 conversion.
>   This is also a fairly commonly asked for feature.
>   The first step would be to define a raid6 layout where the Q block
>   was not rotated around the devices but was always on the last
>   device.  Then we could change a raid5 to a singly-degraded raid6
>   without moving any data.
>
>   The next step would be to implement in-place restriping.
>   This involves
>      - freezing a section of the array (all IO blocks)
>      - copying the data out to a safe backup
>      - copying it back in with the new layout
>      - updating the metadata to indicate that the restripe has
>        progressed.
>      - repeat.
>
>   This would probably be quite slow but it would achieve the desired
>   result.
>
>   Once we have in-place restriping we could change chunksize as
>   well.
>
> - raid5 reduce number of devices.
>   We can currently restripe a raid5 (or 6) over a larger number of
>   devices but not over a smaller number of devices.  That means you
>   cannot undo an increase that you didn't want.
>
>   It might be nice to allow this to happen at the same time as
>   increasing --size (if the devices are big enough) to allow the
>   array to be restriped without changing the available space.
>
> - cluster raid1
>   Allow a raid1 to be assembled on multiple hosts that share some
>   drives, so a cluster filesystem (e.g. ocfs2) can be run over it.
>   It requires co-ordination to handle failure events and
>   resync/recovery.  Most of this would probably be done in userspace.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
