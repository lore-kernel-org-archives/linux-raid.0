From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Mon, 13 Jun 2011 19:41:38 +0100
Message-ID: <BANLkTi=2xO5ZR5Vy2Qb2WJPzCPesy32nkA@mail.gmail.com>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>
	<20110611000000.76ca58e7@natsu>
	<BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com>
	<BANLkTimf-P1x57KmYbunGp8UHskvjQS35A@mail.gmail.com>
	<4DF65758.2030405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF65758.2030405@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Blundell <tim.blundell@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13 June 2011 19:30, Tim Blundell <tim.blundell@gmail.com> wrote:
>
> On 6/11/2011 5:49 AM, Mathias Bur=C3=A9n wrote:
>>
>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> Model Family: =C2=A0 =C2=A0 Western Digital Caviar Green (Adv. Forma=
t) family
>> Device Model: =C2=A0 =C2=A0 WDC WD20EARS-00MVWB0
>> Serial Number: =C2=A0 =C2=A0WD-WMAZ20188479
>> Firmware Version: 50.0AB50
>> User Capacity: =C2=A0 =C2=A02,000,398,934,016 bytes
>> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0In smartctl database [for deta=
ils use: -P show]
>> ATA Version is: =C2=A0 8
>> ATA Standard is: =C2=A0Exact ATA specification draft version not ind=
icated
>> Local Time is: =C2=A0 =C2=A0Sat Jun 11 10:48:05 2011 IST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>
> Not certain if this was mentioned. While WDC WD20EARS drives can be u=
sed in
> an RAID array, WD recommends using there RAID capable drives in an
> enterprise environment.
> I tried using same drives in a simple RAID-1 array and had serious
> performance issues (sync taking a week) and stalls when writing to di=
sk. Are
> you using the stock firmware on these drives?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I'm using stock firmware as far as I know (I've not flashed them
manually), and I experience no performance issues. Of course, my
system is limited (RAID6 with an Intel Atom), so I can't really push
them all out to test it. But still, no issues.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
