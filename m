From: Nathan Dietsch <njd@ndietsch.com>
Subject: Re: RAID5 crash and burn
Date: Mon, 01 Nov 2004 17:05:35 +1100
Message-ID: <4185D22F.9040402@ndietsch.com>
References: <Pine.LNX.4.44.0411010019200.17633-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0411010019200.17633-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mark,

Mark Hahn wrote:

>>>>If you are seriously considering the performance implications of RAID1 
>>>>vs RAID5 for swap, you are already done for performance wise.
>>>>   
>>>>
>>>>        
>>>>
>>>I disagree.  the whole point of Linux's approach to swap is that 
>>>it's fairly cheap to write a page to swap.
>>>
>>>      
>>>
>>Writing to any form of secondary storage is not "cheap" when compared to 
>>memory.
>>    
>>
>
>nonsense - from the cpu and kernel perspective, firing off 
>a write of a page really is normally cheap.  more expensive
>than doing nothing, well, yeah.
>  
>
Nonsense ??? I said swapping to disk is not cheap when compared to memory.

 From Understanding the Linux Kernel "Every access by a program to a 
page that is swapped out increases the process execution time by an 
order of magnitude. In short, if performance is of great importance, 
swapping should be considered as a last resort." (p. 529)
 
I agree that the write is cheap compared to the read (where you will 
stall), but what is the purpose of writing something to swap if you do 
not plan to read it again?

The most important part of my original post was that analysing the 
performance characteristics of RAID1 swap vs RAID5 swap is avoiding the 
point that if you are looking at swap for performance gains, then you 
are missing the many other places that could improve performance.
If you plan on swapping for tasks which require performance[0], then you 
have badly sized the system.

>  
>
>>Writing to a swap RAID5 volume, where you will probably incur a 
>>read-modify-write operation is not considered "cheap" either.
>>    
>>
>
>hence my message.
>  
>
We agree.

>  
>
>>>whether you ever need 
>>>it again depends on how overcommitted you are.  this is assuming that
>>>the kernel successfully chooses not-likley-to-be-reused pages to 
>>>write to swap, and that your swap partitions are reasonably fast 
>>>to write to. 
>>>
>>>      
>>>
>>This is what I am getting at: Any partition can not be considered 
>>reasonably fast to write to when compared to memory.
>>    
>>
>
>perhaps you missed the point because I was sloppy with "fast".
>what I meant was "low overhead".  that is, forcing a page to 
>swap is largely a fire-and-forget kind of operation.  yes, you 
>sometimes have to handle an interrupt, but it's not expensive,
>and doesn't slow you down.  you're not holding up progress until
>the write completes.  the overhead is largely book-keeping.
>  
>
Interesting point.

>  
>
>>Sorry, I still don't buy the premise that writing to disk can be 
>>considered cheap.
>>    
>>
>
>do some benchmarking.
>  
>
I will do that.

>  
>
>>Simply: Looking for performance improvements in swap means that you are 
>>already very, very overloaded OR it is simply an exercise in theory.
>>    
>>
>
>no.  current linux VM logic uses swap as a way of optimizing page 
>usage; handling overcommit is useful, even essential, but not a 
>normal function of swap, and not relevant to most machines.
>
>let me put it a completely other way: swap outs are normal, fairly
>frequent, and GOOD for performance. 
>
Please explain how swapping out a page is good for performance.
I understand that unused pages are paged out, but how does this improve 
performance beyond making more room for the FS cache?

> swap *IN*s are unusual, quite
>infrequent, and bad for performance.  you're in trouble if you see
>more than a trivial number of swap-ins, but even a lot of swap-outs
>is not a problem.  (obviously, you don't want swapouts to starve your 
>explicit/non-swap IO needs.)
>  
>
I agree with you 100% on that.
I am not going to argue with you on Linux swap internals, you obviously 
understand them quite well and my knowledge is more from the Solaris 
side of the fence.

I am simply saying that comparing RAID5 and RAID1 for the purposes of 
swapping is irrelevant, because if you are relying on the performance of 
your swap device, you are missing the point that you have run out of 
memory.

Regards,

Nathan

[0] Some longer running tasks (like batch jobs), that do not have 
performance limitations can afford to swap.
