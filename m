From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RAID0 - unitialised zone->dev_start for zone[0]
Date: Thu, 14 May 2009 08:44:05 +0530
Message-ID: <37d33d830905132014n8c0270fw6a4cb4a80563c8d8@mail.gmail.com>
References: <37d33d830905131008y4a3a3815i6bec41a0d9b32ddf@mail.gmail.com>
	 <beb1238841d24e553e0248080d5e4dca.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <beb1238841d24e553e0248080d5e4dca.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 14, 2009 at 2:41 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, May 14, 2009 3:08 am, SandeepKsinha wrote:
>> Hi Neil,
>>
>>
>> [22:33:46 sinhas]$ diff raid0.c raid0.c.orig
>
> Always, always, always use "diff -u". =A0It provides context
> so the diff is much easier to read.
>
>> 160d159
>> < =A0 =A0 =A0 zone->dev_start =3D 0;
>> [/usr/src/linux-2.6.29/drivers/md]
>> [22:33:59 sinhas]$
>>
>> I see this piece of code missing and being used later.
>> Not very sure of the code flow, but still as part of defensive
>> programming.
>>
>> Am i missing something?
>
> conf->strip_zone is allocated with kzalloc, so all values are
> initialised to 0.
>

zone->zone_start =3D 0;

Sorry, this confused me.

> NeilBrown
>
>
>>
>>
>>
>> --
>> Regards,
>> Sandeep.
>>
>>
>>
>>
>>
>>
>> =93To learn is to change. Education is a process that changes the le=
arner.=94
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
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
