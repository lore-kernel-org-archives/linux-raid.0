From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: raid5: degraded after reboot
Date: Fri, 12 Oct 2007 12:05:25 -0500
Message-ID: <cccedfc60710121005n5290822g3bf463e653405b99@mail.gmail.com>
References: <cccedfc60710120838nd2bb38pf57f03faa803b6c6@mail.gmail.com>
	 <20071012154755.GE21133@skl-net.de>
	 <cccedfc60710120908m24724867had038d9729d16efe@mail.gmail.com>
	 <20071012161809.GF21133@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071012161809.GF21133@skl-net.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You said you had to reboot your box using sysrq. There are chances you
> caused the reboot while all pending data was written to sdb4 and sdc4,
> but not to sda4. So sda4 appears to be non-fresh after the reboot and,
> since mdadm refuses to use non-fresh devices, it kicks sda4.

Can mdadm be told to use non-fresh devices?
What about sdb4: I can understand rewinding an event count (sorta),
but what does this mean:

mdadm: forcing event count in /dev/sdb4(1) from 327615 upto 327626

Since the array is degraded, there are 11 "events" missing from sdb4
(presumably sdc4 had them). Since sda4 is not part of the array, the
events can't be complete, can they?  Why jump *ahead* on events
instead of rewinding?


> Sure. I should have said: It's normal if one disk in a raid5 array is
> missing (or non-fresh).

I do not have a spare for this raid - I am aware of the risks and
mitigate them in other ways.

> To be precise, it means that the event counter for sda4 is less than
> the event counter on the other devices in the array. So mdadm must
> assume the data on sda4 is out of sync and hence the device can't be
> used. If you are not using bitmaps, there is no other way out than
> syncing the whole device, i.e. writing good data (computed from sdb4
> and sdc4) to sda4.
>
> Hope that helps.

Yes, that helps.

-- 
Jon
