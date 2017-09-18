From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Mon, 18 Sep 2017 09:04:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org> <871sn78pzt.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871sn78pzt.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 16 Sep 2017, NeilBrown wrote:

> "Hiding" is a very vague term.  Should we get Harry Potter's
> invisibility cloak and wrap it around the hardware?
> Do we need to:
>  - remove from /proc/partitions - possible and possibly sane
>  - remove from from /dev - easy, given clear justification
>  - remove from /sys/block - I don't think this is justifiable
>  - make open() impossible - it already is if you use O_EXCL
> ??
>
> Possibly something sensible could be done, but we do need a clear
> statement of, and justification for, the customer requirement.

This is interesting.

On the IRC channel #linux-raid on freenode, we have frequent visitors who 
"oh, I happened to overwrite an active component drive with dd" or "I 
zero:ed the superblock on the active component by mistake" etc. So there 
is something to it to remove the "/dev/sd*" when they're part of an active 
md device.

However, this would cause problems when people are using for instance 
"smartctl" and equivalent ways to pull data from the devices. Same with 
mdadm -E.

Just thinking out loud, perhaps it would make sense to create some kind of 
hierarchy along the lines of "/proc/mapper/md0/" and put the components 
there for monitoring. However, I think it would be quite confusing for 
users if /dev/sd[b-f] disappeared as soon as it was put into an array. 
There is also the question about how to refer to these devices when 
manipulating with mdadm.

I don't have good answers, but I can say that there is user pain out there 
when they shoot themselves in the foot. If we can come up with a clever 
way to help them (without too many downsides), it'd be good.

If we could disable writing to the drives/partitions from regular 
userspace when they're handled by md, that could be some kind of middle 
ground. I guess most tools don't use O_EXCL.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
