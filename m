From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 00:29:37 +0100
Message-ID: <1264634977.1928.13.camel@test.apertos.eu>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GCu3zpBA+wEi3oxC33Pw"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Williams <carloswill@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-GCu3zpBA+wEi3oxC33Pw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-27, =C5=9Bro o godzinie 13:56 -0500, Carlos Williams pisze:
> I checked out the 'man' page for 'mdadm' utility and I think I am
> wanting to use the 'mdadm --grow' command but I don't really know what
> I am doing here and the man page is a nice reference but I am looking
> for more guidance. Can anyone please tell me what is the proper way to
> get my desired result?=20

See http://scotgate.org/2006/07/03/growing-a-raid5-array-mdadm/

You can check the status of your arrays by 'cat /proc/mdstat'.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-GCu3zpBA+wEi3oxC33Pw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktgzGAACgkQzQlUjpZYlbcecgCg1wpEaMN6iGmv8Lmq65oJIP16
OZ0AoIeRTLWhE5rlr8DviF0qCBjl3s8N
=1yTT
-----END PGP SIGNATURE-----

--=-GCu3zpBA+wEi3oxC33Pw--

