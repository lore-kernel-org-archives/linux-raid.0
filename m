From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Tue, 14 Jun 2011 08:15:32 +0800
Message-ID: <4DF6A824.6070502@fnarfbargle.com>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>	<20110611000000.76ca58e7@natsu>	<BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com> <BANLkTimf-P1x57KmYbunGp8UHskvjQS35A@mail.gmail.com> <4DF65758.2030405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DF65758.2030405@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/06/11 02:30, Tim Blundell wrote:
>
> On 6/11/2011 5:49 AM, Mathias Bur=C3=A9n wrote:
>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>> Model Family:     Western Digital Caviar Green (Adv. Format) family
>> Device Model:     WDC WD20EARS-00MVWB0
>> Serial Number:    WD-WMAZ20188479
>> Firmware Version: 50.0AB50
>> User Capacity:    2,000,398,934,016 bytes
>> Device is:        In smartctl database [for details use: -P show]
>> ATA Version is:   8
>> ATA Standard is:  Exact ATA specification draft version not indicate=
d
>> Local Time is:    Sat Jun 11 10:48:05 2011 IST
>> SMART support is: Available - device has SMART capability.
>> SMART support is: Enabled
>
> Not certain if this was mentioned. While WDC WD20EARS drives can be u=
sed in an RAID array, WD=20
> recommends using there RAID capable drives in an enterprise environme=
nt.
> I tried using same drives in a simple RAID-1 array and had serious pe=
rformance issues (sync taking=20
> a week) and stalls when writing to disk. Are you using the stock firm=
ware on these drives?

Just a data point. I have 10 of them in a RAID-6. They are in a 6 core =
/ 16GB box with PCIe SAS=20
controllers (so the machine is not bandwidth starved). I hammer the liv=
ing daylights out of them.=20
They are quite fast for sequential access, not very fast for random IO =
and they are pretty cool and=20
quiet.
I have used WDIDLE3 to turn off the idle timer to stop the heads unload=
ing though.

The reason WD state their consumer drives are no good in RAID applicati=
ons is TLER. On a hardware=20
RAID controller the drives can get kicked out of the array if they go i=
nto a deep recovery read, but=20
md does not suffer this issue.

On SMART, it's prudent to configure smartmontools to do regular checks =
and e-mail you if it sees an=20
issue. I do a long every sunday and shorts every other morning and have=
 had early notification of=20
pending issues a couple of times. Definitely worth the price of admissi=
on.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
