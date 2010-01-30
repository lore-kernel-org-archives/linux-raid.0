From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: raid10 How do I tell what side of the mirror a disk is on?
Date: Sat, 30 Jan 2010 15:09:29 +0100
Message-ID: <1264860569.1880.10.camel@michal-laptop.sawicz.net>
References: <1264777247.29409.64.camel@thor>
	 <87k4v0wjx1.fsf@frosties.localdomain>
	 <1264810392.1880.5.camel@michal-laptop.sawicz.net>
	 <4877c76c1001292322u2f01d47auaa6041cd701e4176@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TEr+D8gif86OMQmQd82y"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001292322u2f01d47auaa6041cd701e4176@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-TEr+D8gif86OMQmQd82y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-29, pi=C4=85 o godzinie 23:22 -0800, Michael Evans pisze:
> As was noted in another reply recently; write down drive serial
> numbers.  Drive serial numbers can be obtained online via tools like
> smartctl or hdparm (read their manuals, they're useful tools).

That I knew already, and I knew which disks are which, but there was no
way to tell which of them are mirrored, which are striped.

> In your case you have a 50% chance of finding a working combination
> the first time, and swapping only one cable from a disk that is
> connected to one that's not would resolve the issue.=20

Yes, of course - I even got it the first time, but still - it would be
nice to be sure from /proc/mdstat or mdadm -E.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-TEr+D8gif86OMQmQd82y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktkPZkACgkQzQlUjpZYlbd5/wCcCOsDEE4woT0QUVvS8+jdqKvX
bvcAmQH6I8exogJayATHwagJLM+D0vtl
=RBkS
-----END PGP SIGNATURE-----

--=-TEr+D8gif86OMQmQd82y--

