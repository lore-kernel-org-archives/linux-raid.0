From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: 'Array state: ... 1 failed', but array clean?
Date: Thu, 28 Jan 2010 13:59:39 +0100
Message-ID: <1264683579.1928.23.camel@test.apertos.eu>
References: <1264680565.1928.20.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-smNcGiTqhDhIxcGfoerm"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264680565.1928.20.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-smNcGiTqhDhIxcGfoerm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-28, czw o godzinie 13:09 +0100, Micha=C5=82 Sawicz pisze:
> Where does this 'failed' come from? Oh, and it's like that on all
> members. Is my array safe as /proc/mdstat says?=20

Hmm I think it might be related to this:

> # mdadm -E /dev/sdb1
> [...]
>     Array Slot : 6 (0, failed, 2, 3, 1, 5, 4)
>    Array State : uuuuUu 1 failed

One of the disks in this array was swapped, maybe this is what this info
records? How can I get rid of that?

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-smNcGiTqhDhIxcGfoerm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkthijsACgkQzQlUjpZYlbdC6wCfcEAyCogbvVzxiYceHsko3oaB
4w8An0NznT72VhNk56w+8rTlvp3+HxSD
=JG2g
-----END PGP SIGNATURE-----

--=-smNcGiTqhDhIxcGfoerm--

