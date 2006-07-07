From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Strange intermittant errors + RAID doesn't fail the disk.
Date: Fri, 7 Jul 2006 10:58:07 +0200 (MEST)
Message-ID: <Pine.GSO.4.64.0607071049000.18452@montezuma.acc.umu.se>
References: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
 <17573.52096.655463.808666@cse.unsw.edu.au>
 <bb145bd20606302313x557f94d8xd69cce83731e2a4b@mail.gmail.com>
 <bb145bd20607060601x33519be7tb4c4812ab54cc7c@mail.gmail.com>
 <17581.35131.123710.652968@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17581.35131.123710.652968@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christian Pernegger <pernegger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Jul 2006, Neil Brown wrote:

> On Thursday July 6, pernegger@gmail.com wrote:
>>>> I suggest you find a SATA related mailing list to post this to (Look
>>>> in the MAINTAINERS file maybe) or post it to linux-kernel.
>>
>> linux-ide couldn't help much, aside from recommending a bleeding-edge
>> patchset which should fix a lot of things SATA:
>> http://home-tj.org/files/libata-tj-stable/
>>
>> What fixed the error, though, was exchanging one of the cables. (Just
>> my luck, it was new and supposedly quality, ... oh well)
>>
>> I'm still interested in why the md code didn't fail the disk. While it
>> was 'up' any access to the array would hang for a long time,
>> ultimately fail and corrupt the fs to boot. When I failed the disk
>> manually everything was fine (if degraded) again.
>
> md is very dependant on the driver doing the right thing.  It doesn't
> do any timeouts or anything like that - it assumes the driver will.
> md simply trusts the return status from the drive, and fails a drive
> if and only if a write to the drive is reported as failing (if a read
> fails, md trys to over-write with good data first).

Hmm.. Perhaps a bit of extra logic there might be good? If you try to 
re-write the failing bit with good data, try to read the recently written 
data back (perhaps after a bit of wait). If that still fails, then fail 
the disk.

If it can't remember recently written data, it is clearly unsuitable for a 
running system. But the occasional block going bad (and getting remapped 
at a write) wouldn't trigger it.

/Mattias Wadenstein
