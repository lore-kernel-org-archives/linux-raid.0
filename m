From: NeilBrown <neilb@suse.de>
Subject: Re: Help to assemble raid5 - no superblock!
Date: Sat, 28 Apr 2012 08:08:30 +1000
Message-ID: <20120428080830.6a3d0ab1@notabene.brown>
References: <CAGmni9oPLr6xg07gn0kVpKM2ysOzM5x+Dx-kBTz2ZDdqV0-VOg@mail.gmail.com>
	<20120404214749.0988c792@notabene.brown>
	<CAGmni9pRk4qO88VvUMQ2VpnmzokhxCbfwsA9LpnD1Jsa0KMKgg@mail.gmail.com>
	<CAGmni9ogttmRiWqFkXz=wC=fqy7QFwDtuBYGL1kBenusQtB42g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SzEIX5CyYLOJxXj8Nf+7V.D"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGmni9ogttmRiWqFkXz=wC=fqy7QFwDtuBYGL1kBenusQtB42g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Salatiel Filho <salatiel.filho@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SzEIX5CyYLOJxXj8Nf+7V.D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Apr 2012 07:24:01 -0300 Salatiel Filho <salatiel.filho@gmail.com>
wrote:

> A little help again. After being able to successfully mount in the
> mips machine now that i am trying to mount in a x86 machine it is not
> working.
>=20
> # =A0root@eeepc:~# mdadm -A =A0--update=3Dbyteorder /dev/md1 /dev/sdc2
> /dev/sdd2 /dev/sde2
> mdadm: failed to add /dev/sdd2 to /dev/md1: Invalid argument
> mdadm: failed to add /dev/sde2 to /dev/md1: Invalid argument
> mdadm: failed to add /dev/sdc2 to /dev/md1: Invalid argument
> mdadm: /dev/md1 assembled from 0 drives - not enough to start the array.
>=20
>=20

>=20
>=20
> Apparently i am getting checksum error.
>=20

>=20
>=20
> any ideas how to fix this ?
>=20

Try to assembled with --update=3Dsummaries.  That should fix the checksum.
The byte-order has already been fixed, so it doesn't need fixing again.

NeilBrown


--Sig_/SzEIX5CyYLOJxXj8Nf+7V.D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5sY3jnsnt1WYoG5AQLMog//V+lsKXuylV5BQwd40UxMti5VoEEu3IWj
VIw2/oQByh4NEN6f0CBLabYmlMeK3CXDGc9WSudaSIZTXuQSrB0+nA7jxuFVZtGM
ZRKQdQkQE2YWXJLY2hR5pPwVE01AUbnHYmSat0k5IG0Nx1HJOa7htfU4VbnMOmlG
/rVUAViE2dKBmPZ9O+OU7gaJSjMOEYl7J7NL7RZlCx4tJ+E3LMB4ebJrIJe0fwCP
WLr5Q+UVX5vIJ92lSCxlvW3cQlBUym62WLY8xy68VDrmmEFbY9vQvzxzDMh8fKST
UEr10VFfG3O10IxGuW8dXnxTjGotH5ThPKnvH5ds46q/1ftQkTh3fMeKxaZgkkRc
SPxAlhwdSTD9RRLrDjVIlNxoCq7m4I0KM2MRWfZHcvGB9urB/fKWoYXQ7N2QAD50
XkxEVUbU2/yYmGW7R5k5Xbc78fQenUdsvBGUr4iuUDBTUAPvseh3zASdIWCcV3Or
3x3MUXKTNJ2hq/Dt2n79u911YLrrMK4X4gZFpZBw3hE6XlCcu+Zfi24zsfobFh0D
78zkKwevVGdnH2zh0UNeYukf/U0Wk8ggDvJwuWdCnoe9ItcpHdz9qAT5bnddoP+5
5r9ejl7hRlFYXE7DRUzU8g1NeMauTXiiCklyBBHqVMHtZTThW65CTYVLnxCan9V4
EQirGz4wg9E=
=cALJ
-----END PGP SIGNATURE-----

--Sig_/SzEIX5CyYLOJxXj8Nf+7V.D--
