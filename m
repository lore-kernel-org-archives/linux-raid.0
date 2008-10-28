From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: dmraid - where is the raid done?
Date: Mon, 27 Oct 2008 20:36:15 -0400
Message-ID: <1225154175.16984.16.camel@pc.ilinx>
References: <1225120062.20830.34.camel@pc.ilinx>
	 <49064EF0.4080804@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FqqYu0TU9wUvNeJ1OFrT"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49064EF0.4080804@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-FqqYu0TU9wUvNeJ1OFrT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 18:29 -0500, Roger Heflin wrote:
>=20
> After that the OS driver only reads tables that the BIOS put on the disks=
,
> and figures out which disks are to be raided, and the OS does *ALL* of th=
e work=20
> just like MD.

Ahhhh.  Really.  That is disappointing.  So in reference to the OS doing
all of the work would that be the kernel driver for the particular RAID
card, such as the Promise or Adaptec fakeraid cards?

b.


--=-FqqYu0TU9wUvNeJ1OFrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkGXn8ACgkQl3EQlGLyuXDd1wCgyz+6loS+h/KRYH7CWqn+k38g
RI0AoMzoUX+93pwMA7hi6gvfpZ0YCWMP
=rFXM
-----END PGP SIGNATURE-----

--=-FqqYu0TU9wUvNeJ1OFrT--

