From: Andy Smith <andy@lug.org.uk>
Subject: Re: mdadm + raid1 of 2 disks and now need to add more
Date: Tue, 11 Apr 2006 14:51:43 +0000
Message-ID: <20060411145142.GR29446@strugglers.net>
References: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ON+QUYPPdli25pUV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ON+QUYPPdli25pUV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2006 at 04:41:30PM +0200, Shai wrote:
> I have two SCSI disks on raid1.
> Since I have lots of reads from that raid, I want to add two more
> disks to this raid so that read will be faster.
>=20
> How should I add the new disks?

Is this possible with md currently:

Create a RAID-10 on the two new disks specifying one disk missing
=66rom each mirror.

Then copy data over and add the two existing disks letting it
resync?

--ON+QUYPPdli25pUV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFEO8J+IJm2TL8VSQsRAohVAKDFfjfjqaEFoZR3puVvOPBJYtMLQwCgwV1p
uppGSx6bNgnWGbxCXIo1ePI=
=rORY
-----END PGP SIGNATURE-----

--ON+QUYPPdli25pUV--
