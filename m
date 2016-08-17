From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Wed, 17 Aug 2016 10:27:49 +1000
Message-ID: <8865a784-e061-aa47-b4a8-b95805477a7d@websitemanagers.com.au>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <CAFx4rwQj3_JTNiS0zsQjp_sPXWkrp0ggjg_UiR7oJ8u0X9PQVA@mail.gmail.com>
 <CAJvUf-C7CMqUBe+kPaxxTtmvuCXSRes73kMcAnZw7x8=6DNCdw@mail.gmail.com>
 <CAFx4rwQ4FGpR_X+rz2b0pFUVzOR_OL0UCRAiYZkRMAi0n7+rGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwQ4FGpR_X+rz2b0pFUVzOR_OL0UCRAiYZkRMAi0n7+rGA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com, Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/08/16 08:51, Doug Dumitru wrote:
> Matt,
>
> One last thing I would highly recommend is:
>
> Secure erase the replacement disk before rebuilding onto it.
>
> If the replacement disk is "pre conditioned" with random writes, even
> if very slowly, this will lower the write performance of the disk
> during the rebuild.
>
> On Tue, Aug 16, 2016 at 12:44 PM, Matt Garman <matthew.garman@gmail.com> wrote:
>> Hi Doug & linux-raid list,
>>
>> On Tue, Jul 12, 2016 at 9:10 PM, Doug Dumitru <doug@easyco.com> wrote:
>>
>>> You can probably mitigate the amount of degradation by lowering the rebuild
>>> speed, but this will make the rebuild take longer, so you are messed up
>>> either way.  If the server has "down time" at night, you might lower the
>>> rebuild to a really small value during the day, and up it at night.
>> I'll have to discuss with my colleagues, but we have the impression
>> that the max rebuild speed parameter is more of a hint than an actual
>> "hard" setting.  That is, we tried to do exactly what you suggest:
>> defer most rebuild work to after-hours when the load was lighter (and
>> no one would notice).  But we were unable to stop the rebuild from
>> basically completely crippling the NFS performance during the day.
>>
>> "Messed up either way" is indeed the right conclusion here.  But I
>> think we have some bottleneck somewhere that is artificially hurting,
>> making things worse than they could/should be.
>>
>> Thanks again for the thoughtful feedback!
>>
>> -Matt
Sorry, probably messed up the quoting/attribution, but I don't think 
that is too important here.
You should find that the max value is in fact an upper bound, so the 
re-sync will *try* to limit the speed to this value, and the minimum is 
a lower bound. However, if you set the minimum too high, then the system 
(as a whole) may not be able to achieve that, and so the resync speed 
might be lower.

I don't think I've seen a case where the resync speed is much higher 
than the max value. Of course, even a small resync speed could have a 
big impact on performance (due to extra seeks on the disks moving to the 
resync area away from the active read/write workload area)...

I think there is also an option to completely stop the resync from 
progressing (changes it to "pending" status), but maybe someone else 
on-list can comment about that. You might be able to totally stop the 
resync during the day, and then set an outage period to stop your 
workload and allow the system to run the resync at maximum speed (just 
set the max value to a really large number).

Sorry, but I'm not an mdadm expert, just sharing my experiences with 
dealing with similar issues.

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
