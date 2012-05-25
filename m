From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid 10f2 vs 1 on 2 drives
Date: Fri, 25 May 2012 16:40:07 -0300
Message-ID: <CABYL=TrnYX2jShNA-8Lb5HbY3xVst00=W=_W2mfuXMoJ_+ouUA@mail.gmail.com>
References: <20120522193340.GM27769@electro-mechanical.com>
	<4FBC14DC.8070007@hesbynett.no>
	<20120523112545.GN27769@electro-mechanical.com>
	<4FBFD78D.1010503@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FBFD78D.1010503@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, William Thompson <wt@electro-mechanical.com>
List-Id: linux-raid.ids

in my tests with a mysql and similar database scenarios where write /
read are near 50% / 50% (many updates/inserts and many selects) the
best raid is 1
where scenario is 10%write / 90% read
raid 10far is better (if not degraded or out of sync)


just two scenarios to help 'what's better'  question

2012/5/25 Bill Davidsen <davidsen@tmr.com>:
> William Thompson wrote:
>>
>> On Wed, May 23, 2012 at 12:36:12AM +0200, David Brown wrote:
>>>
>>> On 22/05/12 21:33, William Thompson wrote:
>>>>
>>>> I understand that raid 10 f2 is slower on writes due to the locati=
on of
>>>> the
>>>> 2nd copy. =A0My question is, if lots of writes are performed, coul=
d this
>>>> layout wearout the drives quicker than raid 1?
>>>
>>>
>>> No, wear is not going to be significantly different.
>>>
>>> You didn't say whether you are talking about hard disks (where
>>
>>
>> Sorry about that (Chief). =A0Yes, I was refering to hard drives.
>>
>>> location makes a difference, but "wear" on the drive motor is
>>> insignificant to the disk's expected lifetime), or flash disks
>>
>>
>> I was thinking about how much more head movement there would be to w=
rite
>> the
>> 2nd copy of the data.
>>
> There _is_ no extra head motion. The location of consecutive blocks i=
s
> different on each drive, but as I read the mapping function the dista=
nce
> between blocks on the same drive will be about the same, so amount of=
 head
> motion (both number and distance) is the same on each drive, but the
> location of that motion is not the same.
>
> One drive may be seeking at the outer edge of the platter while anoth=
er
> seeks near the spindle, but there's the same amount of seeking on eac=
h.
>
>
> --
> Bill Davidsen <davidsen@tmr.com>
> =A0"We have more to fear from the bungling of the incompetent than fr=
om
> the machinations of the wicked." =A0- from Slashdot
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
