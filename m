From: Nix <nix@esperi.org.uk>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Fri, 23 Jun 2006 20:45:47 +0100
Message-ID: <87veqrk650.fsf@hades.wkstn.nix>
References: <87wtbbjxd4.fsf@hades.wkstn.nix> <871wtgl419.fsf@hades.wkstn.nix>
	<17563.41604.667253.877348@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17563.41604.667253.877348@cse.unsw.edu.au> (Neil Brown's message of "Fri, 23 Jun 2006 18:12:52 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Jun 2006, Neil Brown mused:
> On Friday June 23, nix@esperi.org.uk wrote:
>> On 20 Jun 2006, nix@esperi.org.uk prattled cheerily:
>> > For some time, mdadm's been dumping core on me in my uClibc-built
>> > initramfs. As you might imagine this is somewhat frustrating, not least
>> > since my root filesystem's in LVM on RAID. Half an hour ago I got around
>> > to debugging this.
>> 
>> Ping?
> 
> No, but I do know someone by that name.....

Sorry, I'm pinging all the patches I've sent out in the last few weeks
and this one was on my hit list :)

> Yeh, it's on my todo list. 

Agreed.

> I suspect I would rather make mdadm not dump core of ftw isn't
> available.

It was... surprising. I'm still not sure how I ever made it work without
this fxi; the first uClibc-based initramfs I ever rolled had mdadm 2.3.1
in it and a `DEVICE partitions', and there was no core dump. A mystery.

> Is there some #define in an include file which will allow me to tell
> if the current uclibc supports ftw or not?

I misspoke: ftw was split into multiple files in late 2005, but it was
originally added in September 2003, in time for version 0.9.21.

Obviously the #defines in <ftw.h> don't exist before that date, but
that's a bit late to check, really.

<features.h> provides the macros __UCLIBC_MAJOR__, __UCLIBC_MINOR__, and
__UCLIBC_SUBLEVEL__: versions above 0.9.20 appear to support ftw()
(at least, they have the function, in 32-bit form at least, which
is certainly enough for this application!)

> (and I'm more like to reply to mail if it the "To" or "Cc" line
>  mentions me specifically - it's less likely to get lost that way).

OK.

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
