From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Problem with RAID-5 not adding disks
Date: Thu, 24 Jul 2014 20:50:11 +0100
Message-ID: <20140724195011.GA31258@cthulhu.home.robinhill.me.uk>
References: <53CEE0E4.4070906@gmail.com>
 <53CEE193.60409@gmail.com>
 <CAAMCDed1o8Ta80sdvefhrLhnmAfeQd5SBmYuWH4Xby6a+m6C2Q@mail.gmail.com>
 <53CFF7B7.3010902@gmail.com>
 <CAAMCDefnMznYnNxoMyhfduhcJkJ1z3iGHD2xD1HEpac1TOxWvg@mail.gmail.com>
 <53D144BD.90301@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53D144BD.90301@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Theophanis Kontogiannis <tkonto@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jul 24, 2014 at 08:39:09PM +0300, Theophanis Kontogiannis wrote:

> Hi Roger, Hi List,
>=20
> With a high heart bit rate I tried this:
>=20
> mdadm --create /dev/md0 --assume-clean --level=3D5 --raid-devices=3D5  /d=
ev/sdb /dev/sdc /dev/sde /dev/sdd missing
>=20
> IT WORKED!
>=20
> Now I have mounted my date back.
>=20
> BUT:
>=20
> 1. I have one failing disk according to SMART (that is /dev/sdc)
>=20
> 2. /dev/sdb and /dev/sdd have a little smaller size then the others:
>=20
> blockdev --getsz /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf
> 1953523055
> 1953525168
> 1953523055
> 1953525168
> 1953523055
>=20
All 1TB disks should be exactly the same size (manufacturers are using
standard sizes for all disks nowadays). Are these drives all on the same
controllers? This looks like maybe the BIOS is reserving some space on
the disks, which may have overwritten something in the original array.

Have you run a fsck across the array after reassembling it? I suspect
you may find the filesystem size doesn't match the original one.

Regards,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlPRY3MACgkQShxCyD40xBK85QCfWLbTnbPfdLZfwTwUcu7N0wWE
3M4An2rEewRhSm0A0Y+si9rKBVBKK9up
=0+nO
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
