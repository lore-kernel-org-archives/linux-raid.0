From: Phil Turmel <philip@turmel.org>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Thu, 30 Jun 2011 10:44:38 -0400
Message-ID: <4E0C8BD6.1080907@turmel.org>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org> <4E0C7196.1070307@gmx.de> <4E0C7B4B.7090404@turmel.org> <4E0C8685.3020806@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C8685.3020806@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/30/2011 10:21 AM, Karsten R=C3=B6mke wrote:
> Hi Phil
>>
>> If your CPU has free cycles, I suggest you run raid6 instead of raid=
5+spare.
>>
>> Phil
>>
> I started the raid 6 array and get:
>=20
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sde5[4] sdd5[3] sdc5[2] sdb2[1] sda3[0]
>       13759296 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  resy=
nc =3D 87.4% (4013184/4586432) finish=3D0.4min speed=3D20180K/sec
>=20
> when I started the raid 5 array I get
>=20
> md0 : active raid5 sdd5[4] sde5[5](S) sdc5[2] sdb2[1] sda3[0]
>       13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>       [=3D>...................]  recovery =3D  6.2% (286656/4586432) =
finish=3D0.9min speed=3D71664K/sec
>=20
> so I have to expect a three times less write speed - or is this calcu=
lation
> to simple ?

That's a bigger difference than I would have expected for resync, which=
 works in full stripes.  If you have a workload with many small random =
writes, this slowdown is quite possible.

Is your CPU maxed out while writing to the raid6?

Can you run some speed tests?  dd streaming read or write in one window=
, with "iostat -xm 1" in another is a decent test of peak performance. =
 bonnie++, dbench, and iozone are good for more generic workload simula=
tion.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
