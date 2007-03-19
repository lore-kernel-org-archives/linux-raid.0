From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: [Linux-usb-users] Failed reads from RAID-0 array (from newbie  
                        who has read the FAQ)
Date: Mon, 19 Mar 2007 08:54:11 -0600 (CST)
Message-ID: <4641.72.21.237.163.1174316051.squirrel@www.multitool.net>
References: <2885.72.21.237.163.1174167308.squirrel@www.multitool.net>   
    <Pine.LNX.4.44L0.0703172208400.16306-100000@netrider.rowland.org>   
    <3123.72.21.237.163.1174192963.squirrel@www.multitool.net>   
    <3612.72.21.237.163.1174236988.squirrel@www.multitool.net>   
    <17917.46554.169905.698240@notabene.brown>
    <3923.72.21.237.163.1174274877.squirrel@www.multitool.net>
    <45FE9E47.40705@tmr.com>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45FE9E47.40705@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>, linux-raid@vger.kernel.org, linux-usb-users@lists.sourceforge.net
List-Id: linux-raid.ids

I'm going to hang on to the hardware. This is a pilot/demo that may lead
to development of a new device, and, if so, I'll be getting back into
device driver writing. Working this problem would be great practice for
that. So I will do it. The only problem is I don't know when!

I believe I can replicate the problem, so I'll find time (perhaps next
weekend) to capture the data of interest.

Mr. Stern: Where might I go for low level programming information on USB
devices? I'm interested in registers/DMA/packet formats, etc.

I've found info on the USB protocol itself, but I haven't found info on
devices. Obviously I can dig through kernel source, but documents would be
nice! Again, if this is an unreasonable request for you to "do my
homework," just say so! I won't be offended. I'm sure I can find it myself
given time, but if you happen to have some URLs handy, they'd be
appreciated.

YET AGAIN thank you both! You've been of great help.

-- 
Michael Schwarz

> Michael Schwarz wrote:
>> More than ever, I am convinced that it is actually a hardware problem,
>> but
>> I am curious for the opinions of both of you on whether the "system"
>> (meaning, I guess, the combination of usb-storage driver and raid) is
>> really doing the best with what it has.
>>
>
> See below, but the short answer is there is probably room for improvement.
>> My last effort was to switch to a different computer. When I did, I got
>> in
>> the dmesg log (unfortunately, not preserved, although I should be able
>> to
>> recreate) that one of the flash drives had bad blocks. Some part of the
>> system eventually decided it was a "dead device" (I believe dmesg
>> indicate
>> the scsi subsystem said so). The device (it happened to be /dev/sdc) was
>> peremptorially dropped from the system. This appears to be what hanged
>> the
>> raid system.
>>
>> (Why these messages never appeared on the other computer is beyond me;
>> obviously some difference in how the actual USB controller reports
>> errors,
>> but, as I said, I've never studied USB drivers or hardware. In fact,
>> once
>> you get beyond the UARTs you are getting sophisticated to me)
>>
>> I've built an array of five known-good devices and so far it works
>> swimmingly (at least on the hardware that was better at error
>> reporting).
>>
>> So it seems to me that there is probably nothing actually wrong with the
>> drivers or their interactions at it leaves me only asking if there
>> should
>> be some sort of improvement in error reporting/recovery up to userland.
>>
>> If I am right and the scsi system was marking a device as dead,
>> shouldn't
>> the userland read against the md device get an error instead of an
>> indefinite hang?
>>
>
> Let me make sure I have this scenario right... one write process (dd or
> cp) hangs, but you can still access data on the array, so the devices
> (all of them?) are working. It would be useful at that point to see if
> /proc/mdstat shows one device as failed.
>
> Given that I have described the behavior, I would think that there is
> still a problem in the driver or md somewhere, hangs should time out,
> errors should be reported up, and if this is caused by a lost write
> completion, I would hope that would be timed out and reported. That's my
> read on it, these "just hangs" cases probably are undetected or
> mishandled errors which should be passed up and reported to the
> application or retried and completed. Or handled in some better way than
> what you describe.
>
> Bad hardware is a fact of life, if you feel like chasing this more, an
> understanding of what the hardware did wrong and what the kernel didn't
> do right would be helpful. Of course the failure mode may be so rare,
> and the fix so time-consuming that it won't get fixed, but it can get
> documented.
>> Beyond this question which I leave to you (although I'd love to hear
>> your
>> answers/thoughts), I think we can safely say that the problem was
>> hardware
>> (even if hard to find). If either of you would like, I'd be happy to
>> find
>> time this week to recreate the error on my "better" PC and send that
>> along.
>>
>> As for rolling a custom kernel with more message buffer, well, I'm going
>> to be getting into a new device driver in the coming months, so a custom
>> debug kernel is definitely in my future, but I'm not sure when.
>>
>> I must say, the kernel has become a much more complex beastie since
>> 2.2.x!
>> (Although it also appears to be improved and somewhat more organized --
>> but definitely MUCH larger!)
>>
>> Thank you both so much! I wouldn't even have diagnosed my hardware
>> problem
>> without your prompts. I'm very grateful. Let me know if you'd like those
>> dmesg logs or if you'd just like to let it go!
>>
>>
> --
>
> bill davidsen <davidsen@tmr.com>
>   CTO TMR Associates, Inc
>   Doing interesting things with small computers since 1979
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

