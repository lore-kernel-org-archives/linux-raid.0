From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: raid10 How do I tell what side of the mirror a disk is on?
Date: Sat, 30 Jan 2010 01:13:12 +0100
Message-ID: <1264810392.1880.5.camel@michal-laptop.sawicz.net>
References: <1264777247.29409.64.camel@thor>
	 <87k4v0wjx1.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AhbXPIDWu8AhX7LVKFfj"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k4v0wjx1.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-AhbXPIDWu8AhX7LVKFfj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-30, sob o godzinie 00:50 +0100, Goswin von Brederlow pisze:
> Does it matter? If one disk fails you know the next disk failure has a
> 33+% chance of data loss and knowing which disk will be critical
> doesn't
> change that.=20

For me it was important when I needed to have the array running (root
fs) with only 2 disks out of 4 (not enough controllers). It would be
nice to be able to tell which are mirrors, which are striped.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-AhbXPIDWu8AhX7LVKFfj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktjeZgACgkQzQlUjpZYlbdgXACgo7aN0Z7LLYswPVpV8UtmW/FO
M5EAoMig9NZQ7BcZ/4oDNZSKsPcS0o7u
=6gR4
-----END PGP SIGNATURE-----

--=-AhbXPIDWu8AhX7LVKFfj--

