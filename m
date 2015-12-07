From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: I/O errors without erros from underlying device
Date: Mon, 7 Dec 2015 18:06:15 +0100
Message-ID: <201512071806.15970.a.miskiewicz@gmail.com>
References: <201512071705.27177.a.miskiewicz@gmail.com> <22117.46523.245486.830064@quad.stoffel.home>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22117.46523.245486.830064@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 07 of December 2015, John Stoffel wrote:
> Arkadiusz> 4.3.0 kernel, raid6 array:
>=20
> I think there's a bug in the 4.3.x and 4.4-rc3 and lower with block
> merges.  I ran into these over the weekend, where v4.2.6 was stable,
> but anything higher would lock up and crash on me.

Well, no crashes here.

> So first step would be to make sure you get and test v4.4-rc4.

Do you know which commit there?

>=20
> Arkadiusz> md7 : active raid6 sdg[10] sdad1[9] sdac1[8] sdag1[7] sdaf=
1[6]
> sdae1[5] sdaj1[4] sdai1[3] sdah1[2] sdn1[1] Arkadiusz>       31255089=
152
> blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/10] [UUUUUUUUUU=
]
> Arkadiusz>       bitmap: 1/30 pages [4KB], 65536KB chunk
>=20
> Arkadiusz> array had weird failure where many disks went into failed =
state
> but Arkadiusz> remove && adding these disks "fixed" it (turns out not
> really fixed it).
>=20
> Arkadiusz> Unfortunately now some reads fail:
>=20
> Arkadiusz> pread(4, 0x1483a00, 4096, 16003680464896) =3D -1 EIO (Inpu=
t/output
> error)
>=20
> Arkadiusz> To reproduce used xfs_io
> Arkadiusz>  xfs_io -d -c "pread 16003680464896 4096" /dev/md7
> Arkadiusz> pread64: Input/output error
> Arkadiusz> which does pread exactly as shown above.
>=20
> Arkadiusz> write also fails for that area:
> Arkadiusz> xfs_io -d -c "pwrite 16003680464896 4096" /dev/md7
> Arkadiusz> pwrite64: Input/output error
>=20
> Arkadiusz> Note that nothing is written in dmesg when that happens.
>=20
> Arkadiusz> I've tried various offsets and sizes of pread and at some =
point
> that was logged: Arkadiusz> [  848.988518] Buffer I/O error on dev md=
7,
> logical block 3907148544, async page read
>=20
> Arkadiusz> but no error from underlying devices.
>=20
> Arkadiusz> List of bad blocks:
> Arkadiusz> http://sprunge.us/XSWI
>=20
> Arkadiusz> What can I do now?
>=20
> Arkadiusz> (loosing data from that few sectors is acceptable if the r=
est
> will be readable)
>=20
> Arkadiusz> Thanks,
> Arkadiusz> --
> Arkadiusz> Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org=
 )
> Arkadiusz> --
> Arkadiusz> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in Arkadiusz> the body of a message to
> majordomo@vger.kernel.org
> Arkadiusz> More majordomo info at=20
> http://vger.kernel.org/majordomo-info.html


--=20
Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
