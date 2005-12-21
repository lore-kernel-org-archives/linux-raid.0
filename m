From: Andy Smith <andy@lug.org.uk>
Subject: Re: Raid sync observations
Date: Wed, 21 Dec 2005 11:49:12 +0000
Message-ID: <20051221114912.GY10278@strugglers.net>
References: <E1Eol86-0008Ju-3J@highlab.com> <43A8B623.5060704@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iPQdpvQZPHatbiDE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43A8B623.5060704@nighthawkrad.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--iPQdpvQZPHatbiDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21, 2005 at 12:55:47PM +1100, Christopher Smith wrote:
> Sebastian Kuzminsky wrote:
> >I just created a RAID array (4-disk RAID-6).  When "mdadm -C" returned,
> >/proc/mdstat showed it syncing the new array at about 17 MB/s.  "vmstat =
1"
> >showed hardly any blocks in or out, and an almost completely idle cpu.
>=20
> This isn't really relevant to your questions but...
>=20
> Why would you use RAID6 and not RAID10 with four disks ?

I was wondering the same thing.  It's true that RAID6 is guaranteed
to still run degraded after losing 2 devices, whereas a RAID10 on 4
devices could only lose 1 device from each RAID1.  So there is some
small extra redundancy there.

But how does the performance for read and write compare?

--iPQdpvQZPHatbiDE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDqUE3IJm2TL8VSQsRAv6mAKCojgt0IwlsfoDjqb1S+lnfGMApMgCfc8Lw
PhlLAyXJ7nnuI2R1BauPzpo=
=gHgG
-----END PGP SIGNATURE-----

--iPQdpvQZPHatbiDE--
