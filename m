From: "NeilBrown" <neilb@suse.de>
Subject: Re: Assume-clean for md grow
Date: Thu, 26 Feb 2009 06:34:16 +1100 (EST)
Message-ID: <c5fe66de938d528320cf21d8ca3c7a83.squirrel@neil.brown.name>
References: <20090225142229.GI32722@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090225142229.GI32722@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, February 26, 2009 1:22 am, Chris Webb wrote:
> I use md arrays made up of slots synthesized through device mapper from
> physical storage distributed across a cluster of machines. When these
> slots
> are created, they are guaranteed to be zero-initialised, so I can safely
> do
> mdadm --create --assume-clean to avoid an initial resync.
>
> When I grow the backing slots, the new storage space is also
> zero-initialised, so I'd like to be able to do the equivalent of
> mdadm --grow --size=max --assume-clean. However, --assume-clean isn't
> supported for grow operations.
>
> Is there some way I can tell the kernel driver (perhaps through sysfs)
> that
> the resync is clean/already complete to avoid unnecessary heavy IO on
> every
> grow? I tried things like
>
>   echo idle >/sys/block/mdX/md/sync_action
>
> without success.

No, there isn't any way do get --grow to --assume-clean.
And I cannot immediately think of a neat way to implement it.
I'll have a think about it and let you know if I come up with anything.

If you want to hack your own kernel, you could just remove the
		mddev->recovery_cp = mddev->dev_sectors;
from raid1_resuze (Assuming it is raid1 arrays that you are growing).
Then the resync-after-grow would never happen.

Or if you want to be slightly more subtle, remove the
	if (mddev->pers)
		return -EBUSY;
from resync_start_store.  Then before a grow that you want to be
--assume-clean, write into /sys/block/mdXX/md/resync_start the
number of sectors in the final raid1 array.

That last might be the way I end up doing it, but I'm not sure yet.

NeilBrown

