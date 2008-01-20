From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm error when trying to replace a failed drive in RAID5
	array
Date: Sun, 20 Jan 2008 21:10:13 +0000
Message-ID: <20080120211013.GA16130@cthulhu.home.robinhill.me.uk>
References: <182d01c85af0$3c6d3520$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <182d01c85af0$3c6d3520$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Jan 19, 2008 at 11:08:43PM -0000, Steve Fairbairn wrote:

>=20
> Hi All,
>=20
> I have a Software RAID 5 device configured, but one of the drives
> failed. I removed the drive with the following command...
>=20
> mdadm /dev/md0 --remove /dev/hdc1
>=20
> Now, when I try to insert the replacement drive back in, I get the
> following...
>=20
> [root@space ~]# mdadm /dev/md0 --add /dev/hdc1
> mdadm: add new device failed for /dev/hdc1 as 5: Invalid argument
>=20
> [root@space mdadm-2.6.4]# dmesg | tail
> ...
> md: hdc1 has invalid sb, not importing!
> md: md_import_device returned -22
> md: hdc1 has invalid sb, not importing!
> md: md_import_device returned -22
>=20
I've had the same error message trying to add a drive into an array
myself - in my case I'm almost certain it's because the drive is
slightly smaller than the others in the array (the array's currently
growing so I haven't delved any further yet).  Have you checked the
actual partition sizes?  Particularly if it's a different type of drive
as drives from different manufacturers can vary by quite a large
amount.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHk7i0ShxCyD40xBIRAiceAKDDqIjxkdfTkJvRu6v6qjFiKDz0rwCeJ2LF
jvF0J+3UEnd57K5zbWDcxsg=
=HhKA
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
