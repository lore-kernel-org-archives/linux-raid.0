From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID-6 question.
Date: Mon, 17 Nov 2008 04:42:11 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811170440001.26146@p34.internal.lan>
References: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan> <alpine.DEB.1.10.0811101101530.25411@p34.internal.lan> <4920BB05.3050206@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4920BB05.3050206@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sun, 16 Nov 2008, H. Peter Anvin wrote:

> Justin Piszcz wrote:
>>
>> The sync_speed_max was the default as well until I changed it, once I
>> lowered
>> the speed, the system was functional again.  By default its set quite high,
>> this appeared to be the root cause of the problem.
>>
>
> You probably ran out of CPU.  2-disk RAID-6 recovery is very CPU intensive.
>
> 	-hpa
>

Yeah, one core was pegged at 100% for the resync, another (md_raidX) process
was at ~35% on the second core.  The third and fourth core were unused but 
immediately when I start the resync it definitley slowed down the system 
quite a bit and hurt interactivity and as I mentioned before *without* 
specifying a lower rebuild speed than the system's maximum I/O the system 
is unusable until the rebuild completes, perhaps its a combination of 
using all of the one core for the resync where raid5 may not?  I recall 
w/raid5 I did not have to specify a lower limit for max_rebuild KiB/s..

Justin.
