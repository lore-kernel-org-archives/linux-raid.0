From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm misuse or bug ? mdadm: Cannot find 8:18: No such file or
 directory
Date: Sat, 9 Aug 2014 10:49:15 +1000
Message-ID: <20140809104915.05b8da17@notabene.brown>
References: <53E54AC5.4010904@megasoft.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/FcaKhLysHoEg3G1GsFInfGs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53E54AC5.4010904@megasoft.be>
Sender: linux-raid-owner@vger.kernel.org
To: Killian De Volder <killian.de.volder@megasoft.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FcaKhLysHoEg3G1GsFInfGs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 09 Aug 2014 00:10:13 +0200 Killian De Volder
<killian.de.volder@megasoft.be> wrote:

> I'm having some trouble with a disk of unknown cause.
> As a result the disk is now "failed"
>=20
> #dmesg
> [362288.463008] ata3: exception Emask 0x10 SAct 0x0 SErr 0x90202 action 0=
xe frozen
> ...
> [377997.666956] md: super_written gets error=3D-5, uptodate=3D0
> [377997.666960] md/raid1:md126: Disk failure on sdb3, disabling device
>=20
> I replugged the disk, and added it again to the raid (it is now called sd=
f instead of sdb):
>=20
> # cat /proc/mdstat:
> md126 : active raid1 sdf2[5] sdd2[0] sde2[3] sdc2[2] sdb2[4](F)
>       102272 blocks super 1.2 [4/4] [UUUU]
>=20
> So I wanted to remove the failed disk:
>=20
> # mdadm /dev/md126 -r failed
> mdadm: Cannot find 8:18: No such file or directory

Hmm.. that looks broken.
What version of mdadm is this?
Does
   mdadm /dev/md126 -r detached
work?
How about
   mdadm /dev/md127 -r sdb2

Thanks,
NeilBrown

--Sig_/FcaKhLysHoEg3G1GsFInfGs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+VwCznsnt1WYoG5AQIjRw/+Pf/p8as2FgEcxpTF6mrwCK3JKJEJRlqs
VPTuqr45rq53f9i5k6bBlfWOUtu2WvXCCq/BdmF3jEbWFgn6b6DV0Ew0h+kfWFDv
CwtADMHltJhd79Lhu9SyU6GCi7SK/Ekk1gjuqrBpwhWcSrzVaQV45SM/LA3cHyQp
dXT6jTXrRW4axu0hd/xBLir8PjrCFQWBZU9RH5/FoQGxwSyUo5q/LuV+Y5H+YAiT
iufL91AEOtTuygSH9tFxAocF2KPgVUoS5l76Quw6m79Fmt8CRRtPeAvON701bsZu
nU0f18ScM8o9AacE6nEaX8HDXUc8LpaMTtWdWr3FJ6XhjU+EGzRQMnOeSHJpJJRq
tbVatEczmo9bi5wGwisOjSFAyiMaC1R3/d+lYU0gd1ypxqUssy7e/R0qYhq84jY+
2fM3P3bCsEzpZl0wdqmrpWU+8/91BataXgpWawWJQ3pZ+PK3IitaEj6VZYB/jC5d
UeAE0opKN90bdDtKnCyWJ2wt+twE+bbvKYjSgfzqLMw40Q4F0Cpmw1goForFPy1Q
Ft7pYr91PK7YkG6lL2BzWJtii7GJz3+zy54a5jKvJoSXNi6Nh1aKBh4VW5tI+P/i
e8PR9roWcy+0XdooJaU3nU3i1xXFHe+gSL7750czIlLvT7E8nhxYssyUH5o/kvaL
em4UKhpvQW4=
=h6Y0
-----END PGP SIGNATURE-----

--Sig_/FcaKhLysHoEg3G1GsFInfGs--
