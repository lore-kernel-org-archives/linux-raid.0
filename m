From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 02 Nov 2009 09:54:20 -0500
Message-ID: <4AEEF29C.10309@tmr.com>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson wrote:
> I have a 4 disk raid6. The disks are individually capable of (at
> least) 75MB/s on average.
> The raid6 looks like this:
>
> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
>       613409536 blocks super 1.1 level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>
> The raid serves basically as an lvm physical volume.
>
> While rsyncing a file from an ext3 filesystem to a jfs filesystem, I
> am observing speeds in the 10-15MB/s range.
> That seems really really slow.
>
>   
It is really slow, recent kernels seem to be unsuitable for use as large 
file servers, as the performance is, as you described it, "unbelievably 
bad."
> Using vmstat, I see similar numbers (I'm averaging a bit, I'll see
> lows of 6MB/s and highs of 18-20MB/s, but these are infrequent.)
> The system is, for the most part, otherwise unloaded.
>
> I looked at stripe_cache_size and increased it to 384 - no difference.
> blockdev --getra reports 256 for all involved raid components.
> I'm using the deadline I/O scheduler.
>
>   
Push is to 8192 or so (assuming enough memory), but pretty much minimal 
improvement. I don't know what problems were solved in recent kernels, 
but they are simply not worth the 300% loss of performance. Linux has 
been getting slower over time as features were added, and faster 
hardware has overcome the issues, but this one needs SSD to make the 
server useful, and I can't afford it.

> Am I crazy?  Is 12.5MB/s (average) what I should expect, here?  What
> might I look at here?
>
>   


-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

