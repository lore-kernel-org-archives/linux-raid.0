From: Asdo <asdo@shiftmail.org>
Subject: Re: Safely swapping a disk in a RAID456
Date: Sat, 01 Oct 2011 12:32:07 +0200
Message-ID: <4E86EC27.7020806@shiftmail.org>
References: <20110930154217.GA11732@albatross.gern.madduck.net>
 <4E860435.5040902@yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4E860435.5040902@yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/30/11 20:02, John Robinson wrote:
>
> Not yet, but it's in the roadmap as a hot-replace. In the mean time, 
> you can do something very similar by hand with almost no lost of 
> redundancy, if your RAID456 has a bitmap.
> ...
>
> I'd be glad to hear of any "real" RAID card that made it easier, or 
> even possible.
>
> Something along the lines of:
>
> # briefly remove your disc from the array
> mdadm --manage /dev/md_raid456 --remove /dev/the_disc_i_want_to_remove
> # make a temp raid1 with only the one disc, using build so metadata is
> # only in RAM and nothing is written to the disc
> mdadm --build /dev/md_temp_raid1 --level 1 
> /dev/the_disc_i_want_to_remove missing
> # now re-add something which looks identical to your original disc,
> # but is actually a single-sided mirror, back into the array
> # the above can all be done very quickly so your raid456 only runs
> # without a drive for seconds
> mdadm --manage /dev/md_raid456 --re-add /dev/md_temp_raid1
> # now get md to make a mirror (copy) to the new disc
> mdadm --manage /dev/md_temp_raid1 --add /dev/the_new_disc
> # wait for it to finish, or just wait for it yourself
> mdadm --wait /dev/md_temp_raid1
> # and switch back again: remove the temporary raid1
> mdadm --manage /dev/md_raid456 --remove /dev/md_temp_raid1
> # stop it so the new disc becomes available again
> mdadm --stop /dev/md_temp_raid1
> # and put the new disc which is now a complete copy of the old one
> # back in to the array
> mdadm --manage /dev/md_raid456 --re-add /dev/the_new_disc
> # and you're done

Very good, but...

> This is all fine if your old disc has no faulty sectors. If it does 
> have, you need more help from someone much more clued-up than me 
> (because it is already possible to do partial rebuilds by manipulating 
> /sys), 

This is the problem. And if you want to replace a drive, it's probably 
because it has bad sectors.

I think that during raid1 device-add (which automatically initiates 
rebuild of raid1), the raid1 would go down completely as soon as it hits 
bad sectors.

So you wouldn't be in a position to use rebuilds by /sys "afterwards", 
because there is no "afterwards".

For this to work, somebody would need to implement the bad block list 
also on the legacy array without metadata (--build), so that the raid1 
would stay up even on bad reads during its rebuild. Actually I don't 
know if Neil implemented that or not, I have not tested bad blocks list 
yet, I am intuitively assuming that he improved only the last version of 
the arrays, that is 1.x .

> or mdadm's roadmap feature of hot-replace, which will do the above and 
> also automatically perform partial rebuilds from the rest of the array 
> when the old disc has bad sectors.

the hot-replace is the most wanted feature as of now.
