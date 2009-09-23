From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Wed, 23 Sep 2009 16:14:36 +0100
Message-ID: <20090923151436.GB9409@cthulhu.home.robinhill.me.uk>
References: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
 <200909230956588.SM01420@trainer>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200909230956588.SM01420@trainer>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 23, 2009 at 09:56:52AM -0400, Sunpyo Hong wrote:

> I actually know the physical order of each HD. I was able to pull them out
> of the NAS in the order specified in the NAS. (Each HD enclosure was
> labeled) In the actual sata ports, this is what the hds are in.
>=20
> SATA 0: HD1
> SATA 1: HD2
> SATA 2: HD3
> SATA 3: HD4
> SATA 4: CD-ROM
>=20
> I think that linux reads the sata ports like.. 0 =3D sda, 1=3Dsdb.. etc. =
So I
> assume that HD1 =3D /dev/sda (missing), HD2 =3D /dev/sdb, HD3 =3D /dev/sd=
c, HD4 =3D
> /dev/sdd so a create command should look like this:
>=20
> #mdadm -Cv -level=3D5 --raid-disks=3D4 missing /dev/sdb4 /dev/sdc4 /dev/s=
dd4
>=20
> This is exactly how I wrote the create command. Again I knew the physical
> order of the Raid and put them together in that order. Tell me if I'm doi=
ng
> something wrong.=20
>=20
> I'll check out testdisk as well..
>=20
The array order detected by the initial --assemble is (unless you have
incredibly strong reason to believe otherwise) most likely to be the
correct order, in which case the correct create command should be:
    mdadm -Cv -l 5 -n 4 /dev/sdd4 /dev/sdc4 /dev/sdb4 missing

I'd suggest re-creating the array in this order (ignoring the irrelevant
"physical" ordering) before attempting any other recovery.
Incidentally, does the --create command report that any of the disks
contain an ext2/3 filesystem? This is usually reported for one of the
drives.

However, given that the initially-assembled array failed to mount, I
suspect you're hosed, and that whatever the ShareSpace did in attempting
to rebuild the array has actually broken it completely.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq6O1sACgkQShxCyD40xBJK2wCeOlCnmemxlfBLC4zJFAGy+gEW
auwAn3WkVQembBP+RnetXYf7+zb+BhMp
=fH83
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
