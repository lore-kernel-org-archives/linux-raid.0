From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: removing nonexistent drive from array
Date: Thu, 12 Nov 2009 20:53:03 +0000
Message-ID: <20091112205303.GA983@cthulhu.home.robinhill.me.uk>
References: <f19d625d0911121146x6235dcdfl4711f088efc3549b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f19d625d0911121146x6235dcdfl4711f088efc3549b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 12, 2009 at 10:46:38PM +0300, CoolCold wrote:

> Hello!
> I have raid1 array built of 2 disks. One of drives failed, so i've
> removed it and inserted another one. Old disk was /dev/sdc, new one
> detected as /dev/sde, I've added it into array, recovery begun and
> everything is fine except i can't remove the old one:
>=20
> root@srv15:~# cat /proc/mdstat
> Personalities : [raid1]
> md3 : active raid1 sde3[2] sdd3[0] sdc3[3](F)
>       290720192 blocks [2/1] [U_]
>       [=3D>...................]  recovery =3D  5.9% (17269760/290720192)
> finish=3D1229.9min speed=3D3703K/sec
>=20
> root@srv15:~# mdadm /dev/md3 -r /dev/sdc3
> mdadm: cannot find /dev/sdc3: No such file or directory
>=20
> Didn't find anything in man about such case. Any ideas?
>=20
The simplest option is to do:
    mdadm /dev/md3 -r failed

Alternatively, you could try creating a dummy /dev/sdc3 entry (using
mknod).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr8da8ACgkQShxCyD40xBJ63ACgkrob2z5o+UkdH91uZ9q945fs
rEMAoJLcrAabMgE6BlZ4dinbTJPRx6Q3
=hWKZ
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
