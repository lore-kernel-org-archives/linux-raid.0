From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: New RAID causing system lockups
Date: Mon, 13 Sep 2010 11:57:03 -0400
Message-ID: <AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> I don't know yet what is causing the lock-up. =A0A quick look at yo=
ur logs
>>> suggest that it could be related to the barrier handling. =A0Maybe =
trying to
>>> handle a barrier during a reshape is prone to races of some sort - =
I wouldn't
>>> be very surprised by that.
>>
>> Just note that during the second lockup no reshape or resync was goi=
ng
>> on. The array state was stable, I was just writing to it.
>>
>>>
>>> I'll have a look at the code and see what I can find.
>>
>> Thanks a lot. If it was only a risk when I was growing/reshaping the
>> array, and covered by the backup file, it would just be an
>> inconvenience. But since it can seemingly happen at any time it's a
>> problem.
>>
>
> The lockup just happened again. I wasn't doing any
> growing/reshaping/anything like that. Just copying some data into the
> partition that lives on md0. dmesg_3.txt has been uploaded alongside
> the other files at http://www.hartmanipulation.com/raid/. The trace
> looks pretty similar to me.
>

The lockup just happened for the fourth time, less than an hour after
I rebooted to clear the previous lockup from last night. All I did was
boot the system, start the RAID, and start copying some files onto it.
The problem seems to be getting worse - up until now I got at least a
full day of fairly heavy usage out of the system before it happened.
dmesg_4.txt has been uploaded alongside the other files. Let me know
if there's any other system information that would be useful.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
