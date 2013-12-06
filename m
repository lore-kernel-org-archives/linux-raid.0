From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm fails to recognise DDF partitions from Marvell MV64460
 controller
Date: Sat, 7 Dec 2013 09:28:20 +1100
Message-ID: <20131207092820.66c7be92@notabene.brown>
References: <52A20CFC.7050802@smears.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Xp2ungPhS2nht3RDmUd90Fu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A20CFC.7050802@smears.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Smears <patrick@smears.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Xp2ungPhS2nht3RDmUd90Fu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Dec 2013 17:44:28 +0000 Patrick Smears <patrick@smears.org> wrot=
e:

> Hi,
>=20
> I have a Lenovo D20 server, which has a Marvel MV64460 (fake)RAID=20
> controller.
>=20
> For various reasons I need to be able to dual-boot the machine with=20
> Windows, so I need to use the native RAID format (which the Windows=20
> drivers understand).
>=20
> It uses DDF metadata on its partitions, which I've been using=20
> successfully with "dmraid" for some time, but I'd like to move to mdadm=20
> since the dmraid support is lacking in a number of respects (e.g. cannot=
=20
> create metadata; cannot rebuild arrays, etc...).
>=20
> Unfortunately, though dmraid recognises the partition as DDF, mdadm does=
=20
> not - it always reports the disk as having no superblock.
>=20
> I've done some debugging on this, and it appears that the RAID=20
> controller's BIOS departs from the DDF spec in a couple of (minor) ways=20
> - and so because mdadm is stricter in its checks than dmraid, it refuses=
=20
> to recognise the disk.
>=20
> I think I can come up with a patch to work around this - should I do=20
> that and submit it (and if so, where should I send it)? Or would it be=20
> better to describe the issues I've found in more detail first?
>=20

A patch is often a good way to describe an issue in detail - though you
should include plain-language text as well of course.
Patches can be posted to this list.

The only "DDF" I've come across which mdadm doesn't like is DDFv1.0 which h=
as
all multi-byte values in the "other" order, and uses a different checksum
algorithm.  As I cannot find  a document describing DDFv1.0 I cannot
calculate the checksum so I cannot update the metadata, so I cannot use
DDFv1.0.

If the "minor" variances you found don't prevent us from being able to upda=
te
the metadata and still have it recognised by the card, then I'm certainly
interested in a patch.

Thanks,
NeilBrown

--Sig_/Xp2ungPhS2nht3RDmUd90Fu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqJPhDnsnt1WYoG5AQJtfRAAl3a5L1QSIM9MUr5L78EV2X72heprnNLb
LMbXXDMeTsb4KIBcN5E5Pgwz/8hcu2w6h+/dqGHw9Zd8jEmjmAlD25plj7AtjwSL
c7yHd7fIVnuaEO4TqfnfteRitmy/dqKEqlwS0I+2dI6R7tEDjtPLK2ypZ4ghLnUa
QD/Pn2FuLfSjtRkJmaS/GjNffeli1KPnYCFdtZq/OQQ1w1KY0GLV2KHBdm/33kin
g163O4njge5/nODjxV0zWEOhpOgSrzOuzzleE9Ul61lWMxxy2Zb+LysWjtX9gH+V
qMkPsIvvLVk1eUZ5BtMp4CC66ZD+Mk1EJpKPrvO/A+VAOylZkcCdukbkIN6SocPv
1CiNRr9Rar7i1uZQpXngrSIL5NXNPVz19YycQ2S6xVttwXgp7B6DwBlHrAK0vfPp
THpH7O0WQp0vJ2507dlCSuK64wJSGsRUSw/Mk5P/pPn1/d6JPcuNYLMOo2N+wcID
Q8e/QJdtdJMKOb1rWjyAK+c9DwCKBIu5HOLkItvfxARZ6KgCaodWFXl7+B5WVdQU
trpi1msJolf1IJCraSzY5/gPze0v1i8XleclgTgvtDbzyGSAYPDN4EI7HMjh+vs6
rULuHrkX2nWCtQZTOXkQVe09+Yf5X+ENRMeDk8DBEkCa7mYlb7wh+LXILJtHOWd5
3rFLxs3bdTQ=
=0uCQ
-----END PGP SIGNATURE-----

--Sig_/Xp2ungPhS2nht3RDmUd90Fu--
