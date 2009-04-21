From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Proposal: make RAID6 code optional
Date: Tue, 21 Apr 2009 09:58:54 -0400
Message-ID: <49EDD11E.2030309@tmr.com>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090418145850.GD28512@mea-ext.zmailer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Matti Aarnio wrote:
> On Sat, Apr 18, 2009 at 03:56:17PM +0200, Jesper Juhl wrote:
>   
>> On Sat, 18 Apr 2009, Prakash Punnoor wrote:
>>     
>>> On Samstag 18 April 2009 10:09:54 Michael Tokarev wrote:
>>>       
>>>> Prakash Punnoor wrote:
>>>>         
> .....
>   
>>>> What's your goal?  What's the problem you're trying to solve?
>>>>         
>>> Having duplicate code is not good, of course. But unused code is also not 
>>> good. As I said, I only use RAID5, so I don't need RAID6 support. The RAID6 
>>> support enlarges kernel (the built-in.o in drivers/md grows from 325kb to 
>>> 414kb in my case), making boot time and compile time longer 
>>>       
>> By a few ms perhaps - nothing that you'd ever notice in real life... A 
>> small price to pay for the shared code. If you were to split them all 
>> again, the combined total size would be greater still.
>>     
>
>
> I did quick "sum of symbol sizes" lookup of the   raid.ko, and got
> it like this:
>
> nm -t d -n -S /lib/modules/2.6.27.21-170.2.56.fc10.x86_64/kernel/drivers/md/raid456.ko | grep raid4|awk '{print $2}'|sed -e 's/^0*//g'|awk '{sum+=$1}END{print sum}'
>   ...
>
> raid4:   152
> raid5:  7165
> raid6: 75558
>
> Entire 64kB of that raid6 is single pre-initialized r/o datablock:  raid6_gfmul
>
>   
It would seem that that space could be allocated and populated when 
raid6 was first used, as part of the initialization. I haven't looked at 
that code since it was new, so I might be optimistic about doing it that 
way.

> So yes, having RAID6 personality as separate module would be appropriate for
> systems that are only interested in RAID4 or RAID5.  Separating the RAID4
> personality wastes space, separating RAID5 ...  barely 2 of 4k memory pages.
>
> There are perhaps a few kB more of codes for RAID5 and RAID6 classes - not all
> local functions at each are named with relevant prefix,  but overall I would
> consider extracting RAID6 as a reasonable goal with common codes on RAID4/5.
>
>   
>>> - admittedly not 
>>> by a big margin. But then again I could argue: Why not put RAID0,1,10,4,5,6 
>>> into one big module? Makes no sense, huh? 
>>>       
>> Makes perfect sense to me. Just modprobe raid.o and you have all 
>> raid levels available. That would make a lot of sense. 
>>     
>
> Also, systems with so many disks that they run RAID4/5/6 to begin with are
> likely to have enough memory so that "wasted" 75-80 kB does not matter.
>   

Everything matters. "Take care of the pennies and the dollars will take 
care of themselves" is not just an old German proverb.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


