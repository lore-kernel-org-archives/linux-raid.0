From: Kerin Millar <kerframil@gmail.com>
Subject: Re: raid10 make_request failure during iozone benchmark upon btrfs
Date: Sat, 07 Jul 2012 18:29:02 +0100
Message-ID: <4FF871DE.4060805@gmail.com>
References: <4FF108A8.6090606@gmail.com> <20120702125227.179c4343@notabene.brown> <4FF10E71.2090501@gmail.com> <20120703113943.3e4c43ad@notabene.brown> <4FF2554D.2040300@gmail.com> <20120703124727.6e2232d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120703124727.6e2232d1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/07/2012 03:47, NeilBrown wrote:

[snip]

> Thanks.  Looks like it is a btrfs bug - so a big "hello" to linux-btrfs :-)
>
> The symptom is that iozone on btrfs on md/raid10 can result in
>
> [  919.893454] md/raid10:md0: make_request bug: can't convert block across chunks or bigger than 256k 6653500160 256
> [  919.893465] btrfs: bdev /dev/mapper/vg0-test errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
>
>
> i.e. RAID10 has a 256K chunk size, but is getting 256K requests which overlap
> two chunks - the last half of one chunk and the first half of the next.
> That isn't allowed and raid10_mergeable_bvec, called by bio_add_page, should
> prevent it.
>
> However btrfs_map_bio() sets ->bi_sector to a new value without verifying
> that the resulting bio is still acceptable - which it isn't.
>
> The core problem is that you cannot build a bio for one location, then use it
> freely at another location.
> md/raid1 handles this by checking each addition to a bio against all the
> possible location that it might read/write it.  Maybe btrfs could do the
> same.
> Alternately we could work with Kent Overstreet (of bcache fame) to remove the
> restriction that the fs must make the bio compatible with the device -
> instead requiring the device to split bios when needed, and making it easy to
> do that (currently it is not easy).
> And there are probably other alternative.
>

Thanks very much for identifying the bug. I'm glad to find that the raid 
subsystem is not at fault. I'll give btrfs a spin at some point in the 
future and see whether anything has changed by then.

Cheers,

--Kerin
