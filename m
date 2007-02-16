From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Changing chunk size
Date: Fri, 16 Feb 2007 18:15:44 -0500
Message-ID: <45D63B20.2090605@tmr.com>
References: <45D4955C.60008@tmr.com> <17876.60347.983953.748979@notabene.brown> <45D5E05E.4000706@tmr.com> <45D5FCC7.7000503@maine.edu> <Pine.LNX.4.64.0702161428200.24249@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702161428200.24249@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Steve Cousins <steve.cousins@maine.edu>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Fri, 16 Feb 2007, Steve Cousins wrote:
>
>>
>>
>> Bill Davidsen wrote:
>>>
>>> I'm sure "slow" is a relative term, compared to backing up TBs of 
>>> data and trying to restore them. Not to mention the lack of 
>>> inexpensive TB size backup media. That's totally unavailable at the 
>>> moment, I'll live with what I have, thanks.
>>
>> You don't backup your RAID arrays?  Yikes! For certain data this 
>> would be fine (data that you can recreate easily) but it sounds like 
>> this isn't the case for you otherwise you'd just wipe the array and 
>> recreate the data. There are other modes of failure than just the 
>> drives themselves (file system corruption for instance) so it is wise 
>> to do backups, even on "redundant" systems.
>>
>> Good luck,
>>
>> Steve
>
> I agree here, RAID is no substitute for backups.
>
Neither is a 2nd copy on another machine, if it isn't something you can 
store off site, it's not a backup. One of the few things I liked about 
working for {a major telco} was that they had a "smoking hole" recovery 
policy, what do you do when the data center is a smoking hole. I don't 
get that kind of budget in other places.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

