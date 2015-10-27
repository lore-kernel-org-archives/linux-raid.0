From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: [UU_] Won't go away
Date: Tue, 27 Oct 2015 12:24:46 +0000
Message-ID: <20151027122446.GA32239@cthulhu.home.robinhill.me.uk>
References: <562F6B56.9040901@highpoweredhelp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <562F6B56.9040901@highpoweredhelp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Munger <michael@highpoweredhelp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 27, 2015 at 08:17:26AM -0400, Michael Munger wrote:

> It's my understanding, that an array running with [UU_] is degraded and
> there is a disk problem.
>=20
> I have been trying to create a RAID array using this command:
>=20
> mdadm --create --verbose /dev/md0 --level=3D5 --raid-devices=3D3 /dev/sdb1
> /dev/sdc1 /dev/sdd1
>=20
> However, once it create it, it get this in /proc/mdstat:
>=20
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
>       3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2]
> [UU_]
>       [>....................]  recovery =3D  0.1% (2611780/1953382400)
> finish=3D1737.7min speed=3D18709K/sec
>       bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> I have done the following to "fix" the drive:
>=20
> 1. Smartmontools smartctl long and short tests. All passed.
> 2. Zeroed the first 1GB of the drive (overkill, I know I could just do
> the first 512) with dd if=3D/dev/zero of=3D/dev/sdb count=3D250000 bs=3D4k
> 3. Re-partitioned the drive.
> 4. Re-create.
>=20
> No joy.
>=20
> Then, I swapped this hard drive out for another drive.
>=20
> I am still getting [UU_].
>=20
> Thoughts?

This is perfectly normal. A RAID-5 array is created in degraded mode,
then the final disk is synchronised. This makes the array available
immediately, with the synchonisation happening in the background.

Just leave it to complete the recovery process.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlYvbQ0ACgkQShxCyD40xBJ5gQCeJ4KiwhTZr8IMc8wfJ6uLU8G8
B3UAoLzNNK9jqarsT0Nb4QfVb98Y/HFn
=+cDH
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
