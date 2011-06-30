From: NeilBrown <neilb@suse.de>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Fri, 1 Jul 2011 07:28:55 +1000
Message-ID: <20110701072855.69ee763b@notabene.brown>
References: <4E0C5539.4030000@gmx.de>
	<4E0C5E47.5090604@anonymous.org.uk>
	<4E0C6CC4.3030506@turmel.org>
	<4E0C7196.1070307@gmx.de>
	<4E0C7B4B.7090404@turmel.org>
	<4E0C8685.3020806@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C8685.3020806@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Karsten =?ISO-8859-1?B?UvZta2U=?= <k.roemke@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Jun 2011 16:21:57 +0200 Karsten R=F6mke <k.roemke@gmx.de> wr=
ote:

> Hi Phil
> >
> > If your CPU has free cycles, I suggest you run raid6 instead of rai=
d5+spare.
> >
> > Phil
> >
> I started the raid 6 array and get:
>=20
> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md0 : active raid6 sde5[4] sdd5[3] sdc5[2] sdb2[1] sda3[0]
>        13759296 blocks level 6, 64k chunk, algorithm 2 [5/5] [UUUUU]
>        [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  res=
ync =3D 87.4% (4013184/4586432) finish=3D0.4min speed=3D20180K/sec
                                  ^^^^^^
Note: resync

>=20
> when I started the raid 5 array I get
>=20
> md0 : active raid5 sdd5[4] sde5[5](S) sdc5[2] sdb2[1] sda3[0]
>        13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
>        [=3D>...................]  recovery =3D  6.2% (286656/4586432)=
 finish=3D0.9min speed=3D71664K/sec
                                  ^^^^^^^^
Note: recovery.

>=20
> so I have to expect a three times less write speed - or is this calcu=
lation
> to simple ?
>=20

You are comparing two different things, neither of which is write speed=
=2E
If you want to measure write speed, you should try writing and measure =
that.

When you create a RAID5 mdadm deliberately triggers recovery rather tha=
n
resync as it is likely to be faster.  This is why you see a missed devi=
ce and
an extra spare.  I don't remember why it doesn't with RAID6.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
