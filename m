From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5E
Date: Mon, 12 Jun 2006 09:50:06 -0400
Message-ID: <448D710E.2020100@tmr.com>
References: <447D9E72.3000704@tmr.com> <17534.16158.788542.538484@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17534.16158.788542.538484@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:

>On Wednesday May 31, davidsen@tmr.com wrote:
>  
>
>>Where I was working most recently some systems were using RAID5E (RAID5 
>>with both the parity and hot spare distributed). This seems to be highly 
>>desirable for small arrays, where spreading head motion over one more 
>>drive will improve performance, and in all cases where a rebuild to the 
>>hot spare will avoid a bottleneck on a single drive.
>>
>>Is there any plan to add this capability?
>>    
>>
>
>I thought about it briefly....
>
>As I understand it, the layout of raid5e when non-degraded is very
>similar to raid6 - however the 'Q' block is simply not used.
>This would be trivial to implement.
>
>The interesting bit comes when a device fails and you want to rebuild
>that distributed spare.
>There are two possible ways that you could do this:
>
>1/ Leave the spare where it is and write the correct data into each
> spare.  This would be fairly easy but would leave an array with an
> very ... interesting layout of data.
> When you add a replacement you just move everything back.
>
>2/ reshape the array to be a regular raid5 layout.  This would be hard
> to do well without NVRAM as you are moving live data, but would result
> in a neat and tidy array.  Ofcourse adding a drive back in would be
> interesting again...
>
>I had previously only thought of option '2', and so discarded the idea
>as not worth the effort.  The more I think about it, the more possible
>option 1 sounds.
>I've put it back on my todo list, but I don't expect to get to it this
>year.  Ofcourse if someone else wants to give it a try, I'm happy to
>make suggestions and review code.
>
I do appreciate being too busy, I'm just glad I have been able to 
clarify the tradeoffs of RAID5e, and get it on your list at all. I did 
look at the code a bit, and it would seem that if the "rebuild to hot 
spare" code is modified to handle a distributed spare, then it looks as 
if RAID6e might pretty much fall out. Feel free to tell me I'm dreaming.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

