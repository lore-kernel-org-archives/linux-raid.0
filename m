From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 16:08:34 +0100
Message-ID: <1264691314.1928.27.camel@test.apertos.eu>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
	 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xV1JDgfWDVhoT34rVq5V"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Williams <carloswill@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-xV1JDgfWDVhoT34rVq5V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-28, czw o godzinie 09:58 -0500, Carlos Williams pisze:
> Now my /dev/md0 RAID5 array is mounted to my / partition. I still need
> to expand the file system to make use of the extra space, right? I
> simply added the drive and empty partition table into the RAID...I
> still don't have a file system on it yet, do I?=20

Yes, that's what resize2fs will do for You (as long as it's ext[2-4]
we're talking about).

You need to 'fsck -f' first to verify that the filesystem is fine.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-xV1JDgfWDVhoT34rVq5V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkthqHIACgkQzQlUjpZYlbd2TACfUioqyIbQoKfjgN6ey7He5Q0V
KqcAoNJEFIbLyn0A7ATH0XMHcEasUug2
=FHNe
-----END PGP SIGNATURE-----

--=-xV1JDgfWDVhoT34rVq5V--

