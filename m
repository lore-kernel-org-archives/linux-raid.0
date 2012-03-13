From: David Brown <david@westcontrol.com>
Subject: Re: Striping does not increase performance.
Date: Tue, 13 Mar 2012 15:12:13 +0100
Message-ID: <jjnl2g$nir$1@dough.gmane.org>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com> <jjl15t$iqb$1@dough.gmane.org> <CAKFseUMvepXdGumQVoei_TE3Ms-jK9U4BoKOVjaiz9PdOAU8pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKFseUMvepXdGumQVoei_TE3Ms-jK9U4BoKOVjaiz9PdOAU8pg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/03/2012 12:55, Caspar Smit wrote:
> Op 12 maart 2012 15:20 heeft David Brown<david@westcontrol.com>  het
> volgende geschreven:
>> On 12/03/2012 13:34, Caspar Smit wrote:
>>>
>>> Hi all,
>>>
>>> I don't know exactly which mailinglists to use for this one so I hope
>>> i used the right ones.
>>>
>>> I did some performance testing on a new system and found out some
>>> things I couldn't explain or didn't expect.
>>> At the end are some questions I hope to get answered to explain the
>>> tings i'm seeing in the test.
>>>
>>>
>>> For the next test I wanted to see if i could double the performance by
>>> striping an LV over 2 md's (so instead of using 10 disks/spindles, use
>>> 20 disks/spindles)
>>>
>>> So i added md1 to the VG as PV.
>>>
>>> Created a fresh LV striped across the two PV's using a 64KB stripe
>>> size and ran the test again.
>>>
>>>
>>> Now the total IO's in 10 seconds are 16x larger than before. 190464 /
>>> 10 = 19046,4 / 16 = 1190,4 /16 = the reported 75 IOPS above.
>>> So the 64KB blocks seem to be split into 4KB blocks (64 / 16 = 4)
>>> which results in a way larger total IO's.
>>> The IO's per disk seem to be in 64KB blocks still only now with a
>>> large MERGE figure besides it. (Now 4KB blocks are merged into 64KB
>>> blocks?)
>>>
>>
>> LVM will stripe the data between the two md's with a default stripe size of
>> 4K - thus the first 4K will go to md0, the second to md1, etc.  This is
>> obviously terribly inefficient.  For 8+2 raid6 with 64KB chunks, you want a
>> stripe size of 8x64K = 512KB when you create the logical volume.
>
> Ok, that makes sense.
> But if I for instance had created a 10 disk RAID5 md with a 64KB chunk
> size it would have been a stripe size of 9x64KB=576KB which is not
> possible. So I have to make sure I always create a raid5/6 md where
> the stripe size is a power of 2 when i want to use raid0 and/or LVM
> striping, correct?
>

LVM raid is limited compared to mdadm.  As far as I know, mdadm raid 
chunk sizes are not limited to a power of 2.

Note, however, that I have no experience with more than 4 disks in an 
array, only some theoretical knowledge.  So my suggestions are only 
ideas to try - nothing is guaranteed correct.  Usually someone else on 
this list will jump in if I say something truly stupid, so changing 
chunk sizes is perhaps worth a try.

mvh.,

David

