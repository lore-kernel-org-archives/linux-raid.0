From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: Re: Performance difference between two raid0 arrays on same drives?
Date: 11 Jul 2003 21:36:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1057984618.3382.81.camel@gregdell.example.com>
References: <200307111813.26177.michel@ket.kth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/M5G0466MQoKENOI0kxj"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307111813.26177.michel@ket.kth.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-/M5G0466MQoKENOI0kxj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-07-11 at 09:13, Michel wrote:
> Hi!
>=20
> I have set two raid0 arrays on two hardrives, using 2x2 partitions. I did=
 a=20
> benchmark of the resulting arrays and one is much slower than the other o=
ne.=20
> I used bonnie++ and hdparm for the tests. It showed that /dev/md0 is 30%=20
> slower than /dev/md1.=20
> /dev/md1 is really close to twice the performance of a single drive.
> I set the arrays with the same parameters. md0 is built from 2x 5 Gb whil=
e md1=20
> is built from 2x2 Gb. The harddrives have the same partition table. md0 i=
s=20
> the closest to the begining of the drives.
> The filessystem is Reiserfs on both arrays.
> Everything works well, except i am curious about such a difference in=20
> performances, since the arrays share the same hardware.=20
> I am new to linux raid, i do not know if this is normal or weird.

This is to be expected.  Partitions toward the "end" of the disk are
written closer to the center of the platters, and as a result, data
transfers suffer.  The drive spins at a constant number of revolutions
per minute, making the linear velocity of the platter across the read
head much higher at the outside of the disk than the outside.  HTH,
	Greg


--=-/M5G0466MQoKENOI0kxj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA/D5BqnAkVXO6fw4sRAn9wAJoDwf3NHQQ7D65F1dIezTQp4KyaMwCfUoMs
AvjymEybJM2yJaDvflf410I=
=CKYH
-----END PGP SIGNATURE-----

--=-/M5G0466MQoKENOI0kxj--

