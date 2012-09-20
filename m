From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: hung in raise_barrier() in raid1.c  -- any ideas?
Date: Thu, 20 Sep 2012 17:05:23 -0600
Message-ID: <505BA133.3000005@genband.com>
References: <505B49E2.8070109@genband.com>	<505B5876.4040405@genband.com> <20120921072751.38319b46@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120921072751.38319b46@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/20/2012 03:27 PM, NeilBrown wrote:
> On Thu, 20 Sep 2012 11:55:02 -0600 Chris Friesen<chris.friesen@genband.com>
> wrote:
>
>> On 09/20/2012 10:52 AM, Chris Friesen wrote:
>>>
>>> Hi,
>>>
>>> I've got a fairly beefy (32 cpus, 64GB ram, isci-based SAS disks,
>>> etc.) embedded system running 2.6.27.
>>>
>>> We're seeing issues where disk operations suddenly seem to stall.  In
>>> the most recent case we had the hung-task watchdog indicate that
>>> md1_resync was stuck for more than 120sec in raise_barrier().
>>>
>>> There are a bunch of "normal" tasks also stuck in wait_barrier(), so
>>> based on that I assume we're stuck in the second call to
>>> wait_event_lock_irq().
>>>
>>> Has anyone seen anything like this?  Could commit 73d5c38 be related?
>>> What about 1d9d524?
>>
>> Could d6b42dc be related?
>
> That last one seems more likely.  Does the scenario fit your config.
> i.e. is your RAID1 being used under LVM?
>
> If it does, then I would say it is very likely this issue.


Yes, we're using it under LVM.  I've added some instrumentation to tell 
if we're hitting that case.  The current->bio_list handling is a bit 
different in 2.6.27 but I think I figured out the equivalent to the patch.

Interesting that it took this long to fix that issue.


>> Also, what's the meaning of RESYNC_DEPTH?
>
> The maximum number of resync requests that can be concurrently active.

And each request would resync a single block?

Chris
