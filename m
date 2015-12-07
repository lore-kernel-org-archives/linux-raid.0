From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: I/O errors without erros from underlying device
Date: Mon, 7 Dec 2015 21:46:28 +0100
Message-ID: <201512072146.28378.a.miskiewicz@gmail.com>
References: <201512071705.27177.a.miskiewicz@gmail.com> <201512071803.26434.arekm@maven.pl> <22117.49283.546268.719858@quad.stoffel.home>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22117.49283.546268.719858@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 07 of December 2015, John Stoffel wrote:
> >>>>> "Arkadiusz" =3D=3D Arkadiusz Mi=B6kiewicz <arekm@maven.pl> writ=
es:
> Arkadiusz> On Monday 07 of December 2015, John Stoffel wrote:
>=20
> Arkadiusz> 4.3.0 kernel, raid6 array:
> >> I think there's a bug in the 4.3.x and 4.4-rc3 and lower with bloc=
k
> >> merges.  I ran into these over the weekend, where v4.2.6 was stabl=
e,
> >> but anything higher would lock up and crash on me.
>=20
> Arkadiusz> Well, no crashes here.
>=20
> That's good.  It was hard(er) to hit when I wasn't running KVM VMs at
> the same time on the server, and I was running strictly RAID1 disks,
> so it's hard to know.
>=20
> >> So first step would be to make sure you get and test v4.4-rc4.
>=20
> Arkadiusz> Do you know which commit there?
>=20
> Try this, from the master lkml git repository:
>=20
>     2873d32ff493ecbfb7d2c7f56812ab941dda42f4

It's merge commit. Don't see any obvious patch in that merge that would=
 help=20
my case.


Anyway I would expect my problem to be related to badblock lists which =
numbers=20
are close to dmesg error message: [  848.988518] Buffer I/O error on de=
v md7,=20
logical block 3907148544, async page read

> >> http://sprunge.us/XSWI

But how to repair these if write() also fails and=20
http://www.spinics.net/lists/raid/msg49325.html suggests that write sho=
uld=20
"fix" these (by using replacement blocks I guess) ?


=20
> Arkadiusz> md7 : active raid6 sdg[10] sdad1[9] sdac1[8] sdag1[7] sdaf=
1[6]
>=20
> >> sdae1[5] sdaj1[4] sdai1[3] sdah1[2] sdn1[1] Arkadiusz>       31255=
089152
> >> blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/10] [UUUUUUU=
UUU]
>=20
> Arkadiusz> bitmap: 1/30 pages [4KB], 65536KB chunk
>=20
> Arkadiusz> array had weird failure where many disks went into failed =
state
>=20
> >> but Arkadiusz> remove && adding these disks "fixed" it (turns out =
not
> >> really fixed it).
>=20
> Arkadiusz> Unfortunately now some reads fail:
>=20
> Arkadiusz> pread(4, 0x1483a00, 4096, 16003680464896) =3D -1 EIO (Inpu=
t/output
>=20
> >> error)
>=20
> Arkadiusz> To reproduce used xfs_io
> Arkadiusz> xfs_io -d -c "pread 16003680464896 4096" /dev/md7
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
>=20
> >> that was logged: Arkadiusz> [  848.988518] Buffer I/O error on dev=
 md7,
> >> logical block 3907148544, async page read
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
>=20
> >> will be readable)
>=20
> Arkadiusz> Thanks,
> Arkadiusz> --
> Arkadiusz> Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org=
 )
> Arkadiusz> --
> Arkadiusz> To unsubscribe from this list: send the line "unsubscribe
>=20
> >> linux-raid" in Arkadiusz> the body of a message to
> >> majordomo@vger.kernel.org
>=20
> Arkadiusz> More majordomo info at
>=20
> >> http://vger.kernel.org/majordomo-info.html
>=20
> Arkadiusz> --
> Arkadiusz> Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org=
 )


--=20
Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )

--=20
Arkadiusz Mi=B6kiewicz, arekm / ( maven.pl | pld-linux.org )
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
