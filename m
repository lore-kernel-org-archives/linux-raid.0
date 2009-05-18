From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID0 - unitialised zone->dev_start for zone[0]
Date: Mon, 18 May 2009 10:45:20 -0400
Message-ID: <4A117480.4030401@tmr.com>
References: <37d33d830905131008y4a3a3815i6bec41a0d9b32ddf@mail.gmail.com> <beb1238841d24e553e0248080d5e4dca.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <beb1238841d24e553e0248080d5e4dca.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Thu, May 14, 2009 3:08 am, SandeepKsinha wrote:
>   
>> Hi Neil,
>>
>>
>> [22:33:46 sinhas]$ diff raid0.c raid0.c.orig
>>     
>
> Always, always, always use "diff -u".  It provides context
> so the diff is much easier to read.
>
>   
>> 160d159
>> <       zone->dev_start = 0;
>> [/usr/src/linux-2.6.29/drivers/md]
>> [22:33:59 sinhas]$
>>
>> I see this piece of code missing and being used later.
>> Not very sure of the code flow, but still as part of defensive
>> programming.
>>
>> Am i missing something?
>>     
>
> conf->strip_zone is allocated with kzalloc, so all values are
> initialised to 0.
>   

To prevent future unnecessary analysis of this section, perhaps a 
comment instead of code would be appropriate?


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


