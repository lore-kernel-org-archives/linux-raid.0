From: Robin Hill <robin.hill47@ntlworld.com>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 1 Sep 2011 16:59:13 +0100
Message-ID: <20110901155913.GA20825@cthulhu.home.robinhill.me.uk>
References: <20110901154759.GA32649@apartia.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110901154759.GA32649@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Sep 01, 2011 at 05:47:59PM +0200, Louis-David Mitterrand wrote:

> Hi,
>=20
> I'm trying to create a raid6 array from 10x3T disks. Since disks > 2T
> must use the GPT partion table I used parted to created a single
> partition on each drive with the correct GPT partion type.
>=20
> Now how do I make sure that these partitions have the correct "raid
> autodetect" (fd) id? Is it even still needed? I didn't find any way to
> set that flag in (g)parted.
>=20
It's only needed for kernel auto-assembly (in which case you're also
limited to 0.90 metadata and 2TB drives), so no, there's no need to use
that. 0xDA seems to be the recommended partition type for RAID arrays
nowadays - that should prevent the OS from trying to read them directly.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5fq9AACgkQShxCyD40xBIdgwCeOOytg123QcjPxf55WfGcYhW8
LiUAoJu/pBL4kfSlSdUwNJyh0b99vHKj
=1w/m
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
