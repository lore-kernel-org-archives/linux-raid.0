From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Any benefity to write intent bitmaps on Raid1
Date: Sat, 11 Apr 2009 09:08:39 -0400
Message-ID: <49E09657.4020809@tmr.com>
References: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net>	<18909.36541.447308.778177@notabene.brown>	<87myaqfily.fsf@frosties.localdomain>	<18911.2963.478861.845896@notabene.brown>	<87y6u7sxsi.fsf@frosties.localdomain>	<18912.11285.266605.223182@notabene.brown> <877i1rpogf.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877i1rpogf.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Neil Brown <neilb@suse.de>, Steven Ellis <steven@openmedia.co.nz>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Neil Brown <neilb@suse.de> writes:
>   
>
>> You could make it work, but there would be a performance hit.
>>
>> Now look at your cases where a filesystem doesn't work well:
>>  1/ Swap.  That is a non-issue.  After a crash, the contents of swap
>>     are irrelevant.  Without a crash, the races you refer to are
>>     irrelevant.
>>     
>
> What about suspend to swap?
>   

suspend is a "without a crash" case, I wouldn't want to restore from 
swap if the system failed to complete a clean shutdown.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


