From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Best strategy to incrementally replace smaller HDDs [success
 story]
Date: Tue, 27 Sep 2011 10:37:48 +0200
Message-ID: <1317112668.2758.43.camel@michal-laptop>
References: <1315565285.2291.25.camel@michal-laptop>
	 <20110909131351.GA25347@cthulhu.home.robinhill.me.uk>
	 <1315578025.14468.18.camel@michal-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-p6p61j9fxM4kK0CBInvv"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315578025.14468.18.camel@michal-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-p6p61j9fxM4kK0CBInvv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks again for all the pointers, I will now describe my workflow that
got me going with the new drives!

I'll try and do some ASCII-art [=3D=3D=3D used space, --- space (not drives=
)
used for parity].


1. initial situation
   -----------------
    ~~1TB~~
sda |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdb |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdc |=3D=3D=3D=3D=3D|
sdd |=3D=3D=3D=3D=3D|
sde |=3D=3D=3D=3D=3D|
sdf |=3D=3D=3D=3D=3D|
sdg |=3D=3D=3D=3D=3D|
sdh |=3D=3D=3D=3D=3D|
sdi |-----|
sdj |-----|

md1       |=3D=3D=3D=3D=3D|             -  2 x 1TB RAID0 =3D=3D 2TB
md2 |=3D=3D=3D=3D=3D|                   - 10 x 1TB RAID6 =3D=3D 8TB


2. added 4 x 2TB drives
   --------------------
sdk             |           |
sdl             |           |
sdm             |           |
sdn             |-----------|

md3             |           | -  5 x 2TB RAID6 =3D=3D 6TB (degraded)


3. moved part of md2 data onto md3
   ----------------------------------
sda |     =3D=3D=3D=3D=3D=3D|
sdb |     =3D=3D=3D=3D=3D=3D|
sdc |=3D=3D=3D=3D=3D|
sdd |=3D=3D=3D=3D=3D|
sde |=3D    |
sdf |     |
sdg |     |
sdh |     |
sdi |-----|
sdj |-----|
sdk             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdl             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdm             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdn             |-----------|

md1       |=3D=3D=3D=3D=3D|             -  2 x 1TB RAID0 =3D=3D 2TB
md2 |=3D=3D   |                   - 10 x 1TB RAID6 =3D=3D 8TB
md3             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D| -  5 x 2TB RAID6 =3D=3D=
 6TB (degraded)


4. shrunk and removed drives from md2
   ----------------------------------
sda |     =3D=3D=3D=3D=3D=3D|
sdb |     =3D=3D=3D=3D=3D=3D|
sdc |=3D=3D=3D=3D=3D|
sdd |=3D=3D=3D=3D=3D|
sde |=3D    |
sdf |-----|
sdg                         |     |
sdh                         |     |
sdi                         |     |
sdj                         |     |
sdk             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdl             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdm             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdn             |-----------|

md1       |=3D=3D=3D=3D=3D|             -  2 x 1TB RAID0 =3D=3D 2TB
md2 |=3D=3D=3D=3D |                   -  5 x 1TB RAID6 =3D=3D 3TB (degraded=
)
md3             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D| -  5 x 2TB RAID6 =3D=3D=
 6TB (degraded)


5. new arrays to free the old 2TB drives
   and create an additional member for md4
   ---------------------------------------
sda             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdb             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdc |=3D=3D=3D=3D=3D|
sdd |=3D=3D=3D=3D=3D|
sde |=3D    |
sdf |-----|
sdg       |=3D=3D=3D=3D=3D|
sdh       |=3D=3D=3D=3D=3D|
sdi             |=3D=3D=3D=3D=3D|
sdj                   |=3D=3D=3D=3D=3D|
sdk             |           |
sdl             |           |
sdm             |-----------|
sdn             |-----------|

md4             |           | -  4 x 1TB RAID10 =3D=3D 2TB (degraded)
md1       |=3D=3D=3D=3D=3D|             -  2 x 1TB RAID0 =3D=3D 2TB
md2 |=3D=3D=3D=3D |                   -  5 x 1TB RAID6 =3D=3D 3TB (degraded=
)
md3             |=3D=3D=3D=3D=3D=3D=3D    | -  7 x 2TB RAID6 =3D=3D 10TB


6. Moved rest of the data from md2,
   dropped it and replaced a disk in md4
   -------------------------------------
sda             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdb             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdc             |=3D=3D=3D=3D=3D|
sdg       |=3D=3D=3D=3D=3D|
sdh       |=3D=3D=3D=3D=3D|
sdj                   |=3D=3D=3D=3D=3D|
sdk             |=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D|
sdl             |           |
sdm             |-----------|
sdn             |-----------|

md4             |           | -  4 x 1TB RAID10 =3D=3D 2TB (degraded)
md1       |=3D=3D=3D=3D=3D|             -  2 x 1TB RAID0 =3D=3D 2TB
md3             |=3D=3D=3D=3D=3D=3D=3D=3D=3D  | -  7 x 2TB RAID6 =3D=3D 10T=
B


And it only took two weeks! ;)

And again, thanks for all the pointers I got on the list, it all
happened without any data loss.
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-p6p61j9fxM4kK0CBInvv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOgYtcAAoJEGnv7NPGHSZFgYEQAI5be5Ov0BYQvR6+FdJJny8M
10TemC95FmGL7NPuA1taYSMiynTncFgUH8gb6lnmTSQ6JDuOm3ec52fecmppSIY3
sY+id924JAl8LCBiEYTbcHmHQl7EdxhAm2LaALxhxjpnib5qVT5Ph6cmgDEYR9Al
uPE/bl05zmnLQdPh5QGokI7nvQBvCVeLW6G/r2cdYAt/4nLrKiJ5mpyTNSSG1EDs
vZdN43ibTio4bjyarcRbUtjgrp8D+z3JwHPlR4uam7Rt79kYOoFT0pNjiXeTqb7B
U65lkFZy/+Kv5uQeZ2ZhjCT+btAQ9iq7feX/iaqR5/qaPwaHLbpUz+MtW95HfJbG
UETJTkSMJcTNh7DOjtp12jLh00soD3GZE9oH0vnpHhjTfZxU2uqHD547Yqsn50aA
kNL7ncu1MVRljzKe6s8SPd0oqqsTm86oKbUkTXLSiDPqBNtjGiTCSCtjkXFzyo52
iykymokhSjiOYm0gvFNByguyvAYqsumrYyas+GiOsgbZhBf9gNhS7BrN8ayfVIem
zcqQGjLiSUaIGhVQWe6xZC46eUVWBjbmrMB0Z4a23sG7kjSC7Ufkz3105aKLecBp
COpNYoHCwHIIyQ58b318EANQwwa0bKThFulrjSZK10LTCmJPFnAkvTV0Nn47wi9J
zp47Vsze6LdZlt/R/kEE
=JoZD
-----END PGP SIGNATURE-----

--=-p6p61j9fxM4kK0CBInvv--

