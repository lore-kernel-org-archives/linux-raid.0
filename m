From: Tim Blundell <tim.blundell@gmail.com>
Subject: Re: HDD reports errors while completing RAID6 array check
Date: Mon, 13 Jun 2011 14:30:48 -0400
Message-ID: <4DF65758.2030405@gmail.com>
References: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>	<20110611000000.76ca58e7@natsu>	<BANLkTinPfZeSwJ8Tckc0usXFpLHHuPSz4Q@mail.gmail.com> <BANLkTimf-P1x57KmYbunGp8UHskvjQS35A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimf-P1x57KmYbunGp8UHskvjQS35A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 6/11/2011 5:49 AM, Mathias Bur=C3=A9n wrote:
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Caviar Green (Adv. Format) family
> Device Model:     WDC WD20EARS-00MVWB0
> Serial Number:    WD-WMAZ20188479
> Firmware Version: 50.0AB50
> User Capacity:    2,000,398,934,016 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   8
> ATA Standard is:  Exact ATA specification draft version not indicated
> Local Time is:    Sat Jun 11 10:48:05 2011 IST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled

Not certain if this was mentioned. While WDC WD20EARS drives can be use=
d=20
in an RAID array, WD recommends using there RAID capable drives in an=20
enterprise environment.
I tried using same drives in a simple RAID-1 array and had serious=20
performance issues (sync taking a week) and stalls when writing to disk=
=2E=20
Are you using the stock firmware on these drives?

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
