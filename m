From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] Plugging changes for blk/md/umem
Date: Tue, 31 Jul 2012 10:54:17 +0200
Message-ID: <50179D39.6080608@kernel.dk>
References: <20120726025650.32180.65163.stgit@notabene.brown> <50178487.4090302@kernel.dk> <20120731172539.4feea95e@notabene.brown> <50178A4F.8010806@kernel.dk> <20120731184425.389515ed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120731184425.389515ed@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On 07/31/2012 10:44 AM, NeilBrown wrote:
> On Tue, 31 Jul 2012 09:33:35 +0200 Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 07/31/2012 09:25 AM, NeilBrown wrote:
>>> On Tue, 31 Jul 2012 09:08:55 +0200 Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 07/26/2012 04:58 AM, NeilBrown wrote:
>>>>> Hi Jens,
>>>>>  the following series makes a number of changes to plugging, moving
>>>>>  common code from md and umem into block, and modifying it to allow
>>>>>  md to get more value out of it.
>>>>>  They've been sitting in -next for a while.
>>>>>  Are you OK with me forwarding them to Linus, or would you rather they
>>>>>  went though your tree?
>>>>
>>>> Thanks Neil, looks good. I will apply them to my tree and do some basic
>>>> testing, too, then push it off for this round (where I haven't pushed
>>>> out yet).
>>>>
>>>
>>> Thanks Jens,
>>>  However I've just today discovered that the very first patch causes a real
>>>  regression in throughput for RAID5 and while I'm sure I can fix it with a
>>>  subsequent patch (once I figure out exactly what it happening) it might make
>>>  sense to hold them all back for 3.7.
>>>
>>>  However if you would like to take them now and fix up later (it is only a
>>>  performance regression so it won't really affect bisection) I can work with
>>>  that.
>>
>> If you're confident we can fix it in this cycle (sounds like it, if you
>> have a grasp on the situation), then I don't think that should stop us.
>>
> 
> Sounds like a plan.
> I have a few md patches queue which depend on those plugging patches, so if
> you could cc me when you send you pull request (which Linus is keen for "by
> Wedneday at the latest" I gather), I'll sort my tree out and send my pull
> request.

They'll go out today, or tomorrow at the latest. I'll CC you. This merge
window has been unfortunately timed with my vacation (Linus, how dare
you!), so I have a bit of a time crunch. On the plus side, it's smaller
than last round.

-- 
Jens Axboe

