From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of RAID1 fails (added disks stays as spare)
Date: Mon, 19 Aug 2013 18:04:28 +1000
Message-ID: <20130819180428.20e94e9d@notabene.brown>
References: <FC7EE784B0E13748AA4FF80E6D4CD67212E27E@w8kmail2.konzern.intern>
	<20130817105037.3aea0b4f@notabene.brown>
	<FC7EE784B0E13748AA4FF80E6D4CD67212EB01@w8kmail2.konzern.intern>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eHpx0MGWVT_IPUPb7R3QAwt"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FC7EE784B0E13748AA4FF80E6D4CD67212EB01@w8kmail2.konzern.intern>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias.Blaesing@persona.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/eHpx0MGWVT_IPUPb7R3QAwt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Aug 2013 07:48:20 +0000 <Matthias.Blaesing@persona.de> wrote:

> Hey,

> > Strange.  I would definitely have expected one of those to start the
> > recovery.
> > Does anything appear in the kernel logs (e.g. output of 'dmesg')?
>=20
> Please see the attaches boot.msg - from my perspective it only confirms t=
he results
> gained from the /proc/mdstat and mdadm output.

I guess I should have been more explicit.
It looks like you have just attached a log of what happened at boot.
I mean does anything appear in the dmesg output when you try to add the spa=
re
device to the array.

>=20
> To give some more information - her the mdadm.conf:
>=20
> s15434194:~ # cat /etc/mdadm.conf
> CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes
>=20
> MAILADDR root
>=20
> DEVICE containers partitions
> ARRAY /dev/md1 level=3Draid1 num-devices=3D2 devices=3D/dev/sda1,/dev/sdb1
> ARRAY /dev/md3 level=3Draid1 num-devices=3D2 devices=3D/dev/sda3,/dev/sdb3
>=20
>=20
> Could it be that the problem lies in the order in the devices row? When I=
 compare the working md1 and the non-working md3 array I see a difference i=
n the mapping of devices to numbers:

No, the order is irrelevant.

The experiment below wouldn't change anything.

NeilBrown

>=20
> For md1:
>=20
>    Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       17        1      active sync   /dev/sdb1
>=20
> For md3:
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8       19        0      active sync   /dev/sdb3
>        1       0        0        1      removed
>=20
>        2       8        3        -      spare   /dev/sda3
>=20
>=20
> Would this be worth a try (the disks need approx. 24 hours to reach the r=
ebuild-state, so I'm reluctant to try without some hope) to do:
>=20
> 1. change the Array line in /etc/mdadm.conf for md3 to read (switching or=
der):
> ARRAY /dev/md3 level=3Draid1 num-devices=3D2 devices=3D/dev/sdb3,/dev/sda3
> 2. Remove the spare sda3
> 3. Zero the superblock of sda3
> 4. Add sda3 again to the array
>=20
> ?
>=20
> Mit freundlichen Gr=C3=BC=C3=9Fen
>=20
> Matthias Bl=C3=A4sing
> Abt IT
> KompetenzCenter
>=20
> Tel.: 02351 950-344
> Fax.: 02351 950-222
> mailto: matthias.blaesing@persona.de
> www.persona.de
>=20
>=20
> persona service Verwaltungs AG & Co. KG=20
> Freisenbergstra=C3=9Fe 31 =E2=80=A2 58513 L=C3=BCdenscheid =20
> Tel.: (02351) 950-0 =E2=80=A2 Fax: (02351) 950-222=20
> Sitz L=C3=BCdenscheid =E2=80=A2 Registergericht Iserlohn, HRA Nr. 2930
>=20
> pers=C3=B6nlich haftende Gesellschafterin: persona service AG
> Gartenstra=C3=9Fe 93 =E2=80=A2 CH-4002 Basel
> Handelsregister Basel, Nr. CH-270.3.012.836-8
> diese vertreten durch den Verwaltungsrat:
> Georg Breucker (Pr=C3=A4sident) und Dr. Sebastian Burckhardt
> www.persona.de


--Sig_/eHpx0MGWVT_IPUPb7R3QAwt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhHRjDnsnt1WYoG5AQJWYhAAn+I7SOfZwi0pKm2BetkSM1SS8YWZyNGI
YhkaNyJa68MjAwjda0KRWP/yr8ombsTwtdskLnm6Q7YmsNZChho94sKwk5SwXi5b
7/6q+7xZYUeVzUH6iEI75ZOJozudFs9Jp+2sGqBBn/i5ycoUIg3jwY8xB19XWKXp
xC6CDJ4Iwk8t10v98MAYXySFrats5A9uNjl213Hi8eT+pefcq/LlnnkWuOgson5c
YoIxs/sVfF2V8YGLZJpQOpMVcKmbFQCtduarXRFWhuJSCrbrdWEKQlTUREWtHf1x
0pksYIBXXHnhnzfavi1YMPiE5J/HugpJlXX71IHfkFcg9B8WwUfF7tra4Tm/d7c6
doU+ZqExA3FZE69Ru+rCVUuC0hi6p2zAlKDsAxcJUMCRHDDuXWMnCECUbDRhzUZs
yST+a6jq0r+VZs6odiW0f3TtoCVc59DOGQsFpcHRuraQ/wyjmjst/CpKqwpsR2/w
XA/OkbLh7wx70kceLn5+oPpBFo/GWxwuPMLlsU4hvNdYHgOA2HPmQ8icxP1Yay/S
Zti3iG7jyHcpfcSFYa4cPZOHDXYKuZ/0/KaK7HJsrcIt0Kn1aEIBSLjYSxQCd1LX
QIuOCJ2TR9cHm9YII/8IfHzQssSDzSgdh4DQ4gUJZWfhN6oEQWp+kWYbbvVXZV7K
kyL0ksgxYqo=
=YmIs
-----END PGP SIGNATURE-----

--Sig_/eHpx0MGWVT_IPUPb7R3QAwt--
