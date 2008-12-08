From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: time limited error recovery and md raid
Date: Mon, 8 Dec 2008 12:01:34 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812081200070.718@p34.internal.lan>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>  <1228518288.16555.98.camel@localhost>  <alpine.DEB.1.10.0812051851010.4906@p34.internal.lan> <1228755569.16555.113.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228755569.16555.113.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 8 Dec 2008, Redeeman wrote:

> On Fri, 2008-12-05 at 18:52 -0500, Justin Piszcz wrote:
>>
>> On Sat, 6 Dec 2008, Redeeman wrote:
>>
>>> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
>>>>
>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>
>>>>> Hello..
>>>>>
>>>>> Im going to be building a software raid6 setup with probably 8 disks,
>>>>> and i've been looking at the wd gp disks, which comes in both standard
>>>>> and raid edition, with the raid edition being much more expensive.
>>>>>
>>>>> I have searched around, and found that it is indeed possible to activate
>>>>> tler on the "normal" disks, however, the setting has a parameter, more
>>>>> specifically, how many seconds it should be limited to. Default is 7.
>>>>>
>>>>> So i was wondering, what should that be set to, to be optimal for linux
>>>>> md raid? i havent been able to find any information about this.
>>>>>
>>>>>
>>>>> Thanks.
>>>>>
>>>>>
>>>>> mvh.
>>>>> Kasper Sandberg
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>
>>>> The exact time is a good question.
>>>
>>> About this, shouldnt it be possible to find the exact time which the
>>> linux raid system waits until it auto kicks out the drive?
>>>
>>>
>>>>
>>>> Something I have noticed is when TLER is off, the drives hang up when they
>>>> hit a bad sector and when TLER is on, the drives is kicked out of the
>>>> array immediately when it reports a bad sector.
>>>
>>> On further thought, might this not suggest that the linux raid system
>>> waits indefinetly for I/O error, before kicking out?
>> It times out after 1-2 minutes.  I have been dealing with this for a very long
>> time, another 'symptom' is short smart tests taking forever when the disk is in
>> a soon-to-be failing state.
>
> Do you know if this is actually caused by the disk's error recovery
> timing out in 1-2 minutes, or the linux raid system?
I am not sure, that is a good question.  I am not sure how long the drive 
itself will spend 'searching' or trying to repair/read a bad sector with 
TLER off vs. when the kernel will drop the disk for not responding.

Justin.
