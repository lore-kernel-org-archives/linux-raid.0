From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 14:22:33 +0100
Message-ID: <20090410132233.GA15442@cthulhu.home.robinhill.me.uk>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <003801c9b96d$21a0f420$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Apr 09, 2009 at 04:44:25PM -0700, Timothy D. Lenz wrote:

> I used "sudo cp -axu / /mnt/md0" to copy hda to md0. I changed
> /mnt/md0/etc/fstab so that "/" os /md0 instead of /hda.
>=20
This won't work properly, for a start.  You _cannot_ copy a running
system - there's bound to be data which hasn't yet been flushed to disk,
as well as locked files.  You need to boot off a CD (or another
partition) and do the copy from there.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknfSBkACgkQShxCyD40xBK2zACfTyGDMV03tgEeQkF3o31m2qmB
PW0AoKeQWxRRIn9jazRQOZxClambGmmx
=Q63h
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
