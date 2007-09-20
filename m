From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: MD devices renaming or re-ordering question
Date: Thu, 20 Sep 2007 09:41:29 -0600
Message-ID: <46F294A9.90203@harddata.com>
References: <46E984E7.1080903@harddata.com> <46F28DCE.4040102@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46F28DCE.4040102@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>, vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> ..
> I'm not clear on what you mean by a "plain disk" followed by a list of
> partitions. If that means putting all your initial data on a single
> disk without RAID protection, that's a far worse idea in my experience
> than splitting arrays across controllers.
It is easiest enough for now to mirror the boot drive.
I worded it this way to make it clear the migration is not a booting issue.
>> The remaining 15 disks are configured as :
>> sdb1 through sde1 as md0 ( 4 devices/partitions)
>> sdf1 through sdp1 as md1 (10 devices/partitions)
>> I want to add a 2nd controller, and 4 more drives, to the md0 device.
>>
>> But, I do not want md0 to be "split" across the 2 controllers this way.
>> I prefer to do the split on md1
>>   
> Move the md0 drives to the 2nd controller, add more.
Yes, that is one way, involving some hardware swapping and more downtime.
>> Other than starting from scratch, the best solution would be to add the
>> disks to md0, then to "magically" turn md0 into md1, and md1 into md0
>>   
>
> Unless you want to practice doing critical config changes, why? Moving
> the drives won't effect their name, at least not unless you have done
> something like configure by physical partition name instead of UUID.
> Doing that for more than a few drives is a learning experience waiting
> to happen. If that's the case, backup your mdadm.conf file and
> reconfigure using UUID, then start moving things around.
OK, where may I learn more on using UUID for drive identification?
I have always assembled a RAID using the syntax /dev/sdxx ( sd drive
letter and partition number)
I take it there is a way to identify the UUID of a drive and partition
and assemble and maintain using syntax that way?

I hope that this will also get me past the problem sometimes of running
out  of letters in the 26 char alphabet!
I never thought the day where I would have a problem with more than 24
drives.. OK, so I show my age there!
> ..
> Then consider the performance vs. reliability issues of having all
> drives on a single controller.
> Multiple controllers give you more points of failure unless you are
> mirroring across them, but better peak performance.
Controller reliability seems to be not an issue. I have rarely seen a
3Ware card fail.
Drives, OTOH, well..
Hence the desire to have duplicated arrays, so we can clone across on MD
to another.

> Note, I'm suggesting evaluating what you are doing only, it may be
> fine, just avoids "didn't think about that" events.
>
Agreed. All good points.
> Well, you asked for suggestions...  ;-)
These are appreciated.
I am still looking , however, for a way to rename and md device.

Another case where it comes up is when I take a set of drives from one
machine and move them to another.
Having conflicting md devices comes to mind..

Thanks Bill




-- 

With our best regards,


Maurice W. Hilarius        Telephone: 01-780-456-9771
Hard Data Ltd.  FAX:       01-780-456-9772
11060 - 166 Avenue         email:maurice@harddata.com
Edmonton, AB, Canada       http://www.harddata.com/
   T5X 1Y3

