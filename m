From: Nathan Dietsch <njd@ndietsch.com>
Subject: Re: RAID5 crash and burn
Date: Mon, 01 Nov 2004 19:58:01 +1100
Message-ID: <4185FA99.9070101@ndietsch.com>
References: <Pine.LNX.4.44.0411010106290.17633-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0411010106290.17633-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark,

Mark Hahn wrote:

>> From Understanding the Linux Kernel "Every access by a program to a 
>>page that is swapped out increases the process execution time by an 
>>order of magnitude. In short, if performance is of great importance, 
>>swapping should be considered as a last resort." (p. 529)
>>    
>>
>
>not relevant: we're talking about what it costs to perform
>a swapout, not what happens if the wrong page is chosen for 
>swapout, and later necessitates a swapin.
>  
>
You have convinced me that swapping out is low-overhead in Linux.

>  
>
>>I agree that the write is cheap compared to the read (where you will 
>>stall), but what is the purpose of writing something to swap if you do 
>>not plan to read it again?
>>    
>>
>
>to free the underlying physical page for other use.
>  
>
Unused memory is wasted memory, hence the reason for FS caches.
If you have such a squeeze on memory that you are swapping for a more 
active page using LRU algorithms, you do not have enough memory for the 
task at hand.

>>>let me put it a completely other way: swap outs are normal, fairly
>>>frequent, and GOOD for performance. 
>>>
>>>      
>>>
>>Please explain how swapping out a page is good for performance.
>>    
>>
>
>swapouts mean that the kernel doesn't need to dedicate a page of 
>physical memory to keep track of some stale page.  swapping out 
>active pages would be mistake, obviously.  the kernel tries to 
>avoid that mistake in any OS.
>  
>
Agreed, but yet again it comes back to not having enough memory for 
*performance*.

>  
>
>>I understand that unused pages are paged out, but how does this improve 
>>performance beyond making more room for the FS cache?
>>    
>>
>
>a swapout frees a physical page, period.  whether it's used for 
>the FS cache or not is irrelevant.  perhaps your model for how 
>the system works involves uniform references to all pages?
>if that were true, then indeed, swapouts would be dubious.
>since references are highly skewed, there are some pages which
>are not effective investments of physical ram, so to speak,
>but which can't be thrown away (because they're dirty and/or anonymous).
>
>  
>
>>I am simply saying that comparing RAID5 and RAID1 for the purposes of 
>>swapping is irrelevant, because if you are relying on the performance of 
>>your swap device, you are missing the point that you have run out of 
>>memory.
>>    
>>
>
>which is either vapid or wrong.  yes, it's silly to worry about 
>how fast your system thrashes.  but no one is talking about non-fatal error
>conditions like thrashing.  and there *is* a good reason to choose 
>r1 over r5 for swap, since writes are so much lower-overhead.  worrying
>about the efficiency of r1 vs r5 reads verges on the "optimizing 
>for thrashing" that you're so worried about.
>  
>
That is what I was getting at.

I think this is going in circles, but it has made me see swapping in 
another light.

Regards,

Nathan
