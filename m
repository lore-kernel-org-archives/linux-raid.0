From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v3 0/4] add --offroot argument to mdadm/mdmon
Date: Wed, 25 Jan 2012 11:02:15 -0500
Message-ID: <4F202787.70001@redhat.com>
References: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig49E23BB7DA191ACEBC4460E1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1327504684-9219-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig49E23BB7DA191ACEBC4460E1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 1/25/2012 10:18 AM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> Here is v3, also known as the perfect<tm> version of the of the
> systemd/dracut fixes for preboot/offroot/initrd handling in
> mdadm/mdmon. I have changed the argument now to --offroot based on the
> input I received.=20
>=20
> Cheers,
> Jes
>=20
>=20
> Jes Sorensen (4):
>   mdmon: Use getopt_long() to parse command line options
>   Add --offroot argument to mdadm
>   Add --offroot argument to mdmon
>   Spawn mdmon with --offroot if mdadm was launched with --offroot
>=20
>  ReadMe.c   |    5 +++++
>  mdadm.8.in |   12 ++++++++++++
>  mdadm.c    |   10 ++++++++++
>  mdadm.h    |    3 +++
>  mdmon.8    |   12 +++++++++++-
>  mdmon.c    |   59 ++++++++++++++++++++++++++++++++++++++++++++++++----=
-------
>  util.c     |   17 +++++++++++++----
>  7 files changed, 102 insertions(+), 16 deletions(-)
>=20

Acked-by: Doug Ledford <dledford@redhat.com>


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig49E23BB7DA191ACEBC4460E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPICeHAAoJELgmozMOVy/dSj8QAKn+//8Hf1wzddkgiVrH3Dzi
sflQeQVaNVlDlmpfFmmKaQQT62k4f5B0hbqdZuJdHq3D68Rye506AqbSt+3nU8kA
8dli3UbdUQvKF1P6woUmwCu6H38KMNyQbpUsM2DGf1oqoOa9xT3ADZS08La7/PCn
5yaIet9p3rOtWIoq2tIbZmmcMNRP65LZFJJg0NYeDwzQbr5XX1YLdQU3Jyz+0yzs
8pD3HjClDY5l++0S/CAMmZ5WjqGALOGM7GUO3jS9HrNHqVipWFFqH+wGaSMxATf+
qp9AANRmUYvY4F31XrB28dUCZdpKboFqlomPKtvx9KSm4zK9eFfMbsxf/2dy/U5E
nrxb38wEmp9vjgGpT+CKJKbsgXqknr1pZurCT+Yj79lnrQdtAGuP81BprGXQWT9J
eGFhJm4O1nRcPt5xnSI+rS18ft3Xn72mnHU6bX3DvqhOjy1Vjw0iCzLzrJC2kVN1
X75GZfFuhdCHBG1+GCpSMg9OTaIPSa759nOUixzC8Ne+2P+NSyRIzR55wbKDiOWy
01AKMdml5Dr9H9xMxDb8MDM3+9GqxLxqemrfrRqnlB/Kfhi5wjTzpUG1v8RBZzOF
2N1VnxYJszGy4Io5kc+/Dm8irURSLn9MjGHpBcmvoIZvM4NdKOLMGAl1P7hWKn6e
XTqbVd5r5Ji/Un9ofbWK
=J1Zf
-----END PGP SIGNATURE-----

--------------enig49E23BB7DA191ACEBC4460E1--
