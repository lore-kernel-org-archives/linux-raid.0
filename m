From: Nicholas Ipsen <NCLI@ncli-design.com>
Subject: Re: Trouble adding disk to degraded array
Date: Thu, 10 Jan 2013 00:47:46 +0100
Message-ID: <CAJ=LqmZKXqn+nGt8=Rt8QS9S7pVS7qyEaN8Cbb91D7XETEvFug@mail.gmail.com>
References: <CAJ=LqmbYG8H45M196ZuRcDMu9Ucz0t_pQenQbZtMKM9AhSqrpQ@mail.gmail.com>
 <CAJ=LqmasSo9WRmPAO6-RBE5N=zxg9vitWhdqcekbUO89oxKevA@mail.gmail.com>
 <50EDAF0A.7030903@turmel.org> <CAJ=LqmbKR1BczeFyGeQooDsPMf8PqriiD3z7i1_LjupGij5ewQ@mail.gmail.com>
 <50EDF030.2060502@smartguide.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50EDF030.2060502@smartguide.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Phil, I wrote "mdadm -E /dev/sd[abcde]" instead of "mdadm -E
/dev/sd[abcde]1"... Anyway, I'm currently trying your advice with
dd_rescue, I'll report back when something happens.

Nicholas Ipsen


On 9 January 2013 23:33, Tudor Holton <tudor@smartguide.com.au> wrote:
> Having been through this process recently, and I agree that the advice will
> most likely lead the user to speculate on this as a potential cause, is
> there some way we could more easily alert the user to this situation?  Maybe
> we could mark the disk with a (URE) tag in mdstat (my preference) and/or
> reporting the error as "md: URE error occurred during read on disk X,
> aborting synchronization, returning discs [Y,Z...] to spare"? Trailing logs
> during synchronization can take several hours on large arrays (and busy
> servers) and cause alot of time wastage, particularly if you don't know what
> you're looking for.
>
> Since it first affected me I found this kind of question asked quite
> regularly on a multitude of tech forums and alot of the responses I came
> across were incorrect or misleading at best. Alot more were along the lines
> of "That happened to me, and after trying to fix it for days I just wiped
> the array and started again.  Then it happened to the array again later.
> mdadm is so unstable!"  Unfortunately we can't avoid people blaming the
> software, but we can at least help them to diagnose the problem more quicky
> and help their pain and our reputation.  :-)
>
> Incidentally, is the state "active faulty" an allowed state? Because that
> could be a good way to report it, also.
>
> On 10/01/13 08:18, Nicholas Ipsen(Sephiroth_VII) wrote:
>>
>> --snip---
>>
>>
>> On 9 January 2013 18:55, Phil Turmel <philip@turmel.org> wrote:
>>>
>>> On 01/09/2013 12:21 PM, Nicholas Ipsen(Sephiroth_VII) wrote:
>>>>
>>>> I recently had mdadm mark a disk in my RAID5-array as faulty. As it
>>>> was within warranty, I returned it to the manufacturer, and have now
>>>> installed a new drive. However, when I try to add it, recovery fails
>>>> about halfway through,  with the newly added drive being marked as a
>>>> spare, and one of my other drives marked as faulty!
>>>>
>>>> I seem to have full access to my data when assembling the array
>>>> without the new disk using --force, and e2fsck reports no problems
>>>> with the filesystem.
>>>>
>>>> What is happening here?
>>>
>>> You haven't offered a great deal of information here, so I'll speculate:
>>>   an unused sector one of your original drives has become unreadable (per
>>> most drive specs, occurs naturally about every 12TB read).  Since
>>> rebuilding an array involves computing parity for every stripe, the
>>> unused sector is read and triggers the unrecoverable read error (URE).
>>> Since the rebuild is incomplete, mdadm has no way to generate this
>>> sector from another source, and doesn't know it isn't used, so the drive
>>> is kicked out of the array.  You now have a double-degraded raid5, which
>>> cannot continue operating.
>>>
> --snip--
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
