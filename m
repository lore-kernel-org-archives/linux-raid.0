From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Building a new raid6 with bitmap does not clear bits during resync
Date: Wed, 14 Nov 2007 10:33:40 -0500
Message-ID: <473B1554.2050608@tmr.com>
References: <87lk98ad7e.fsf@informatik.uni-tuebingen.de>	<18231.62186.908021.981786@notabene.brown>	<47387137.7000401@tmr.com> <18232.53770.923521.968923@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18232.53770.923521.968923@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday November 12, davidsen@tmr.com wrote:
>   
>> Neil Brown wrote:
>>     
>>> However there is value in regularly updating the bitmap, so add code
>>> to periodically pause while all pending sync requests complete, then
>>> update the bitmap.  Doing this only every few seconds (the same as the
>>> bitmap update time) does not notciable affect resync performance.
>>>   
>>>       
>> I wonder if a minimum time and minimum number of stripes would be 
>> better. If a resync is going slowly because it's going over a slow link 
>> to iSCSI, nbd, or a box of cheap drives fed off a single USB port, just 
>> writing the updated bitmap may represent as much data as has been 
>> resynced in the time slice.
>>
>> Not a suggestion, but a request for your thoughts on that.
>>     
>
> Thanks for your thoughts.
> Choosing how often to update the bitmap during a sync is certainly not
> trivial.   In different situations, different requirements might rule.
>
> I chose to base it on time, and particularly on the time we already
> have for "how soon to write back clean bits to the bitmap" because it
> is fairly easy to users to understand the implications (if I set the
> time to 30 seconds, then I might have to repeat 30second of resync)
> and it is already configurable (via the "--delay" option to --create
> --bitmap).
>   

Sounds right, that part of it is pretty user friendly.
> Presumably if someone has a very slow system and wanted to use
> bitmaps, they would set --delay relatively large to reduce the cost
> and still provide significant benefits.  This would effect both normal
> clean-bit writeback and during-resync clean-bit-writeback.
>
> Hope that clarifies my approach.
>   

Easy to implement and understand is always a strong point, and a user 
can make an informed decision. Thanks for the discussion.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

