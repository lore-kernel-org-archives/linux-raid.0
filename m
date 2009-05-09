From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Requesting replace mode for changing a disk
Date: Sat, 09 May 2009 19:07:42 -0400
Message-ID: <4A060CBE.9090308@tmr.com>
References: <8763gb44xk.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8763gb44xk.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Hi,
>
> consider the following situation: You have a software raid that runs
> fine but one disk is suspect (e.g. SMART says failure imminent or
> something). How do you replace that disk?
>
> Currently you have do fail/remove the disk from the raid, add a
> fresh disk and resync. That leaves a large window in which redundancy
> is compromised. With current disk sizes that can be days.
>
> It would be nice if one could tell the kernel to replace a disk in a
> raid set with a spare without the need to degrade the raid.
>
> Thoughts?
>   

This is one of many things proposed occasionally here, no real 
objection, sometimes loud support, but no one actually *does* the code.

You have described the problem exactly, and the solution is still to do 
it manually. But you don't need to fail the drive long term, if you can 
stop the array for a few moments. You stop the array, remove the suspect 
drive, create a raid1 of the suspect drive marked write-mostly and the 
new spare, then add the raid1 in place of the suspect drive. For any 
chunks present on the new drive the reads will go there, reducing 
access, while data is copied from the old to the new in resync, and 
writes still go to the old suspect drive so if the new drive fails you 
are no worse off. When the raid1 is clean you stop the main array and 
back the suspect drive out.

This is complicated enough that I totally agree a hot migrate would be 
desirable. This is why people use lvm, although I make zero claims that 
this same problem will solve more easily, I'm just not an lvm guru (or 
even a newbie, just an occasional user).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


