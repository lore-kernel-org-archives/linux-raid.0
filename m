From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Thu, 12 Dec 2013 17:13:53 +0000
Message-ID: <52A9EED1.40703@mpstor.com>
References: <52A98FAF.4000205@insync.za.net> <52A9A380.50805@hesbynett.no> <52A9EAF9.6020804@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A9EAF9.6020804@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/12/13 16:57, Pieter De Wit wrote:
> On 13/12/2013 00:52, David Brown wrote:
>> On 12/12/13 11:27, Pieter De Wit wrote:
>>> Hi List,
>>>
>>> Given the recent work done with techs like CUDA etc. - has the idea been
>>> floated to use the video card for RAID parity calculations vs the CPU ?
>>> Bitcoin and plenty others have shown the true speed of these cards. This
>>> might be a cheaper version of a RAID card.
>>>
>>> Cheers,
>>>
>>> Pieter
>> I am almost certain that you /could/ use a graphics card to do parity
>> calculations faster than a cpu core.  However, even the newly proposed
>> multi-parity calculations are not a big challenge for a modern cpu.  A
>> bigger issue is getting optimal threading so that multiple cores (or at
>> least threads) can be used at the same time, and this work is well under
>> way already.  Once that work is completed, my guess is that I/O, cache
>> or memory bandwidth will be the bottleneck for big raid arrays rather
>> than cpu power - and using graphics cards will not help there.
>>
>> David
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Ah - I see - I also thought it was multi-threaded, but, tbh, I never
> looked that hard into it. My question comes from the fact that I now
> have access to 32x750gig (and more if needed) drives on a fiber array.
> The down side is that I only have *old* CPUs driving the array. RAID5's
> sync speed (15 disks) is 8meg/second. Change the array to RAID10 and the
> sync speed is above 100meg/second.
When resyncing a RAID5, is the CPU running 100%? Even old CPUs should be 
able to resync faster than that. What CPU is that if I may ask?

>
> I, naively perhaps, assumed the bottleneck to be the Intel CPU's which
> sparked this idea.
>
> What about block level hashing ? (Unless this is already done and I just
> never knew it :) )
Like keeping a checksum of each RAID chunk or stripe for data 
consistency checks? RAID doesn't deal with that, it deals with 
reconstructing data in the event of a drive failure but doesn't 
guarantee data consistency. Therefore, if some bits on a drive were to 
be "flipped", the next RAID "scrub" (repair) would detect a mismatch 
between the data chunks and the parity and would simply update the 
parity from the available data (not "repairing" the corrupted data), as 
far as I know that's because there's no way for the array to know 
whether the data or the parity was written wrong or corrupted.

Regards,
Ben.

>
> Cheers,
>
> Pieter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

