From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Best strategy to incrementally replace smaller HDDs
Date: Fri, 09 Sep 2011 16:12:36 +0200
Message-ID: <1315577572.14468.11.camel@michal-laptop>
References: <1315565285.2291.25.camel@michal-laptop>
	 <j4d19g$1r4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zeZJsAMiTGEAhi+i1KZZ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j4d19g$1r4$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-zeZJsAMiTGEAhi+i1KZZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2011-09-09, pi=C4=85 o godzinie 14:34 +0200, David Brown pisze:
> On 09/09/2011 12:48, Micha=C5=82 Sawicz wrote:
> > Hi all, given the configuration below:
> >        * 8 x 1TB HDDs
> >        * 2 x 2TB HDDs
> >
> > On which I currently have:
> >        * (10 x 1TB) RAID6 - persistent storage
> >        * (2 x 1TB) system / temporary storage etc.
> >
>=20
> By this do you mean that you have 8 x 1TB drives with a 1 TB partition=
=20
> on each, and 2 x 2T drives with 2 x 1TB partition on each?  So that the=
=20
> two big disks are shared with both raids?
Yes, that wasn't like that before, but that's a result of exchanging two
1TB drives to 2TB ones.=20

> > I want to replace the 1TB drives for 2TB ones on an as-needed basis,
> > what strategy would you recommend?
>=20
> This sounds like you are thinking that you can replace a single disk in=
=20
> your RAID6 array and get more storage - changing 10 x 1 TB raid6 =3D 8TB=
=20
> into 9 x 1TB + 1 x 2TB raid6 =3D 9 TB.  It doesn't work like that.  You=
=20
> will have to replace /all/ your 1 TB devices with 2 TB devices (and move=
=20
> the second raid off the two existing 2TB devices) - all members of the=
=20
> raid6 must be the same size.
Actually no, I know how RAIDs work, so the three schemes I described
below account for that.

> To help you plan your upgrades, it is also useful to know your=20
> partitioning scheme (for example, do you use LVM?), whether you have the=
=20
> space to put lots more drives in the system or must do it one drive at a=
=20
> time, whether you can take the system off-line during the process, and=
=20
> whether you need to do the upgrade quickly or can spend a week or so at=
=20
> it (some of these are conflicting requirements).
No LVM here. The most important - big RAID6 - is a single partition. The
remaining 2 x 1TB on the big drives are split into RAID1 for boot,
RAID10 for root, RAID0 for temporary storage and swap space. I can
temporarily put more drives in there. I can take it off-line for some
periods and I can do the upgrade over an extended period of time.=20

> Before you think about upgrading, however, make sure you have a solid=20
> backup.  Then make sure you have a backup of that backup - and a plan=20
> for how to restore everything if something goes horribly wrong.
Yeah... I plan to rely on RAID's redundancy by moving data around,
growing / shrinking the filesystems and then shuffling the HDDs. I know
that's asking for trouble, but I haven't yet found a place to rent 8TBs
of storage for a week... And that's worked for me in the past, btw.
Twice, even, IIRC.

--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-zeZJsAMiTGEAhi+i1KZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOah7UAAoJEGnv7NPGHSZFr4gP/R1SMqdQ5tvAIoaAvfiiUTUh
t+63PUdaooAe6fncGEnQ56jDf0CwnbexQugaFE1OctWHzvzBK1sDAqabg7Kr3Nu8
HWpUVI3ELKdDep3dS0GXkvX1C3STuHY+uZYPSjr3Wl/9K+Gc8r8huHcMbwXaANK7
D5c1GmmGjf/XpONl+gzkHVl+v0XEBjm2HtTBmhZ6jniAsRkymFl5m6j5JwM/W3SJ
LweygFetcigarVPwyaFsieB4zyksL8aaBscBsL4XhhcDI7FUq4Ur5wrXo3Dv0zU6
8B1jP0k1CQM37twuuxdHxcW9Uu9DSC28O/C9SdnX4xe1RgcWjsveolZecLL6up3X
haSYSDl+vy5JAKQOSyYZAtjV9FtgJiJcBF5owFcmlI/h4H75swOj+X5WrGpbU4RX
bNEig6v0Ihwo1W4dcyK6ggH02LL8h2iLImaCUSn3npqwLvSJPN2gAObrC5Zvd1pG
nYxEzOHmWfWoXOHLQhkSM4GtIEf6plyxh5kMylnMTTiBaEsE0YFvbvRb0nTMa885
7pt8BR2W9GsgeHA6lTG7l0sJUaFkf+mhRnnEOr4IBPA3XPBY6fAhGw3Jrfurg1vc
a9A+Y9d1wBPfK7ziKcsRjZXshgKjuyrRO3LRzooS+WsXd5dKzUeI0nbvAT7kRkxZ
v7ZGK5jsTjpA6WghLUim
=km5Q
-----END PGP SIGNATURE-----

--=-zeZJsAMiTGEAhi+i1KZZ--

