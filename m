From: Andy Smith <andy@lug.org.uk>
Subject: Is this hdparm -t output correct? (was Re: RAID1 & 2.6.9 performance problem)
Date: Mon, 17 Jan 2005 16:51:33 +0000
Message-ID: <20050117165133.GC99565@caffreys.strugglers.net>
References: <41EBD827.80701@pipi.ma.cx> <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net> <200501171624.47645.andrew@walrond.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+USGC6dOGWst/L1U"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501171624.47645.andrew@walrond.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+USGC6dOGWst/L1U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2005 at 04:24:47PM +0000, Andrew Walrond wrote:
> FWIW I get these results with RAID-0
>=20
> andrew@orac ~ $ sudo hdparm -t /dev/sda /dev/sdb /dev/md0
>=20
> /dev/sda:
>  Timing buffered disk reads:  170 MB in  3.00 seconds =3D  56.64 MB/sec
>=20
> /dev/sdb:
>  Timing buffered disk reads:  170 MB in  3.02 seconds =3D  56.37 MB/sec
>=20
> /dev/md0:
>  Timing buffered disk reads:  236 MB in  3.02 seconds =3D  78.08 MB/sec

As an aside, when I try this, how come I get this:

$ sudo hdparm -t /dev/sda /dev/sdb /dev/md0

/dev/sda:
 Timing buffered disk reads:  152 MB in  3.03 seconds =3D  50.19 MB/sec
HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Inappropriate ioctl =
for device

/dev/sdb:
 Timing buffered disk reads:  152 MB in  3.03 seconds =3D  50.24 MB/sec
HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Inappropriate ioctl =
for device

/dev/md0:
 Timing buffered disk reads:  read(2097152) returned 524288 bytes

(note warnings about ioctls and no speed output for /dev/md0)

These are SATA drives in a RAID 1.

--+USGC6dOGWst/L1U
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB6+0VIJm2TL8VSQsRAndyAJ9slfekNndNxReszxCYkh29vr0WhwCg0TDW
k1pOYgmS57jIGBbmbaH/nl8=
=aQU9
-----END PGP SIGNATURE-----

--+USGC6dOGWst/L1U--
