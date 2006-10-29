From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 0 breakage (maybe)
Date: Mon, 30 Oct 2006 09:03:31 +1100
Message-ID: <17733.9523.946779.424799@cse.unsw.edu.au>
References: <1162100400.17928.9.camel@stoneburner.xwredwing.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Matt Thrailkill on Saturday October 28
Sender: linux-raid-owner@vger.kernel.org
To: Matt Thrailkill <matt@modestolan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 28, matt@modestolan.com wrote:
> Hi.
> 
> Last night, I upgraded from Ubuntu 6.06 to Ubuntu 6.10.  I have a Linux
> sw raid0 running on two drives, just using the raw devices rather than
> any partitions on them.  The Ubuntu 6.06 kernel would simply see the
> superblocks on boot and start up the array automagically for me.  The
> 6.10 kernel does not.  I don't know if this is an Ubuntu thing, a Linux
> kernel issue (2.6.17 now), or something else.
> 
> I try and start my array by hand with mdadm, and I get weird stuff.
> Basically, check this out:
> root@stoneburner:~# mdadm --assemble /dev/md0 /dev/hde /dev/hdi
> mdadm: cannot open device /dev/hde: Device or resource busy

This is telling you that /dev/hde - or one of it's partitions - is
"Busy".  This means more than just 'open'.  It means mounted or
included in an md or dm array, or used for swap.
You need to find out what is keeping it busy.
Most likely dm or md.
What does
  cat /proc/mdstat
show?
I don't know much about dm - is there some 'pvlist' command or similar
that will show all the phys volumes it is holding on to..

Or possibly just look in /sys/block/hde/holders

NeilBrown
