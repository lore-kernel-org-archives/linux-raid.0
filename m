From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 10 Issue
Date: Fri, 6 Mar 2015 08:54:07 +0000
Message-ID: <20150306085407.GA32079@cthulhu.home.robinhill.me.uk>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Mar 05, 2015 at 06:56:00PM +0100, Stefan Lamby wrote:

> Hello List.
>=20
> I was setting up a new machine using ubuntu 14.04.02 lts using its instal=
ler,
> configuring a raid 10 with 2 disks and lvm on top of it. I was using 2 di=
sks and
> now I like to add 2 more disks to the array so i want to end up with 4 di=
sks, no
> spare.
>=20
> Searching the internet I found that I am not able to --grow the array wit=
h the
> mdadm version this ubuntu is using (v3.2.5).
> Is that right?
>=20
> So I decided to build a new array that way and try to move my data afterw=
ards,
> which failed:
> (Is it OK to do it that way or do you recommend another?)
>=20
> root@kvm15:~# mdadm --verbose --create --level=3D10 --raid-devices=3D4 /d=
ev/md10
> missing missing /dev/sdc1 /dev/sdd1
> mdadm: layout defaults to n2
> mdadm: layout defaults to n2
> mdadm: chunk size defaults to 512K
> mdadm: /dev/sdc1 appears to be part of a raid array:
>     level=3Draid10 devices=3D4 ctime=3DFri Feb 27 15:49:14 2015
> mdadm: /dev/sdd1 appears to be part of a raid array:
>     level=3Draid10 devices=3D4 ctime=3DFri Feb 27 15:49:14 2015
> mdadm: size set to 1904165376K
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: RUN_ARRAY failed: Input/output error
>               <<<<<<<<<<<<<<<<<<<<<<<<<<<
> root@kvm15:~#=20
>
IIRC, in a RAID10 setup, the redundant pair is held on adjacent drives.
You've specified two adjacent drives as missing, so the array cannot be
run. Try doing:
    mdadm --verbose --create --level=3D10 --raid-devices=3D4 /dev/md10 \
        missing /dev/sdc1 missing /dev/sdd1

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlT5ay4ACgkQShxCyD40xBK8TACdEtBKvps9s6zQW4Iys/vi2g15
f2UAnjlbmSd71TxODMDKcbLPzzTq5zRm
=sPIy
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
