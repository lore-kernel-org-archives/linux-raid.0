From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Removed drive from mdadm raid 5 array after reboot
Date: Fri, 18 Feb 2011 21:49:16 +0100
Message-ID: <1298062156.4497.7.camel@michal-laptop.sawicz.net>
References: <BAY148-w38CAE450FEC67644025E33EFD40@phx.gbl>
	 ,<BAY148-w4658B4D2C63A5B2ADAEDBEFD40@phx.gbl>
	 <BAY148-w245C4F3B070F5743631EA9EFD40@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SQP2cNjoUMyoJs5TfqAd"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w245C4F3B070F5743631EA9EFD40@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-SQP2cNjoUMyoJs5TfqAd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2011-02-18, pi=C4=85 o godzinie 15:08 -0500, Mike Viau pisze:
> I was wondering if anyone had come across an issue where after rebooting =
the system, mdadm fails to reassemble an entire raid 5 array with all the d=
rives. I am getting the array up with just /dev/sda and /dev/sdb, but the a=
rray is degraded as a consequence to missing /dev/sdd (which I assume has b=
ecome the parity drive).=20

There is no such thing as a parity drive in raid5, everything (parity
data, too) is spread out evenly over all of the disks.

Please post the output of `mdadm --examine /dev/sd{a,b,d}1` and check
your logs to see if there are any mentions of why the array isn't
assembled on boot.

Have you tried booting in single user mode (I assume this drive isn't
your boot drive?) and try to assemble the array by hand? Have you seen
any errors?

--=20
Micha=C5=82 Sawicz <michal@sawicz.net>

--=-SQP2cNjoUMyoJs5TfqAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk1e20wACgkQzQlUjpZYlbfuSQCfYWVUqQc8zXcvenOo3SjUd7BW
B5YAn2CYO82DvZAb0nzSI5yd+zuIMpW2
=0qAn
-----END PGP SIGNATURE-----

--=-SQP2cNjoUMyoJs5TfqAd--

