From: Nathan Dietsch <njd@ndietsch.com>
Subject: Re: RAID5 crash and burn
Date: Mon, 01 Nov 2004 15:26:35 +1100
Message-ID: <4185BAFB.50502@ndietsch.com>
References: <Pine.LNX.4.44.0410311434240.17633-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0410311434240.17633-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:

>>If you are seriously considering the performance implications of RAID1 
>>vs RAID5 for swap, you are already done for performance wise.
>>    
>>
>
>I disagree.  the whole point of Linux's approach to swap is that 
>it's fairly cheap to write a page to swap.
>
Writing to any form of secondary storage is not "cheap" when compared to 
memory.
Writing to a swap RAID5 volume, where you will probably incur a 
read-modify-write operation is not considered "cheap" either.

>whether you ever need 
>it again depends on how overcommitted you are.  this is assuming that
>the kernel successfully chooses not-likley-to-be-reused pages to 
>write to swap, and that your swap partitions are reasonably fast 
>to write to. 
>
This is what I am getting at: Any partition can not be considered 
reasonably fast to write to when compared to memory.

>this approach works very well, excepting heuristic problems
>in certain kernel versions.
>
>in other words, reading from swap is permitted to be expensive,
>since any disk read is always assumed to be slow.  
>
Agreed.

>but writing to 
>swap really should be fairly cheap, and this is a premise of the 
>kernel's swap policies.
>  
>
Sorry, I still don't buy the premise that writing to disk can be 
considered cheap.

>I would not use raid5 swap for this reason; raid1 is not insane,
>since you don't need *that* much swap space, so the 50% overhead 
>is not crippling.  (don't even think about things like raid 10
>for swap - the kernel already has zero-overhead swap striping.)
>  
>
I would agree with that.

What I was trying to say was that if you are forced to go to swap, for a 
page out or a page in, you are going to incur overhead which is 
incredibly inefficient compared to memory.
Putting swap on RAID5, where you incur even more overhead is worse.

Putting swap on RAID1, as Guy pointed out, avoids crashes. So for the 
one time that you will go to swap, it is worse the extra bit of overhead 
to write it to a second disk to avoid losing the machine in the event of 
a disk failure.

Simply: Looking for performance improvements in swap means that you are 
already very, very overloaded OR it is simply an exercise in theory.

Kind Regards,

Nathan
