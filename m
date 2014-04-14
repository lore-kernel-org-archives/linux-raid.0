From: NeilBrown <neilb@suse.de>
Subject: Re: Force mdadm to not prompt the user
Date: Tue, 15 Apr 2014 08:48:30 +1000
Message-ID: <20140415084830.1cbf299c@notabene.brown>
References: <534BFFB8.2030203@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mukposVZDmcLsPa1nUG_2Ya"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <534BFFB8.2030203@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/mukposVZDmcLsPa1nUG_2Ya
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Apr 2014 17:33:12 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> Hello,
>=20
> I'm using mdadm in script which setup a system automtically.
>=20
> When creating a RAID array, I'd like mdadm to not prompt the user.
>=20
> Currently I get:
>=20
> # mdadm --create array1 --force --metadata=3D1.0 --level=3Draid1
> --raid-devices=3D3 /dev/vdb1 /dev/vdc1 /dev/vdd1
> mdadm: /dev/vdb1 appears to be part of a raid array:
>        level=3Draid0 devices=3D0 ctime=3DThu Jan  1 01:00:00 1970
> mdadm: metadata will over-write last partition on /dev/vdb1.
> Continue creating array?
>=20
> I thought that using --force would do the trick, but it didn't.
>=20
> I'm using mdadm - v3.3 - 3rd September 2013
>=20
> Is there any other way to achieve that ?

run
   man mdadm

search for "prompt".... doesn't find anything.
search for "ask".  Ahh, there is the answer.

NeilBrown

--Sig_/mukposVZDmcLsPa1nUG_2Ya
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU0xlvjnsnt1WYoG5AQIzHw//Vls7g5ZPfOsxfKUu85MfMaOhuLCJc94A
xGU1nR4IDbOsZl0y+L+FLL2J7Fr+Ujjw33cifzafSbCBsWyF251RnRzLeaLtR73E
1G0Pl1gK57G+EtJH2vJ+8+aU8RGoFtrX+bn25D8yrEdzl9heUCRdUXeYGxftNwNU
XGPK9SX8lqyMZMe29nVzXxKIGzDSc1Rh3Z+2nSvuFiXOFqINdi+v9sNY9jtAXj5c
uqG8yM/hbItYQUHa3UrMdEFeGB0eEgfEDTHhWr3ULkBUJbzQWsMSrbktpOxvBMTS
s3OZguT4SmfqowbhlUMu2iX4/Nge5vFHC0ImS8sA1VJVh0ZoqSBF9cufdjos5xQZ
uMil1bI7Qgj5gQjMfpxNKsRa/pI8OHMjG2VeCeP0CI49NXCeynUMxer4tkKnZHcj
WQJJ6SmNHFgfdXEdtvBb4pC9WGYa8KbrK5/PJvpwK+RxzJt20+8OR36VE2M5dYIR
coHZ53eQlC1IHd8Ng4ZC5aXv3mpkKlpiTHexPizmIKFO6P9BuyCfI6WsRoFpQn+g
aMpD1m6j2nUwAAlH+DbF2O9yahZTRCsEwTY1zBILLhFg+4gBsfNWC6hIHprld9eq
6rFTYs4McBLDaxKU71W0zPbExfbaO4Mrlkwb0vpAZtEx7GfY3WOOPT6QqWa7poLA
4b2QCWDdWwM=
=Twn7
-----END PGP SIGNATURE-----

--Sig_/mukposVZDmcLsPa1nUG_2Ya--
