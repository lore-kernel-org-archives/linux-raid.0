From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Using Video cards (CUDA) for RAID parity
Date: Fri, 13 Dec 2013 05:57:29 +1300
Message-ID: <52A9EAF9.6020804@insync.za.net>
References: <52A98FAF.4000205@insync.za.net> <52A9A380.50805@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A9A380.50805@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/12/2013 00:52, David Brown wrote:
> On 12/12/13 11:27, Pieter De Wit wrote:
>> Hi List,
>>
>> Given the recent work done with techs like CUDA etc. - has the idea been
>> floated to use the video card for RAID parity calculations vs the CPU ?
>> Bitcoin and plenty others have shown the true speed of these cards. This
>> might be a cheaper version of a RAID card.
>>
>> Cheers,
>>
>> Pieter
> I am almost certain that you /could/ use a graphics card to do parity
> calculations faster than a cpu core.  However, even the newly proposed
> multi-parity calculations are not a big challenge for a modern cpu.  A
> bigger issue is getting optimal threading so that multiple cores (or at
> least threads) can be used at the same time, and this work is well under
> way already.  Once that work is completed, my guess is that I/O, cache
> or memory bandwidth will be the bottleneck for big raid arrays rather
> than cpu power - and using graphics cards will not help there.
>
> David
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Ah - I see - I also thought it was multi-threaded, but, tbh, I never 
looked that hard into it. My question comes from the fact that I now 
have access to 32x750gig (and more if needed) drives on a fiber array. 
The down side is that I only have *old* CPUs driving the array. RAID5's 
sync speed (15 disks) is 8meg/second. Change the array to RAID10 and the 
sync speed is above 100meg/second.

I, naively perhaps, assumed the bottleneck to be the Intel CPU's which 
sparked this idea.

What about block level hashing ? (Unless this is already done and I just 
never knew it :) )

Cheers,

Pieter
