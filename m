From: Chris Webb <chris@arachsys.com>
Subject: Re: Assume-clean for md grow
Date: Thu, 26 Feb 2009 15:57:43 +0000
Message-ID: <20090226155743.GM17577@arachsys.com>
References: <20090225142229.GI32722@arachsys.com> <c5fe66de938d528320cf21d8ca3c7a83.squirrel@neil.brown.name> <20090226145442.GH17577@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090226145442.GH17577@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Webb <chris@arachsys.com> writes:

> NeilBrown <neilb@suse.de> writes:
> 
> > Or if you want to be slightly more subtle, remove the
> > 	if (mddev->pers)
> > 		return -EBUSY;
> > from resync_start_store.  Then before a grow that you want to be
> > --assume-clean, write into /sys/block/mdXX/md/resync_start the
> > number of sectors in the final raid1 array.
> 
> Hi Neil. Thanks for this suggestion: it looks fine for what we're looking to
> achieve. Interestingly, this will mean writing a smaller value that shown by
> a read from this file for an in-sync array, but will still work?

For instance, 

  3# cat /sys/block/md127/{size,md/resync_start}
  2097136
  18446744073709551615

I just tried growing the slots up from 1G to 3G, then

  echo $((2097136 + 2*1024*1024*2)) >/sys/block/md127/md/resync_start
  mdadm --grow 3145720

but this gives me

  md127 : active raid1 dm-3[1] dm-2[0]
        3145720 blocks super 1.1 [2/2] [UU]
          resync=PENDING

in /proc/mdstat, which is presumably not right?

Does this sysfs file hold the size of the array or the size of the
components, for implementing the non-RAID1 case?

Also, if I don't know the size of the final array[1], is it safe to write a
value much larger than the size of the array in here, or will that cause
future grows to be clean when this isn't necessarily intended?

[1] One of the things which has been most awkward with using md as part of a
automated storage system has been going from component size to available
array size and back again, given that bitmap reservation depends on the
original size of the array not the current size of the array. (In the end,
we've cheated and always written everything in terms of change in component
size vs change in array size, and been generous with the amount of space we
allocate to components on initial device create. It does feel like I'm
coding far too much knowledge of the internal choices mdadm makes into my
management layer, though!)

Cheers,

Chris.
