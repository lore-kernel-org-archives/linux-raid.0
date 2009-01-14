From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Roadmap for md/raid ???
Date: Wed, 14 Jan 2009 15:43:05 -0500
Message-ID: <496E4E59.4090505@tmr.com>
References: <18763.7881.300921.177207@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18763.7881.300921.177207@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Not really a roadmap, more a few tourist attractions that you might
> see on the way if you stick around (and if I stick around)...
>
>   
Thanks for sharing, although that last comment is a little worrisome.

> Comments welcome.
>
>   
Here's one, is this in some sense a prioritized list? If so I might 
comment on the order, and I'm sure others would feel even more strongly 
than I. ;-)

> NeilBrown
>
>
> - Bad block list
>   The idea here is to maintain and store on each device a list of
>   blocks that are known to be 'bad'.  This effectively allows us to
>   fail a single block rather than a whole device when we get a media
>   write error.  Of course if updating the bad-block-list gives an
>   error we then have to fail the device.
>
>   
In terms of improving reliability this sounds good, and of course it's a 
required step toward doing data relocation in md instead of depending on 
the drive to do relocation. That's a comment, not a request or even 
suggestion, but in some cases it could open possibilities.

>   We would also record a bad block if we get a read error on a degraded
>   array.  This would e.g. allow recovery for a degraded raid1 where the
>   sole remaining device has a bad block.
>
>   An array could have multiple errors on different devices and just
>   those stripes would be considered to be "degraded".  As long a no
>   single stripe had too many bad blocks, the data would still be safe.
>   Naturally as soon as you get one bad block, the array becomes
>   susceptible to data loss on a single device failure, so it wouldn't
>   be advisable to run with non-empty badblock lists for an extended
>   length of time,  However it might provide breathing space until
>   drive replacement can be achieved.
>
> - hot-device-replace
>   This is probably the most asked for feature of late.  It would allow
>   a device to be 'recovered' while the original was still in service. 
>   So instead of failing out a device and adding a spare, you can add
>   the spare, build the data onto it, then fail out the device.
>
>   This meshes well with the bad block list.  When we find a bad block,
>   we start a hot-replace onto a spare (if one exists).  If sleeping
>   bad blocks are discovered during the hot-replace process, we don't
>   lose the data unless we find two bad blocks in the same stripe.
>   And then we just lose data in that stripe.
>
>   
This certainly is a solution to some growth issues, currently this can 
pretty well be done manually from a rescue boot, but not by the average 
user.

>   Recording in the metadata that a hot-replace was happening might be
>   a little tricky, so it could be that if you reboot in the middle,
>   you would have to restart from the beginning.  Similarly there would
>   be no 'intent' bitmap involved for this resync.
>
>   Each personality would have to implement much of this independently,
>   effectively providing a mini raid1 implementation.  It would be very
>   minimal without e.g. read balancing or write-behind etc.
>
>   There would be no point implementing this in raid1.  Just
>   raid456 and raid10.
>   It could conceivably make sense for raid0 and linear, but that is
>   very unlikely to be implemented.
>
> - split-mirror
>   This is really a function of mdadm rather than md.  It is already
>   quite possible to break a mirror into two separate single-device
>   arrays.  However it is a sufficiently common operation that it is
>   probably making it very easy to do with mdadm.
>   I'm thinking something like
>       mdadm --create /dev/md/new --split /dev/md/old
>
>   will create a new raid1 by taking one device off /dev/md/old (which
>   must be a raid1) and making an array with exactly the right metadata
>   and size.
>
> - raid5->raid6 conversion.
>    This is also a fairly commonly asked for feature.
>    The first step would be to define a raid6 layout where the Q block
>    was not rotated around the devices but was always on the last
>    device.  Then we could change a raid5 to a singly-degraded raid6
>    without moving any data.
>
>    The next step would be to implement in-place restriping. 
>    This involves 
>       - freezing a section of the array (all IO blocks)
>       - copying the data out to a safe backup
>       - copying it back in with the new layout
>       - updating the metadata to indicate that the restripe has
>         progressed.
>       - repeat.
>
>   
It would seem very safe, something like
 1 - call the chunk on the new drive the available space
 2 - determine what needs to be in the available space
 3 - if data, copy the data chunk to the available chunk, mark the old 
location avail, repeat step 2
 4 - Q goes in the available chunk, calculate it and the stripe is done
I don't see the move to a safe backup if you move one chunk at a time 
until you are ready for Q, unless there are moves I'm missing. You 
always have a free space to move one chunk, when all data is in the 
right place and the P value is in place (does it move?), then Q is 
calculated and saved. In other words, no out of stripe storage needed.

>    This would probably be quite slow but it would achieve the desired
>    result. 
>
>   
It would depend on how many moves were needed, I guess, but slow seems 
likely.
>    Once we have in-place restriping we could change chunksize as
>    well.
>
> - raid5 reduce number of devices.
>    We can currently restripe a raid5 (or 6) over a larger number of
>    devices but not over a smaller number of devices.  That means you
>    cannot undo an increase that you didn't want.
>
>   
The more common case might be that the prices are in free fall, and 
drives a few months old are obsolete and should be replaces with fewer 
and larger drives to save power and boost reliability.

>    It might be nice to allow this to happen at the same time as
>    increasing --size (if the devices are big enough) to allow the
>    array to be restriped without changing the available space.
>
> - cluster raid1
>    Allow a raid1 to be assembled on multiple hosts that share some
>    drives, so a cluster filesystem (e.g. ocfs2) can be run over it.
>    It requires co-ordination to handle failure events and
>    resync/recovery.  Most of this would probably be done in userspace.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


