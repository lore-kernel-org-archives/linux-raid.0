From: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Subject: Re: Failing disk?
Date: Wed, 25 Jun 2003 19:18:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030625231820.GL21580@rdlg.net>
References: <20030625183111.GF21580@rdlg.net> <16122.11487.594097.921234@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16122.11487.594097.921234@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thus spake Neil Brown (neilb@cse.unsw.edu.au):

> On Wednesday June 25, Robert.L.Harris@rdlg.net wrote:
> >=20
> >=20
> > I'm asking this on the raid list even though it's LVM related for 2
> > reasons.  It's the best list I know of for this question and because the
> > LVM in question is disk 0 in a RAID 1 scheme so it's not 100 % off
> > topic.
> >=20
> > I've got an lvm which consists of drive sda and sdbc.  One of the two
> > disks is complaining about scsi errors.  I get this on the console:
> >=20
> > md: lvm-vg2/lvm2 [events: 0000000b]<6>(write) lvm-vg2/lvm2's sb offset:
> > 35618752
> >  I/O error: dev 08:22, sector 35430824
=2E
=2E
=2E
> >=20
> > Am I correct in assuming that the 22 is hex which translates to 34
>=20
> Yes.
>=20
> > giving me:
> >=20
=2E
=2E
=2E
> > Meaning it's partition 2 of disk hdc (host 0 target 2)?
> >=20
> > Thoughts?
>=20
> Replace the disc...
>=20
> or was there some other though you were after?

The first "Yes" whas exactly what I needed.=20

Thank you,
  Robert

:wq!
---------------------------------------------------------------------------
Robert L. Harris                     | GPG Key ID: E344DA3B
                                         @ x-hkp://pgp.mit.edu=20
DISCLAIMER:
      These are MY OPINIONS ALONE.  I speak for no-one else.

Diagnosis: witzelsucht  =09

IPv6 =3D robert@ipv6.rdlg.net	http://ipv6.rdlg.net
IPv4 =3D robert@mail.rdlg.net	http://www.rdlg.net

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE++i288+1vMONE2jsRApKiAKCxJ+PeMqfWBn3PKNR7+pM8QT0dcgCfZI0o
mi10TTsD/aJiQinjzIunZ1s=
=Mr2w
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
