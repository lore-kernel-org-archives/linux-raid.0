From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: time limited error recovery and md raid
Date: Fri, 5 Dec 2008 18:52:03 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812051851010.4906@p34.internal.lan>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan> <1228518288.16555.98.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228518288.16555.98.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 6 Dec 2008, Redeeman wrote:

> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
>>
>> On Fri, 5 Dec 2008, Redeeman wrote:
>>
>>> Hello..
>>>
>>> Im going to be building a software raid6 setup with probably 8 disks,
>>> and i've been looking at the wd gp disks, which comes in both standard
>>> and raid edition, with the raid edition being much more expensive.
>>>
>>> I have searched around, and found that it is indeed possible to activate
>>> tler on the "normal" disks, however, the setting has a parameter, more
>>> specifically, how many seconds it should be limited to. Default is 7.
>>>
>>> So i was wondering, what should that be set to, to be optimal for linux
>>> md raid? i havent been able to find any information about this.
>>>
>>>
>>> Thanks.
>>>
>>>
>>> mvh.
>>> Kasper Sandberg
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> The exact time is a good question.
>
> About this, shouldnt it be possible to find the exact time which the
> linux raid system waits until it auto kicks out the drive?
>
>
>>
>> Something I have noticed is when TLER is off, the drives hang up when they
>> hit a bad sector and when TLER is on, the drives is kicked out of the
>> array immediately when it reports a bad sector.
>
> On further thought, might this not suggest that the linux raid system
> waits indefinetly for I/O error, before kicking out?
It times out after 1-2 minutes.  I have been dealing with this for a very long
time, another 'symptom' is short smart tests taking forever when the disk is in 
a soon-to-be failing state.
>
> If that is indeed the case, then if the use of the raid isnt
> time-critical, then maybe its a good thing to have tler enabled, just in
> case the disk is able to fix stuff?
With TLER enabled the drive is kicked out immediately. The purpose of TLER is
that of HW raid where it can alert the controller about it and the controller
handles it.

