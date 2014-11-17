From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Does order/ sequence of SATA drives matter?
Date: Mon, 17 Nov 2014 11:31:23 +0000
Message-ID: <20141117113123.GA20034@cthulhu.home.robinhill.me.uk>
References: <4CC0CE83-56B9-40FE-AC92-9F60B4C80D4E@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CC0CE83-56B9-40FE-AC92-9F60B4C80D4E@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: forumscollective@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Nov 17, 2014 at 12:13:26PM +0200, forumscollective@gmail.com wrote:

> The motherboard on which I was running a mdadm 8TB array comprised of
> 5 x 2TB drives has packed up so the array needs to be moved to a new
> motherboard.
>=20
> Is the sequence of connectivity to motherboard SATA ports important or
> does mdadm identify each drive and automagically know its sequence in
> the array?
>=20
The array position is stored in the array metadata on each disk, so the
physical connection order does not matter. If you're using a RAID1 array
for the boot drive, you'll need to make sure that the correct disk is
set in the BIOS to boot from though (or that the boot block was
installed to all array members).

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlRp3IoACgkQShxCyD40xBKqKQCdHu5zB5dIpJr6nwcHyfWpG5yd
7JAAoNLelL5kd6HqEGHt+JcD6NJD+/y9
=3/II
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
