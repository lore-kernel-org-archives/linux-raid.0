From: Marko Berg <marko.berg@iki.fi>
Subject: Re: RAID 5: weird size results after Grow
Date: Sat, 13 Oct 2007 20:32:51 +0300
Message-ID: <47110143.4060807@iki.fi>
References: <47107DB5.10103@iki.fi> <4710C337.40708@tmr.com> <4710F021.30508@iki.fi> <4710FDAA.3050408@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4710FDAA.3050408@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Corey Hickey wrote:
> Marko Berg wrote:
>> Bill Davidsen wrote:
>>> Marko Berg wrote:
>>>> Any suggestions on how to fix this, or what to investigate next, 
>>>> would be appreciated!
>>>>
>>> I'm not sure what you're trying to "fix" here, everything you posted 
>>> looks sane.
>>
>> I'm trying to find the missing 300 GB that, as df reports, are not 
>> available. I ought to have a 900 GB array, consisting of four 300 GB 
>> devices, while only 600 GB are available. Adding the fourth device 
>> didn't increase the capacity of the array (visible, at least). E.g. 
>> fdisk reports the array size to be 900 G, but df still claims 600 
>> capacity. Any clues why?
>
> df reports the size of the filesystem, which is still about 600GB--the 
> filesystem doesn't resize automatically when the size of the 
> underlying device changes.
>
> You'll need to use resize2fs, resize_reiserfs, or whatever other tool 
> is appropriate for your type of filesystem.
>
> -Corey 

Right, so this isn't one of my sharpest days... Thanks a bunch, Corey!

-- 
Marko
