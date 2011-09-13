From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 16:29:51 +0600
Message-ID: <20110913162951.6b4297db@natsu>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
	<CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
	<20110913084419.380babcc@notabene.brown>
	<CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
	<20110913093850.606efa70@notabene.brown>
	<CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
	<20110913144424.64348c41@natsu>
	<CAGZH0-eAynK17a-B=x-pKHXpN8K+tDNb7cOYqa3M1ThhyvB=4g@mail.gmail.com>
	<CAGZH0-fYrC91=kBMxO3FKKtY0Zmnx4D4+-DD43cbHVNhc2pp3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hy0di3LOsiWFpt4noF4qajf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGZH0-fYrC91=kBMxO3FKKtY0Zmnx4D4+-DD43cbHVNhc2pp3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andriano <chief000@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hy0di3LOsiWFpt4noF4qajf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Sep 2011 19:05:41 +1000
Andriano <chief000@gmail.com> wrote:

> Connected one of the offenders to HBA port, and hdparm outputs this:
>=20
> #hdparm -N /dev/sdh
>=20
> /dev/sdh:
>  max sectors   =3D 3907027055/14715056(18446744073321613488?), HPA
> setting seems invalid (buggy kernel device driver?)

You could just try "hdparm -N p3907029168" (capacity of the 'larger' disks)=
, but that could fail if the device driver is indeed buggy.

Another possible course of action would be to try that on some other contro=
ller.
For example on your motherboard you have two violet ports, http://www.gigab=
yte.ru/products/upload/products/1470/100a.jpg
those are managed by the JMicron JMB363 controller, try plugging the disks =
which need HPA to be removed to those ports, AFAIR that JMicron controller =
works with "hdparm -N" just fine.

--=20
With respect,
Roman

--Sig_/hy0di3LOsiWFpt4noF4qajf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5vMJ8ACgkQTLKSvz+PZwiojwCfQFqG5p8VPiJ+yt3XIoKeqSUU
hM0An0VioNnw572LI/MQFBkvUI+dsB38
=JKgy
-----END PGP SIGNATURE-----

--Sig_/hy0di3LOsiWFpt4noF4qajf--
