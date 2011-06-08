From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Wed, 08 Jun 2011 11:11:17 +0100
Message-ID: <4DEF4AC5.1090003@anonymous.org.uk>
References: <4DEE6A11.1030205@xunil.at> <4DEE84F0.2030205@harddata.com> <4DEEBB66.7080802@nybeta.com> <isng0m$8c9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <isng0m$8c9$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/06/2011 10:38, David Brown wrote:
> On 08/06/2011 01:59, Thomas Harold wrote:
>> On 6/7/2011 4:07 PM, Maurice Hilarius wrote:
>>> On 6/7/2011 12:12 PM, Stefan G. Weichinger wrote:
>>>> Greetings, could you please advise me how to proceed?
>>>>
>>>> On a server I have 2 RAID1-arrays, each consisting of 2 TB-drives:
>>>>
>>>> ..
>>>>
>>>> Now I would like to move things to a more reliable RAID6 consisting of
>>>> all the four TB-drives ...
>>>>
>>>> How to do that with minimum risk?
>>>>
>>>> ..
>>>> Maybe I overlook a clever alternative?
>>>
>>> RAID 10 is as secure, and risk free, and much faster.
>>> And will cause much less CPU load.
>>>
>>
>> Well, with both a pair of RAID1 arrays and a pair of RAID-10 arrays, you
>> can lose 2 disks without losing data, but only if the right 2 disks fail.
>>
>> With RAID6, any two of the four can fail without data loss.
>>
>
> It /sounds/ like RAID6 is more reliable here because it can always
> survive a second disk failure, while with RAID10 you have only a 66%
> chance of surviving a second disk failure.
>
> However, how often does a disk fail? What is the chance of a random disk
> failure in a given space of time? And how long will it go between one
> disk failing, and it being replaced and the array rebuilt? If you figure
> out these numbers, you'll have the probability of losing your RAID10
> array due to the second critical disk failing.
>
> To pick some rough numbers - say you've got low reliability, cheap disks
> with a 500,000 hour MTBF. If it takes you 3 days to replace a disk (over
> the weekend), and 8 hours to rebuild, you have a risk period of 80
> hours. That gives you a 0.016% chance of having the second disk failing.
> Even if you consider that a rebuild is quite stressful on the critical
> disk, it's not a big risk.

It's not so much that the mirror disc might fail that I'd be worried 
about, it's that you might find the odd sector failure during the 
rebuild - this is the reason why RAID5 is now so disliked, and the 
reasons apply similarly to RAID1 and RAID10 too, even if you're only 
relying on one disc ('s worth of data) being perfect rather than two or 
more.

Still, I don't have any stats to back this up...

Cheers,

John.

