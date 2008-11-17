From: "NeilBrown" <neilb@suse.de>
Subject: Re: RAID-6 question.
Date: Mon, 17 Nov 2008 12:01:56 +1100 (EST)
Message-ID: <4872bf23ab1db897313c28afd43b5ad0.squirrel@neil.brown.name>
References: <alpine.DEB.1.10.0811100653060.21263@p34.internal.lan>
    <alpine.DEB.1.10.0811101101530.25411@p34.internal.lan>
    <4920BB05.3050206@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4920BB05.3050206@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, November 17, 2008 11:29 am, H. Peter Anvin wrote:
> Justin Piszcz wrote:
>>
>> The sync_speed_max was the default as well until I changed it, once I
>> lowered
>> the speed, the system was functional again.  By default its set quite
>> high,
>> this appeared to be the root cause of the problem.
>>
>
> You probably ran out of CPU.  2-disk RAID-6 recovery is very CPU
> intensive.

So maybe we need to back-off resync when the CPU is busy ??

I wonder how you measure "am I taking CPU from something else important"??

Maybe we just set the scheduling priority quite low.  Maybe

   set_user_nice(current, 15);

near the top of md_do_sync().
??

NeilBrown

