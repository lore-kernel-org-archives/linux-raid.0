From: Mike Hardy <mhardy@h3c.com>
Subject: Re: swp - Re: ext3 journal on software raid (was Re: PROBLEM: Kernel
 2.6.10 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 20:49:02 -0800
Message-ID: <41DCC33E.6080101@h3c.com>
References: <200501060332.j063We928711@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501060332.j063We928711@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Guy wrote:

> Maybe the concept of swapping is becoming obsolete?

I think its definitely headed that way, if not already there for most 
new systems

> to programmers.  Most systems can support more RAM than most programs need.
> With PC based systems (and some others I assume), 1 Gig of RAM is very
> cheap!  But I did note someone said you had to do something to break the
> 2Gig boundary in Linux with x68 based systems.  That's too bad.  In a few

To go bigger than 2GB on x86 you have to enable PAE (pointer address 
extensions? I forget the TLA expansion) which does have a speed hit and 
so is sub-optimal. Additionally, you still have limits on the amount of 
RAM any process can address and its more policy decisions and tradeoffs.

Even with 64-bit, in my professional world (Java programming) I've had 
occasion to want 4GB heaps to work with for caching purposes, and 
programs are only just getting there. I think you're right then, the 
hardware and software have just met each other in the last year or so 
except for the edge cases.

Bandwidth is the usual limiter at this point :-)

> today (I think 64 Gig is about as much as is reasonable today).  We should
> reach the 64 bit limit in 42-56 years.  Maybe it will be a long wait?  :)

:-)

To make this more on topic, I'll say that I just switched all my servers 
(which had raid1 /boot and / but parallel JBOD swap) to mirrored swap 
after this discussion. All using simple mdadm/swapon/swapoff commands 
while they were humming, thanks to all the author's work. The servers 
are all doing fine, post-change.

As further penance for taking up everyone's time, I'll point to the 
specific section of the software raid howto that discusses swapping on raid:

http://www.tldp.org/HOWTO/Software-RAID-HOWTO-2.html#ss2.3

They succinctly say what was posted here - which is that you don't swap 
on raid for performance, but if you're looking for single-hdd machine 
survivability, swapping on raid1 is the only way.

Cheers-
-Mike
