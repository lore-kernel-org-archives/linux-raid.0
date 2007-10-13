From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5: weird size results after Grow
Date: Sat, 13 Oct 2007 13:42:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710131342040.32548@p34.internal.lan>
References: <47107DB5.10103@iki.fi> <4710C337.40708@tmr.com> <4710F021.30508@iki.fi>
 <4710FDAA.3050408@fatooh.org> <47110143.4060807@iki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47110143.4060807@iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Marko Berg <marko.berg@iki.fi>
Cc: Corey Hickey <bugfood-ml@fatooh.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 13 Oct 2007, Marko Berg wrote:

> Corey Hickey wrote:
>> Marko Berg wrote:
>>> Bill Davidsen wrote:
>>>> Marko Berg wrote:
>>>>> Any suggestions on how to fix this, or what to investigate next, would 
>>>>> be appreciated!
>>>>> 
>>>> I'm not sure what you're trying to "fix" here, everything you posted 
>>>> looks sane.
>>> 
>>> I'm trying to find the missing 300 GB that, as df reports, are not 
>>> available. I ought to have a 900 GB array, consisting of four 300 GB 
>>> devices, while only 600 GB are available. Adding the fourth device didn't 
>>> increase the capacity of the array (visible, at least). E.g. fdisk reports 
>>> the array size to be 900 G, but df still claims 600 capacity. Any clues 
>>> why?
>> 
>> df reports the size of the filesystem, which is still about 600GB--the 
>> filesystem doesn't resize automatically when the size of the underlying 
>> device changes.
>> 
>> You'll need to use resize2fs, resize_reiserfs, or whatever other tool is 
>> appropriate for your type of filesystem.
>> 
>> -Corey 
>
> Right, so this isn't one of my sharpest days... Thanks a bunch, Corey!
>
> -- 
> Marko
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Ah, already answered.

Justin.
