From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: 3ware raid question
Date: Tue, 02 Aug 2005 12:10:24 -0700
Message-ID: <1123009824.11363.129.camel@seki.nac.uci.edu>
References: <5d96567b0508020352252af125@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g+iPaXcM1pNSOW+VYUWS"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0508020352252af125@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


--=-g+iPaXcM1pNSOW+VYUWS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2005-08-02 at 13:52 +0300, Raz Ben-Jehuda(caro) wrote:
> i have encountered a weired feature of 3ware raid.
> When i try to put inside an existing raid a disk which=20
> belonged to a different 3ware raid if fail.
> Any idea anyone ?=20

Two thoughts:

1) Maybe test the disk in another machine and see if it's still good

2) Maybe wipe the disk clean in another machine with something like:

	dd if=3D/dev/zero of=3D/dev/sdb

...but be very careful to get the right disk (IE, you may not
need /dev/sdb, you might need /dev/hdd or a number of other
possibilities).


--=-g+iPaXcM1pNSOW+VYUWS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC78Ugo0feVm00f/8RApTlAJ9s+qDfp6GWoEK7MCGo3TgY7RpY6wCeM2ZG
e8GPfCLskIMdG290qXeFARc=
=9AdB
-----END PGP SIGNATURE-----

--=-g+iPaXcM1pNSOW+VYUWS--

