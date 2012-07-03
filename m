From: NeilBrown <neilb@suse.de>
Subject: Re: tests/03r5assemV1 issues
Date: Tue, 3 Jul 2012 11:44:59 +1000
Message-ID: <20120703114459.29c21b8f@notabene.brown>
References: <wrfjtxxqcn38.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QsyFaZhqN4p7Pt.vhCWAcN2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjtxxqcn38.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/QsyFaZhqN4p7Pt.vhCWAcN2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jul 2012 15:24:43 +0200 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Hi Neil,
>=20
> I am trying to get the test suite stable on RHEL, but I see a lot of
> failures in 03r5assemV1, in particular between these two cases:
>=20
> mdadm -A $md1 -u $uuid $devlist
> check state U_U
> eval $tst
>=20
> mdadm -A $md1 --name=3Done $devlist
> check state U_U
> check spares 1
> eval $tst
>=20
> I have tested it with the latest upstream kernel as well and see the
> same problems. I suspect it is simply the box that is too fast, ending
> up with the raid check completing inbetween the two test cases?
>=20
> Are you seeing the same thing there? I tried playing with the max speed
> variable but it doesn't really seem to make any difference.
>=20
> Any ideas for what we can be done to make this case more resilient to
> false positives? I guess one option would be to re-create the array
> inbetween each test?
>=20
> Cheers,
> Jes

Maybe it really is a bug?
The test harness set the resync speed to be very slow.  A fast box will get
through the test more quickly and be more likely to see the array still
syncing.

I'll try to make time to look more closely.
But I wouldn't discount the possibility that the second "mdadm -A" is
short-circuiting the recovery somehow.

thanks,
NeilBrown


--Sig_/QsyFaZhqN4p7Pt.vhCWAcN2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/JOmznsnt1WYoG5AQJmAw//TLYH2dmKl5TiUEeqHkYYPfU5+xH508pZ
EOLw9NXkKYUFw4zWhyaaDopPnsxqD/3XLfQMf4MsvVyrEBT0SJSIIZ1/uXNdz7v3
LF+VZDsSHk80rh3bDTVQ2O6ZV8nY5yRYxoebkJKZZPMOISCYifOVZ827LeDW2OTh
APjcA3kKfB8+1pa/Psmhk7ei/n0wNZ9B3XjEOPryK9SGzvBTuOpsa6z74Br5Wlxx
fr1YXLsg9fBHgrHAxZh37FBcQWdDz9zUz4EATp1UoR0aPgEVA1qNVlGKlBHXaHld
qUBH+MlyHWKvdQI4mAMPNNemfxCG/U7I5mZBkf7sBdCxGz391iZ0oav6xVIQeLGd
WjyoCjnZSPQezW6fQ5dvrIniduNsPLqPN4/7q/zyrRgNFWJo6KV2vJeiYltl/CzK
dyws4PrVWXhm/hE1ZbG21yvsAONraeSc3kCy4FUhwJ8kusGp6PLywLuKhBgHMwJG
Gd7SlTF3Z62QXt9ibyRE7fDKSdIlm4RlC4CFV8i5+4TniK9Y1h4z/NZOVAKblLWX
GzQIVlcvIV9S6JN7ZDjhmPjCAAYZpjxTEdWGri5O8e44gNMuuWRtzVwu36np2odO
ieRiZ7XF1GLL2EzgTfk9TllvU0CDK9+QyWQn5/zRFrsFXqb/AChoc9O8itg91geG
0TscfhWQq4c=
=sPMq
-----END PGP SIGNATURE-----

--Sig_/QsyFaZhqN4p7Pt.vhCWAcN2--
