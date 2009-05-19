From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md: Enhancements and clean to linear RAID
Date: Tue, 19 May 2009 16:16:01 +0530
Message-ID: <37d33d830905190346g4147a114o5f4a53bf64c1ebac@mail.gmail.com>
References: <37d33d830905182323x22eec1c8l2a7471668c1a02b3@mail.gmail.com>
	 <9a138833b29b54e5d6c1eaa188f27399.squirrel@neil.brown.name>
	 <37d33d830905190031u5172af46kccb720343e359d99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905190031u5172af46kccb720343e359d99@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

I have made all the required changes and have tested the changes.
It works fine.

Thanks for enlightening me, the changes really optimized the code furth=
er.

The patches will be followed by this mail.

On Tue, May 19, 2009 at 1:01 PM, SandeepKsinha <sandeepksinha@gmail.com=
> wrote:
> Thanks Neil,
>
>
> On Tue, May 19, 2009 at 12:55 PM, NeilBrown <neilb@suse.de> wrote:
>> On Tue, May 19, 2009 4:23 pm, SandeepKsinha wrote:
>>> Hi Neil,
>>>
>>> I have made the desired changes and have tested the changes as well=
=2E
>>> As expected the performance gain with number of devices ( > 20 ) is
>>> quite visible.
>>
>> How did you measure the performance gain and what were your
>> results?
>>
>
> I created arrays with 20 devices and performed random I/O it.
> The results with linear search were slower as compared to binary.
>
>>> The code also looks simpler as compared to what it earlier was.
>>>
>>> I have created the following patches for the changes:
>>>
>>> PATCH [01/03] md: Removal of num_sectors from dev_info in linear ra=
id
>>>
>>> This patch removes the num_sectors from dev_info and makes use of t=
he
>>> rdev->sectors for
>>> all further usage.
>>
>> Could I as you to redo this one a little differently?
>> I want to keep the linear search very tight, and you have just added
>> a pointer de-reference to it.
>>
>> If you could replace start_sector by end_sector, we wouldn't need th=
at
>> de-reference or the addition.
>>
>>
> I would make the required changes.
>
>>>
>>> PATCH[02/03] md: Getting rid of sector_div and hash table in linear=
 raid
>>>
>>> Removal of all the code pertaining hast table and other related dat=
a
>>> structures.
>>> This also makes the code really really simple.
>>> The searching being made linear for the time being to test the patc=
h.
>>>
>>> PATCH[03/03] md: Replacing linear with a binary search
>>>
>>> This patch replaces the linear search in which_dev with binary sear=
ch.
>>
>> Two things wrong with you binary search.
>> 1/ the while() condition is "hi >=3D lo". =A0That will always be tru=
e, so it
>> =A0would be better to make that explicit. =A0i.e. "while(1)".
>> =A0However the while loop of a binary search should be
>> =A0 while (hi > lo)
>>
>> 2/ You have 3 comparisons against 'sector' inside the loop. =A0There=
 should
>> =A0 only be one. =A0We are aiming for speed remember :-)
>>
>> =A0 while (hi > lo) {
>> =A0 =A0 =A0 mid =3D (hi + lo + 1) / 2;
>> =A0 =A0 =A0 dev =3D conf->disks + mid;
>>
>> =A0 =A0 =A0 if (sector >=3D dev->start_sector)
>> =A0 =A0 =A0 =A0 =A0 =A0lo =3D mid;
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0hi =3D mid - 1;
>> =A0 =A0}
>> =A0 =A0return dev;
>>
>> =A0 =A0With that formulation, you don't even need to replace
>> =A0 =A0sector_start by sector_end.. However doing so would make othe=
r
>> =A0 =A0code simpler, so please do proceed with replacing sector_star=
t by
>> =A0 =A0sector_end.
>> =A0 =A0Then the binary search (with a fix because dev can be uniniti=
alised),
>> =A0 =A0becomes:
>>
>> =A0 =A0while (hi > lo) {
>> =A0 =A0 =A0 mid =3D (hi + lo) / 2;
>>
>> =A0 =A0 =A0 if (sector < conf->disks[mid].end_sector)
>> =A0 =A0 =A0 =A0 =A0 =A0hi =3D mid;
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0lo =3D mid + 1;
>> =A0 =A0}
>> =A0 =A0return conf->disks + lo;
>>
>
> I will make this change too.
>
>
> Thanks.
>
>> NeilBrown
>>
>>
>>
>>
>
>
>
> --
> Regards,
> Sandeep.
>
>
>
>
>
>
> =93To learn is to change. Education is a process that changes the lea=
rner.=94
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
